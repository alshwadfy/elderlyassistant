import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/rafiq_repositories.dart';
import '../data/models/reminder_model.dart';

/// Medication & Routine Timeline Cubit (`أدويتي` & `الرئيسية`).
///
/// Subscribes to `MedicationRepository.remindersStream` so that doses logged
/// conversationally via `VoiceAssistantBloc` (Sequence Diagram 1) or remote
/// Caregiver updates (Sequence Diagram 4) automatically update the UI without
/// controller-to-controller coupling.
class RemindersCubit extends Cubit<List<ReminderModel>> {
  RemindersCubit({MedicationRepository? repository})
      : this._(repository ?? MedicationRepository());

  RemindersCubit._(this._repository) : super(_repository.currentReminders) {
    _sub = _repository.remindersStream.listen((items) {
      if (!isClosed) emit(items);
    });
  }

  final MedicationRepository _repository;
  StreamSubscription<List<ReminderModel>>? _sub;

  void toggleStatus(String reminderId) {
    _repository.toggleStatus(reminderId);
    emit(List.unmodifiable(_repository.currentReminders));
  }

  void setStatus(String reminderId, String newStatus) {
    _repository.setStatus(reminderId, newStatus);
    emit(List.unmodifiable(_repository.currentReminders));
  }

  String logDoseByMedicationName(String? medicationQuery) {
    final res = _repository.logDoseByMedicationName(medicationQuery);
    emit(List.unmodifiable(_repository.currentReminders));
    return res;
  }

  void addReminder(ReminderModel reminder) {
    _repository.addReminder(reminder);
    emit(List.unmodifiable(_repository.currentReminders));
  }

  void updateReminder(ReminderModel updated) {
    _repository.updateReminder(updated);
    emit(List.unmodifiable(_repository.currentReminders));
  }

  void deleteReminder(String reminderId) {
    _repository.deleteReminder(reminderId);
    emit(List.unmodifiable(_repository.currentReminders));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

typedef RemindersNotifier = RemindersCubit;
