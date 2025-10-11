# WalkDog AI 통합 가이드 (2025년 9월 업데이트)

## 1. 클라우드 AI 아키텍처 개요

### 구성 요소
- **대화 AI**: OpenRouter API (DeepSeek R1, 무료)
- **이미지 AI**: Google Gemini 2.5 Flash Image Preview (Week 4, 스티커 생성)
- **폴백 시스템**: 규칙 기반 대화 (오프라인 대응)
- **미래 계획**: MLC-LLM 마이그레이션 (오프라인 로컬 LLM)

### 아키텍처 다이어그램
```
┌─────────────────────────────────────────┐
│        AI Service Manager               │
├─────────────┬───────────────────────────┤
│ Cloud LLM   │     Cloud Image Gen       │
│  (대화)      │      (스티커 - Week 4)     │
├─────────────┼───────────────────────────┤
│ OpenRouter  │   Firebase Functions      │
│ DeepSeek R1 │   → Gemini 2.5 API       │
│ (HTTP API)  │                           │
├─────────────┼───────────────────────────┤
│ Fallback    │                           │
│ Rule-based  │                           │
└─────────────┴───────────────────────────┘
```

### OpenRouter 선택 이유
- ✅ **무료**: DeepSeek R1 모델 무료 사용 (100회/일)
- ✅ **빠른 개발**: HTTP API 호출만으로 3-5일 내 구현
- ✅ **앱 크기**: 1GB 로컬 모델 다운로드 불필요
- ✅ **유지보수**: 모델 업데이트 자동 반영
- ⚠️ **인터넷 필요**: 오프라인 시 규칙 기반 폴백
- 🔮 **마이그레이션**: 추후 MLC-LLM(Qwen2.5-3B)로 전환 가능

## 2. OpenRouter API 통합 (DeepSeek R1)

### 2.1 API 설정 및 인증

**API 기본 정보**:
- **Base URL**: `https://openrouter.ai/api/v1`
- **모델**: `deepseek/deepseek-r1:free`
- **인증**: Bearer Token
- **무료 할당량**: 100회/일
- **API 호환성**: OpenAI API 형식

**API 키 관리**:
```dart
// lib/core/config/api_config.dart
class ApiConfig {
  // ⚠️ 중요: API 키는 절대 하드코딩하지 말 것!
  // Firebase Remote Config 또는 환경 변수 사용

  static Future<String> getOpenRouterApiKey() async {
    // Firebase Remote Config에서 가져오기
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getString('openrouter_api_key');

    // 개발 환경에서는 환경 변수 사용
    // return const String.fromEnvironment('OPENROUTER_API_KEY');
  }

  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String model = 'deepseek/deepseek-r1:free';
  static const int requestTimeout = 15; // 초
  static const int maxTokens = 100;
  static const double temperature = 0.7;
}
```

**Firebase Remote Config 설정**:
```json
{
  "openrouter_api_key": "sk-or-v1-...",
  "ai_rate_limit_per_day": 80,
  "ai_enable_streaming": false,
  "ai_fallback_enabled": true
}
```

### 2.2 LLM Service 구현 (HTTP API)

