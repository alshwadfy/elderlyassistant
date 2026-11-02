import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/rafiq_repositories.dart';
import '../data/models/appointment_model.dart';

/// Next Visit / Appointments Cubit (`زيارتي القادمة` — Sequence Diagram 4).
class AppointmentsCubit extends Cubit<List<AppointmentModel>> {
  AppointmentsCubit()
      : super(List<AppointmentModel>.from(HealthcareRepository.initialVisits));

  void addAppointment(AppointmentModel appointment) {
    emit([appointment, ...state]);
  }

  void cancelAppointment(String appointmentId) {
    emit([
      for (final appt in state)
        if (appt.appointmentId == appointmentId)
          appt.copyWith(status: 'Cancelled')
        else
          appt,
    ]);
  }

  void deleteAppointment(String appointmentId) {
    emit(state.where((a) => a.appointmentId != appointmentId).toList());
  }
}

typedef AppointmentsNotifier = AppointmentsCubit;
