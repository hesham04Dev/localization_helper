import 'package:flutter/material.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_helper/models/PrimaryContainer.dart';
import 'package:localization_helper/models/click_detector.dart';
import 'package:localization_lite/translate.dart';

class KeyCard extends StatefulWidget {
  final String localizationKey;
  const KeyCard({ super.key, required this.localizationKey });

  @override
  State<KeyCard> createState() => _KeyCardState();
}
late List<String> keyValues;

class _KeyCardState extends State<KeyCard> {
  bool isOpen = false;
  Widget buildClosed(context){
    return ClickDetector(
      onRightClick: (){
        //TODO as long press
      },
      onLeftClick: (){
        isOpen = true;
        setState(() {
          
        });
      },
      child: PrimaryContainer(
        
        margin: 0,
        paddingHorizontal: 10,
        child: Row(children: [Expanded(child:Text(widget.localizationKey)), ...List.generate(keyValues.length, (index) =>Expanded(
          child: Text(keyValues[index]),
        ) )],),
      ),
    );
  }

  Widget buildOpen(context){
    
    List<String> langs = Localization.instance.langues();
    List controllers = List.generate(langs.length,(index) => TextEditingController(text:keyValues[index]),);  
    void disposeControllers(){
     for(var controller in controllers){
      controller.dispose();
     }
     controllers.clear();
    }
      return PrimaryContainer(
      padding: 20,
      margin: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(widget.localizationKey),IconButton(onPressed: (){
              isOpen =false;
              disposeControllers();
              setState(() {
                
              });
            }, icon: const Icon(Icons.close))],
          ),
          Wrap(
            children: List.generate(keyValues.length, (index) =>  TextField(
              controller: controllers[index],
              decoration: InputDecoration(
                //todo for the contorller
                
                hintText: langs[index]
              ),
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [TextButton(onPressed: (){
               List<String> langues = Localization.instance.langues();
                for(int i=0;i<controllers.length;i++){
                  
                Localization.instance.data[langues[i]]![widget.localizationKey]= controllers[i].text;}
                isOpen=false;
                setState(() {
                  
                });
                print(Localization.instance.data);
              }, child: Text(tr("save"))),
              FilledButton(onPressed: (){}, child: Text(tr("generate")))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    keyValues = Localization.instance.getKeyValues(widget.localizationKey);
    return isOpen? buildOpen(context): buildClosed(context) ;
  }
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
//     List<String> langs = Localization.instance.langues();

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
//                   List<String> langues = Localization.instance.langues();
//                   for (int i = 0; i < controllers.length; i++) {
//                     Localization.instance.data[langues[i]]![widget.localizationKey] =
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