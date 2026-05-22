/**
 * Fallback Manager for Free User Image Generation
 * 2단계 폴백 시스템: Pixazo → OpenAI
 *
 * 순서:
 * 1차: Pixazo ($0, FLUX.1 Schnell 무료)
 * 2차: OpenAI ($0.005) - 가장 안정적
 *
 * ⚠️ 주의:
 * - Pixazo는 월간/요청 한도가 공시되지 않음
 * - 향후 한도를 도입할 수 있으므로 대시보드에서 주기적으로 사용량 확인 권장
 */

import {generateImageWithPixazo, PixazoRequest} from "./pixazo";
import {generateImageWithOpenAI, OpenAIImageRequest} from "./openaiImage";

export type ImageProvider = "pixazo" | "openai" | "none";

export interface FallbackConfig {
  pixazoApiKey: string;
  openaiApiKey: string;
}

export interface FallbackRequest {
  prompt: string;
  size?: number; // 정사각형 사이즈 (512, 1024 등)
  seed?: number;
}

export interface FallbackResponse {
  success: boolean;
  imageBuffer?: Buffer;
  provider: ImageProvider;
  error?: string;
  attempts: {
    provider: ImageProvider;
    success: boolean;
    error?: string;
    durationMs: number;
  }[];
}

/**
 * 2단계 폴백 시스템으로 이미지 생성
 * 1차: Pixazo → 실패 시 → 2차: OpenAI
 *
 * @param config API 키 설정
 * @param request 이미지 생성 요청
 * @returns 이미지 버퍼 또는 에러
 */
export async function generateImageWithFallback(
  config: FallbackConfig,
  request: FallbackRequest
): Promise<FallbackResponse> {
  console.log("🚀 [FallbackManager] Starting 2-tier fallback image generation");

  const attempts: FallbackResponse["attempts"] = [];

  // =====================
  // 1차: Pixazo 시도
  // =====================
  console.log("📍 [FallbackManager] Attempt 1: Pixazo");
  const pixazoStartTime = Date.now();

  const pixazoRequest: PixazoRequest = {
    prompt: request.prompt,
    height: request.size || 1024,
    width: request.size || 1024,
    seed: request.seed,
    numSteps: 4,
  };

  const pixazoResult = await generateImageWithPixazo(
    config.pixazoApiKey,
    pixazoRequest
  );

  const pixazoDuration = Date.now() - pixazoStartTime;

  attempts.push({
    provider: "pixazo",
    success: pixazoResult.success,
    error: pixazoResult.error,
    durationMs: pixazoDuration,
  });

  if (pixazoResult.success && pixazoResult.imageBuffer) {
    console.log(`✅ [FallbackManager] Pixazo succeeded in ${pixazoDuration}ms`);
    return {
      success: true,
      imageBuffer: pixazoResult.imageBuffer,
      provider: "pixazo",
      attempts,
    };
  }

  console.log(`⚠️ [FallbackManager] Pixazo failed: ${pixazoResult.error}`);

  // =====================
  // 2차: OpenAI 시도
  // =====================
  console.log("📍 [FallbackManager] Attempt 2: OpenAI (fallback)");
  const openaiStartTime = Date.now();

  const openaiRequest: OpenAIImageRequest = {
    prompt: request.prompt,
    size: "1024x1024",
    quality: "low", // 비용 절감을 위해 low 품질
  };

  const openaiResult = await generateImageWithOpenAI(
    config.openaiApiKey,
    openaiRequest
  );

  const openaiDuration = Date.now() - openaiStartTime;

  attempts.push({
    provider: "openai",
    success: openaiResult.success,
    error: openaiResult.error,
    durationMs: openaiDuration,
  });

  if (openaiResult.success && openaiResult.imageBuffer) {
    console.log(`✅ [FallbackManager] OpenAI succeeded in ${openaiDuration}ms`);
    return {
      success: true,
      imageBuffer: openaiResult.imageBuffer,
      provider: "openai",
      attempts,
    };
  }

  console.log(`⚠️ [FallbackManager] OpenAI failed: ${openaiResult.error}`);

  // =====================
  // 모든 시도 실패
  // =====================
  console.error("❌ [FallbackManager] All providers failed");
  return {
    success: false,
    provider: "none",
    error: "All image generation providers failed",
    attempts,
  };
}

/**
 * 비용 계산 유틸리티
 * @param provider 사용된 프로바이더
 * @returns 예상 비용 (USD)
 */
export function calculateCost(provider: ImageProvider): number {
  const costs: Record<ImageProvider, number> = {
    pixazo: 0,
    openai: 0.005,
    none: 0,
  };
  return costs[provider];
}

/**
 * 프로바이더 이름 반환
 * @param provider 프로바이더
 * @returns 읽기 쉬운 이름
 */
export function getProviderDisplayName(provider: ImageProvider): string {
  const names: Record<ImageProvider, string> = {
    pixazo: "Pixazo (Flux Schnell)",
    openai: "OpenAI (gpt-image-1)",
    none: "None",
  };
  return names[provider];
}
