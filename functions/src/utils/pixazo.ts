/**
 * Pixazo Flux Schnell API Wrapper
 * 무료 사용자용 1차 이미지 생성 API
 *
 * 가격: $0.0012/이미지
 * 테스트 결과: 10.51초 응답시간
 */

import axios from "axios";
import {validateImageUrl} from "./validateUrl";

// Pixazo API 설정
const PIXAZO_API_URL = "https://gateway.pixazo.ai/flux-1-schnell/v1/getData";
const PIXAZO_TIMEOUT = 15000; // 15초 타임아웃

export interface PixazoRequest {
  prompt: string;
  numSteps?: number; // 기본값 4, 최대 8
  height?: number; // 기본값 1024
  width?: number; // 기본값 1024
  seed?: number;
}

export interface PixazoResponse {
  success: boolean;
  imageBuffer?: Buffer;
  imageUrl?: string;
  error?: string;
  provider: "pixazo";
}

/**
 * Pixazo API를 사용하여 이미지 생성
 * @param apiKey Pixazo API 키
 * @param request 이미지 생성 요청
 * @returns 이미지 버퍼 또는 에러
 */
export async function generateImageWithPixazo(
  apiKey: string,
  request: PixazoRequest
): Promise<PixazoResponse> {
  console.log("🎨 [Pixazo] Starting image generation...");
  console.log(`📝 [Pixazo] Prompt: ${request.prompt.substring(0, 100)}...`);

  try {
    // 1. Pixazo API 호출
    const response = await axios.post(
      PIXAZO_API_URL,
      {
        prompt: request.prompt,
        num_steps: request.numSteps || 4,
        height: request.height || 1024,
        width: request.width || 1024,
        seed: request.seed,
      },
      {
        headers: {
          "Content-Type": "application/json",
          "Ocp-Apim-Subscription-Key": apiKey,
        },
        timeout: PIXAZO_TIMEOUT,
      }
    );

    // 2. 응답에서 이미지 URL 추출
    const imageUrl = response.data?.output;

    if (!imageUrl) {
      console.error("❌ [Pixazo] No image URL in response");
      return {
        success: false,
        error: "No image URL in response",
        provider: "pixazo",
      };
    }

    console.log(`✅ [Pixazo] Image URL received: ${imageUrl.substring(0, 50)}...`);

    // 3. URL 검증 (SSRF 방지)
    const urlError = validateImageUrl(imageUrl);
    if (urlError) {
      console.error(`❌ [Pixazo] URL validation failed: ${urlError}`);
      return {
        success: false,
        error: `URL validation failed: ${urlError}`,
        provider: "pixazo",
      };
    }

    // 4. 이미지 URL에서 이미지 다운로드
    const imageResponse = await axios.get(imageUrl, {
      responseType: "arraybuffer",
      timeout: 10000, // 다운로드 타임아웃 10초
    });

    const imageBuffer = Buffer.from(imageResponse.data);
    console.log(`✅ [Pixazo] Image downloaded, size: ${imageBuffer.length} bytes`);

    return {
      success: true,
      imageBuffer,
      imageUrl,
      provider: "pixazo",
    };
  } catch (error) {
    const err = error as {
      response?: { status?: number; data?: unknown };
      message?: string;
      code?: string;
    };

    // 에러 타입별 로깅
    if (err.code === "ECONNABORTED" || err.code === "ETIMEDOUT") {
      console.error("❌ [Pixazo] Timeout error");
      return {
        success: false,
        error: "Pixazo API timeout",
        provider: "pixazo",
      };
    }

    if (err.response) {
      console.error(`❌ [Pixazo] HTTP ${err.response.status}: ${JSON.stringify(err.response.data)}`);
      return {
        success: false,
        error: `Pixazo API error: HTTP ${err.response.status}`,
        provider: "pixazo",
      };
    }

    console.error(`❌ [Pixazo] Error: ${err.message}`);
    return {
      success: false,
      error: err.message || "Unknown Pixazo error",
      provider: "pixazo",
    };
  }
}
