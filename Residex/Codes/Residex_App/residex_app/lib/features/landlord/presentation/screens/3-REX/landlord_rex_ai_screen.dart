import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../providers/landlord_rex_ai_provider.dart';
import '../../widgets/AI/rex_message_bubble.dart';

/// Landlord Rex AI Screen — Instagram-style AI chat interface
class LandlordRexAIScreen extends ConsumerStatefulWidget {
  final RexContext? initialContext;

  const LandlordRexAIScreen({
    super.key,
    this.initialContext,
  });

  @override
  ConsumerState<LandlordRexAIScreen> createState() =>
      _LandlordRexAIScreenState();
}

class _LandlordRexAIScreenState extends ConsumerState<LandlordRexAIScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    ref
        .read(rexAIProvider(widget.initialContext).notifier)
        .sendMessage(text);
    _textController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.single.name.isNotEmpty) {
      ref
          .read(rexAIProvider(widget.initialContext).notifier)
          .uploadFile(result.files.single.name);

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    final rexState = ref.watch(rexAIProvider(widget.initialContext));

    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: Stack(
        children: [
          // Ambient background gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 600,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    AppColors.blue600.withValues(alpha: 0.5),
                    AppColors.deepSpace,
                    AppColors.deepSpace,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(rexState.context),

                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    itemCount: rexState.messages.length,
                    itemBuilder: (context, index) {
                      final message = rexState.messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: RexMessageBubble(message: message),
                      );
                    },
                  ),
                ),

                _buildInputDock(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(RexContext context) {
    final canPop = Navigator.canPop(this.context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (canPop)
            GestureDetector(
              onTap: () => Navigator.pop(this.context),
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Icon(
                  LucideIcons.arrowLeft,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.blue500.withValues(alpha: 0.2),
                  AppColors.purple.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.blue500.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue500.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.bot,
              color: AppColors.blue500,
              size: 24,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                duration: const Duration(seconds: 2),
                color: AppColors.purple.withValues(alpha: 0.3),
              ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'REX',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .fadeOut(duration: const Duration(seconds: 1))
                        .then()
                        .fadeIn(duration: const Duration(seconds: 1)),

                    const SizedBox(width: 6),

                    Text(
                      context.label,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputDock() {
    final hasText = _textController.text.isNotEmpty;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: AppColors.deepSpace,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.blue500.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),

            Expanded(
              child: TextField(
                controller: _textController,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Input Directive...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),

            const SizedBox(width: 8),

            IconButton(
              onPressed: _pickFile,
              icon: const Icon(
                Icons.camera_alt_outlined,
                size: 20,
                color: AppColors.textMuted,
              ),
            ),

            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: hasText ? AppColors.blue500 : AppColors.slate700,
                  shape: BoxShape.circle,
                  boxShadow: hasText
                      ? [
                          BoxShadow(
                            color: AppColors.blue500.withValues(alpha: 0.3),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  Icons.send,
                  size: 18,
                  color: hasText ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
