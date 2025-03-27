import 'package:dirassati/core/background_shapes_toponly.dart';
import 'package:dirassati/features/acceuil/data/models/student_model.dart';
import 'package:dirassati/features/acceuil/presentation/widgets/activities_widget.dart';
import 'package:dirassati/features/acceuil/presentation/widgets/informations_generales_widget.dart';
import 'package:dirassati/features/acceuil/presentation/widgets/profile_header_widget.dart';
import 'package:flutter/material.dart';

class StudentDetailsPage extends StatelessWidget {
  final Student student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundShapesToponly(
          child2: Column(
            children: [
              Text(
                "LOGO",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Wrap the profile image in a Hero widget using the same tag as StudentCard.
              Hero(
                tag: 'student-${student.studentId}',
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250",
                  ),
                ),
              ),
            ],
          ),
          child1: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      ProfileHeaderWidget(student: student),
                      InformationsGeneralesWidget(student: student),
                      ActivitesWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
