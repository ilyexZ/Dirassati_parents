// lib/features/notifications/domain/models/real_time_absence.dart

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

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'firstName': firstName,
      'lastName': lastName,
      'enrollmentDate': enrollmentDate,
      'grade': grade,
      'isActive': isActive,
      'address': address,
      'birthPlace': birthPlace,
      'birthDate': birthDate,
      'classe': classe,
    };
  }
}

class RealTimeAbsence {
  final String absenceId;
  final DateTime dateTime;
  final String studentId;
  final bool isJustified;
  final String? remark;
  final bool isNotified;
  final Student? student;

  RealTimeAbsence({
    required this.absenceId,
    required this.dateTime,
    required this.studentId,
    required this.isJustified,
    this.remark,
    required this.isNotified,
    this.student,
  });

  factory RealTimeAbsence.fromJson(Map<String, dynamic> json) {
    return RealTimeAbsence(
      absenceId: json['absenceId'] as String? ?? "",
      dateTime: DateTime.tryParse(json['dateTime'] as String? ?? "") ?? DateTime.now(),
      studentId: json['studentId'] as String? ?? "",
      isJustified: json['isJustified'] as bool? ?? false,
      remark: json['remark'] as String?,
      isNotified: json['isNotified'] as bool? ?? false,
      student: json['student'] != null 
          ? Student.fromJson(json['student'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'absenceId': absenceId,
      'dateTime': dateTime.toIso8601String(),
      'studentId': studentId,
      'isJustified': isJustified,
      'remark': remark,
      'isNotified': isNotified,
      'student': student?.toJson(),
    };
  }

  @override
  String toString() {
    return 'RealTimeAbsence(absenceId: $absenceId, dateTime: $dateTime, studentId: $studentId, isJustified: $isJustified, student: $student)';
  }
}