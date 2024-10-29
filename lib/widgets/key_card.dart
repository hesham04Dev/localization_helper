import 'package:flutter/material.dart';
import 'package:localization_helper/config/const.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/models/click_detector.dart';
import 'package:provider/provider.dart';

class KeyCard extends StatefulWidget {
  final String localizationKey;

  const KeyCard({ super.key, required this.localizationKey });

  @override
  State<KeyCard> createState() => _KeyCardState();
}
late List<String> keyValues;

class _KeyCardState extends State<KeyCard> {
  bool isOpen = false;
  late List<String> langs;
  late Localization localizationInstance;

  @override
  Widget build(BuildContext context) {
    localizationInstance =context.read<Localization>();
    keyValues = localizationInstance.getKeyValues(widget.localizationKey);
     return Column(
      mainAxisSize: MainAxisSize.min,
       children: [
         ClickDetector(
          onRightClick: (){
            //TODO as long press
          },
          onLeftClick: (){
            isOpen = true;
            setState(() {
              //TODO nav to new page await and get the data then setstate this widget 
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: kAccentColor.withOpacity(0.2)))
            ),
            child: Row(mainAxisSize: MainAxisSize.min,
              children: [SizedBox(width: 100, child:Text(widget.localizationKey)), ...List.generate(keyValues.length, (index) =>SizedBox(width: 100,
              child: Text(keyValues[index]),
            ) )],),
          ),
             ),
          
       ],
     );
  
  }

  // Widget buildClosed(context){
  //   return ClickDetector(
  //     onRightClick: (){
  //       //TODO as long press
  //     },
  //     onLeftClick: (){
  //       isOpen = true;
  //       setState(() {
          
  //       });
  //     },
  //     child: PrimaryContainer(
        
  //       margin: 0,
  //       paddingHorizontal: 10,
  //       child: Row(mainAxisSize: MainAxisSize.min,
  //         children: [SizedBox(width: 100, child:Text(widget.localizationKey)), ...List.generate(keyValues.length, (index) =>SizedBox(width: 100,
  //         child: Text(keyValues[index]),
  //       ) )],),
  //     ),
  //   );
  // }

  // Widget buildOpen(BuildContext context){
     
  //   langs = localizationInstance.languages();
  //   List controllers = List.generate(langs.length,(index) => TextEditingController(text:keyValues[index]),);  
  //   void disposeControllers(){
  //    for(var controller in controllers){
  //     controller.dispose();
  //    }
  //    controllers.clear();
  //   }
  //     return PrimaryContainer(
  //     padding: 20,
  //     margin: 0,
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [Text(widget.localizationKey),IconButton(onPressed: (){
  //             isOpen =false;
  //             disposeControllers();
  //             setState(() {
                
  //             });
  //           }, icon: const Icon(Icons.close))],
  //         ),
  //         Wrap(
  //           children: List.generate(keyValues.length, (index) =>  TextField(
  //             controller: controllers[index],
  //             decoration: InputDecoration(
  //               //todo for the contorller
                
  //               hintText: langs[index]
  //             ),
  //           ),),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(top: 8.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [TextButton(onPressed: (){
               
  //               for(int i=0;i<controllers.length;i++){
  //               localizationInstance.data[langs[i]]![widget.localizationKey]= controllers[i].text;}
  //               isOpen=false;
  //               setState(() {
                  
  //               });
  //               // print(localizationInstance.data);
  //             }, child: Text(tr("save"))),
  //             FilledButton(onPressed: (){
  //                 var param = {"key": widget.localizationKey};
  //                 for(int i=0;i<controllers.length;i++){
  //                   param[langs[i]] = controllers[i].text;
  //                 }
  //                 localizationInstance.generateCardValues(param);
  //             }, child: Text(tr("generate")))
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  
}

// import 'package:flutter/material.dart';
// import 'package:localization_helper/controllers/localization.dart';
// import 'package:localization_helper/models/PrimaryContainer.dart';
// import 'package:localization_helper/models/right_click_detector.dart';
// import 'package:localization_lite/translate.dart';

// class KeyCard extends StatefulWidget {
//   final String localizationKey;
//   const KeyCard({super.key, required this.localizationKey});

//   @override
//   State<KeyCard> createState() => _KeyCardState();
// }

// late List<String> keyValues;

// class _KeyCardState extends State<KeyCard> with SingleTickerProviderStateMixin {
//   bool isOpen = false;
//   late List<TextEditingController> controllers;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize key values and controllers
//     keyValues = Localization.instance.getKeyValues(widget.localizationKey);
//     controllers = List.generate(
//       keyValues.length,
//       (index) => TextEditingController(text: keyValues[index]),
//     );
//   }

//   @override
//   void dispose() {
//     // Properly dispose controllers to avoid memory leaks
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   // Function to close the card and reset state
//   void close() {
//     setState(() {
//       isOpen = false;
//     });
//   }

//   Widget buildClosed(BuildContext context) {
//     return RightClickDetector(
//       onRightClick: () {
//         //TODO: Handle right click
//       },
//       child: MaterialButton(
//         onPressed: () {
//           setState(() {
//             isOpen = true;
//           });
//         },
//         onLongPress: () {
//           // Show dialog for delete or change key name
//         },
//         child: PrimaryContainer(
//           paddingHorizontal: 10,
//           child: Row(
//             children: [
//               Expanded(child: Text(widget.localizationKey)),
//               ...List.generate(
//                 keyValues.length,
//                 (index) => Expanded(child: Text(keyValues[index])),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildOpen(BuildContext context) {
//     List<String> langs = Localization.instance.languages();

//     return PrimaryContainer(
//       padding: 20,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(widget.localizationKey),
//               IconButton(
//                 onPressed: close,
//                 icon: const Icon(Icons.close),
//               ),
//             ],
//           ),
//           Wrap(
//             children: List.generate(
//               keyValues.length,
//               (index) => TextField(
//                 controller: controllers[index],
//                 decoration: InputDecoration(hintText: langs[index]),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   List<String> languages = Localization.instance.languages();
//                   for (int i = 0; i < controllers.length; i++) {
//                     Localization.instance.data[languages[i]]![widget.localizationKey] =
//                         controllers[i].text;
//                   }
//                   close();
//                 },
//                 child: Text(tr("save")),
//               ),
//               FilledButton(
//                 onPressed: () {},
//                 child: Text(tr("generate")),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSize(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       child: isOpen ? buildOpen(context) : buildClosed(context),
//     );
//   }
// }

//animated version have some err the data does not appear on close 

//make the first input autofocus and in all input add on submit to save or generate
