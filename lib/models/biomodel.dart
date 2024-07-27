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

  // Method to create a UserBioData instance from JSON with null safety checks
  factory UserBioData.fromJson(Map<String, dynamic> json) {
    return UserBioData(
      name: json['name'] ?? 'Unknown Name',
      email: json['email'] ?? 'Unknown Email',
      phone: json['phone'] ?? 'Unknown Phone',
      nationalIdentificationNumber: json['nationalIdentificationNumber'] ?? 'Unknown ID',
      districtOfResidence: json['districtOfResidence'] ?? 'Unknown District',
    );
  }

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
}
