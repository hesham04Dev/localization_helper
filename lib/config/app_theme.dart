import 'package:flutter/material.dart';
import 'package:flutter_color_utils/flutter_color_utils.dart';
import 'package:localization_helper/general_widgets/imageIcon.dart';

import 'const.dart';

ThemeData buildTheme(MaterialColor accentColor, bool isDark) {
  final ThemeData base = isDark ? ThemeData.dark() : ThemeData.light();
  Color backgroundColor = isDark ? kDarkGrey : kWhite;
  Color primaryColor = accentColor;
  final swatch = ColorScheme.fromSwatch(
      primarySwatch: accentColor,
      brightness: isDark ? Brightness.dark : Brightness.light);
  return base.copyWith(
    listTileTheme: ListTileThemeData(
      iconColor: accentColor,
      selectedTileColor: accentColor.shade100,
      shape: ContinuousRectangleBorder(borderRadius:primaryBorderRadius)
    ),
    dialogBackgroundColor: accentColor.shade100,
    tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
    dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
            alignment: const Alignment(-1, 1.3),
            surfaceTintColor: WidgetStatePropertyAll(primaryColor),
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(backgroundColor),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: primaryColor, width: 2),
            )))),
    segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
            side: const BorderSide(width: 1.5, color: Colors.transparent),
            selectedBackgroundColor: swatch.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ))),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        elevation: 0,
        unselectedItemColor: Colors.grey,
        selectedItemColor: swatch.primary,
        selectedLabelStyle: TextStyle(color: swatch.primary)),
        drawerTheme: DrawerThemeData(
           backgroundColor: Colors.black87,
           
           scrimColor: Colors.black45
        ),
    switchTheme: SwitchThemeData(
      trackOutlineColor:
          WidgetStateProperty.all(swatch.primary.withOpacity(0.2)),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return swatch.primary; // Color when switch is ON
        }
        return accentColor.shade100; // Color when switch is OFF
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return swatch.primary; // Color when switch is ON
        }
        return isDark ? kDarkGrey : kWhite; // Color when switch is OFF
      }),
    ),
    dividerColor: accentColor,
    dialogTheme: DialogTheme(
        backgroundColor: accentColor.withOpacity(0.2),
        barrierColor: isDark ? Colors.black26 : Colors.black12),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            iconColor: WidgetStatePropertyAll(
      swatch.primary,
    ))),
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.normal)),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(TextStyle(
      color: swatch.primary,
      fontFamily: kFont,
    )))),
    scaffoldBackgroundColor: isDark ? kDarkGrey : kWhite,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: const CircleBorder(),
        backgroundColor: swatch.primary.withOpacity(0.9),
        elevation: 0,
        hoverElevation: 0),
    iconTheme: IconThemeData(
      color: swatch.primary,
    ),
    colorScheme: swatch,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) => IconImage(iconName: "back.png"),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? kDarkGrey : kWhite,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: kFont,
        fontSize: 20,
        color: swatch.primary,
      ),
      centerTitle: true,
    ),
    hintColor: accentColor,
    cardColor: primaryColor,
    primaryColor: primaryColor,
    primaryIconTheme: base.primaryIconTheme.copyWith(
      color: accentColor,
    ),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme, accentColor),
    textSelectionTheme:
        _buildTextSelectionTheme(base.textSelectionTheme, accentColor, isDark),
    textTheme: _buildTextTheme(base.textTheme, accentColor),
  );
}

TextTheme _buildTextTheme(TextTheme base, Color color) {
  return base.copyWith(
    bodyMedium: base.bodyMedium!.copyWith(fontSize: 16, fontFamily: kFont),
    bodyLarge: base.bodyLarge!.copyWith(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: kFont),
    labelLarge: base.labelLarge!.copyWith(color: color, fontFamily: kFont),
    bodySmall:
        base.bodySmall!.copyWith(color: color, fontSize: 14, fontFamily: kFont),
    headlineSmall: base.headlineSmall!
        .copyWith(color: color, fontSize: 22, fontFamily: kFont),
    titleMedium: base.titleMedium!
        .copyWith(color: color, fontSize: 16, fontFamily: kFont),
    titleLarge: base.titleLarge!.copyWith(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: kFont),
  );
}

TextSelectionThemeData _buildTextSelectionTheme(
    TextSelectionThemeData base, Color accentColor, bool isDark) {
  return base.copyWith(
    cursorColor: accentColor,
    selectionColor: isDark ? kDarkGrey : kLightGrey,
    selectionHandleColor: accentColor,
  );
}
