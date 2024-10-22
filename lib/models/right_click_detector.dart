
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RightClickDetector extends StatelessWidget {
 RightClickDetector({ super.key, required this.child , required this.onRightClick});
  Widget child;
  Function onRightClick;
  @override
  Widget build(BuildContext context){
    return Listener(
        onPointerDown: 
          (PointerDownEvent event) {
          if (event.kind == PointerDeviceKind.mouse &&
              event.buttons == kSecondaryMouseButton) {
                onRightClick();
          }
          },
        child: child);
  }
}