/**
 * URL 검증 유틸 (M-2 SSRF 방지)
 *
 * API 응답에서 받은 URL을 다운로드하기 전에 검증.
 * 도메인 화이트리스트 + private IP 차단 + HTTPS 강제.
 */

// 허용된 이미지 호스트 도메인
const ALLOWED_HOSTS = [
  // Pixazo
  "gateway.pixazo.ai",
  "pixazo.ai",
  // OpenAI / Azure Blob (DALL-E 이미지 호스팅)
  "oaidalleapiprodscus.blob.core.windows.net",
  "dalleproduse.blob.core.windows.net",
];

// 정규식 기반 허용 호스트 패턴
// Pixazo가 이미지를 Cloudflare R2 public bucket(pub-{32hex}.r2.dev)으로 서빙함
const ALLOWED_HOST_PATTERNS = [
  /^pub-[a-f0-9]{32}\.r2\.dev$/,
];

// Private/내부 IP 대역 (CIDR)
const PRIVATE_IP_PATTERNS = [
  /^127\./,
  /^10\./,
  /^172\.(1[6-9]|2\d|3[01])\./,
  /^192\.168\./,
  /^169\.254\./,
  /^0\./,
  /^::1$/,
  /^fc00:/i,
  /^fe80:/i,
  /^fd/i,
];

/**
 * 이미지 다운로드 URL 검증
 *
 * @returns null if valid, error message if invalid
 */
export function validateImageUrl(
  url: string
): string | null {
  // 1. URL 파싱
  let parsed: URL;
  try {
    parsed = new URL(url);
  } catch {
    return "Invalid URL format";
  }

  // 2. HTTPS 강제
  if (parsed.protocol !== "https:") {
    return `Invalid protocol: ${parsed.protocol}`;
  }

  // 3. 도메인 화이트리스트 (정적 + 패턴)
  const host = parsed.hostname.toLowerCase();
  const allowedByHost = ALLOWED_HOSTS.some(
    (h) => host === h || host.endsWith(`.${h}`)
  );
  const allowedByPattern = ALLOWED_HOST_PATTERNS.some((p) => p.test(host));
  if (!allowedByHost && !allowedByPattern) {
    return `Host not allowed: ${host}`;
  }

  // 4. Private IP 차단 (도메인이 IP인 경우)
  for (const pattern of PRIVATE_IP_PATTERNS) {
    if (pattern.test(host)) {
      return `Private IP not allowed: ${host}`;
    }
  }

  return null;
}
