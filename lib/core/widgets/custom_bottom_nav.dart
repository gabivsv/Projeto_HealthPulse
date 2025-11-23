import 'package:flutter/material.dart';
import 'package:trabalho01/core/theme/app_theme.dart';

class CustomBottomNav extends StatelessWidget {
  final Color componentColor;
  final String activeKey;
  final VoidCallback onHomeTap;
  final VoidCallback onTreinoTap;
  final VoidCallback onAtividadesTap;
  final VoidCallback onConfigTap;

  const CustomBottomNav({
    super.key,
    required this.componentColor,
    required this.activeKey,
    required this.onHomeTap,
    required this.onTreinoTap,
    required this.onAtividadesTap,
    required this.onConfigTap,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 30;

    final List<Map<String, dynamic>> navItems = [
      {
        'key': 'home',
        'icon': Icons.home,
        'action': onHomeTap,
      },
      {
        'key': 'treino',
        'icon': Icons.fitness_center,
        'action': onTreinoTap,
      },
      {
        'key': 'atividades',
        'icon': Icons.list_alt,
        'action': onAtividadesTap,
      },
      {
        'key': 'config',
        'icon': Icons.settings,
        'action': onConfigTap,
      },
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: componentColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final bool isActive = item["key"] == activeKey;

          return IconButton(
            iconSize: iconSize,
            color: isActive ? baseGreen : Colors.white70,
            onPressed: item["action"],
            icon: Icon(item["icon"]),
          );
        }).toList(),
      ),
    );
  }
}
