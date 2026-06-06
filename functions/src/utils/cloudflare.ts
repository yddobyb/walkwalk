/**
 * Cloudflare Workers AI — FLUX.1 Schnell API Wrapper
 * 무료 사용자용 1차 이미지 생성 API
 *
 * 가격: 매일 10,000 neurons 무료 (약 170장/일, 1024x1024 기준)
 *       초과 시 $0.011 / 1,000 neurons (Workers Paid $5/월 필요)
 * 모델: FLUX.1 Schnell (Apache 2.0, 상업적 사용 자유)
 *
 * Pixazo 대비 장점:
 * - Base64 직접 반환 → URL 다운로드/SSRF 검증 불필요
 * - 명확한 무료 한도 (매일 00:00 UTC 리셋)
 * - Cloudflare 엣지 인프라 안정성
 */

import axios from "axios";

// Cloudflare Workers AI 설정
const CF_MODEL = "@cf/black-forest-labs/flux-1-schnell";
const CF_TIMEOUT = 20000; // 20초 타임아웃

export interface CloudflareRequest {
  prompt: string;
  steps?: number; // 기본값 4, 최대 8
  seed?: number;
}

export interface CloudflareResponse {
  success: boolean;
  imageBuffer?: Buffer;
  error?: string;
  provider: "cloudflare";
}

/**
 * Cloudflare Workers AI로 이미지 생성
 * @param accountId Cloudflare Account ID
 * @param apiToken Cloudflare API Token (Workers AI 권한)
 * @param request 이미지 생성 요청
 * @returns 이미지 버퍼 또는 에러
 */
export async function generateImageWithCloudflare(
  accountId: string,
  apiToken: string,
  request: CloudflareRequest
): Promise<CloudflareResponse> {
  console.log("🎨 [Cloudflare] Starting image generation...");
  console.log(`📝 [Cloudflare] Prompt: ${request.prompt.substring(0, 100)}...`);

  const endpoint =
    `https://api.cloudflare.com/client/v4/accounts/${accountId}/ai/run/${CF_MODEL}`;

  try {
    const response = await axios.post(
      endpoint,
      {
        prompt: request.prompt,
        steps: request.steps || 4,
        seed: request.seed,
      },
      {
        headers: {
          "Authorization": `Bearer ${apiToken}`,
          "Content-Type": "application/json",
        },
        timeout: CF_TIMEOUT,
      }
    );

    // REST API는 result로 감싸서 반환: { result: { image: "<base64>" } }
    // (원시 모델 출력은 { image: "..." } 형태이므로 둘 다 처리)
    const base64Image = response.data?.result?.image ?? response.data?.image;

    if (!base64Image) {
      console.error("❌ [Cloudflare] No image in response");
      return {
        success: false,
        error: "No image in Cloudflare response",
        provider: "cloudflare",
      };
    }

    const imageBuffer = Buffer.from(base64Image, "base64");
    console.log(
      `✅ [Cloudflare] Image received (base64), size: ${imageBuffer.length} bytes`
    );

    return {
      success: true,
      imageBuffer,
      provider: "cloudflare",
    };
  } catch (error) {
    const err = error as {
      response?: { status?: number; data?: unknown };
      message?: string;
      code?: string;
    };

    if (err.code === "ECONNABORTED" || err.code === "ETIMEDOUT") {
      console.error("❌ [Cloudflare] Timeout error");
      return {
        success: false,
        error: "Cloudflare API timeout",
        provider: "cloudflare",
      };
    }

    if (err.response) {
      console.error(
        `❌ [Cloudflare] HTTP ${err.response.status}: ` +
        `${JSON.stringify(err.response.data)}`
      );
      return {
        success: false,
        error: `Cloudflare API error: HTTP ${err.response.status}`,
        provider: "cloudflare",
      };
    }

    console.error(`❌ [Cloudflare] Error: ${err.message}`);
    return {
      success: false,
      error: err.message || "Unknown Cloudflare error",
      provider: "cloudflare",
    };
  }
}
