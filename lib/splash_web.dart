import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:web/web.dart' as web;

/// Hides the HTML splash overlay in [web/index.html] after Flutter paints once.
void removeWebSplashAfterFirstFrame() {
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    final el = web.document.getElementById('flutter-loading');
    if (el == null) return;
    el.classList.add('flutter-loading--hide');
    await Future<void>.delayed(const Duration(milliseconds: 380));
    el.remove();
  });
}
