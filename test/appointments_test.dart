import 'package:elderlyassistant/features/doctors/data/models/appointment_model.dart';
import 'package:elderlyassistant/features/doctors/providers/appointments_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppointmentsNotifier', () {
    test('addAppointment inserts new appointment at top', () {
      final notifier = AppointmentsNotifier();
      final initialCount = notifier.state.length;
      final newAppt = AppointmentModel(
        appointmentId: 'app_new',
        doctorId: 'doc_99',
        doctorName: 'Dr. Test Specialist',
        doctorType: 'Neurology',
        dateTime: DateTime(2026, 10, 1, 15, 0),
        status: 'Upcoming',
      );
      notifier.addAppointment(newAppt);
      expect(notifier.state.length, equals(initialCount + 1));
      expect(notifier.state.first.appointmentId, equals('app_new'));
    });

    test('cancelAppointment changes status to Cancelled', () {
      final notifier = AppointmentsNotifier();
      final target = notifier.state.firstWhere((a) => a.status == 'Upcoming');
      notifier.cancelAppointment(target.appointmentId);
      final cancelled = notifier.state.firstWhere((a) => a.appointmentId == target.appointmentId);
      expect(cancelled.status, equals('Cancelled'));
    });
  });
}
