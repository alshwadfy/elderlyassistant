class CaregiverRequestModel {
  CaregiverRequestModel({
    required this.requestId,
    required this.caregiverName,
    required this.role,
    required this.phone,
    required this.requestedAt,
    this.status = 'pending', // 'pending', 'approved', 'declined'
  });

  final String requestId;
  final String caregiverName;
  final String role; // e.g., 'Primary Nurse', 'Family Caregiver'
  final String phone;
  final DateTime requestedAt;
  final String status;

  CaregiverRequestModel copyWith({
    String? status,
  }) {
    return CaregiverRequestModel(
      requestId: requestId,
      caregiverName: caregiverName,
      role: role,
      phone: phone,
      requestedAt: requestedAt,
      status: status ?? this.status,
    );
  }
}
