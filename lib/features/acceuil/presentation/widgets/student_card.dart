// ... other imports
import 'package:dirassati/features/acceuil/data/models/student_model.dart';
import 'package:dirassati/features/acceuil/presentation/pages/student_details_page.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      clipBehavior: Clip.none,
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        side: BorderSide(
          width: 0.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MAIN CONTENT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP ROW: Image + Name & Notification Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Wrap the profile image in a Hero widget.
                    Hero(
                      tag: 'student-${student.studentId}', // Unique tag
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          "https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250",
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Hero(
                        tag: 'student-name-${student.studentId}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            "${student.firstName} ${student.lastName}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Notification Icon with badge
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Placeholder(),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          const Icon(Icons.notifications_outlined, size: 30),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "3",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                // Classe
                _buildInfoRow("Classe",student.grade ?? "#empty#"),
                // Reference
                _buildInfoRow("Num Ref", student.studentId),
                // Performance
                const Divider(),
                _buildPerformanceRow(),
              ],
            ),
          ),

          // BOTTOM SECTION WITH DIFFERENT COLOR
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudentDetailsPage(student: student),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(
                    0xFF4D44B5), // Different color for the bottom part
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Voir details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods ...
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14, fontFamily: "Poppins"),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceRow() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Performance",
                style: TextStyle(
                    fontSize: 14, color: Colors.grey, fontFamily: "Poppins"),
              ),
            ),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(2),
                value: 0.6,
                backgroundColor: Colors.grey[300],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF1A8037)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
