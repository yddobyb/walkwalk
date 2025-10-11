# WalkDog Firebase Functions API 상세 사양 (2025년 9월 업데이트)

## 1. API 개요

### 기본 정보
- **Base URL**: `https://us-central1-walk-dog-app.cloudfunctions.net`
- **인증**: Firebase Auth (Anonymous/Email)
- **App Check**: 필수 (모든 엔드포인트)
- **응답 형식**: JSON
- **타임아웃**: 30초

### 환경별 엔드포인트
```javascript
const ENDPOINTS = {
  dev: 'http://localhost:5001/walk-dog-dev/us-central1',
  staging: 'https://us-central1-walk-dog-staging.cloudfunctions.net',
  prod: 'https://us-central1-walk-dog-app.cloudfunctions.net'
};
```

## 2. 이미지 생성 API

### 2.1 POST `/genSticker` - 스티커 생성
```typescript
// 요청
interface GenStickerRequest {
  petId: string;           // 필수, 펫 고유 ID
  breed?: string;          // 기본: "Shiba Inu"
  color?: string;          // 기본: "orange"
  accessory?: 'none' | 'bandana' | 'glasses' | 'bowtie' | 'hat' | 'collar';
  style?: 'sticker-flat' | 'sticker-3d' | 'realistic';  // 기본: 'sticker-flat'
  size?: number;           // 256-1024, 기본: 512
  bg?: 'transparent' | 'white' | 'gradient';  // 기본: 'transparent'
  seed?: number;           // 재현성을 위한 시드값
  force?: boolean;         // 캐시 무시 여부
}

// 응답
interface GenStickerResponse {
  success: boolean;
  data?: {
    image_base64: string;   // Base64 인코딩된 WebP 이미지
    mime: string;           // "image/webp"
    seed: number;           // 사용된 시드값
    inferenceId: string;    // 추론 ID
    cached: boolean;        // 캐시 사용 여부
    size: {
      width: number;
      height: number;
    };
    metadata: {
      breed: string;
      color: string;
      accessory: string;
      style: string;
    };
  };
  error?: {
    code: string;
    message: string;
  };
}

// 예제
const response = await fetch(`${BASE_URL}/genSticker`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'App-Check-Token': appCheckToken,
    'Authorization': `Bearer ${idToken}`
  },
  body: JSON.stringify({
    petId: 'pet-123',
    breed: 'Poodle',
    color: 'white',
    accessory: 'bowtie',
    size: 512
  })
});
```

### 2.2 POST `/genPose` - 포즈 변형 생성
```typescript
// 요청
interface GenPoseRequest {
  petId: string;           // 필수
  baseKey?: string;        // 기존 이미지 캐시 키
  base_image_b64?: string; // 또는 Base64 이미지 직접 제공
  pose: 'walking-side' | 'sitting' | 'running' | 'sleeping' | 'playing';
  strength?: number;       // 0.2-0.8, 변형 강도, 기본: 0.4
  seed?: number;
}

// 응답
interface GenPoseResponse extends GenStickerResponse {
  data?: GenStickerResponse['data'] & {
    pose: string;
    strength: number;
  };
}
```

### 2.3 GET `/quota` - 할당량 확인
```typescript
// 응답
interface QuotaResponse {
  success: boolean;
  data?: {
    remaining: number;      // 남은 생성 가능 횟수
    total: number;          // 일일 총 할당량
    used: number;           // 오늘 사용한 횟수
    resetAt: string;        // ISO 8601 형식, 리셋 시간
    nextResetIn: number;    // 리셋까지 남은 초
  };
}

// 예제
const response = await fetch(`${BASE_URL}/quota`, {
  method: 'GET',
  headers: {
    'App-Check-Token': appCheckToken,
    'Authorization': `Bearer ${idToken}`
  }
});
```

## 3. 동기화 API

