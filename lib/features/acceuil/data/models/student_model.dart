class Student {
  final String studentId;
  final String firstName;
  final String lastName;
  final String enrollmentDate;
  final String grade;
  final bool isActive;

  Student({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.enrollmentDate,
    required this.grade,
    required this.isActive,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      enrollmentDate: json['enrollmentDate'] as String,
      grade: json['grade'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}
