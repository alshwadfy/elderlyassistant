import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/appointment_model.dart';

class AppointmentsNotifier extends StateNotifier<List<AppointmentModel>> {
  AppointmentsNotifier() : super(_mockAppointments);

  static final List<AppointmentModel> _mockAppointments = [
    AppointmentModel(
      appointmentId: 'app_1',
      doctorId: 'doc_1',
      doctorName: 'Dr. Ahmed Hassan',
      doctorType: 'General Practitioner',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      status: 'Upcoming',
    ),
    AppointmentModel(
      appointmentId: 'app_2',
      doctorId: 'doc_2',
      doctorName: 'Dr. Salma Abdelaziz',
      doctorType: 'Internal Medicine',
      dateTime: DateTime.now().subtract(const Duration(days: 10)),
      status: 'Past',
    ),
  ];
}

final appointmentsProvider = StateNotifierProvider.autoDispose<AppointmentsNotifier, List<AppointmentModel>>((ref) {
  return AppointmentsNotifier();
});
