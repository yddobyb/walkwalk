// lib/test_happiness_decay.dart
// 행복도 자동 감소 DB 검증 테스트
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'data/datasources/database_service.dart';
import 'domain/entities/pet.dart';
import 'services/pet/pet_reward_service.dart';

/// 행복도 감소 시스템 테스트 화면
class HappinessDecayTestScreen extends StatefulWidget {
  const HappinessDecayTestScreen({super.key});

  @override
  State<HappinessDecayTestScreen> createState() => _HappinessDecayTestScreenState();
}

class _HappinessDecayTestScreenState extends State<HappinessDecayTestScreen> {
  final DatabaseService _db = DatabaseService();
  final PetRewardService _rewardService = PetRewardService.instance;

  String _testLog = '테스트 대기 중...\n';
  Pet? _testPet;
  bool _isRunning = false;

  void _log(String message) {
    setState(() {
      _testLog += '$message\n';
    });
    print('🧪 TEST: $message');
  }

  /// 테스트 1: lastDecayDate null인 새 펫 생성 및 저장
  Future<void> _test1_CreatePetWithNullDecayDate() async {
    _log('\n========================================');
    _log('테스트 1: lastDecayDate null인 펫 생성');
    _log('========================================');

    final testPet = Pet(
      petId: const Uuid().v4(),
      name: 'TestDog',
      breed: 'Test Breed',
      color: 'Brown',
      accessory: PetAccessory.none,
      happiness: 100,
      treats: 10,
      level: 1,
      experience: 0,
      stepsToday: 0,
      totalSteps: 0,
      lastUpdate: DateTime.now(),
      lastDecayDate: null, // 명시적으로 null
      personality: PetPersonality.cheerful,
      isActive: false, // 활성 펫이 아님 (테스트용)
      createdAt: DateTime.now().subtract(const Duration(days: 2)), // 2일 전 생성
      consecutiveDays: 0,
      bestStreak: 0,
      avgDailySteps: 0,
    );

    _log('펫 생성 완료:');
    _log('  - petId: ${testPet.petId}');
    _log('  - happiness: ${testPet.happiness}');
    _log('  - lastDecayDate: ${testPet.lastDecayDate}');
    _log('  - createdAt: ${testPet.createdAt}');

    // DB에 저장
    await _db.savePet(testPet);
    _log('✅ DB 저장 완료');

    // DB에서 다시 로드
    final loadedPet = await _db.getPetById(testPet.petId);
    if (loadedPet == null) {
      _log('❌ 펫을 다시 로드할 수 없음!');
      return;
    }

    _log('DB에서 로드한 펫:');
    _log('  - petId: ${loadedPet.petId}');
    _log('  - happiness: ${loadedPet.happiness}');
    _log('  - lastDecayDate: ${loadedPet.lastDecayDate}');
    _log('  - createdAt: ${loadedPet.createdAt}');

    // 검증
    if (loadedPet.lastDecayDate == null) {
      _log('✅ lastDecayDate가 null로 올바르게 저장/로드됨');
    } else {
      _log('❌ lastDecayDate가 null이어야 하는데 ${loadedPet.lastDecayDate}');
    }

    setState(() {
      _testPet = loadedPet;
    });
  }

  /// 테스트 2: applyDailyHappinessDecay 호출 및 lastDecayDate 업데이트 확인
  Future<void> _test2_ApplyDecayAndCheckUpdate() async {
    if (_testPet == null) {
      _log('❌ 테스트 1을 먼저 실행하세요');
      return;
    }

    _log('\n========================================');
    _log('테스트 2: applyDailyHappinessDecay 호출');
    _log('========================================');

    _log('감소 적용 전:');
    _log('  - happiness: ${_testPet!.happiness}');
    _log('  - lastDecayDate: ${_testPet!.lastDecayDate}');

    // 행복도 감소 적용
    final updatedPet = await _rewardService.applyDailyHappinessDecay(_testPet!.petId);

    if (updatedPet == null) {
      _log('❌ applyDailyHappinessDecay 실패!');
      return;
    }

    _log('감소 적용 후 (메모리):');
    _log('  - happiness: ${updatedPet.happiness}');
    _log('  - lastDecayDate: ${updatedPet.lastDecayDate}');

    // DB에서 다시 로드하여 실제 저장 확인
    await Future.delayed(const Duration(milliseconds: 500)); // DB 쓰기 대기
    final verifyPet = await _db.getPetById(_testPet!.petId);

    if (verifyPet == null) {
      _log('❌ DB 검증 실패: 펫을 다시 로드할 수 없음');
      return;
    }

    _log('감소 적용 후 (DB 검증):');
    _log('  - happiness: ${verifyPet.happiness}');
    _log('  - lastDecayDate: ${verifyPet.lastDecayDate}');

    // 검증
    final expectedHappiness = _testPet!.happiness - 10; // 2일 × 5 = 10 감소

    if (verifyPet.happiness < _testPet!.happiness) {
      _log('✅ 행복도가 감소함: ${_testPet!.happiness} → ${verifyPet.happiness}');
    } else {
      _log('❌ 행복도가 감소하지 않음!');
    }

    if (verifyPet.lastDecayDate != null) {
      _log('✅ lastDecayDate가 업데이트됨: ${verifyPet.lastDecayDate}');
    } else {
      _log('❌ lastDecayDate가 여전히 null!');
    }

    setState(() {
      _testPet = verifyPet;
    });
  }

