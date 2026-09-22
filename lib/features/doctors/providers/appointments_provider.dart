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
      dateTime: DateTime(2026, 9, 23, 10, 0),
      status: 'Upcoming',
    ),
    AppointmentModel(
      appointmentId: 'app_2',
      doctorId: 'doc_2',
      doctorName: 'Dr. Salma Abdelaziz',
      doctorType: 'Internal Medicine',
      dateTime: DateTime(2026, 9, 28, 14, 30),
      status: 'Upcoming',
    ),
    AppointmentModel(
      appointmentId: 'app_3',
      doctorId: 'doc_3',
      doctorName: 'Dr. Karim Nabil',
      doctorType: 'Cardiology',
      dateTime: DateTime(2026, 8, 12, 11, 0),
      status: 'Past',
    ),
  ];

  void addAppointment(AppointmentModel appointment) {
    state = [appointment, ...state];
  }
}

final appointmentsProvider = StateNotifierProvider<AppointmentsNotifier, List<AppointmentModel>>((ref) {
  return AppointmentsNotifier();
});
