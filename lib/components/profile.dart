import 'package:flutter/material.dart';

class CProfileChat extends StatelessWidget {
  final String text;

  const CProfileChat({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CProfileAvatar(text: text),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class CProfileAvatar extends StatelessWidget {
  final String text;
  final double radius;

  const CProfileAvatar({super.key, required this.text, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      radius: radius,
      child: Text(
        text.isEmpty ? "?" : text[0].toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
