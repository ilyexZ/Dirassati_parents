class Student {
  final String studentId;
  final String firstName;
  final String lastName;
  final String enrollmentDate;
  final String? grade;
  final bool isActive;
  final String? address;
  final String? birthPlace;
  final String? birthDate;
  final String? classe;
@override
  String toString() {
    return 'Student(firstName: $firstName, lastName: $lastName, birthDate: $birthDate, birthPlace: $birthPlace)';
  }
  Student({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.enrollmentDate,
    this.grade,
    required this.isActive,
     this.address,
     this.birthPlace,
    this.birthDate,
    this.classe
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'] as String? ?? "",
      firstName: json['firstName'] as String? ?? "",
      lastName: json['lastName'] as String? ?? "",
      enrollmentDate: json['enrollmentDate'] as String? ?? "",
      grade: json['grade'] as String? ?? "",
      isActive: json['isActive'] as bool? ?? false,
      address: json['address'] as String? ?? "",
      birthPlace: json['birthPlace'] as String? ?? "",
      birthDate: json['birthDate'] as String? ?? "",
      classe: json['classe'] as String? ?? "",
    );
  }
}
