import 'package:flutter/material.dart';

class PageConversationSticker extends StatefulWidget {
  final void Function(String) onSticker;

  const PageConversationSticker({
    super.key,
    required this.onSticker,
  });

  @override
  State<PageConversationSticker> createState() =>
      _PageConversationStickerState();
}

class _PageConversationStickerState extends State<PageConversationSticker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stiker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            GestureDetector(
              onTap: () {
                widget.onSticker("stickers/buffalo.png");
                Navigator.pop(context);
              },
              child: Image.asset("stickers/buffalo.png"),
            ),
            GestureDetector(
              onTap: () {
                widget.onSticker("stickers/cow.png");
                Navigator.pop(context);
              },
              child: Image.asset("stickers/cow.png"),
            ),
            GestureDetector(
              onTap: () {
                widget.onSticker("stickers/crocodile.png");
                Navigator.pop(context);
              },
              child: Image.asset("stickers/crocodile.png"),
            ),
            GestureDetector(
              onTap: () {
                widget.onSticker("stickers/flamingo.png");
                Navigator.pop(context);
              },
              child: Image.asset("stickers/flamingo.png"),
            ),
            GestureDetector(
              onTap: () {
                widget.onSticker("stickers/horse.png");
                Navigator.pop(context);
              },
              child: Image.asset("stickers/horse.png"),
            ),
            GestureDetector(
              onTap: () {
                widget.onSticker("stickers/pig.png");
                Navigator.pop(context);
              },
              child: Image.asset("stickers/pig.png"),
            ),
            GestureDetector(
              onTap: () {
                widget.onSticker("stickers/sheep.png");
                Navigator.pop(context);
              },
              child: Image.asset("stickers/sheep.png"),
            ),
          ],
        ),
      ),
    );
  }
}
