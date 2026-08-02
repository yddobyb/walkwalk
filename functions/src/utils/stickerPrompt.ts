/**
 * 스티커 프롬프트 생성 + 입력 allowlist (Phase 29-2)
 *
 * genSticker(프리미엄)와 genStickerFree(무료)가 **같은 표를 봐야 한다.**
 * 예전엔 두 파일에 같은 로직이 복사돼 있었고, 그래서 "style을 프롬프트에
 * 반영하지 않는" 버그가 양쪽에 똑같이 존재했다(파라미터로 받아놓고 본문에서
 * 쓰지 않아, 이용자가 Flat/3D/Realistic 중 무엇을 골라도 결과가 같았다).
 *
 * ⚠️ **allowlist는 클라이언트 enum과 반드시 일치해야 한다.**
 * 목록에 없는 값은 거부되지 않고 *조용히 기본값으로 대체*되므로(프롬프트
 * 인젝션 방어), 클라이언트에만 옵션을 추가하면 이용자는 선택했는데 결과는
 * 안 바뀌는 상태가 된다 — 위 style 버그와 똑같이 알아채기 어렵다.
 */

export const ALLOWED_BREEDS = [
  // 기존 8종
  "Golden Retriever", "Labrador", "Shiba Inu",
  "Pomeranian", "Husky", "Beagle", "Bulldog", "Poodle",
  // Phase 29-2 추가 8종 (한국·북미에서 흔한 품종 위주)
  "Corgi", "Maltese", "Chihuahua", "Dachshund",
  "Border Collie", "German Shepherd", "Yorkshire Terrier", "Bichon Frise",
];

export const ALLOWED_COLORS = [
  "golden", "brown", "black", "white", "gray", "cream",
  "orange", // 기본값 호환 (UI에는 없음)
  // Phase 29-2 추가
  "tan", "apricot", "rust", "merle",
];

export const ALLOWED_ACCESSORIES = [
  "none", "bandana", "glasses", "bowtie", "hat", "collar",
  // Phase 29-2 추가
  "scarf", "crown", "cap", "flowerCrown",
  "backpack", "headphones", "necktie", "medal",
];

export const ALLOWED_STYLES = [
  "sticker-flat", "sticker-3d", "realistic",
  // Phase 29-2 추가
  "watercolor", "pixel-art", "line-art",
];

export const ALLOWED_BGS = [
  "transparent", "white", "gradient",
  // Phase 29-2 추가
  "park", "beach", "night", "snow", "pastel",
];

/** 목록에 없으면 기본값으로 대체 (프롬프트 인젝션 방어) */
export function pick(
  allowed: readonly string[],
  value: string | undefined,
  fallback: string
): string {
  return allowed.includes(value ?? "") ? value! : fallback;
}

/** 액세서리 → 프롬프트 조각. "none"은 호출 전에 걸러진다. */
const ACCESSORY_PROMPTS: Record<string, string> = {
  bandana: "red bandana accessory",
  glasses: "sunglasses accessory",
  bowtie: "bow tie accessory",
  hat: "top hat accessory",
  collar: "decorative collar",
  scarf: "knitted winter scarf",
  crown: "small golden crown",
  cap: "baseball cap",
  flowerCrown: "flower crown on head",
  backpack: "small backpack",
  headphones: "headphones over ears",
  necktie: "necktie",
  medal: "gold medal on a ribbon",
};

/**
 * 스타일 → 프롬프트 조각.
 * 기본 프롬프트에 "2D flat"이 하드코딩돼 있던 걸 여기로 옮겼다.
 */
const STYLE_PROMPTS: Record<string, string> = {
  "sticker-flat": "cute sticker, front view, simple shading, 2D flat",
  "sticker-3d": "cute 3D render sticker, front view, soft studio lighting, " +
    "glossy rounded shapes",
  "realistic": "photorealistic portrait, front view, natural fur detail, " +
    "shallow depth of field",
  "watercolor": "soft watercolor painting, front view, visible paper " +
    "texture, gentle color bleed",
  "pixel-art": "16-bit pixel art sprite, front view, crisp pixels, " +
    "limited palette",
  "line-art": "clean black line art, front view, bold even outlines, " +
    "minimal flat color fill",
};

/** 배경 → 프롬프트 조각 */
const BG_PROMPTS: Record<string, string> = {
  transparent: "transparent background",
  white: "plain white background",
  gradient: "smooth gradient background",
  park: "sunny park background with grass and trees",
  beach: "sandy beach background with calm sea",
  night: "night sky background with stars and moon",
  snow: "snowy winter background with soft falling snow",
  pastel: "soft pastel color background",
};

/**
 * 최종 프롬프트 조립.
 *
 * 값은 전부 allowlist를 통과한 것이라 이용자 입력이 그대로 들어가지 않는다
 * (프롬프트 인젝션 방어). 매핑에 없는 값이 와도 안전한 기본 조각으로 떨어진다.
 */
export function generatePrompt(
  breed: string,
  color: string,
  accessory: string,
  style: string,
  bg: string
): string {
  const stylePart = STYLE_PROMPTS[style] ?? STYLE_PROMPTS["sticker-flat"];
  let prompt = `${breed} dog, ${color} coat, ${stylePart}`;

  if (accessory !== "none") {
    const accessoryPart = ACCESSORY_PROMPTS[accessory];
    if (accessoryPart) prompt += `, ${accessoryPart}`;
  }

  prompt += `, ${BG_PROMPTS[bg] ?? BG_PROMPTS["transparent"]}`;

  return prompt;
}
