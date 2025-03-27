// custom_list_tile.dart
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final Color? iconColor;

  const CustomListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.trailingIcon,
    this.onTap,
    this.iconColor,
  });

  static const blacktile = Color(0xFF393939);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashFactory: InkRipple.splashFactory,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Icon(leadingIcon, color: iconColor ?? blacktile, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: iconColor ?? blacktile,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (trailingIcon != null)
                Icon(trailingIcon, color: blacktile, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