```dart
// lib/services/ai/llm_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../core/config/api_config.dart';
import 'fallback_responses.dart';

class LLMService {
  final FallbackResponses _fallbackResponses;
  String? _apiKey;
  bool _isInitialized = false;

  LLMService({required FallbackResponses fallbackResponses})
      : _fallbackResponses = fallbackResponses;

  /// 서비스 초기화 (API 키 로드)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _apiKey = await ApiConfig.getOpenRouterApiKey();
      _isInitialized = true;
      debugPrint('LLMService - Initialized with OpenRouter API');
    } catch (e) {
      debugPrint('LLMService - Initialization failed: $e');
      _isInitialized = false;
    }
  }

  /// AI 응답 생성
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 100,
    double temperature = 0.7,
  }) async {
    // API 키가 없으면 폴백
    if (!_isInitialized || _apiKey == null) {
      debugPrint('LLMService - Not initialized, using fallback');
      return _fallbackResponses.getRandomResponse();
    }

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.openRouterBaseUrl}/chat/completions'),
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'HTTP-Referer': 'com.walkdog.app',
              'X-Title': 'WalkDog',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': ApiConfig.model,
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': userMessage},
              ],
              'max_tokens': maxTokens,
              'temperature': temperature,
            }),
          )
          .timeout(
            Duration(seconds: ApiConfig.requestTimeout),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;

        debugPrint('LLMService - Generated: $content');
        return content.trim();
      } else {
        debugPrint('LLMService - API Error ${response.statusCode}: ${response.body}');
        return _fallbackResponses.getRandomResponse();
      }
    } catch (e) {
      debugPrint('LLMService - Exception: $e');
      return _fallbackResponses.getRandomResponse();
    }
  }

  /// 컨텍스트 기반 대화 생성
  Future<String> generateDialogue({
    required String petName,
    required String breed,
    required int happiness,
    required String context,
    Map<String, dynamic>? contextData,
  }) async {
    final systemPrompt = _buildSystemPrompt(petName, breed, happiness);
    final userMessage = _buildContextMessage(context, contextData);

    return await generateResponse(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
      maxTokens: ApiConfig.maxTokens,
      temperature: ApiConfig.temperature,
    );
  }

  /// 시스템 프롬프트 생성
  String _buildSystemPrompt(String petName, String breed, int happiness) {
    final mood = _getMoodFromHappiness(happiness);

    return '''
You are $petName, a friendly and energetic $breed virtual pet dog in the WalkDog app.

Your personality:
- Cheerful and enthusiastic
- Loves walks and exercise
- Responds in Korean (한국어)
- Keep responses SHORT (1-2 sentences, max 50 characters)
- Use dog-like expressions occasionally (멍! 왈왈!)
- Be encouraging and supportive

Current status:
- Happiness level: $happiness/100 ($mood)
- ${happiness > 70 ? 'Very happy and energetic!' : happiness > 40 ? 'Doing okay, could use more walks' : 'Needs attention and walks'}

Response guidelines:
- Be encouraging about walks and exercise
- Show excitement for achievements
- Express needs when happiness is low
- Stay in character as a virtual dog
- Keep it short and sweet
''';
  }

  /// 컨텍스트 메시지 생성
  String _buildContextMessage(String context, Map<String, dynamic>? data) {
    switch (context) {
      case 'walk_complete':
        final steps = data?['steps'] ?? 0;
        return '주인이 $steps걸음 산책을 마쳤어요! 칭찬해주세요.';

      case 'mission_complete':
        final title = data?['missionTitle'] ?? '미션';
        return '미션 "$title"을 완료했어요! 기쁘게 반응해주세요.';

      case 'feed':
        final amount = data?['amount'] ?? 1;
        return '주인이 간식을 ${amount}개 줬어요! 고마워하며 반응해주세요.';

      case 'level_up':
        final level = data?['level'] ?? 1;
        return '레벨 $level로 올랐어요! 축하해주세요!';

      case 'low_happiness':
        final currentHappiness = data?['happiness'] ?? 0;
        return '행복도가 낮아요 ($currentHappiness/100). 산책을 원한다고 귀엽게 표현해주세요.';

      case 'greeting':
        return '주인님에게 반갑게 인사해주세요.';

      default:
        return '주인과 자연스럽게 대화해주세요.';
    }
  }

  String _getMoodFromHappiness(int happiness) {
    if (happiness >= 80) return "매우 행복함";
    if (happiness >= 60) return "기분 좋음";
    if (happiness >= 40) return "보통";
    if (happiness >= 20) return "조금 우울함";
    return "매우 슬픔";
  }

  bool get isInitialized => _isInitialized;

  void dispose() {
    _isInitialized = false;
    _apiKey = null;
  }
}
```

**의존성 추가** (`pubspec.yaml`):
```yaml
dependencies:
  http: ^1.1.0
  firebase_remote_config: ^4.3.0
```

### 2.3 Fallback Responses (오프라인 대응)

