class DoctorModel {
  DoctorModel({
    required this.providerId,
    required this.name,
    required this.type,
    required this.address,
    required this.distanceKm,
    required this.estimatedMinutes,
  });

  final String providerId;
  final String name;
  final String type; // e.g., 'General Practitioner', 'Internal Medicine'
  final String address;
  final double distanceKm;
  final int estimatedMinutes;
}
