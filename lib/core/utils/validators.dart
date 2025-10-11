/// 입력값 검증을 위한 유틸리티 클래스입니다.
class Validators {
  Validators._();

  /// 이메일 주소 유효성 검사
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일 주소를 입력해주세요';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }

    return null;
  }

  /// 필수 입력 필드 검사
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? '값'}을 입력해주세요';
    }
    return null;
  }

  /// 최소 길이 검사
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? '값'}은 최소 $minLength자 이상이어야 합니다';
    }
    return null;
  }

  /// 최대 길이 검사
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? '값'}은 최대 $maxLength자까지 입력 가능합니다';
    }
    return null;
  }

  /// 펫 이름 유효성 검사
  static String? petName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '펫 이름을 입력해주세요';
    }

    if (value.trim().length < 2) {
      return '펫 이름은 최소 2자 이상이어야 합니다';
    }

    if (value.trim().length > 20) {
      return '펫 이름은 최대 20자까지 입력 가능합니다';
    }

    // 특수문자 제한 (한글, 영문, 숫자, 공백만 허용)
    final nameRegex = RegExp(r'^[가-힣a-zA-Z0-9\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return '펫 이름에는 한글, 영문, 숫자, 공백만 사용할 수 있습니다';
    }

    return null;
  }

  /// 걸음수 유효성 검사
  static String? stepCount(String? value) {
    if (value == null || value.isEmpty) {
      return '걸음수를 입력해주세요';
    }

    final steps = int.tryParse(value);
    if (steps == null) {
      return '올바른 숫자를 입력해주세요';
    }

    if (steps < 0) {
      return '걸음수는 0 이상이어야 합니다';
    }

    if (steps > 100000) {
      return '걸음수는 100,000보 이하여야 합니다';
    }

    return null;
  }

  /// 행복도 값 유효성 검사
  static String? happiness(int? value) {
    if (value == null) {
      return '행복도 값이 필요합니다';
    }

    if (value < 0 || value > 100) {
      return '행복도는 0~100 사이의 값이어야 합니다';
    }

    return null;
  }

  /// 복합 검증 함수 - 여러 검증을 연결
  static String? compose(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}