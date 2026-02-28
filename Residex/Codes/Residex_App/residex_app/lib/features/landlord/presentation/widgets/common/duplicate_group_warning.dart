import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';

  class DuplicateGroupWarning extends StatelessWidget {
    final String existingGroupName;
    final String existingGroupEmoji;
    final int memberCount;

    const DuplicateGroupWarning({
      super.key,
      required this.existingGroupName,
      required this.existingGroupEmoji,
      required this.memberCount,
    });

    @override
    Widget build(BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Group Already Exists',
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'A group "$existingGroupEmoji $existingGroupName" with these $memberCount members already exists. Create a duplicate anyway?',
          style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create Anyway', style: TextStyle(color: Color(0xFF06B6D4))),
          ),
        ],
      );
    }
  }