### 3.1 POST `/syncProgress` - 진행상황 동기화
```typescript
// 요청
interface SyncProgressRequest {
  petData: {
    petId: string;
    happiness: number;
    treats: number;
    stepsToday: number;
    totalSteps: number;
    lastUpdate: string;  // ISO 8601
  };
  achievements: Array<{
    code: string;
    unlockedAt?: string;
    progress: number;
  }>;
  settings: {
    version: string;
    locale: string;
  };
}

// 응답
interface SyncProgressResponse {
  success: boolean;
  data?: {
    synchronized: boolean;
    serverTime: string;
    updates?: {
      remoteConfig?: Record<string, any>;
      newMissions?: Array<Mission>;
    };
  };
}
```

### 3.2 GET `/getRemoteConfig` - 원격 설정 가져오기
```typescript
// 응답
interface RemoteConfigResponse {
  success: boolean;
  data?: {
    gameplay: {
      stepPerTreat: number;
      happinessPerTreat: number;
      happinessPer100Steps: number;
      dailyHappinessDecay: number;
      outdoorBonus: number;
      maxDailyTreats: number;
    };
    ai: {
      maxTokens: number;
      temperature: number;
      enableLocalLLM: boolean;
      enableCloudImage: boolean;
      imageQuotaDaily: number;
    };
    features: {
      outdoorModeEnabled: boolean;
      missionsEnabled: boolean;
      socialFeaturesEnabled: boolean;
      arModeEnabled: boolean;
    };
    limits: {
      maxWalkDuration: number;  // 분
      minStepsForReward: number;
      maxStepsPerDay: number;
    };
    maintenance?: {
      enabled: boolean;
      message?: string;
      estimatedEnd?: string;
    };
  };
}
```

## 4. 미션 API

### 4.1 GET `/getMissions` - 활성 미션 목록
```typescript
// 쿼리 파라미터
interface GetMissionsQuery {
  type?: 'daily' | 'weekly' | 'special';
  active?: boolean;
  limit?: number;  // 기본: 10
}

// 응답
interface GetMissionsResponse {
  success: boolean;
  data?: {
    missions: Array<{
      id: string;
      type: string;
      title: string;
      description: string;
      requirements: {
        steps?: number;
        duration?: number;  // 초
        distance?: number;  // 미터
        consecutiveDays?: number;
      };
      rewards: {
        treats: number;
        happiness: number;
        badgeCode?: string;
      };
      progress: {
        current: number;
        target: number;
        percentage: number;
      };
      expiresAt: string;
      createdAt: string;
    }>;
    totalCount: number;
  };
}
```

### 4.2 POST `/completeMission` - 미션 완료
```typescript
// 요청
interface CompleteMissionRequest {
  missionId: string;
  completionData: {
    steps: number;
    duration: number;
    distance: number;
    timestamp: string;
  };
}

// 응답
interface CompleteMissionResponse {
  success: boolean;
  data?: {
    completed: boolean;
    rewards: {
      treats: number;
      happiness: number;
      badge?: {
        code: string;
        name: string;
        imageUrl: string;
      };
    };
    nextMission?: Mission;
  };
}
```

## 5. 분석 API

### 5.1 POST `/logEvent` - 이벤트 로깅
```typescript
// 요청
interface LogEventRequest {
  events: Array<{
    name: string;
    timestamp: string;
    parameters: Record<string, any>;
    category: 'gameplay' | 'ai' | 'ui' | 'error' | 'performance';
  }>;
  sessionId: string;
  deviceInfo?: {
    platform: 'ios' | 'android';
    version: string;
    model: string;
  };
}

// 응답
interface LogEventResponse {
  success: boolean;
  data?: {
    logged: number;  // 기록된 이벤트 수
    failed: number;  // 실패한 이벤트 수
  };
}
```

### 5.2 POST `/reportError` - 에러 리포팅
```typescript
// 요청
interface ReportErrorRequest {
  error: {
    message: string;
    stack?: string;
    code?: string;
    severity: 'low' | 'medium' | 'high' | 'critical';
  };
  context: {
    screen?: string;
    action?: string;
    userId?: string;
    sessionId: string;
  };
  deviceInfo: {
    platform: string;
    version: string;
    freeMemory?: number;
    batteryLevel?: number;
  };
  timestamp: string;
}

// 응답
interface ReportErrorResponse {
  success: boolean;
  data?: {
    reportId: string;
    acknowledged: boolean;
  };
}
```

## 6. 관리자 API

