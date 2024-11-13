import 'package:flutter/material.dart';

class CPopup extends StatelessWidget {
  final List<Widget> menuChildren;

  const CPopup({super.key, required this.menuChildren});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
        );
      },
      menuChildren: menuChildren,
    );
  }
}
