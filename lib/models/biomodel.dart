class UserBioData {
  String name;
  String email;
  String phone;

  UserBioData({
    required this.name,
    required this.email,
    required this.phone,
  });

  // Method to convert UserBioData to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  // Method to create a UserBioData instance from JSON
  factory UserBioData.fromJson(Map<String, dynamic> json) {
    return UserBioData(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
