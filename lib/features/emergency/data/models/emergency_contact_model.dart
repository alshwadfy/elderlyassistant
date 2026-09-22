class EmergencyContactModel {
  EmergencyContactModel({
    required this.contactId,
    required this.name,
    required this.relation,
    required this.phone,
    required this.priorityOrder,
  });

  final String contactId;
  final String name;
  final String relation;
  final String phone;
  final int priorityOrder;
}