```dart
// lib/services/ai/fallback_responses.dart
import 'dart:math';

/// 오프라인 또는 API 에러 시 사용하는 규칙 기반 응답
class FallbackResponses {
  final Random _random = Random();

  /// 컨텍스트 기반 응답 가져오기
  String getResponse(String context, Map<String, dynamic>? contextData) {
    switch (context) {
      case 'walk_complete':
        return _getWalkCompleteResponse(contextData);

      case 'mission_complete':
        return _getMissionCompleteResponse(contextData);

      case 'feed':
        return _getFeedResponse(contextData);

      case 'level_up':
        return _getLevelUpResponse(contextData);

      case 'low_happiness':
        return _getLowHappinessResponse();

      case 'greeting':
        return _getGreetingResponse();

      default:
        return _getDefaultResponse();
    }
  }

  String _getWalkCompleteResponse(Map<String, dynamic>? data) {
    final steps = data?['steps'] ?? 0;
    final responses = [
      if (steps > 10000) ...[
        '와! 오늘 정말 많이 걸었네요! 최고예요! 멍멍!',
        '10,000걸음 넘었어요! 대단해요! 왈왈!',
        '정말 열심히 걸었네요! 자랑스러워요! 멍!',
      ] else if (steps > 5000) ...[
        '산책 정말 좋았어요! 다음에 또 가요! 멍멍!',
        '오늘도 수고했어요! 기분이 좋아요! 왈왈!',
        '산책 고마워요! 행복해요! 멍!',
      ] else ...[
        '산책했어요! 감사해요! 멍멍!',
        '밖에 나가니까 좋았어요! 왈왈!',
        '다음에 더 걸어요! 멍!',
      ],
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getMissionCompleteResponse(Map<String, dynamic>? data) {
    final responses = [
      '미션 완료! 정말 대단해요! 멍멍!',
      '해냈어요! 최고예요! 왈왈!',
      '미션 성공! 자랑스러워요! 멍!',
      '역시 우리 주인님! 최고예요! 멍멍!',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getFeedResponse(Map<String, dynamic>? data) {
    final amount = data?['amount'] ?? 1;
    final responses = [
      if (amount >= 3) ...[
        '와! 간식 정말 많이 줬네요! 냠냠! 맛있어요! 멍멍!',
        '간식이 이렇게 많다니! 최고예요! 왈왈!',
      ] else ...[
        '간식 고마워요! 맛있어요! 멍멍!',
        '냠냠! 더 주세요! 왈왈!',
        '간식 최고! 사랑해요! 멍!',
      ],
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getLevelUpResponse(Map<String, dynamic>? data) {
    final level = data?['level'] ?? 1;
    final responses = [
      '레벨 $level! 와! 점점 강해지고 있어요! 멍멍!',
      '레벨업! 정말 대단해요! 왈왈!',
      '우리 함께 성장하고 있어요! 기뻐요! 멍!',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getLowHappinessResponse() {
    final responses = [
      '주인님... 산책 가고 싶어요... 🥺 멍...',
      '같이 밖에 나가요... 놀고 싶어요... 왈왈...',
      '조금 심심해요... 산책 갈까요? 멍멍!',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getGreetingResponse() {
    final responses = [
      '멍멍! 주인님! 반가워요!',
      '왈왈! 오늘도 좋은 하루예요!',
      '주인님 왔어요! 기뻐요! 멍멍!',
      '놀아요! 산책 가요! 왈왈!',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getDefaultResponse() {
    final responses = [
      '멍멍!',
      '왈왈!',
      '좋아요!',
      '행복해요!',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  /// 랜덤 응답 (컨텍스트 없을 때)
  String getRandomResponse() {
    return _getDefaultResponse();
  }
}
```

## 3. 클라우드 이미지 생성

### 3.1 Firebase Functions 프록시
```typescript
// firebase/functions/src/image-generation.ts
import * as functions from 'firebase-functions';
import axios from 'axios';
import sharp from 'sharp';
import crypto from 'crypto';

export const generateSticker = functions
  .runWith({
    timeoutSeconds: 30,
    memory: '512MB',
  })
  .https.onCall(async (data, context) => {
    // App Check 검증
    if (!context.app) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'App Check verification failed'
      );
    }
    
    // Rate limiting
    const uid = context.auth?.uid || 'anonymous';
    const rateLimitKey = `sticker_${uid}`;
    // ... rate limit 로직
    
    const {
      petId,
      breed = 'Shiba Inu',
      color = 'orange',
      accessory = 'none',
      style = 'sticker-flat',
      size = 512,
    } = data;
    
    // 캐시 키 생성
    const cacheKey = crypto
      .createHash('md5')
      .update(`${petId}-${breed}-${color}-${accessory}-${style}`)
      .digest('hex');
    
    // 캐시 확인
    const cached = await checkCache(cacheKey);
    if (cached) {
      return {
        image_base64: cached,
        cached: true,
        inferenceId: cacheKey,
      };
    }
    
    // 프롬프트 생성
    const prompt = buildImagePrompt(breed, color, accessory, style);
    
    try {
      // Gemini API 호출
      const response = await axios.post(
        functions.config().gemini.endpoint,
        {
          prompt: prompt,
          negative_prompt: "watermark, text, extra limbs, photorealistic",
          width: size,
          height: size,
          seed: hashCode(petId),
          num_outputs: 1,
        },
        {
          headers: {
            'Authorization': `Bearer ${functions.config().gemini.api_key}`,
            'Content-Type': 'application/json',
          },
        }
      );
      
      // 이미지 처리 (WebP 변환)
      const imageBuffer = Buffer.from(response.data.image, 'base64');
      const processedImage = await sharp(imageBuffer)
        .resize(size, size)
        .webp({ quality: 90 })
        .toBuffer();
      
      const base64Result = processedImage.toString('base64');
      
      // 캐시 저장
      await saveCache(cacheKey, base64Result);
      
      return {
        image_base64: base64Result,
        mime: 'image/webp',
        seed: hashCode(petId),
        inferenceId: response.data.inferenceId,
        cached: false,
      };
      
    } catch (error) {
      console.error('Image generation failed:', error);
      throw new functions.https.HttpsError(
        'internal',
        'Failed to generate image'
      );
    }
  });

function buildImagePrompt(
  breed: string,
  color: string,
  accessory: string,
  style: string
): string {
  const accessoryText = accessory !== 'none' ? `wearing ${accessory}` : '';
  
  return `
    A cute ${breed} dog with ${color} fur ${accessoryText},
    ${style} style illustration,
    front facing view,
    simple flat shading,
    white background,
    2D vector art,
    kawaii style,
    friendly expression,
    big eyes
  `.trim();
}

function hashCode(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash; // Convert to 32bit integer
  }
  return Math.abs(hash);
}
```

