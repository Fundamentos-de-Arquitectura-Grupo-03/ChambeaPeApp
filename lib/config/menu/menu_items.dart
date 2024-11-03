import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData iconActive;
  final IconData? iconDeactivated;

  const MenuItem({
    required this.title,
    required this.iconActive,
    this.iconDeactivated,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
      title: 'Inicio',
      iconActive: Icons.home,
      iconDeactivated: Icons.home_outlined),
  MenuItem(
      title: 'Posts',
      iconActive: Icons.post_add,
      iconDeactivated: Icons.post_add_outlined),
  MenuItem(
      title: 'Chat',
      iconActive: Icons.chat,
      iconDeactivated: Icons.chat_outlined),
  MenuItem(
      title: 'Negociaciones',
      iconActive: Icons.business_center,
      iconDeactivated: Icons.business_center_outlined),
  MenuItem(
      title: 'Perfil',
      iconActive: Icons.person,
      iconDeactivated: Icons.person_outline)
];
