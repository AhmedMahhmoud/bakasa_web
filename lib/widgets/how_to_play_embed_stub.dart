import 'package:flutter/material.dart';

Widget buildHowToPlayEmbed({required String videoId}) {
  return const ColoredBox(
    color: Color(0xFF111A2E),
    child: Center(
      child: Icon(
        Icons.ondemand_video_rounded,
        size: 52,
        color: Colors.white70,
      ),
    ),
  );
}