  /// 테스트 3: 같은 날 재호출 시 감소 안되는지 확인
  Future<void> _test3_SameDayNoDecay() async {
    if (_testPet == null) {
      _log('❌ 테스트 2를 먼저 실행하세요');
      return;
    }

    _log('\n========================================');
    _log('테스트 3: 같은 날 재호출 (감소 안되어야 함)');
    _log('========================================');

    final beforeHappiness = _testPet!.happiness;
    _log('재호출 전 happiness: $beforeHappiness');

    // 같은 날 다시 호출
    final updatedPet = await _rewardService.applyDailyHappinessDecay(_testPet!.petId);

    if (updatedPet == null) {
      _log('❌ applyDailyHappinessDecay 실패!');
      return;
    }

    _log('재호출 후 happiness: ${updatedPet.happiness}');

    // 검증
    if (updatedPet.happiness == beforeHappiness) {
      _log('✅ 같은 날 재호출 시 행복도 변화 없음 (정상)');
    } else {
      _log('❌ 같은 날인데 행복도가 변경됨! ($beforeHappiness → ${updatedPet.happiness})');
    }

    setState(() {
      _testPet = updatedPet;
    });
  }

  /// 테스트 4: lastDecayDate를 3일 전으로 설정하고 다시 테스트
  Future<void> _test4_SimulateThreeDaysLater() async {
    if (_testPet == null) {
      _log('❌ 테스트 1을 먼저 실행하세요');
      return;
    }

    _log('\n========================================');
    _log('테스트 4: 3일 전으로 lastDecayDate 강제 설정');
    _log('========================================');

    // 3일 전 날짜로 강제 설정
    final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
    final modifiedPet = _testPet!.copyWith(
      lastDecayDate: threeDaysAgo,
      happiness: 100, // 행복도도 100으로 리셋
    );

    _log('강제 설정:');
    _log('  - lastDecayDate: ${modifiedPet.lastDecayDate}');
    _log('  - happiness: ${modifiedPet.happiness}');

    // DB에 저장
    await _db.savePet(modifiedPet);
    _log('✅ DB 저장 완료');

    // 검증 로드
    await Future.delayed(const Duration(milliseconds: 500));
    final verifyPet = await _db.getPetById(modifiedPet.petId);

    if (verifyPet == null) {
      _log('❌ DB 검증 실패');
      return;
    }

    _log('DB 검증:');
    _log('  - lastDecayDate: ${verifyPet.lastDecayDate}');
    _log('  - happiness: ${verifyPet.happiness}');

    // 이제 감소 적용
    _log('\n감소 적용 시작...');
    final decayedPet = await _rewardService.applyDailyHappinessDecay(verifyPet.petId);

    if (decayedPet == null) {
      _log('❌ applyDailyHappinessDecay 실패!');
      return;
    }

    _log('감소 적용 후:');
    _log('  - happiness: ${decayedPet.happiness}');
    _log('  - lastDecayDate: ${decayedPet.lastDecayDate}');

    // 3일 × 5 = 15 감소 예상
    final expectedHappiness = 100 - 15;

    if (decayedPet.happiness == expectedHappiness) {
      _log('✅ 3일치 감소 정확히 적용됨: 100 → ${decayedPet.happiness}');
    } else {
      _log('⚠️ 예상: $expectedHappiness, 실제: ${decayedPet.happiness}');
    }

    setState(() {
      _testPet = decayedPet;
    });
  }

