import 'package:elderlyassistant/features/emergency/providers/caregiver_requests_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CaregiverRequestsNotifier', () {
    test('initial state contains pending caregiver requests', () {
      final notifier = CaregiverRequestsNotifier();
      expect(notifier.state.isNotEmpty, isTrue);
      expect(notifier.state.first.status, equals('pending'));
    });

    test('approveRequest changes status to approved', () {
      final notifier = CaregiverRequestsNotifier();
      final reqId = notifier.state.first.requestId;
      notifier.approveRequest(reqId);
      final updated = notifier.state.firstWhere((r) => r.requestId == reqId);
      expect(updated.status, equals('approved'));
    });

    test('declineRequest changes status to declined', () {
      final notifier = CaregiverRequestsNotifier();
      final reqId = notifier.state.first.requestId;
      notifier.declineRequest(reqId);
      final updated = notifier.state.firstWhere((r) => r.requestId == reqId);
      expect(updated.status, equals('declined'));
    });
  });
}
