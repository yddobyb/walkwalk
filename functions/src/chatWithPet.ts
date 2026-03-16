/**
 * chatWithPet - LLM 대화 프록시 Cloud Function
 *
 * API 키를 서버 사이드에서만 관리하여 클라이언트 노출을 방지한다.
 *
 * 3단계 폴백:
 * 1차: OpenRouter Free (자동 라우터)
 * 2차: Groq Free (Llama 3.3 70B)
 * 3차: Gemini Flash-Lite
 */

import * as functions from "firebase-functions";
import axios from "axios";

interface ChatRequest {
  systemPrompt: string;
  userMessage: string;
  maxTokens?: number;
  temperature?: number;
}

interface LlmResult {
  text: string;
  provider: string;
  durationMs: number;
}

export const chatWithPet = functions
  .region("us-central1")
  .https.onCall(async (data: ChatRequest, context) => {
    // 1. App Check
    if (!context.app) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "App Check required"
      );
    }

    // 2. 인증 확인
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Authentication required"
      );
    }

    // 3. 입력 검증 + 범위 제한
    const {
      systemPrompt,
      userMessage,
    } = data;

    if (!systemPrompt || !userMessage) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "systemPrompt and userMessage are required"
      );
    }

    // 입력 길이 제한 (비용 방지)
    if (systemPrompt.length > 2000 || userMessage.length > 1000) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Input too long"
      );
    }

    // maxTokens/temperature 범위 제한
    const maxTokens = Math.min(
      Math.max(data.maxTokens ?? 100, 1), 500
    );
    const temperature = Math.min(
      Math.max(data.temperature ?? 0.7, 0), 1.5
    );

    // 4. API 키 로드 (서버 사이드 전용)
    const config = functions.config();
    const openrouterKey = config.openrouter?.api_key;
    const groqKey = config.groq?.api_key;
    const geminiKey = config.gemini?.api_key;

    // 5. Provider 순회 (폴백)
    const providers = [
      {
        name: "openrouter",
        fn: () => callOpenRouter(
          openrouterKey, systemPrompt, userMessage,
          maxTokens, temperature
        ),
        available: !!openrouterKey,
      },
      {
        name: "groq",
        fn: () => callGroq(
          groqKey, systemPrompt, userMessage,
          maxTokens, temperature
        ),
        available: !!groqKey,
      },
      {
        name: "gemini",
        fn: () => callGemini(
          geminiKey, systemPrompt, userMessage,
          maxTokens, temperature
        ),
        available: !!geminiKey,
      },
    ];

    const startTime = Date.now();

    for (const provider of providers) {
      if (!provider.available) continue;

      try {
        const result = await provider.fn();
        const durationMs = Date.now() - startTime;
        console.log(
          `[chatWithPet] ${provider.name} succeeded (${durationMs}ms)`
        );
        return {
          success: true,
          text: result,
          provider: provider.name,
          durationMs,
        } as LlmResult & {success: boolean};
      } catch (e) {
        const err = e as Error;
        console.log(
          `[chatWithPet] ${provider.name} failed: ${err.message}`
        );
      }
    }

    // 모든 Provider 실패
    throw new functions.https.HttpsError(
      "internal",
      "All LLM providers failed"
    );
  });

// OpenRouter API 호출
async function callOpenRouter(
  apiKey: string,
  systemPrompt: string,
  userMessage: string,
  maxTokens: number,
  temperature: number
): Promise<string> {
  const response = await axios.post(
    "https://openrouter.ai/api/v1/chat/completions",
    {
      model: "openrouter/free",
      messages: [
        {role: "system", content: systemPrompt},
        {role: "user", content: userMessage},
      ],
      max_tokens: maxTokens,
      temperature,
    },
    {
      timeout: 8000,
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "HTTP-Referer": "com.walkdog.app",
        "X-Title": "WalkDog",
        "Content-Type": "application/json",
      },
    }
  );

  return response.data.choices[0].message.content;
}

// Groq API 호출
async function callGroq(
  apiKey: string,
  systemPrompt: string,
  userMessage: string,
  maxTokens: number,
  temperature: number
): Promise<string> {
  const response = await axios.post(
    "https://api.groq.com/openai/v1/chat/completions",
    {
      model: "llama-3.3-70b-versatile",
      messages: [
        {role: "system", content: systemPrompt},
        {role: "user", content: userMessage},
      ],
      max_tokens: maxTokens,
      temperature,
    },
    {
      timeout: 5000,
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
    }
  );

  return response.data.choices[0].message.content;
}

// Gemini API 호출
async function callGemini(
  apiKey: string,
  systemPrompt: string,
  userMessage: string,
  maxTokens: number,
  temperature: number
): Promise<string> {
  const url =
    "https://generativelanguage.googleapis.com/v1beta/models/" +
    "gemini-2.0-flash-lite:generateContent";

  const response = await axios.post(
    url,
    {
      systemInstruction: {
        parts: [{text: systemPrompt}],
      },
      contents: [{
        parts: [{text: userMessage}],
      }],
      generationConfig: {
        maxOutputTokens: maxTokens,
        temperature,
      },
    },
    {
      timeout: 8000,
      headers: {
        "Content-Type": "application/json",
        "x-goog-api-key": apiKey,
      },
    }
  );

  return response.data.candidates[0].content.parts[0].text;
}
