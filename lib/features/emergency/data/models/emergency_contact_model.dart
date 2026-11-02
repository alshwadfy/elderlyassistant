class EmergencyContactModel {
  const EmergencyContactModel({
    required this.contactId,
    required this.name,
    required this.relation,
    required this.phone,
    required this.priorityOrder,
    this.isEmergencyContact = true,
  });

  final String contactId;
  final String name;
  final String relation;
  final String phone;
  final int priorityOrder;
  final bool isEmergencyContact;

  EmergencyContactModel copyWith({
    String? contactId,
    String? name,
    String? relation,
    String? phone,
    int? priorityOrder,
    bool? isEmergencyContact,
  }) {
    return EmergencyContactModel(
      contactId: contactId ?? this.contactId,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      phone: phone ?? this.phone,
      priorityOrder: priorityOrder ?? this.priorityOrder,
      isEmergencyContact: isEmergencyContact ?? this.isEmergencyContact,
    );
  }
}
