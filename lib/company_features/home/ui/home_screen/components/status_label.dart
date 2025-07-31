import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusLabel extends StatelessWidget {
  const StatusLabel({
    super.key,
    required this.status,
  });

  final String? status;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFF4A90E2); // Blue
      case 'in progress':
        return const Color(0xFF7B68EE); // Purple-ish
      case 'closed':
        return const Color(0xFF28C76F); // Green
      default:
        return const Color(0xFF8E8E93); // Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = status?.toUpperCase() ?? 'UNKNOWN';
    final color = _statusColor(status ?? '');

    return Align(
      alignment: Alignment.centerLeft, // Or center if needed
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
