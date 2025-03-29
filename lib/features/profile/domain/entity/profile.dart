class Profile {
  final String parentId;
  final String occupation;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String userName;
  final String email;
  final bool emailConfirmed;
  final String phoneNumber;
  final bool phoneNumberConfirmed;
  final String relationshipName;

  Profile({
    required this.parentId,
    required this.occupation,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.userName,
    required this.email,
    required this.emailConfirmed,
    required this.phoneNumber,
    required this.phoneNumberConfirmed,
    required this.relationshipName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      parentId: json['parentId'] as String,
      occupation: json['occupation'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: json['birthDate'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      emailConfirmed: json['emailConfirmed'] as bool,
      phoneNumber: json['phoneNumber'] as String,
      phoneNumberConfirmed: json['phoneNumberConfirmed'] as bool,
      relationshipName: json['relationshipName'] as String,
    );
  }
}
