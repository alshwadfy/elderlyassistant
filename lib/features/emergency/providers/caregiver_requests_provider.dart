import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/caregiver_request_model.dart';

class CaregiverRequestsNotifier extends StateNotifier<List<CaregiverRequestModel>> {
  CaregiverRequestsNotifier() : super(_initialRequests);

  static final List<CaregiverRequestModel> _initialRequests = [
    CaregiverRequestModel(
      requestId: 'req_1',
      caregiverName: 'Sarah Mansour',
      role: 'Home Nurse Caregiver',
      phone: '+20 10 9988 7766',
      requestedAt: DateTime(2026, 9, 28, 14, 15),
      status: 'pending',
    ),
    CaregiverRequestModel(
      requestId: 'req_2',
      caregiverName: 'Dr. Tarek Fouad',
      role: 'Family Doctor',
      phone: '+20 11 5544 3322',
      requestedAt: DateTime(2026, 9, 27, 09, 30),
      status: 'pending',
    ),
  ];

  void approveRequest(String requestId) {
    state = [
      for (final req in state)
        if (req.requestId == requestId) req.copyWith(status: 'approved') else req,
    ];
  }

  void declineRequest(String requestId) {
    state = [
      for (final req in state)
        if (req.requestId == requestId) req.copyWith(status: 'declined') else req,
    ];
  }
}

final caregiverRequestsProvider = StateNotifierProvider<
    CaregiverRequestsNotifier, List<CaregiverRequestModel>>((ref) {
  return CaregiverRequestsNotifier();
});
