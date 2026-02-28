// lib/features/landlord/presentation/providers/landlord_rex_ai_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/gemini_service.dart';

/// Message types for Rex AI responses
enum MessageType {
  text,
  actionRequired,
  suggestion,
  warning,
  cardWarningShot,
  cardFinalStraw,
  cardJuryDuty,
}

/// Chat message model
class RexMessage {
  final String id;
  final String sender; // 'REX' or 'USER'
  final String text;
  final MessageType type;
  final String? attachment;
  final Map<String, dynamic>? cardData;
  final DateTime timestamp;

  RexMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.type = MessageType.text,
    this.attachment,
    this.cardData,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Rex AI context modes
enum RexContext {
  concierge('Concierge Mode'),
  fiscalAnalyst('Fiscal Analyst'),
  harmonyEngine('Harmony Engine'),
  contractGuardian('Contract Guardian'),
  maintenanceChief('Maintenance Chief'),
  propertyCommander('Property Commander');

  final String label;
  const RexContext(this.label);
}

/// Rex AI state
class RexAIState {
  final List<RexMessage> messages;
  final bool isThinking;
  final RexContext context;

  RexAIState({
    required this.messages,
    this.isThinking = false,
    this.context = RexContext.propertyCommander,
  });

  RexAIState copyWith({
    List<RexMessage>? messages,
    bool? isThinking,
    RexContext? context,
  }) {
    return RexAIState(
      messages: messages ?? this.messages,
      isThinking: isThinking ?? this.isThinking,
      context: context ?? this.context,
    );
  }
}

/// Rex AI provider — connected to Gemini (landlord model)
class RexAINotifier extends Notifier<RexAIState> {
  final RexContext? _rexContext;
  final GeminiService _geminiService = GeminiService();

  RexAINotifier(this._rexContext);

  @override
  RexAIState build() {
    _geminiService.startLandlordChat();
    return RexAIState(
      messages: [
        RexMessage(
          id: '1',
          sender: 'REX',
          text: _getInitialGreeting(_rexContext ?? RexContext.propertyCommander),
          type: MessageType.text,
        ),
      ],
      context: _rexContext ?? RexContext.propertyCommander,
    );
  }

  static String _getInitialGreeting(RexContext context) {
    switch (context) {
      case RexContext.fiscalAnalyst:
        return "Fiscal protocols engaged. Rent is due in T-minus 72 hours. Your liability share is RM 600. Initiating settlement sequence?";
      case RexContext.harmonyEngine:
        return "Harmony diagnostics online. Roster check: You are assigned 'Trash Disposal' today. Failure to execute will impact your social standing.";
      case RexContext.contractGuardian:
        return "Lease Sentinel active. Upload the PDF. I will scan for predation, ambiguity, and non-standard clauses.";
      case RexContext.maintenanceChief:
        return "Systems check initiated. I detect 3 active alerts. Do you wish to override the AC repair schedule or escalate the plumbing ticket?";
      case RexContext.propertyCommander:
        return "Commander on deck. Portfolio revenue is up 8.4%. I have a draft lease ready for Unit 4-2. Awaiting your directive.";
      default:
        return "Greetings, Commander. Rex Neural Core is fully operational. Sync Score: STABLE. Awaiting your directive.";
    }
  }

  /// Send user message — streams response from Gemini
  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = RexMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'USER',
      text: text,
      type: MessageType.text,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isThinking: true,
    );

    // Add empty AI placeholder — will be filled as chunks stream in
    final aiMsgId = '${DateTime.now().millisecondsSinceEpoch}_ai';
    state = state.copyWith(
      messages: [
        ...state.messages,
        RexMessage(id: aiMsgId, sender: 'REX', text: '', type: MessageType.text),
      ],
    );

    String accumulated = '';
    try {
      await for (final chunk in _geminiService.sendLandlordMessage(text)) {
        accumulated += chunk;
        final msgs = state.messages.toList();
        final idx = msgs.indexWhere((m) => m.id == aiMsgId);
        if (idx != -1) {
          msgs[idx] = RexMessage(
            id: aiMsgId,
            sender: 'REX',
            text: accumulated,
            type: MessageType.text,
          );
        }
        state = state.copyWith(messages: msgs, isThinking: true);
      }
      state = state.copyWith(isThinking: false);
    } catch (e) {
      final msgs = state.messages.toList();
      final idx = msgs.indexWhere((m) => m.id == aiMsgId);
      if (idx != -1) {
        msgs[idx] = RexMessage(
          id: aiMsgId,
          sender: 'REX',
          text: 'Neural link disrupted. Please check your connection and retry.',
          type: MessageType.text,
        );
      }
      state = state.copyWith(messages: msgs, isThinking: false);
    }
  }

  /// Handle file upload — passes filename context to Gemini
  void uploadFile(String fileName) async {
    final uploadMessage = RexMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'USER',
      text: 'Uploaded: $fileName',
      type: MessageType.text,
      attachment: fileName,
    );

    state = state.copyWith(
      messages: [...state.messages, uploadMessage],
      isThinking: true,
    );

    final aiMsgId = '${DateTime.now().millisecondsSinceEpoch}_ai';
    state = state.copyWith(
      messages: [
        ...state.messages,
        RexMessage(id: aiMsgId, sender: 'REX', text: '', type: MessageType.suggestion),
      ],
    );

    final prompt =
        'The user has uploaded a document named "$fileName". Acknowledge the upload and explain how you can assist them with this file in the context of property management.';

    String accumulated = '';
    try {
      await for (final chunk in _geminiService.sendLandlordMessage(prompt)) {
        accumulated += chunk;
        final msgs = state.messages.toList();
        final idx = msgs.indexWhere((m) => m.id == aiMsgId);
        if (idx != -1) {
          msgs[idx] = RexMessage(
            id: aiMsgId,
            sender: 'REX',
            text: accumulated,
            type: MessageType.suggestion,
          );
        }
        state = state.copyWith(messages: msgs, isThinking: true);
      }
      state = state.copyWith(isThinking: false);
    } catch (e) {
      final msgs = state.messages.toList();
      final idx = msgs.indexWhere((m) => m.id == aiMsgId);
      if (idx != -1) {
        msgs[idx] = RexMessage(
          id: aiMsgId,
          sender: 'REX',
          text: 'File received. Processing failed — please retry.',
          type: MessageType.suggestion,
        );
      }
      state = state.copyWith(messages: msgs, isThinking: false);
    }
  }
}

/// Provider for Rex AI chat
final rexAIProvider = NotifierProvider.family<RexAINotifier, RexAIState, RexContext?>(
  (RexContext? arg) => RexAINotifier(arg),
);
