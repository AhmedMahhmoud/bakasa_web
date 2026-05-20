// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

final Set<String> _registeredViewTypes = <String>{};

Widget buildHowToPlayEmbed({required String videoId}) {
  return _YouTubeIFrame(videoId: videoId);
}

class _YouTubeIFrame extends StatefulWidget {
  const _YouTubeIFrame({required this.videoId});

  final String videoId;

  @override
  State<_YouTubeIFrame> createState() => _YouTubeIFrameState();
}

class _YouTubeIFrameState extends State<_YouTubeIFrame> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'youtube-embed-${widget.videoId}';
    if (_registeredViewTypes.add(_viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
        final iframe = html.IFrameElement()
          ..src =
              'https://www.youtube.com/embed/${widget.videoId}?rel=0&modestbranding=1&playsinline=1'
          ..style.border = '0'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allow =
              'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
          ..allowFullscreen = true;
        return iframe;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