  /// 모든 테스트 실행
  Future<void> _runAllTests() async {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _testLog = '테스트 시작...\n';
      _testPet = null;
    });

    try {
      await _test1_CreatePetWithNullDecayDate();
      await Future.delayed(const Duration(seconds: 1));

      await _test2_ApplyDecayAndCheckUpdate();
      await Future.delayed(const Duration(seconds: 1));

      await _test3_SameDayNoDecay();
      await Future.delayed(const Duration(seconds: 1));

      await _test4_SimulateThreeDaysLater();

      _log('\n========================================');
      _log('✅ 모든 테스트 완료!');
      _log('========================================');
    } catch (e, stackTrace) {
      _log('\n❌ 테스트 중 에러 발생:');
      _log('$e');
      _log('$stackTrace');
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  /// 테스트 펫 삭제
  Future<void> _cleanup() async {
    if (_testPet != null) {
      await _db.deletePet(_testPet!.petId);
      _log('🗑️ 테스트 펫 삭제 완료');
      setState(() {
        _testPet = null;
      });
    }
  }

  /// 실제 활성 펫 데이터 조회
  Future<void> _checkActivePet() async {
    _log('\n========================================');
    _log('실제 활성 펫 데이터 조회');
    _log('========================================');

    try {
      final activePet = await _rewardService.getActivePet();

      if (activePet == null) {
        _log('❌ 활성 펫이 없습니다!');
        return;
      }

      _log('🐕 활성 펫 정보:');
      _log('  - petId: ${activePet.petId}');
      _log('  - name: ${activePet.name}');
      _log('  - happiness: ${activePet.happiness}');
      _log('  - lastDecayDate: ${activePet.lastDecayDate}');
      _log('  - createdAt: ${activePet.createdAt}');
      _log('  - lastUpdate: ${activePet.lastUpdate}');
      _log('  - isActive: ${activePet.isActive}');

      // 날짜 계산
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (activePet.lastDecayDate == null) {
        final createdDay = DateTime(activePet.createdAt.year, activePet.createdAt.month, activePet.createdAt.day);
        final daysPassed = today.difference(createdDay).inDays;
        _log('\n📊 분석 (lastDecayDate가 null):');
        _log('  - 생성일: $createdDay');
        _log('  - 오늘: $today');
        _log('  - 경과 일수: $daysPassed일');
        _log('  - 예상 감소량: ${daysPassed * 5}');
        _log('  - 예상 행복도: ${activePet.happiness} (현재) → ${activePet.happiness - (daysPassed * 5)} (감소 후)');
      } else {
        final lastDecayDay = DateTime(activePet.lastDecayDate!.year, activePet.lastDecayDate!.month, activePet.lastDecayDate!.day);
        final daysPassed = today.difference(lastDecayDay).inDays;
        _log('\n📊 분석 (lastDecayDate 존재):');
        _log('  - 마지막 감소일: $lastDecayDay');
        _log('  - 오늘: $today');
        _log('  - 경과 일수: $daysPassed일');
        _log('  - 예상 감소량: ${daysPassed * 5}');
        _log('  - 예상 행복도: ${activePet.happiness} (현재) → ${activePet.happiness - (daysPassed * 5)} (감소 후)');
      }

      // 모든 펫 조회
      _log('\n📋 DB의 모든 펫 목록:');
      final allPets = await _db.getAllPets();
      _log('  - 총 ${allPets.length}개의 펫');
      for (final pet in allPets) {
        _log('    ${pet.isActive ? "✅" : "⬜"} ${pet.name} (happiness: ${pet.happiness}, lastDecayDate: ${pet.lastDecayDate})');
      }

      setState(() {
        _testPet = activePet;
      });
    } catch (e, stackTrace) {
      _log('❌ 에러 발생: $e');
      _log('$stackTrace');
    }
  }

  /// 활성 펫에 수동으로 감소 적용
  Future<void> _manualApplyDecayToActivePet() async {
    _log('\n========================================');
    _log('활성 펫에 수동으로 감소 적용');
    _log('========================================');

    try {
      final activePet = await _rewardService.getActivePet();

      if (activePet == null) {
        _log('❌ 활성 펫이 없습니다!');
        return;
      }

      _log('감소 적용 전:');
      _log('  - happiness: ${activePet.happiness}');
      _log('  - lastDecayDate: ${activePet.lastDecayDate}');

      final updatedPet = await _rewardService.applyDailyHappinessDecay(activePet.petId);

      if (updatedPet == null) {
        _log('❌ 감소 적용 실패!');
        return;
      }

      _log('감소 적용 후:');
      _log('  - happiness: ${updatedPet.happiness}');
      _log('  - lastDecayDate: ${updatedPet.lastDecayDate}');

      if (updatedPet.happiness < activePet.happiness) {
        _log('✅ 행복도 감소 성공: ${activePet.happiness} → ${updatedPet.happiness}');
      } else if (updatedPet.happiness == activePet.happiness) {
        _log('⚠️ 행복도 변화 없음 (이미 오늘 감소 적용되었거나 daysPassed = 0)');
      } else {
        _log('❌ 행복도가 증가함?! (비정상)');
      }

      // UI 새로고침을 위해 다시 조회
      await Future.delayed(const Duration(milliseconds: 500));
      await _checkActivePet();
    } catch (e, stackTrace) {
      _log('❌ 에러 발생: $e');
      _log('$stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('행복도 감소 DB 검증 테스트'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          // 버튼 영역
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isRunning ? null : _runAllTests,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('전체 테스트 실행'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isRunning ? null : _cleanup,
                        icon: const Icon(Icons.delete),
                        label: const Text('테스트 펫 삭제'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isRunning ? null : _test1_CreatePetWithNullDecayDate,
                        child: const Text('테스트 1만'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isRunning ? null : _test2_ApplyDecayAndCheckUpdate,
                        child: const Text('테스트 2만'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isRunning ? null : _test3_SameDayNoDecay,
                        child: const Text('테스트 3만'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isRunning ? null : _test4_SimulateThreeDaysLater,
                        child: const Text('테스트 4만'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Text('실제 펫 진단 도구', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isRunning ? null : _checkActivePet,
                        icon: const Icon(Icons.search),
                        label: const Text('실제 활성 펫 데이터 확인'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isRunning ? null : _manualApplyDecayToActivePet,
                        icon: const Icon(Icons.bolt),
                        label: const Text('수동으로 감소 적용 (실제 펫)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // 로그 영역
          Expanded(
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: SelectableText(
                  _testLog,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
