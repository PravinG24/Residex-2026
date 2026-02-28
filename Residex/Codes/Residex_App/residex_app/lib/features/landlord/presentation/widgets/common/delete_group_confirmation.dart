import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';

  class DeleteGroupConfirmation extends StatelessWidget {
    final String groupName;
    final String groupEmoji;
    final int memberCount;
    final int usageCount;

    const DeleteGroupConfirmation({
      super.key,
      required this.groupName,
      required this.groupEmoji,
      required this.memberCount,
      required this.usageCount,
    });

    @override
    Widget build(BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Group?',
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Delete "$groupEmoji $groupName" ($memberCount members)?'
          '${usageCount > 0 ? ' This group is used in $usageCount bill(s).' : ''}',
          style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      );
    }
  }