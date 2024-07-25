class UserBioData {
  String name;
  String email;
  String phone;
  String nationalIdentificationNumber;
  String districtOfResidence;

  UserBioData({
    required this.name,
    required this.email,
    required this.phone,
    required this.nationalIdentificationNumber,
    required this.districtOfResidence,
  });

  // Method to convert UserBioData to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'nationalIdentificationNumber': nationalIdentificationNumber,
      'districtOfResidence': districtOfResidence,
    };
  }

  // Method to create a UserBioData instance from JSON
  factory UserBioData.fromJson(Map<String, dynamic> json) {
    return UserBioData(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      nationalIdentificationNumber: json['nationalIdentificationNumber'],
      districtOfResidence: json['districtOfResidence'],
    );
  }
}
