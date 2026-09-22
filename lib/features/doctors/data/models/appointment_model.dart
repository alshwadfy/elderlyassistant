class AppointmentModel {
  AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorType,
    required this.dateTime,
    required this.status,
  });

  final String appointmentId;
  final String doctorId;
  final String doctorName;
  final String doctorType;
  final DateTime dateTime;
  final String status; // 'Upcoming' or 'Past'
}
