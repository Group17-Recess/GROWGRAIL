class AdminBioData {
  String name;
  String email;
  String phone;
  String nationalIdentificationNumber;
  String districtOfResidence;

  AdminBioData({
    required this.name,
    required this.email,
    required this.phone,
    required this.nationalIdentificationNumber,
    required this.districtOfResidence,
  });

  // Method to convert AdminBioData to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'nationalIdentificationNumber': nationalIdentificationNumber,
      'districtOfResidence': districtOfResidence,
    };
  }

  // Method to create an AdminBioData instance from JSON
  factory AdminBioData.fromJson(Map<String, dynamic> json) {
    return AdminBioData(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      nationalIdentificationNumber: json['nationalIdentificationNumber'],
      districtOfResidence: json['districtOfResidence'],
    );
  }
}
