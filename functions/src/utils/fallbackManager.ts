/**
 * Fallback Manager for Free User Image Generation
 * 2단계 폴백 시스템: Cloudflare → OpenAI
 *
 * 순서:
 * 1차: Cloudflare Workers AI (FLUX.1 Schnell, 매일 10,000 neurons 무료 ≈ 170장/일)
 * 2차: OpenAI ($0.005) - 가장 안정적
 *
 * ⚠️ 주의:
 * - Cloudflare 무료 한도(매일 10,000 neurons)를 초과하면 Workers Paid($5/월) + 종량제 필요
 * - 무료 한도는 매일 00:00 UTC 리셋
 */

import {generateImageWithCloudflare, CloudflareRequest} from "./cloudflare";
import {generateImageWithOpenAI, OpenAIImageRequest} from "./openaiImage";

export type ImageProvider = "cloudflare" | "openai" | "none";

export interface FallbackConfig {
  cloudflareAccountId: string;
  cloudflareApiToken: string;
  openaiApiKey: string;
}

export interface FallbackRequest {
  prompt: string;
  size?: number; // 정사각형 사이즈 (512, 1024 등) — Cloudflare flux-1-schnell은 고정 출력
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
 * 1차: Cloudflare → 실패 시 → 2차: OpenAI
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
  // 1차: Cloudflare 시도
  // =====================
  console.log("📍 [FallbackManager] Attempt 1: Cloudflare");
  const cloudflareStartTime = Date.now();

  const cloudflareRequest: CloudflareRequest = {
    prompt: request.prompt,
    seed: request.seed,
    steps: 4,
  };

  const cloudflareResult = await generateImageWithCloudflare(
    config.cloudflareAccountId,
    config.cloudflareApiToken,
    cloudflareRequest
  );

  const cloudflareDuration = Date.now() - cloudflareStartTime;

  attempts.push({
    provider: "cloudflare",
    success: cloudflareResult.success,
    error: cloudflareResult.error,
    durationMs: cloudflareDuration,
  });

  if (cloudflareResult.success && cloudflareResult.imageBuffer) {
    console.log(
      `✅ [FallbackManager] Cloudflare succeeded in ${cloudflareDuration}ms`
    );
    return {
      success: true,
      imageBuffer: cloudflareResult.imageBuffer,
      provider: "cloudflare",
      attempts,
    };
  }

  console.log(
    `⚠️ [FallbackManager] Cloudflare failed: ${cloudflareResult.error}`
  );

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
    cloudflare: 0, // 무료 한도 내 $0 (초과 시 ~$0.0006/장)
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
    cloudflare: "Cloudflare (Flux Schnell)",
    openai: "OpenAI (gpt-image-1)",
    none: "None",
  };
  return names[provider];
}