### 6.1 POST `/admin/updateRemoteConfig` - 원격 설정 업데이트
```typescript
// 요청 (관리자 권한 필요)
interface UpdateRemoteConfigRequest {
  config: Partial<RemoteConfig>;
  reason: string;
  effectiveFrom?: string;  // 즉시 적용 시 생략
}

// 응답
interface UpdateRemoteConfigResponse {
  success: boolean;
  data?: {
    updated: boolean;
    version: number;
    effectiveFrom: string;
    changes: Array<{
      key: string;
      oldValue: any;
      newValue: any;
    }>;
  };
}
```

### 6.2 GET `/admin/stats` - 통계 조회
```typescript
// 응답
interface StatsResponse {
  success: boolean;
  data?: {
    users: {
      total: number;
      daily: number;
      weekly: number;
      monthly: number;
    };
    walks: {
      totalSessions: number;
      avgDuration: number;  // 분
      avgSteps: number;
      totalSteps: number;
    };
    ai: {
      dialoguesGenerated: number;
      imagesGenerated: number;
      avgResponseTime: number;  // ms
      cacheHitRate: number;  // 0-1
    };
    missions: {
      completed: number;
      inProgress: number;
      completionRate: number;
    };
  };
}
```

## 7. 에러 코드

### 표준 에러 코드
```typescript
enum ErrorCode {
  // 인증 관련 (401)
  UNAUTHORIZED = 'UNAUTHORIZED',
  INVALID_TOKEN = 'INVALID_TOKEN',
  TOKEN_EXPIRED = 'TOKEN_EXPIRED',
  
  // 권한 관련 (403)
  FORBIDDEN = 'FORBIDDEN',
  APP_CHECK_FAILED = 'APP_CHECK_FAILED',
  INSUFFICIENT_PERMISSIONS = 'INSUFFICIENT_PERMISSIONS',
  
  // 요청 관련 (400)
  BAD_REQUEST = 'BAD_REQUEST',
  INVALID_PARAMS = 'INVALID_PARAMS',
  MISSING_FIELD = 'MISSING_FIELD',
  
  // 리소스 관련 (404)
  NOT_FOUND = 'NOT_FOUND',
  PET_NOT_FOUND = 'PET_NOT_FOUND',
  MISSION_NOT_FOUND = 'MISSION_NOT_FOUND',
  
  // 제한 관련 (429)
  RATE_LIMIT_EXCEEDED = 'RATE_LIMIT_EXCEEDED',
  QUOTA_EXCEEDED = 'QUOTA_EXCEEDED',
  
  // 서버 관련 (500)
  INTERNAL_ERROR = 'INTERNAL_ERROR',
  AI_SERVICE_ERROR = 'AI_SERVICE_ERROR',
  DATABASE_ERROR = 'DATABASE_ERROR',
  
  // 정책 관련 (422)
  CONTENT_POLICY_VIOLATION = 'CONTENT_POLICY_VIOLATION',
  INVALID_IMAGE_CONTENT = 'INVALID_IMAGE_CONTENT'
}
```

### 에러 응답 형식
```typescript
interface ErrorResponse {
  success: false;
  error: {
    code: ErrorCode;
    message: string;
    details?: Record<string, any>;
    timestamp: string;
    requestId: string;
  };
}
```

## 8. 레이트 리미팅

### 엔드포인트별 제한
```typescript
const RATE_LIMITS = {
  '/genSticker': {
    perMinute: 3,
    perHour: 10,
    perDay: 20,
    burstSize: 2
  },
  '/genPose': {
    perMinute: 2,
    perHour: 5,
    perDay: 10,
    burstSize: 1
  },
  '/syncProgress': {
    perMinute: 10,
    perHour: 100,
    perDay: 1000
  },
  '/logEvent': {
    perMinute: 60,
    perHour: 1000,
    perDay: 10000,
    batchSize: 100
  }
};
```

### 레이트 리밋 헤더
```http
X-RateLimit-Limit: 10
X-RateLimit-Remaining: 7
X-RateLimit-Reset: 1640995200
X-RateLimit-RetryAfter: 3600
```

## 9. 보안 고려사항

