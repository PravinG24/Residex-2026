import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // ← ADD THIS
import 'package:flutter_riverpod/flutter_riverpod.dart';  // ← ADD THIS
import '../../../../shared/domain/entities/users/app_user.dart';
import '../../../../landlord/domain/entities/property.dart';
import '../../../../tenant/presentation/providers/bills/bills_provider.dart';
import '../../../../../features/shared/domain/entities/groups/app_group.dart'; 
import '../../providers/group_providers.dart';  
import 'duplicate_group_warning.dart';
import 'delete_group_confirmation.dart';

 const List<String> groupEmojis = [
    '🏠', '🍛', '🎮', '🎵', '🐾', '🌮', '🎭', '⚽',
    '🎨', '🍕', '🎬', '📚', '🌿', '🎸', '🏋️', '☕',
  ];

  const List<Color> groupColors = [
    Color(0xFF6366F1), // indigo
    Color(0xFF8B5CF6), // violet
    Color(0xFFEC4899), // pink
    Color(0xFFEF4444), // red
    Color(0xFFF59E0B), // amber
    Color(0xFF10B981), // emerald
    Color(0xFF06B6D4), // cyan
    Color(0xFF3B82F6), // blue
  ];

/// Full-featured Group Editor modal
class GroupEditorModal extends ConsumerStatefulWidget {
  final List<AppUser> selectedMembers;
  final AppGroup? existingGroup;// For editing
  final String currentUserId;
  final Function(AppGroup) onSave;
  final Function(AppGroup)? onDelete;

  const GroupEditorModal({
    super.key,
    required this.selectedMembers,
    this.existingGroup,
    required this.currentUserId,
    required this.onSave,
    this.onDelete,
  });

  @override
  ConsumerState<GroupEditorModal> createState() => _GroupEditorModalState();
}

