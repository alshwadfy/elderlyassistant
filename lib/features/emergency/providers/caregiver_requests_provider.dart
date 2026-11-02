import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/rafiq_repositories.dart';
import '../data/models/caregiver_request_model.dart';

class CaregiverRequestsCubit extends Cubit<List<CaregiverRequestModel>> {
  CaregiverRequestsCubit()
      : super(
          List<CaregiverRequestModel>.from(EmergencyRepository.initialRequests),
        );

  void approveRequest(String requestId) {
    emit([
      for (final req in state)
        if (req.requestId == requestId)
          req.copyWith(status: 'approved')
        else
          req,
    ]);
  }

  void declineRequest(String requestId) {
    emit([
      for (final req in state)
        if (req.requestId == requestId)
          req.copyWith(status: 'declined')
        else
          req,
    ]);
  }
}

typedef CaregiverRequestsNotifier = CaregiverRequestsCubit;
