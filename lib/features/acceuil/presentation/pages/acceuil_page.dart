import 'package:community_material_icon/community_material_icon.dart';
import 'package:dirassati/core/services/colorLog.dart';
import 'package:dirassati/core/widgets/shimmer_student_card.dart';
import 'package:dirassati/features/school_info/domain/models/school_info_model.dart';
import 'package:dirassati/features/school_info/presentation/pages/school_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../acceuil/domain/providers/students_provider.dart';
import '../widgets/student_card.dart';

class AcceuilPage extends ConsumerStatefulWidget {
  const AcceuilPage({super.key});

  @override
  ConsumerState<AcceuilPage> createState() => _AcceuilPageState();
}

class _AcceuilPageState extends ConsumerState<AcceuilPage> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    // Set refresh state to show shimmer placeholders
    setState(() {
      _isRefreshing = true;
    });

    // Force a new fetch; this returns a Future that completes when the new data is ready
    await ref.refresh(studentsProvider.future);

    // Optionally delay to make the loading state clearly visible
    await Future.delayed(const Duration(milliseconds: 300));

    // Remove the refresh flag once data is reloaded
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsyncValue = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEDEFFF),
        surfaceTintColor: Colors.transparent,
        title: Center(
          child: Image.asset(
            "assets/img/logo_h.png",
            width: 400,
            height: 40,
          ),
        ),
      ),
      backgroundColor: Color(0xffEDEFFF),
      body: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 1,
              color: Colors.black.withOpacity(0.3),
            )
          ],
          color: Colors.white,
          border: Border(),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10),
                    child: Text(
                      "Enfants",
                      style: TextStyle(
                        color: CupertinoColors.systemIndigo,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32,vertical: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SchoolInfoPage()),
                      );
                    },
                    child: Icon(CommunityMaterialIcons.school_outline,size: 32,),
                  ),
                )
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: _isRefreshing
                    // When refreshing, show shimmer placeholders
                    ? ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return const ShimmerStudentCard();
                        },
                      )
                    // Otherwise, use the existing AsyncValue state
                    : studentsAsyncValue.when(
                        data: (students) => ListView.builder(
                          addAutomaticKeepAlives: false,
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];
                            //clog("y", student);
                            return StudentCard(student: student);
                          },
                        ),
                        loading: () => ListView.builder(
                          itemCount:
                              6, // Number of shimmer placeholders for initial load
                          itemBuilder: (context, index) {
                            return const ShimmerStudentCard();
                          },
                        ),
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
