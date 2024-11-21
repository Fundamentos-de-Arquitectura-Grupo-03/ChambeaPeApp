import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final enableNotifierProvider = StateNotifierProvider<EnableNotifier, bool>((ref) {
  return EnableNotifier();
});

class EnableNotifier extends StateNotifier<bool> {
  static const _key = 'enable_notifier';

  EnableNotifier() : super(false) {
    _loadFromPreferences();
  }

  void toggle() {
    state = !state;
    _saveToPreferences();
  }

  void _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? savedState = prefs.getBool(_key);
    if (savedState != null) {
      state = savedState;
    }
  }

  void _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, state);
  }
}
