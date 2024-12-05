import 'package:flutter/material.dart';

class CTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;

  const CTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        prefixIcon: Icon(prefixIcon),
      ),
    );
  }
}

class CTextSearch extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const CTextSearch({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        icon: const Icon(Icons.search),
      ),
    );
  }
}

class CTextFieldChat extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSend;
  final void Function() onSticker;

  const CTextFieldChat({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onSticker,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.emoji_emotions),
          onPressed: () {
            onSticker();
          },
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Ketik pesan...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            onSend(controller.text);
            controller.clear();
          },
        ),
      ],
    );
  }
}
