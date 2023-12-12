class UserProfile {
  String name;
  String email;
  String gender;
  DateTime? dateOfBirth;
  double height;
  double weight;
  String bloodGroup;

  UserProfile({
    required this.name,
    required this.email,
    required this.gender,
    this.dateOfBirth,
    required this.height,
    required this.weight,
    required this.bloodGroup,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      email: map['email'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : null,
      height: map['height'],
      weight: map['weight'],
      bloodGroup: map['bloodGroup'],
    );
  }
}