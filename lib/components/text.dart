import 'package:flutter/material.dart';

class CTextHeader extends StatelessWidget {
  final String text;

  const CTextHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary),
    );
  }
}

class CTextWarning extends StatelessWidget {
  final String text;

  const CTextWarning({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.error),
    );
  }
}
