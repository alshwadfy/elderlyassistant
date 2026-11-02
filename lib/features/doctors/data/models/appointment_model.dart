class AppointmentModel {
  AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorType,
    required this.dateTime,
    required this.status,
    this.hospitalName = 'مستشفى الأمل',
    this.department = 'العيادات الخارجية',
    this.specialty = 'القلب',
    this.dateLabelAr = '٢٩ أكتوبر ٢٠٢٦',
    this.timeLabelAr = '١٠:٠٠ ص',
    this.address = '١٤ شارع الجلاء، مصر الجديدة، القاهرة',
    this.companionName = 'فاطمة أحمد',
    this.companionRelation = 'الابنة · المرافق المحدد',
    this.familyNote = 'أضافت العائلة زيارة حسن إبراهيم وحدّدت المرافق. التفاصيل للعرض فقط.',
    this.isFamilySynced = true,
  });

  final String appointmentId;
  final String doctorId;
  final String doctorName;
  final String doctorType;
  final DateTime dateTime;
  final String status; // 'Upcoming', 'Past', 'Cancelled'
  final String hospitalName;
  final String department;
  final String specialty;
  final String dateLabelAr;
  final String timeLabelAr;
  final String address;
  final String companionName;
  final String companionRelation;
  final String familyNote;
  final bool isFamilySynced;

  AppointmentModel copyWith({
    String? appointmentId,
    String? doctorId,
    String? doctorName,
    String? doctorType,
    DateTime? dateTime,
    String? status,
    String? hospitalName,
    String? department,
    String? specialty,
    String? dateLabelAr,
    String? timeLabelAr,
    String? address,
    String? companionName,
    String? companionRelation,
    String? familyNote,
    bool? isFamilySynced,
  }) {
    return AppointmentModel(
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorType: doctorType ?? this.doctorType,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      hospitalName: hospitalName ?? this.hospitalName,
      department: department ?? this.department,
      specialty: specialty ?? this.specialty,
      dateLabelAr: dateLabelAr ?? this.dateLabelAr,
      timeLabelAr: timeLabelAr ?? this.timeLabelAr,
      address: address ?? this.address,
      companionName: companionName ?? this.companionName,
      companionRelation: companionRelation ?? this.companionRelation,
      familyNote: familyNote ?? this.familyNote,
      isFamilySynced: isFamilySynced ?? this.isFamilySynced,
    );
  }
}
