import 'package:flutter/material.dart';

class CIconHeader extends StatelessWidget {
  final IconData icon;

  const CIconHeader({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 80,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