### 9.1 App Check 구현
```typescript
// Firebase Functions 내부
export const validateAppCheck = async (context: CallableContext) => {
  if (!context.app) {
    throw new HttpsError(
      'failed-precondition',
      'The request must be made from a verified app.'
    );
  }
  
  // 추가 검증
  const appId = context.app.appId;
  if (!ALLOWED_APP_IDS.includes(appId)) {
    throw new HttpsError(
      'permission-denied',
      'App not authorized'
    );
  }
};
```

### 9.2 입력 검증
```typescript
// 입력 새니타이징
const sanitizeInput = (input: any): any => {
  if (typeof input === 'string') {
    // XSS 방지
    return input
      .replace(/[<>]/g, '')
      .trim()
      .slice(0, MAX_STRING_LENGTH);
  }
  if (typeof input === 'number') {
    return Math.min(Math.max(input, MIN_NUMBER), MAX_NUMBER);
  }
  if (Array.isArray(input)) {
    return input.slice(0, MAX_ARRAY_LENGTH).map(sanitizeInput);
  }
  if (typeof input === 'object' && input !== null) {
    return Object.fromEntries(
      Object.entries(input)
        .slice(0, MAX_OBJECT_KEYS)
        .map(([k, v]) => [sanitizeInput(k), sanitizeInput(v)])
    );
  }
  return input;
};
```

## 10. 클라이언트 SDK

### 10.1 Flutter 클라이언트
```dart
// lib/services/api/walk_dog_api.dart
class WalkDogApi {
  final FirebaseFunctions _functions;
  final AppCheckService _appCheck;
  
  WalkDogApi({
    FirebaseFunctions? functions,
    AppCheckService? appCheck,
  }) : _functions = functions ?? FirebaseFunctions.instance,
       _appCheck = appCheck ?? AppCheckService();
  
  Future<Map<String, dynamic>> _callFunction(
    String name,
    Map<String, dynamic> data,
  ) async {
    try {
      // App Check 토큰 가져오기
      await _appCheck.activate();
      
      // 함수 호출
      final callable = _functions.httpsCallable(
        name,
        options: HttpsCallableOptions(
          timeout: Duration(seconds: 30),
        ),
      );
      
      final result = await callable.call(data);
      return result.data as Map<String, dynamic>;
      
    } on FirebaseFunctionsException catch (e) {
      throw ApiException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    } catch (e) {
      throw ApiException(
        code: 'unknown',
        message: e.toString(),
      );
    }
  }
  
  // 스티커 생성
  Future<StickerResponse> generateSticker(StickerRequest request) async {
    final response = await _callFunction('genSticker', request.toJson());
    return StickerResponse.fromJson(response);
  }
  
  // 할당량 확인
  Future<QuotaInfo> getQuota() async {
    final response = await _callFunction('quota', {});
    return QuotaInfo.fromJson(response);
  }
  
  // 진행상황 동기화
  Future<void> syncProgress(ProgressData data) async {
    await _callFunction('syncProgress', data.toJson());
  }
}
```

### 10.2 재시도 로직
```dart
class RetryPolicy {
  static const int maxRetries = 3;
  static const Duration baseDelay = Duration(seconds: 1);
  
  static Future<T> execute<T>(
    Future<T> Function() operation, {
    bool Function(Exception)? retryIf,
  }) async {
    int attempt = 0;
    
    while (attempt < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        
        if (attempt >= maxRetries) {
          rethrow;
        }
        
        if (e is ApiException) {
          // 재시도 불가능한 에러
          if (['INVALID_PARAMS', 'NOT_FOUND', 'FORBIDDEN']
              .contains(e.code)) {
            rethrow;
          }
          
          // 레이트 리밋
          if (e.code == 'RATE_LIMIT_EXCEEDED') {
            final retryAfter = e.details?['retryAfter'] as int?;
            if (retryAfter != null) {
              await Future.delayed(Duration(seconds: retryAfter));
              continue;
            }
          }
        }
        
        // 지수 백오프
        final delay = baseDelay * math.pow(2, attempt);
        await Future.delayed(delay);
      }
    }
    
    throw Exception('Max retries exceeded');
  }
}
```