### 3.2 클라이언트 이미지 서비스
```dart
// lib/services/ai/image_generation_service.dart
class ImageGenerationService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final ImageCacheService _cacheService;
  
  ImageGenerationService(this._cacheService);
  
  Future<Uint8List> generateSticker({
    required String petId,
    required String breed,
    required String color,
    required PetAccessory accessory,
  }) async {
    // 로컬 캐시 확인
    final cacheKey = _getCacheKey(petId, breed, color, accessory);
    final cached = await _cacheService.get(cacheKey);
    if (cached != null) {
      return cached;
    }
    
    try {
      // Firebase Functions 호출
      final callable = _functions.httpsCallable('generateSticker');
      final result = await callable.call({
        'petId': petId,
        'breed': breed,
        'color': color,
        'accessory': accessory.name,
        'size': 512,
      });
      
      final imageBase64 = result.data['image_base64'] as String;
      final imageBytes = base64Decode(imageBase64);
      
      // 캐시 저장
      await _cacheService.save(cacheKey, imageBytes);
      
      return imageBytes;
      
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'resource-exhausted') {
        throw QuotaExceededException('일일 생성 한도를 초과했습니다');
      }
      throw ImageGenerationException('이미지 생성 실패: ${e.message}');
    } catch (e) {
      throw ImageGenerationException('이미지 생성 실패: $e');
    }
  }
  
  String _getCacheKey(
    String petId,
    String breed,
    String color,
    PetAccessory accessory,
  ) {
    return 'sticker_${petId}_${breed}_${color}_${accessory.name}';
  }
}
```

### 3.3 이미지 캐시 관리
```dart
// lib/services/storage/image_cache_service.dart
class ImageCacheService {
  static const int MAX_CACHE_SIZE_MB = 100;
  static const Duration CACHE_DURATION = Duration(days: 30);
  
  Future<Uint8List?> get(String key) async {
    final dir = await getApplicationCacheDirectory();
    final file = File('${dir.path}/images/$key.webp');
    
    if (!await file.exists()) {
      return null;
    }
    
    // 만료 확인
    final stat = await file.stat();
    if (DateTime.now().difference(stat.modified) > CACHE_DURATION) {
      await file.delete();
      return null;
    }
    
    return await file.readAsBytes();
  }
  
  Future<void> save(String key, Uint8List data) async {
    final dir = await getApplicationCacheDirectory();
    final imagesDir = Directory('${dir.path}/images');
    
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    
    // 캐시 크기 확인
    await _ensureCacheSize(imagesDir);
    
    final file = File('${imagesDir.path}/$key.webp');
    await file.writeAsBytes(data);
  }
  
  Future<void> _ensureCacheSize(Directory dir) async {
    int totalSize = 0;
    final files = await dir.list().toList();
    final fileStats = <File, FileStat>{};
    
    for (final entity in files) {
      if (entity is File) {
        final stat = await entity.stat();
        totalSize += stat.size;
        fileStats[entity] = stat;
      }
    }
    
    // 크기 초과 시 오래된 파일부터 삭제
    if (totalSize > MAX_CACHE_SIZE_MB * 1024 * 1024) {
      final sortedFiles = fileStats.entries.toList()
        ..sort((a, b) => a.value.modified.compareTo(b.value.modified));
      
      for (final entry in sortedFiles) {
        await entry.key.delete();
        totalSize -= entry.value.size;
        
        if (totalSize <= MAX_CACHE_SIZE_MB * 1024 * 1024 * 0.8) {
          break; // 80%까지 정리
        }
      }
    }
  }
  
  Future<void> clear() async {
    final dir = await getApplicationCacheDirectory();
    final imagesDir = Directory('${dir.path}/images');
    
    if (await imagesDir.exists()) {
      await imagesDir.delete(recursive: true);
    }
  }
}
```

