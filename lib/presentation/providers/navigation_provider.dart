import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider = StateNotifierProvider<NavigationProvider, int>((ref) {
  return NavigationProvider();
});

class NavigationProvider extends StateNotifier<int> {
  NavigationProvider() : super(0);

  void setIndex(int index) {
    state = index;
  }
}