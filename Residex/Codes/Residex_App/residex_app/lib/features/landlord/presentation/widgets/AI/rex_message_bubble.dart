import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../providers/landlord_rex_ai_provider.dart';
import '../AI/rex_card_widgets.dart';

/// Instagram-style message bubble for Rex AI chat
class RexMessageBubble extends StatelessWidget {
  final RexMessage message;

  const RexMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'USER';
    return isUser ? _buildUserRow(context) : _buildRexRow(context);
  }

  Widget _buildUserRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: _buildUserBubble(),
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Text(
            _formatTime(message.timestamp),
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 10,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRexRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildAvatar(),
            const SizedBox(width: 8),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child: _buildRexBubble(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(left: 36),
          child: Text(
            _formatTime(message.timestamp),
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 10,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.deepSpace,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.blue500.withValues(alpha: 0.4),
        ),
      ),
      child: const Icon(LucideIcons.bot, size: 13, color: AppColors.blue400),
    );
  }

  Widget _buildUserBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.blue500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Text(
        message.text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
          height: 1.45,
        ),
      ),
    );
  }

  Widget _buildRexBubble() {
    final isEmpty = message.text.isEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.indigo500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        border: Border.all(
          color: AppColors.indigo400.withValues(alpha: 0.3),
        ),
      ),
      child: isEmpty
          ? const _ThinkingDots()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                ),
                if (message.cardData != null) ...[
                  const SizedBox(height: 12),
                  _buildCard(message),
                ],
                if (message.type == MessageType.actionRequired) ...[
                  const SizedBox(height: 12),
                  _buildActionButton(),
                ],
              ],
            ),
    );
  }

  Widget _buildCard(RexMessage message) {
    switch (message.type) {
      case MessageType.cardWarningShot:
        return RexWarningCard(cardData: message.cardData!);
      case MessageType.cardFinalStraw:
        return RexFinalStrawCard(cardData: message.cardData!);
      case MessageType.cardJuryDuty:
        return RexJuryDutyCard(cardData: message.cardData!);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.attach_file, size: 14, color: AppColors.purple),
          const SizedBox(width: 8),
          Text(
            'Upload Evidence',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

/// Animated bouncing dots shown while Rex is generating a response
class _ThinkingDots extends StatelessWidget {
  const _ThinkingDots();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: AppColors.indigo300,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .moveY(
                begin: 0,
                end: -5,
                delay: Duration(milliseconds: i * 150),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              )
              .then()
              .moveY(
                begin: -5,
                end: 0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
        }),
      ),
    );
  }
}
