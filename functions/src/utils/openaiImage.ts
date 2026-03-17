/**
 * OpenAI gpt-image-1 API Wrapper
 * 무료 사용자용 2차 폴백 이미지 생성 API
 *
 * 가격: $0.005/이미지 (1024x1024, low quality)
 * 테스트 결과: 16.80초 응답시간
 */

import OpenAI from "openai";
import {validateImageUrl} from "./validateUrl";

// OpenAI 설정
const OPENAI_TIMEOUT = 30000; // 30초 타임아웃

export interface OpenAIImageRequest {
  prompt: string;
  size?: "1024x1024" | "1536x1024" | "1024x1536";
  quality?: "low" | "medium" | "high";
}

export interface OpenAIImageResponse {
  success: boolean;
  imageBuffer?: Buffer;
  error?: string;
  provider: "openai";
}

/**
 * OpenAI API를 사용하여 이미지 생성
 * @param apiKey OpenAI API 키
 * @param request 이미지 생성 요청
 * @returns 이미지 버퍼 또는 에러
 */
export async function generateImageWithOpenAI(
  apiKey: string,
  request: OpenAIImageRequest
): Promise<OpenAIImageResponse> {
  console.log("🎨 [OpenAI] Starting image generation...");
  console.log(`📝 [OpenAI] Prompt: ${request.prompt.substring(0, 100)}...`);

  try {
    // OpenAI 클라이언트 초기화
    const openai = new OpenAI({
      apiKey: apiKey,
      timeout: OPENAI_TIMEOUT,
    });

    // 이미지 생성 요청
    const response = await openai.images.generate({
      model: "gpt-image-1",
      prompt: request.prompt,
      n: 1,
      size: request.size || "1024x1024",
      quality: request.quality || "low",
    });

    // 응답 처리
    if (!response.data || response.data.length === 0) {
      console.error("❌ [OpenAI] No data array in response");
      return {
        success: false,
        error: "No data array in response",
        provider: "openai",
      };
    }

    const imageData = response.data[0];

    if (!imageData) {
      console.error("❌ [OpenAI] No image data in response");
      return {
        success: false,
        error: "No image data in response",
        provider: "openai",
      };
    }

    // Base64 데이터 처리
    if (imageData.b64_json) {
      const imageBuffer = Buffer.from(imageData.b64_json, "base64");
      console.log(`✅ [OpenAI] Image received (base64), size: ${imageBuffer.length} bytes`);
      return {
        success: true,
        imageBuffer,
        provider: "openai",
      };
    }

    // URL 데이터 처리 (fallback)
    if (imageData.url) {
      console.log(`✅ [OpenAI] Image URL received: ${imageData.url.substring(0, 50)}...`);

      // URL 검증 (SSRF 방지)
      const urlError = validateImageUrl(imageData.url);
      if (urlError) {
        console.error(
          `❌ [OpenAI] URL validation failed: ${urlError}`
        );
        return {
          success: false,
          error: `URL validation failed: ${urlError}`,
          provider: "openai",
        };
      }

      // URL에서 이미지 다운로드 (axios 사용)
      const axios = (await import("axios")).default;
      const imageResponse = await axios.get(imageData.url, {
        responseType: "arraybuffer",
        timeout: 10000,
      });
      const imageBuffer = Buffer.from(imageResponse.data);

      console.log(`✅ [OpenAI] Image downloaded, size: ${imageBuffer.length} bytes`);
      return {
        success: true,
        imageBuffer,
        provider: "openai",
      };
    }

    console.error("❌ [OpenAI] No base64 or URL in response");
    return {
      success: false,
      error: "No image data format available",
      provider: "openai",
    };
  } catch (error) {
    const err = error as {
      status?: number;
      message?: string;
      code?: string;
    };

    // 타임아웃 에러
    if (err.code === "ETIMEDOUT" || err.message?.includes("timeout")) {
      console.error("❌ [OpenAI] Timeout error");
      return {
        success: false,
        error: "OpenAI API timeout",
        provider: "openai",
      };
    }

    // API 에러
    if (err.status) {
      console.error(`❌ [OpenAI] HTTP ${err.status}: ${err.message}`);
      return {
        success: false,
        error: `OpenAI API error: HTTP ${err.status}`,
        provider: "openai",
      };
    }

    console.error(`❌ [OpenAI] Error: ${err.message}`);
    return {
      success: false,
      error: err.message || "Unknown OpenAI error",
      provider: "openai",
    };
  }
}
