import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rex_ai_main_menu_screen.dart';

/// Entry point for the REX centre tab — shows the Sync Hub style main menu.
/// Card taps push LandlordRexAIScreen via Navigator from within the menu.
class RexAITabWrapper extends ConsumerWidget {
  const RexAITabWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const RexAIMainMenuScreen();
  }
}
