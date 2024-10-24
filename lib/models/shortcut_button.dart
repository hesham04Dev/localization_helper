// import 'package:flutter/material.dart';
// //TODO not working

// class ShortcutButton extends StatelessWidget {
//   const ShortcutButton(
//       {super.key,
//       required this.icon,
//       required this.logicalKeySet,
//       required this.onClick});
//   final Function onClick;
//   final Widget icon;
//   final LogicalKeySet logicalKeySet;
//   @override
//   Widget build(BuildContext context) {
//     return Shortcuts(
//       shortcuts: <LogicalKeySet, Intent>{
//         logicalKeySet: const ActivateIntent(),
//       },
//       child: Actions(
//         actions: <Type, Action<Intent>>{
//           // Define what happens when the key combination is pressed
//           ActivateIntent: CallbackAction<ActivateIntent>(
//             onInvoke: (intent) => onClick(),
//           ),
//         },
//         child: IconButton(onPressed: onClick(), icon: icon),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortcutButton extends StatelessWidget {
  const ShortcutButton({
    super.key,
    required this.icon,
    required this.logicalKeySet,
    required this.onClick,
  });

  final onClick;
  final Widget icon;
  final LogicalKeySet logicalKeySet;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        logicalKeySet: const ActivateIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) => onClick(),
          ),
        },
        child: Focus(
          autofocus: true, // To ensure the widget can receive keyboard input
          child: IconButton(
            onPressed: onClick, // Pass the function reference without invoking it
            icon: icon,
          ),
        ),
      ),
    );
  }
}
