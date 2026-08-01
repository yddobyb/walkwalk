// lib/services/moderation/content_report_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 신고 사유 (Firestore에 저장되는 값은 [id]).
enum ReportReason {
  inappropriate('inappropriate'),
  violent('violent'),
  sexual('sexual'),
  misleading('misleading'),
  other('other');

  const ReportReason(this.id);
  final String id;
}

/// 신고 대상 종류.
enum ReportedContentType {
  /// AI가 생성한 스티커 이미지
  sticker('sticker'),

  /// AI가 생성한 펫 대사
  dialogue('dialogue');

  const ReportedContentType(this.id);
  final String id;
}

/// AI 결과물 신고 서비스.
///
/// Phase 27: Google Play 생성형 AI 앱 정책(부적절 생성물에 대한 앱 내 신고 경로)과
/// Apple App Review Guideline 1.2(콘텐츠 신고 수단)를 충족하기 위한 최소 구현.
///
/// 신고는 `contentReports` 컬렉션에 create만 가능하며(Firestore Rules), 열람은
/// 운영자(Admin SDK) 전용이다. 생성된 이미지 자체는 서버에 저장하지 않으므로
/// 신고에는 이미지가 아니라 **사유·종류·provider**만 담는다.
class ContentReportService {
  ContentReportService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// 신고 접수. 성공하면 true.
  Future<bool> submit({
    required ReportReason reason,
    required ReportedContentType contentType,
    String? provider,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      debugPrint('⚠️ ContentReportService - not signed in, report skipped');
      return false;
    }

    try {
      await _firestore.collection('contentReports').add({
        'uid': uid,
        'reason': reason.id,
        'contentType': contentType.id,
        // provider가 없으면 필드 자체를 넣지 않는다(Rules 화이트리스트와 일치).
        'provider': ?provider,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('📮 ContentReportService - report submitted (${reason.id})');
      return true;
    } catch (e) {
      debugPrint('❌ ContentReportService - submit failed: $e');
      return false;
    }
  }
}

final contentReportServiceProvider = Provider<ContentReportService>(
  (ref) => ContentReportService(),
);
