import 'package:asset_icon/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:localization_helper/general_widgets/PrimaryContainer.dart';
import 'package:localization_helper/generated/icons.g.dart';
import 'package:localization_helper/providers/localization.dart';
import 'package:localization_lite/translate.dart';
import 'package:provider/provider.dart';

class SearchField extends StatefulWidget {
  SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void submit() {
      context.read<Localization>().dataManager.filterByKey(_controller.text);
      context.read<Localization>().notify();
      // Navigator.pop(context);
    }

    return PrimaryContainer(
      padding: 0,
      paddingHorizontal: 5,
      margin: 6,
      borderRadius: 20,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                // searchText = value;
                submit();
                setState(() {
                  
                });
              },
              onSubmitted: (value) {
                // print(value);
                submit();
              },
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                // fillColor: Colors.green,
                // filled: true,
                border: InputBorder.none,

                hintText: tr("search"),
                hintStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // submit();
               _controller.text ="";
               submit();
            },
            icon: AssetIcon(_controller.text =="" ? AssetIcons.search : AssetIcons.close, size: 18),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}