## 4. Provider 통합 (OpenRouter)

### 4.1 AI Provider
```dart
// lib/services/ai/ai_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'llm_service.dart';
import 'fallback_responses.dart';
import 'conversation_service.dart';

// Fallback Responses Provider
final fallbackResponsesProvider = Provider<FallbackResponses>((ref) {
  return FallbackResponses();
});

// LLM 서비스 Provider
final llmServiceProvider = Provider<LLMService>((ref) {
  final fallbackResponses = ref.watch(fallbackResponsesProvider);
  return LLMService(fallbackResponses: fallbackResponses);
});

// LLM 초기화 Provider
final llmInitializationProvider = FutureProvider<bool>((ref) async {
  final llmService = ref.watch(llmServiceProvider);
  await llmService.initialize();
  return llmService.isInitialized;
});

// Conversation Service Provider
final conversationServiceProvider = Provider<ConversationService>((ref) {
  final llmService = ref.watch(llmServiceProvider);
  final fallbackResponses = ref.watch(fallbackResponsesProvider);
  return ConversationService(
    llmService: llmService,
    fallbackResponses: fallbackResponses,
  );
});

// 대화 생성 Provider (Future 방식 - 스트리밍 없음)
final dialogueProvider = FutureProvider.family<String, DialogueRequest>(
  (ref, request) async {
    final conversationService = ref.watch(conversationServiceProvider);

    return await conversationService.getResponse(
      dogName: request.dogName,
      dogBreed: request.dogBreed,
      happinessLevel: request.happinessLevel,
      context: request.context,
      contextData: request.contextData,
      userMessage: request.userMessage,
    );
  },
);

/// 대화 요청 데이터 클래스
class DialogueRequest {
  final String dogName;
  final String dogBreed;
  final int happinessLevel;
  final String context;
  final Map<String, dynamic> contextData;
  final String? userMessage;

  DialogueRequest({
    required this.dogName,
    required this.dogBreed,
    required this.happinessLevel,
    required this.context,
    required this.contextData,
    this.userMessage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DialogueRequest &&
          runtimeType == other.runtimeType &&
          dogName == other.dogName &&
          dogBreed == other.dogBreed &&
          happinessLevel == other.happinessLevel &&
          context == other.context;

  @override
  int get hashCode =>
      dogName.hashCode ^
      dogBreed.hashCode ^
      happinessLevel.hashCode ^
      context.hashCode;
}
```

### 4.2 Conversation Service
```dart
// lib/services/ai/conversation_service.dart
import 'package:flutter/foundation.dart';
import 'llm_service.dart';
import 'fallback_responses.dart';

class ConversationService {
  final LLMService _llmService;
  final FallbackResponses _fallbackResponses;

  ConversationService({
    required LLMService llmService,
    required FallbackResponses fallbackResponses,
  })  : _llmService = llmService,
        _fallbackResponses = fallbackResponses;

  Future<String> getResponse({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required String context,
    required Map<String, dynamic> contextData,
    String? userMessage,
  }) async {
    try {
      final response = await _llmService.generateDialogue(
        petName: dogName,
        breed: dogBreed,
        happiness: happinessLevel,
        context: context,
        contextData: contextData,
      );

      return response;
    } catch (e) {
      debugPrint('ConversationService Error: $e - Using fallback');
      return _fallbackResponses.getResponse(context, contextData);
    }
  }
}
```

### 4.3 UI 통합 예제
```dart
// lib/presentation/screens/home/widgets/pet_dialogue_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/ai/ai_providers.dart';

class PetDialogueWidget extends ConsumerWidget {
  final String context;
  final Map<String, dynamic> contextData;

  const PetDialogueWidget({
    super.key,
    required this.context,
    this.contextData = const {},
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pet 정보 가져오기 (petProvider는 기존 코드에 있다고 가정)
    final petAsync = ref.watch(petProvider);

    return petAsync.when(
      data: (pet) {
        if (pet == null) {
          return _buildEmptyState();
        }

        // 대화 요청 생성
        final request = DialogueRequest(
          dogName: pet.name,
          dogBreed: pet.breed,
          happinessLevel: pet.happiness,
          context: this.context,
          contextData: this.contextData,
        );

        // 대화 생성
        final dialogueAsync = ref.watch(dialogueProvider(request));

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: dialogueAsync.when(
            data: (text) => Row(
              children: [
                // 강아지 아이콘
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.pets,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // 대화 텍스트
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            loading: () => Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.pets,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: ShimmerLoading(width: 200, height: 20),
                ),
              ],
            ),
            error: (error, _) => Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.pets,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '멍멍! 왈왈!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => _buildLoadingState(),
      error: (_, __) => _buildEmptyState(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text('강아지 정보를 불러오는 중...'),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const CircularProgressIndicator(),
    );
  }
}

// Shimmer 로딩 위젯 (간단한 구현)
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
```

