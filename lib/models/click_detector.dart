
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickDetector extends StatelessWidget {
 ClickDetector({ super.key, required this.child ,  this.onRightClick,this.onLeftClick});
  Widget child;
  Function? onRightClick;
  Function? onLeftClick;
  Function? onMiddleClick;
  @override
  Widget build(BuildContext context){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Listener(
          onPointerDown: 
            (PointerDownEvent event) {
            if (event.kind == PointerDeviceKind.mouse &&
                event.buttons == kSecondaryMouseButton && onRightClick != null) {
                  onRightClick!();
            }
                else if(event.kind == PointerDeviceKind.mouse && event.buttons == kMiddleMouseButton && onMiddleClick != null) {
                  onMiddleClick!();
                }
                else if(onLeftClick != null) {
                   onLeftClick!();
                }
            },
            
          child: child),
    );
  }
}