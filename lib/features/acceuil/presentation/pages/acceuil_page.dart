import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../acceuil/domain/providers/students_provider.dart';
import '../widgets/student_card.dart';

class AcceuilPage extends ConsumerWidget {
  const AcceuilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsyncValue = ref.watch(studentsProvider);

    return Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFFEDEFFF),
        surfaceTintColor: Colors.transparent,
        title: Center(
          child: const Text(
            "LOGO",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 4,spreadRadius: 1,color: Colors.black.withOpacity(0.3))],
          color: Colors.white,
          border: Border(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                
                padding: const EdgeInsets.only(left: 20.0, top: 20.0,bottom: 10),
                child: const Text(
                  "Enfants",
                  style: TextStyle(
                      color: CupertinoColors.systemIndigo,
                      fontFamily: "Poppins",
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: CupertinoColors.systemIndigo,
                          blurRadius: 3,
                          offset: Offset(1, 1)
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: ()async {
                  ref.invalidate(studentsProvider);
                },
                child: studentsAsyncValue.when(
                  data: (students) => ListView.builder(
                    addAutomaticKeepAlives: false,
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return StudentCard(student: student);
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      Center(child: Text("Error: $error")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