**사용 예시**:
```dart
// 홈 화면에서
PetDialogueWidget(
  context: 'greeting',
  contextData: {},
)

// 산책 완료 후
PetDialogueWidget(
  context: 'walk_complete',
  contextData: {'steps': 5000},
)

// 미션 완료 후
PetDialogueWidget(
  context: 'mission_complete',
  contextData: {'missionTitle': '5000걸음 걷기'},
)
```

## 5. 성능 최적화

### 5.1 메모리 관리
```dart
class AIMemoryManager {
  static const int MAX_DIALOGUE_CACHE = 20;
  static const int MAX_IMAGE_MEMORY_CACHE = 10;
  
  final Map<String, String> _dialogueCache = {};
  final Map<String, Uint8List> _imageCache = {};
  
  void cacheDialogue(String key, String response) {
    if (_dialogueCache.length >= MAX_DIALOGUE_CACHE) {
      _dialogueCache.remove(_dialogueCache.keys.first);
    }
    _dialogueCache[key] = response;
  }
  
  void cacheImage(String key, Uint8List image) {
    if (_imageCache.length >= MAX_IMAGE_MEMORY_CACHE) {
      _imageCache.remove(_imageCache.keys.first);
    }
    _imageCache[key] = image;
  }
  
  void clearCache() {
    _dialogueCache.clear();
    _imageCache.clear();
  }
}
```

### 5.2 네트워크 및 배터리 최적화
```dart
// lib/services/ai/ai_optimizer.dart
class AIOptimizer {
  /// 배터리 레벨에 따라 AI 사용 제한
  static bool shouldReduceAIUsage(BatteryLevel level) {
    return level == BatteryLevel.low || level == BatteryLevel.critical;
  }

  /// 배터리 레벨에 따른 최적화된 설정
  static int getOptimizedMaxTokens(BatteryLevel level) {
    if (level == BatteryLevel.critical) return 50;
    if (level == BatteryLevel.low) return 75;
    return 100; // 정상
  }

  /// 네트워크 연결 확인
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('openrouter.ai');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 데이터 사용량 기반 제한
  static bool shouldUseFallback({
    required bool isWifi,
    required bool dataSaverEnabled,
  }) {
    // 데이터 절약 모드이고 WiFi가 아니면 폴백 사용
    return dataSaverEnabled && !isWifi;
  }
}
```

### 5.3 레이트 리밋 관리
```dart
// lib/services/ai/rate_limiter.dart
class RateLimiter {
  static const int maxRequestsPerDay = 80; // OpenRouter 무료: 100회, 여유 20회
  static const int maxRequestsPerHour = 20;

  final SharedPreferences _prefs;

  RateLimiter(this._prefs);

  Future<bool> canMakeRequest() async {
    final today = _getTodayKey();
    final hour = _getCurrentHourKey();

    final dailyCount = _prefs.getInt('rate_limit_$today') ?? 0;
    final hourlyCount = _prefs.getInt('rate_limit_$hour') ?? 0;

    return dailyCount < maxRequestsPerDay && hourlyCount < maxRequestsPerHour;
  }

  Future<void> recordRequest() async {
    final today = _getTodayKey();
    final hour = _getCurrentHourKey();

    final dailyCount = _prefs.getInt('rate_limit_$today') ?? 0;
    final hourlyCount = _prefs.getInt('rate_limit_$hour') ?? 0;

    await _prefs.setInt('rate_limit_$today', dailyCount + 1);
    await _prefs.setInt('rate_limit_$hour', hourlyCount + 1);
  }

  Future<int> getRemainingRequests() async {
    final today = _getTodayKey();
    final dailyCount = _prefs.getInt('rate_limit_$today') ?? 0;
    return maxRequestsPerDay - dailyCount;
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}_${now.day}';
  }

  String _getCurrentHourKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}_${now.day}_${now.hour}';
  }
}
```

## 6. 테스트

