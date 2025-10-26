// lib/test_remote_config.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'core/services/firebase_service.dart';
import 'services/config/remote_config_service.dart';
import 'core/config/api_config.dart';

/// Remote Config 테스트 앱
///
/// Firebase Remote Config에서 API 키를 제대로 가져오는지 확인
///
/// 사용법:
/// ```bash
/// flutter run --target=lib/test_remote_config.dart
/// ```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('======================================');
  debugPrint('🔧 Remote Config 테스트 시작');
  debugPrint('======================================');

  // 1. Firebase 초기화
  debugPrint('\n📱 Step 1: Firebase 초기화');
  final firebaseInit = await FirebaseService.initialize();
  debugPrint('   결과: ${firebaseInit ? "성공 ✅" : "실패 ❌"}');

  if (!firebaseInit) {
    debugPrint('❌ Firebase 초기화 실패. 테스트 중단.');
    return;
  }

  // 2. Remote Config 초기화
  debugPrint('\n☁️ Step 2: Remote Config 초기화');
  final remoteConfigInit = await RemoteConfigService.initialize();
  debugPrint('   결과: ${remoteConfigInit ? "성공 ✅" : "실패 ❌"}');

  if (!remoteConfigInit) {
    debugPrint('⚠️ Remote Config 초기화 실패. 환경 변수로 폴백합니다.');
  }

  // 3. Remote Config 값 확인
  debugPrint('\n📊 Step 3: Remote Config 파라미터 확인');
  if (RemoteConfigService.isInitialized) {
    final apiKey = RemoteConfigService.getOpenRouterApiKey();
    final dailyLimit = RemoteConfigService.getRateLimitDaily();
    final hourlyLimit = RemoteConfigService.getRateLimitHourly();
    final debugLogs = RemoteConfigService.isDebugLogsEnabled();

    debugPrint('   - openrouter_api_key: ${_maskApiKey(apiKey)}');
    debugPrint('   - rate_limit_daily: $dailyLimit');
    debugPrint('   - rate_limit_hourly: $hourlyLimit');
    debugPrint('   - enable_debug_logs: $debugLogs');

    // API 키 유효성 검증
    final isValid = ApiConfig.isValidApiKey(apiKey);
    debugPrint('\n🔐 API 키 유효성: ${isValid ? "유효 ✅" : "무효 ❌"}');

    if (!isValid && apiKey.isNotEmpty) {
      debugPrint('   ⚠️ API 키가 "sk-or-"로 시작하지 않습니다.');
    } else if (apiKey.isEmpty) {
      debugPrint('   ⚠️ API 키가 비어있습니다.');
    }
  } else {
    debugPrint('   ❌ Remote Config가 초기화되지 않았습니다.');
  }

  // 4. ApiConfig.getOpenRouterApiKey() 테스트
  debugPrint('\n🔑 Step 4: ApiConfig에서 API 키 가져오기');
  try {
    final apiKey = await ApiConfig.getOpenRouterApiKey();
    debugPrint('   API 키: ${_maskApiKey(apiKey)}');
    debugPrint('   결과: 성공 ✅');
  } catch (e) {
    debugPrint('   결과: 실패 ❌');
    debugPrint('   에러: $e');
  }

  debugPrint('\n======================================');
  debugPrint('✅ Remote Config 테스트 완료');
  debugPrint('======================================');

  runApp(const RemoteConfigTestApp());
}

/// API 키 마스킹 (앞 10자, 뒤 4자만 표시)
String _maskApiKey(String key) {
  if (key.isEmpty) return '(empty)';
  if (key.length <= 14) return '***';
  return '${key.substring(0, 10)}...${key.substring(key.length - 4)}';
}

class RemoteConfigTestApp extends StatelessWidget {
  const RemoteConfigTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Config Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RemoteConfigTestScreen(),
    );
  }
}

class RemoteConfigTestScreen extends StatelessWidget {
  const RemoteConfigTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Config Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_done,
              size: 120,
              color: Colors.blue,
            ),
            const SizedBox(height: 32),
            const Text(
              'Remote Config 테스트 완료',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '콘솔 로그를 확인하세요',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () async {
                debugPrint('\n🔄 Remote Config 재확인');

                if (RemoteConfigService.isInitialized) {
                  final apiKey = RemoteConfigService.getOpenRouterApiKey();
                  final dailyLimit = RemoteConfigService.getRateLimitDaily();
                  final hourlyLimit = RemoteConfigService.getRateLimitHourly();

                  debugPrint('   - API Key: ${_maskApiKey(apiKey)}');
                  debugPrint('   - Daily Limit: $dailyLimit');
                  debugPrint('   - Hourly Limit: $hourlyLimit');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Remote Config 값 확인 완료 (콘솔 참조)'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Remote Config가 초기화되지 않았습니다'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('다시 확인'),
            ),
          ],
        ),
      ),
    );
  }
}
