import 'package:chambeape/presentation/screens/screens.dart';
import 'package:chambeape/presentation/shared/custom_navbar.dart';
import 'package:go_router/go_router.dart';

final appRouterLogged = GoRouter(
  initialLocation: '/',
  routes: routes,
);

final appRouterNotLogged = GoRouter(
  initialLocation: '/login',
  routes: routes,
);

final routes = <GoRoute>[
  GoRoute(
    path: '/',
    name: CustomNavbar.routeName,
    builder: (context, state) => const CustomNavbar(),
  ),
  GoRoute(
    path: '/home',
    name: HomeView.routeName,
    builder: (context, state) => const HomeView(),
  ),
  GoRoute(
    path: '/login',
    name: LoginView.routeName,
    builder: (context, state) => const LoginView(),
  ),
  GoRoute(
    path: '/workers',
    name: WorkersView.routeName,
    builder: (context, state) => const WorkersView(),
  ),
  GoRoute(
    path: '/posts',
    name: PostView.routeName,
    builder: (context, state) => const PostView(),
  ),
  GoRoute(
    path: '/deals',
    name: DealView.routeName,
    builder: (context, state) => const DealView(),
  ),
  GoRoute(
    path: '/profile',
    name: ProfileView.routeName,
    builder: (context, state) => const ProfileView(),
  ),
  GoRoute(
    path: '/chat',
    name: ChatListView.routeName,
    builder: (context, state) => const ChatListView(),
  ),
  GoRoute(
    path: '/options',
    name: OptionsView.routeName,
    builder: (context, state) => const OptionsView(),
  ),
  GoRoute(
    path: '/postulation',
    name: PostulationView.routeName,
    builder: (context, state) => const PostulationView(),
  ),
];
