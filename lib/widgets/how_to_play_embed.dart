import 'package:flutter/widgets.dart';

import 'how_to_play_embed_stub.dart'
    if (dart.library.html) 'how_to_play_embed_web.dart' as impl;

class HowToPlayEmbed extends StatelessWidget {
  const HowToPlayEmbed({super.key, required this.videoId});

  final String videoId;

  @override
  Widget build(BuildContext context) {
    return impl.buildHowToPlayEmbed(videoId: videoId);
  }
}
