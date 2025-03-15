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

    return SafeArea(
      maintainBottomViewPadding: false,
      child: Card(
        clipBehavior: Clip.none,
        elevation: 5,
        color: Color(0xffEDEFFF),
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        //surfaceTintColor: Colors.white,

        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
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
                  padding: const EdgeInsets.only(left: 20.0, top: 20.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
