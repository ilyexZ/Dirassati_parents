import 'package:dirassati/core/widgets/full_screen_avatar.dart';
import 'package:dirassati/features/profile/domain/entity/profile.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  const ProfileHeader({super.key, required this.profile});
  static final tempImage = AssetImage("assets/img/pfp.png");

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false, // Makes the route non-opaque.
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FullScreenAvatar(
                        tag: 'profileP',
                        child: Image(image: tempImage),
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'profileP',
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: tempImage,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${profile.firstName} ${profile.lastName}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E1E),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.occupation,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
