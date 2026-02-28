import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../shared/domain/entities/users/app_user.dart';
import '../../../../shared/presentation/utils/user_helpers.dart';

/// Sleek modal for adding a new member manually
class AddMemberModal extends StatefulWidget {
  final Function(AppUser) onAdd;

  const AddMemberModal({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddMemberModal> createState() => _AddMemberModalState();
}

class _AddMemberModalState extends State<AddMemberModal> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _close() {
    _animController.reverse().then((_) => Navigator.pop(context));
  }

  void _addMember() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      
      final member = AppUser(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        avatarInitials: UserHelpers.generateInitials(name),
        gradientColorValues: UserHelpers.generateGradientColors(name),
        isGuest: true,
        phoneNumber: phone,
        profileImage: null,
      );

      widget.onAdd(member);
      _close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: Colors.black.withValues(alpha:0.6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha:0.95),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha:0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.5),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Add New Member',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Enter contact details',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: _close,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha:0.1),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha:0.1),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Name Field
                            _buildLabel('Full Name'),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _nameController,
                              hint: 'Enter full name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Phone Field
                            _buildLabel('Phone Number'),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _phoneController,
                              hint: '+60123456789',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a phone number';
                                }
                                if (!UserHelpers.isValidPhone(value)) {
                                  return 'Please enter a valid phone number (min 8 digits)';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Info Note
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF06B6D4).withValues(alpha:0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF06B6D4).withValues(alpha:0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: const Color(0xFF06B6D4),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Phone number required for WhatsApp sharing',
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Add Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _addMember,
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
                                    child: const Text(
                                      'Add Member',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha:0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.1),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(icon, color: Colors.grey[500], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                errorStyle: const TextStyle(fontSize: 12, height: 0.5),
              ),
              validator: validator,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

/// Helper function to show the modal
Future<void> showAddMemberModal({
  required BuildContext context,
  required Function(AppUser) onAdd,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Add Member',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return AddMemberModal(onAdd: onAdd);
    },
  );
}
