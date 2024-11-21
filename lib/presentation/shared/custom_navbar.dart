import 'package:chambeape/config/menu/menu_items.dart';
import 'package:chambeape/infrastructure/models/users.dart';
import 'package:chambeape/presentation/providers/navigation_provider.dart';
import 'package:chambeape/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNavbar extends ConsumerWidget {
  static const routeName = 'custom_navbar';

  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);
    final navigationNotifier = ref.read(navigationProvider.notifier);
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    final screens = [
      const HomeView(),
      const PostView(),
      const ChatListView(),
      const DealView(),
      const ProfileView()
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        title: const Text('ChambeaPe'),
        leading: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Image.asset('assets/images/logo_white.png'),
        ),
      ),
      body: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) {
          Widget page = screens[selectedIndex];
          if (settings.name == ProfileView.routeName) {
            page = const ProfileView();
          } else if (settings.name == ChatView.routeName) {
            final chatUser = settings.arguments as Users;
            page = ChatView(otherUser: chatUser);
          } else if (settings.name == OptionsView.routeName) {
            page = const OptionsView();
          } else if (settings.name == PostulationView.routeName) {
            page = const PostulationView();
          }
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: (index) {
          navigationNotifier.setIndex(index);
        },
        items: appMenuItems
            .map((item) => BottomNavigationBarItem(
                icon: Icon(item.iconDeactivated),
                activeIcon: Icon(item.iconActive),
                label: item.title))
            .toList(),
      ),
    );
  }
}
