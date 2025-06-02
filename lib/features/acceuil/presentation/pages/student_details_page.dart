import 'package:dirassati/core/background_shapes_toponly.dart';
import 'package:dirassati/core/widgets/full_screen_avatar.dart';
import 'package:dirassati/features/acceuil/data/models/student_model.dart';
import 'package:dirassati/features/acceuil/presentation/widgets/activities_widget.dart';
import 'package:dirassati/features/acceuil/presentation/widgets/informations_generales_widget.dart';
import 'package:dirassati/features/acceuil/presentation/widgets/profile_header_widget.dart';
import 'package:flutter/material.dart';

class StudentDetailsPage extends StatelessWidget {
  final Student student;

  static final tempImage = AssetImage("assets/img/childm2");
  const StudentDetailsPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundShapesToponly(
          child2: Column(
            children: [
               Image.asset("assets/img/logo_h.png",width: 400,height: 40,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false, // Makes the route non-opaque.
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FullScreenAvatar(
                        tag: 'student-${student.studentId}',
                        child: Image(image: tempImage),
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'student-${student.studentId}',
                  child: CircleAvatar(radius: 50, backgroundImage: tempImage,backgroundColor: Colors.transparent,),
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
                      ActivitesWidget(student: student,),
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