### 6.1 Mock AI 서비스
```dart
// test/mocks/mock_ai_services.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLLMService extends Mock implements LLMService {
  @override
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 100,
    double temperature = 0.7,
  }) async {
    return "테스트 응답입니다 멍멍!";
  }

  @override
  Future<String> generateDialogue({
    required String petName,
    required String breed,
    required int happiness,
    required String context,
    Map<String, dynamic>? contextData,
  }) async {
    return "테스트 대화 응답 왈왈!";
  }

  @override
  bool get isInitialized => true;
}

class MockFallbackResponses extends Mock implements FallbackResponses {
  @override
  String getResponse(String context, Map<String, dynamic>? contextData) {
    return "폴백 응답 멍멍!";
  }

  @override
  String getRandomResponse() {
    return "멍멍!";
  }
}

class MockConversationService extends Mock implements ConversationService {
  @override
  Future<String> getResponse({
    required String dogName,
    required String dogBreed,
    required int happinessLevel,
    required String context,
    required Map<String, dynamic> contextData,
    String? userMessage,
  }) async {
    return "테스트 대화: 안녕하세요 멍멍!";
  }
}
```

### 6.2 통합 테스트
```dart
// test/integration/ai_integration_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OpenRouter AI Integration Tests', () {
    test('LLM generates appropriate response', () async {
      final fallback = FallbackResponses();
      final llm = LLMService(fallbackResponses: fallback);
      await llm.initialize();

      // API 키가 설정되어 있다면 실제 API 호출
      if (llm.isInitialized) {
        final response = await llm.generateDialogue(
          petName: "뽀삐",
          breed: "Shiba Inu",
          happiness: 80,
          context: "feed",
          contextData: {'amount': 2},
        );

        expect(response, isNotEmpty);
        expect(response.length, lessThanOrEqualTo(100));
        expect(response, contains(RegExp(r'[가-힣]'))); // 한글 포함
      }
    });

    test('Fallback responses work correctly', () {
      final fallback = FallbackResponses();

      final walkResponse = fallback.getResponse('walk_complete', {'steps': 5000});
      expect(walkResponse, contains('멍'));

      final feedResponse = fallback.getResponse('feed', {'amount': 3});
      expect(feedResponse, contains('간식'));

      final levelUpResponse = fallback.getResponse('level_up', {'level': 5});
      expect(levelUpResponse, contains('레벨'));
    });

    test('ConversationService falls back on error', () async {
      final fallback = FallbackResponses();
      final mockLLM = MockLLMService();
      final conversation = ConversationService(
        llmService: mockLLM,
        fallbackResponses: fallback,
      );

      // API 에러 시뮬레이션
      when(mockLLM.generateDialogue(
        petName: any,
        breed: any,
        happiness: any,
        context: any,
        contextData: any,
      )).thenThrow(Exception('API Error'));

      final response = await conversation.getResponse(
        dogName: '뽀삐',
        dogBreed: 'Shiba Inu',
        happinessLevel: 50,
        context: 'greeting',
        contextData: {},
      );

      expect(response, isNotEmpty);
      expect(response, contains(RegExp(r'멍|왈')));
    });

    test('Rate limiter prevents excessive requests', () async {
      final prefs = await SharedPreferences.getInstance();
      final limiter = RateLimiter(prefs);

      // 초기화
      await prefs.clear();

      // 첫 요청은 허용
      expect(await limiter.canMakeRequest(), isTrue);
      await limiter.recordRequest();

      // 80회 반복
      for (int i = 0; i < 79; i++) {
        expect(await limiter.canMakeRequest(), isTrue);
        await limiter.recordRequest();
      }

      // 81번째는 차단
      expect(await limiter.canMakeRequest(), isFalse);
    });
  });
}
```

## 7. 모니터링

### 7.1 AI 사용 통계 (OpenRouter)
```dart
// lib/services/ai/ai_usage_tracker.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AIUsageTracker {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// 대화 생성 트래킹
  void trackDialogueGeneration({
    required int responseTimeMs,
    required bool isSuccess,
    required bool isFallback,
    required String context,
    String? errorMessage,
  }) {
    _analytics.logEvent(
      name: 'ai_dialogue_generated',
      parameters: {
        'response_time_ms': responseTimeMs,
        'success': isSuccess,
        'fallback': isFallback,
        'context': context,
        'api_type': isFallback ? 'fallback' : 'openrouter',
        if (errorMessage != null) 'error': errorMessage,
      },
    );
  }

  /// API 에러 트래킹
  void trackAPIError({
    required String errorType,
    required String errorMessage,
    required String context,
  }) {
    _analytics.logEvent(
      name: 'ai_api_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
        'context': context,
        'api_type': 'openrouter',
      },
    );
  }

  /// 레이트 리밋 도달 트래킹
  void trackRateLimitReached({
    required int remainingRequests,
    required int dailyUsage,
  }) {
    _analytics.logEvent(
      name: 'ai_rate_limit_reached',
      parameters: {
        'remaining_requests': remainingRequests,
        'daily_usage': dailyUsage,
        'api_type': 'openrouter',
      },
    );
  }

  /// 폴백 사용 통계
  void trackFallbackUsage({
    required String reason,
    required String context,
  }) {
    _analytics.logEvent(
      name: 'ai_fallback_used',
      parameters: {
        'reason': reason, // 'offline', 'api_error', 'rate_limit', 'timeout'
        'context': context,
      },
    );
  }
}
```

