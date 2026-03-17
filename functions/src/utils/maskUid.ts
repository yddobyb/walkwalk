/**
 * UID 마스킹 유틸 (M-4 로그 민감정보 보호)
 *
 * 로그에 UID 전문 노출 방지.
 * 앞 4자 + ... + 뒤 3자로 마스킹.
 */
export function maskUid(uid: string): string {
  if (uid.length <= 8) return "****";
  return uid.slice(0, 4) + "..." + uid.slice(-3);
}
