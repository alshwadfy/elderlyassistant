class DoctorModel {
  DoctorModel({
    required this.providerId,
    required this.name,
    required this.type,
    required this.address,
    required this.distanceKm,
    required this.estimatedMinutes,
    this.specialties = const [],
    this.phone = '+20 2 2415 0001',
    this.distanceLabelAr = '',
  });

  final String providerId;
  final String name;
  final String type;
  final String address;
  final double distanceKm;
  final int estimatedMinutes;
  final List<String> specialties;
  final String phone;
  final String distanceLabelAr;
}