class _GroupEditorModalState extends ConsumerState<GroupEditorModal> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  late String _selectedEmoji;
  late Color _selectedColor;
  late AnimationController _animController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.existingGroup?.emoji ?? groupEmojis[1]; // Default 🍛
    _selectedColor = widget.existingGroup != null
      ? Color(widget.existingGroup!.colorValue)
      : groupColors[4]; // Default Amber
    _nameController.text = widget.existingGroup?.name ?? '';

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward();
  }
    


  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _close() {
    _animController.reverse().then((_) => Navigator.pop(context));
  }

  Future<void> _saveGroup() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a group name'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    // Get member IDs for comparison
    final newMemberIds = widget.selectedMembers
        .where((m) => m.id != widget.currentUserId)
        .map((m) => m.id)
        .toSet();

    // Skip duplicate check if editing existing group
    if (widget.existingGroup == null) {
      // Check for duplicate groups
      final duplicate = await _findDuplicateGroup(newMemberIds);

      if (duplicate != null) {
        HapticFeedback.mediumImpact();

        // Show warning dialog
        final shouldCreateAnyway = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => DuplicateGroupWarning(
            existingGroupName: duplicate.name,
            existingGroupEmoji: duplicate.emoji,
            memberCount: newMemberIds.length,
          ),
        );

        // User cancelled
        if (shouldCreateAnyway != true) {
          return;
        }
      }
    }

    // Create or update group
    final group = AppGroup(
      id: widget.existingGroup?.id ?? 'group_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      emoji: _selectedEmoji,
      colorValue: _selectedColor.toARGB32(),
      tenantIds: newMemberIds.toList(),
      createdBy: widget.currentUserId,
    );

    widget.onSave(group);
    _close();
  }

  // Helper method to find duplicate groups
  Future<AppGroup?> _findDuplicateGroup(Set<String> newMemberIds) async {
    try {
      // Fetch all existing groups
      final allGroups = await ref.read(groupsProvider.future);

      // Check each group for duplicate members
      for (final group in allGroups) {
        final existingSet = Set<String>.from(group.tenantIds);

        // Compare sets: same size and all members match
        if (existingSet.length == newMemberIds.length &&
            existingSet.containsAll(newMemberIds)) {
          return group; // Found duplicate!
        }
      }

      return null; // No duplicate found
    } catch (e) {
      // If there's an error fetching groups, proceed without check
      debugPrint('Error checking for duplicate groups: $e');
      return null;
    }
  }

  Future<void> _deleteGroup() async {
    if (widget.existingGroup == null || widget.onDelete == null) {
      return;
    }

    HapticFeedback.mediumImpact();

    // Get usage count
    final usageCount = await _getGroupUsageCount();

    // Show confirmation dialog with usage info
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteGroupConfirmation(
        groupName: widget.existingGroup!.name,
        groupEmoji: widget.existingGroup!.emoji,
        memberCount: widget.existingGroup!.tenantIds.length,
        usageCount: usageCount,  // ← PASS USAGE COUNT
      ),
    );

    if (shouldDelete == true) {
      widget.onDelete!(widget.existingGroup!);
      _close();
    }
  }

  Future<int> _getGroupUsageCount() async {
    if (widget.existingGroup == null) {
      return 0;
    }

    try {
      // Fetch all bills
      final billsAsync = ref.read(billsProvider);
      final allBills = billsAsync.value ?? [];

      // Count bills that include any member from this group
      // A bill "uses" a group if it has the exact same member set
      final groupMemberIds = Set<String>.from(widget.existingGroup!.tenantIds);

      int count = 0;
      for (final bill in allBills) {
        final billParticipants = Set<String>.from(bill.participantIds);

        // Check if bill participants match group members
        // (This is a simple check - you could also just count any overlap)
        if (groupMemberIds.length == billParticipants.length &&
            groupMemberIds.containsAll(billParticipants)) {
          count++;
        }
      }

      return count;
    } catch (e) {
      debugPrint('Error getting group usage count: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: Colors.black.withValues(alpha:0.7),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, MediaQuery.of(context).size.height * _slideAnimation.value),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E293B),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHandle(),
                            _buildHeader(),
                            Flexible(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildEmojiSelector(),
                                    const SizedBox(height: 16),
                                    _buildColorSelector(),
                                    const SizedBox(height: 20),
                                    _buildNameInput(),
                                    const SizedBox(height: 24),
                                    _buildMembersList(),
                                  ],
                                ),
                              ),
                            ),
                            _buildSaveButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.existingGroup == null ? 'New Group' : 'Edit Group',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),

          Row(
            children: [
              // Delete button (only show when editing existing group)
              if (widget.existingGroup != null && widget.onDelete != null) ...[
                GestureDetector(
                  onTap: _deleteGroup,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Close button
              GestureDetector(
                onTap: _close,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

   Widget _buildEmojiSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Selected Emoji Preview
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: _selectedColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              _selectedEmoji,
              style: const TextStyle(
                fontSize: 48,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Horizontal Emoji Picker
        SizedBox(
          height: 56,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: groupEmojis.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final emoji = groupEmojis[index];
              final isSelected = emoji == _selectedEmoji;
              return GestureDetector(
                onTap: () => setState(() => _selectedEmoji = emoji),
                child: Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(
                        fontSize: 28,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

   Widget _buildColorSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: groupColors.length,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final color = groupColors[index];
          final isSelected = color == _selectedColor;
          return GestureDetector(
            onTap: () => setState(() => _selectedColor = color),
            child: Container(
              width: 32,
              height: 32,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 6,
                right: index == groupColors.length - 1 ? 0 : 6,
              ),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameInput() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Group Name',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      );
  }

  Widget _buildMembersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MEMBERS (${widget.selectedMembers.length})',
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 12),
        ...widget.selectedMembers.map((member) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha:0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha:0.05)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: member.gradientColorValues != null && member.gradientColorValues!.isNotEmpty
                      ? Color(member.gradientColorValues!.first)
                      : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      member.avatarInitials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.id == widget.currentUserId ? '${member.name} (You)' : member.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      if (member.isGuest) ...[
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF06B6D4).withValues(alpha:0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFF06B6D4).withValues(alpha:0.3),
                            ),
                          ),
                          child: const Text(
                            'New Guest',
                            style: TextStyle(
                              color: Color(0xFF06B6D4),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.check_circle, color: _selectedColor, size: 20),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha:0.1)),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _saveGroup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF06B6D4), Color(0xFF2563EB)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withValues(alpha:0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.existingGroup == null ? 'Create Group' : 'Update Group',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to show the group editor
Future<void> showGroupEditorModal({
  required BuildContext context,
  required List<AppUser> selectedMembers,
  AppGroup? existingGroup,
  required String currentUserId,
  required Function(AppGroup) onSave,
  Function (AppGroup)? onDelete,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Group Editor',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, anim1, anim2) {
      return GroupEditorModal(
        selectedMembers: selectedMembers,
        existingGroup: existingGroup,
        currentUserId: currentUserId,
        onSave: onSave,
        onDelete: onDelete,
      );
    },
  );
}