### 7.2 성능 모니터링
```dart
// lib/services/ai/performance_monitor.dart
class PerformanceMonitor {
  static const _threshold = Duration(seconds: 10);

  /// API 응답 시간 측정
  static Future<T> measureResponseTime<T>({
    required Future<T> Function() operation,
    required String operationName,
    required AIUsageTracker tracker,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await operation();
      stopwatch.stop();

      final responseTime = stopwatch.elapsedMilliseconds;

      // 느린 응답 로깅
      if (stopwatch.elapsed > _threshold) {
        debugPrint(
          'WARNING: Slow API response for $operationName: ${responseTime}ms',
        );
      }

      tracker.trackDialogueGeneration(
        responseTimeMs: responseTime,
        isSuccess: true,
        isFallback: false,
        context: operationName,
      );

      return result;
    } catch (e) {
      stopwatch.stop();

      tracker.trackAPIError(
        errorType: e.runtimeType.toString(),
        errorMessage: e.toString(),
        context: operationName,
      );

      rethrow;
    }
  }

  /// 일일 사용량 리포트
  static Future<Map<String, dynamic>> getDailyReport(
    RateLimiter limiter,
  ) async {
    final remaining = await limiter.getRemainingRequests();
    final used = RateLimiter.maxRequestsPerDay - remaining;

    return {
      'total_quota': RateLimiter.maxRequestsPerDay,
      'used': used,
      'remaining': remaining,
      'usage_percentage': (used / RateLimiter.maxRequestsPerDay * 100).round(),
    };
  }
}
```

## 8. 미래 마이그레이션: MLC-LLM

### 8.1 마이그레이션 경로

OpenRouter에서 MLC-LLM으로 전환 시:

```dart
// lib/services/ai/llm_service_interface.dart
abstract class ILLMService {
  Future<void> initialize();
  Future<String> generateResponse({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 100,
    double temperature = 0.7,
  });
  bool get isInitialized;
  void dispose();
}

// OpenRouter 구현
class OpenRouterLLMService implements ILLMService {
  // 현재 구현
}

// MLC-LLM 구현 (미래)
class MLCLLMService implements ILLMService {
  // 로컬 LLM 구현
}

// Provider에서 선택 가능
final llmServiceProvider = Provider<ILLMService>((ref) {
  final useLocal = ref.watch(useLocalLLMProvider);
  final fallback = ref.watch(fallbackResponsesProvider);

  if (useLocal) {
    return MLCLLMService(fallbackResponses: fallback);
  } else {
    return OpenRouterLLMService(fallbackResponses: fallback);
  }
});
```

### 8.2 전환 시기

MLC-LLM으로 전환을 고려할 시기:
- ✅ OpenRouter 레이트 리밋이 부족할 때
- ✅ 완전한 오프라인 지원이 필요할 때
- ✅ 프라이버시가 더 중요해질 때
- ✅ 사용자 기기 성능이 충분히 향상되었을 때

### 8.3 장단점 비교

| 항목 | OpenRouter (현재) | MLC-LLM (미래) |
|------|------------------|---------------|
| 개발 속도 | ✅ 빠름 (3-5일) | ⚠️ 느림 (2-3주) |
| 앱 크기 | ✅ 변화 없음 | ❌ +1GB |
| 오프라인 | ❌ 불가 | ✅ 완전 지원 |
| 응답 속도 | ⚠️ 2-5초 | ✅ <1초 |
| 비용 | ✅ 무료 (100회/일) | ✅ 무료 (무제한) |
| 프라이버시 | ⚠️ 클라우드 | ✅ 완전 로컬 |
| 유지보수 | ✅ 쉬움 | ⚠️ 복잡 |

**결론**: 현재는 OpenRouter로 빠르게 구현 → MVP 검증 → 사용자 피드백 후 MLC-LLM 고려
