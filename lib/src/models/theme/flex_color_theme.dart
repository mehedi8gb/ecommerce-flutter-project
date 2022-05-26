import 'package:app/src/models/theme/hex_color.dart';
import 'package:app/src/themes/google_font.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

ThemeData flexThemeFromJson(Map<String, dynamic>? json, String themeMode) {
  return themeMode == 'light' ? json is Map<String, dynamic> ? FlexThemeData.light(
    scheme: json["useBuiltIn"] == true ? getFlexScheme(json["scheme"]) : null,
    colors: json["useBuiltIn"] != true ? flexThemesColorsfromJson(json["colors"]) : null,
    surfaceMode: getSurfaceMode(json["surfaceMode"]),
    blendLevel: isInt(json["blendLevel"].toString()) ? int.parse(json["blendLevel"].toString()) : 18,
    appBarStyle: getAppBarStyle(json["appBarStyle"]),
    appBarOpacity: isDouble(json["appBarOpacity"].toString()) ? double.parse(json["appBarOpacity"].toString()) : 0.95,
    appBarElevation: isDouble(json["appBarElevation"].toString()) ? double.parse(json["appBarElevation"].toString()) : 0.0,
    transparentStatusBar: json["transparentStatusBar"] == false ? false : true,
    tabBarStyle: getTabBarStyle(json["tabBarStyle"]),
    tooltipsMatchBackground: json["tooltipsMatchBackground"] == false ? false : true,
    swapColors: json["swapColors"] == false ? false : true,
    lightIsWhite: json["lightIsWhite"] == false ? false : true,
    useSubThemes: json["useSubThemes"] == false ? false : true,
    visualDensity: getVisualDensity(json["visualDensity"]),
    fontFamily: getGoogleFont(json['fontFamily']).fontFamily,
    subThemesData: json["subThemesData"] == null ? subThemesDataFromJson({}) : subThemesDataFromJson(json["subThemesData"]),
  ) : FlexThemeData.light(
    scheme: FlexScheme.blumineBlue,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 18,
    appBarStyle: FlexAppBarStyle.material,
    appBarOpacity: 0.95,
    appBarElevation: 0.0,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: true,
    lightIsWhite: true,
    useSubThemes: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use this font, add GoogleFonts package and uncomment:
    // fontFamily: GoogleFonts.notoSans().fontFamily,
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      fabUseShape: false,
      interactionEffects: true,
      bottomNavigationBarOpacity: 0.95,
      bottomNavigationBarElevation: 0.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedHasBorder: true,
      blendOnColors: true,
      blendTextTheme: true,
      popupMenuOpacity: 0.95,
    ),
  ) : json is Map<String, dynamic> ? FlexThemeData.dark(
    scheme: json["useBuiltIn"] == true ? getFlexScheme(json["scheme"]) : null,
    colors: json["useBuiltIn"] != true ? flexThemesColorsfromJson(json["colors"]) : null,
    surfaceMode: getSurfaceMode(json["surfaceMode"]),
    blendLevel: isInt(json["blendLevel"].toString()) ? int.parse(json["blendLevel"].toString()) : 18,
    appBarStyle: getAppBarStyle(json["appBarStyle"]),
    appBarOpacity: isDouble(json["appBarOpacity"].toString()) ? double.parse(json["appBarOpacity"].toString()) : 0.95,
    appBarElevation: isDouble(json["appBarElevation"].toString()) ? double.parse(json["appBarElevation"].toString()) : 0.0,
    transparentStatusBar: json["transparentStatusBar"] == false ? false : true,
    tabBarStyle: getTabBarStyle(json["tabBarStyle"]),
    tooltipsMatchBackground: json["tooltipsMatchBackground"] == false ? false : true,
    swapColors: json["swapColors"] == false ? false : true,
    useSubThemes: json["useSubThemes"] == false ? false : true,
    visualDensity: getVisualDensity(json["visualDensity"]),
    fontFamily: getGoogleFont(json['fontFamily']).fontFamily,
    subThemesData: json["subThemesData"] == null ? subThemesDataFromJson({}) : subThemesDataFromJson(json["subThemesData"]),
  ) : FlexThemeData.dark(
    scheme: FlexScheme.blumineBlue,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 18,
    appBarStyle: FlexAppBarStyle.material,
    appBarOpacity: 0.95,
    appBarElevation: 0.0,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapColors: true,
    useSubThemes: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use this font, add GoogleFonts package and uncomment:
    // fontFamily: GoogleFonts.notoSans().fontFamily,
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      fabUseShape: false,
      interactionEffects: true,
      bottomNavigationBarOpacity: 0.95,
      bottomNavigationBarElevation: 0.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedHasBorder: true,
      blendOnColors: true,
      blendTextTheme: true,
      popupMenuOpacity: 0.95,
    ),
  );
}

FlexSchemeColor flexThemesColorsfromJson(Map<String, dynamic>? json) {
  return json is Map<String, dynamic> ? FlexSchemeColor(
    primary: json['primary'] != null ? HexColor(json['primary']) : Colors.blue,
    primaryVariant: json['primary'] != null ? HexColor(json['primaryVariant']) : Colors.lightBlue,
    secondary: json['primary'] != null ? HexColor(json['secondary']) : Colors.orange,
    secondaryVariant: json['primary'] != null ? HexColor(json['secondaryVariant']) : Colors.deepOrange,
    appBarColor: json['appBarColor'] == null ? Colors.white : HexColor(
        json['appBarColor']),
    error: json['error'] == null ? null : HexColor(json['error']),
  ) : FlexSchemeColor(
    primary: Colors.blue,
    primaryVariant: Colors.lightBlue,
    secondary: Colors.orange,
    secondaryVariant: Colors.deepOrange,
    appBarColor: Colors.white,
    error: null,
  );
}

FlexSubThemesData? subThemesDataFromJson(Map<String, dynamic> json) {
  return FlexSubThemesData(
    useTextTheme: json["useTextTheme"] == false ? false : true,
    fabUseShape: json["fabUseShape"] == true ? true : false,
    interactionEffects: json["interactionEffects"] == false ? false : true,
    bottomNavigationBarOpacity: isDouble(json["bottomNavigationBarOpacity"].toString()) ? double.parse(json["bottomNavigationBarOpacity"].toString()) : 0.95,
    bottomNavigationBarElevation: isDouble(json["bottomNavigationBarElevation"].toString()) ? double.parse(json["bottomNavigationBarElevation"].toString()) : 0.0,
    inputDecoratorIsFilled: json["inputDecoratorIsFilled"] == false ? false : true,
    inputDecoratorBorderType: getInputDecoratorBorderType(json["inputDecoratorBorderType"]),
    inputDecoratorUnfocusedHasBorder: json["inputDecoratorUnfocusedHasBorder"] == false ? false : true,
    blendOnColors: json["blendOnColors"] == false ? false : true,
    blendTextTheme: json["blendTextTheme"] == false ? false : true,
    popupMenuOpacity: isDouble(json["popupMenuOpacity"].toString()) ? double.parse(json["popupMenuOpacity"].toString()) : 0.95,
  );
}

bool isDouble(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool isInt(String? s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}

getFlexScheme(flexScheme) {
  switch (flexScheme) {
    case 'FlexScheme.material':
      return FlexScheme.material;
    case 'FlexScheme.materialHc':
      return FlexScheme.materialHc;
    case 'FlexScheme.blue':
      return FlexScheme.blue;
    case 'FlexScheme.indigo':
      return FlexScheme.indigo;
    case 'FlexScheme.hippieBlue':
      return FlexScheme.hippieBlue;
    case 'FlexScheme.aquaBlue':
      return FlexScheme.aquaBlue;
    case 'FlexScheme.brandBlue':
      return FlexScheme.brandBlue;
    case 'FlexScheme.deepBlue':
      return FlexScheme.deepBlue;
    case 'FlexScheme.sakura':
      return FlexScheme.sakura;
    case 'FlexScheme.mandyRed':
      return FlexScheme.mandyRed;
    case 'FlexScheme.red':
      return FlexScheme.red;
    case 'FlexScheme.redWine':
      return FlexScheme.redWine;
    case 'FlexScheme.purpleBrown':
      return FlexScheme.purpleBrown;
    case 'FlexScheme.green':
      return FlexScheme.green;
    case 'FlexScheme.money':
      return FlexScheme.money;
    case 'FlexScheme.jungle':
      return FlexScheme.jungle;
    case 'FlexScheme.greyLaw':
      return FlexScheme.greyLaw;
    case 'FlexScheme.wasabi':
      return FlexScheme.wasabi;
    case 'FlexScheme.gold':
      return FlexScheme.gold;
    case 'FlexScheme.mango':
      return FlexScheme.mango;
    case 'FlexScheme.amber':
      return FlexScheme.amber;
    case 'FlexScheme.vesuviusBurn':
      return FlexScheme.vesuviusBurn;
    case 'FlexScheme.deepPurple':
      return FlexScheme.deepPurple;
    case 'FlexScheme.ebonyClay':
      return FlexScheme.ebonyClay;
    case 'FlexScheme.barossa':
      return FlexScheme.barossa;
    case 'FlexScheme.sakura':
      return FlexScheme.sakura;
    case 'FlexScheme.bigStone':
      return FlexScheme.bigStone;
    case 'FlexScheme.damask':
      return FlexScheme.damask;
    case 'FlexScheme.bahamaBlue':
      return FlexScheme.bahamaBlue;
    case 'FlexScheme.mallardGreen':
      return FlexScheme.mallardGreen;
    case 'FlexScheme.espresso':
      return FlexScheme.espresso;
    case 'FlexScheme.outerSpace':
      return FlexScheme.outerSpace;
    case 'FlexScheme.blueWhale':
      return FlexScheme.blueWhale;
    case 'FlexScheme.sanJuanBlue':
      return FlexScheme.sanJuanBlue;
    case 'FlexScheme.rosewood':
      return FlexScheme.rosewood;
    case 'FlexScheme.blumineBlue':
      return FlexScheme.blumineBlue;
    case 'FlexScheme.custom':
      return FlexScheme.custom;
    default:
      return FlexScheme.mandyRed;
  }
}

getSurfaceMode(json) {
  switch (json) {
    case 'FlexSurfaceMode.custom':
      return FlexSurfaceMode.custom;
    case 'FlexSurfaceMode.highBackgroundLowScaffold':
      return FlexSurfaceMode.highBackgroundLowScaffold;
    case 'FlexSurfaceMode.highScaffoldLevelSurface':
      return FlexSurfaceMode.highScaffoldLevelSurface;
    case 'FlexSurfaceMode.highScaffoldLowSurface':
      return FlexSurfaceMode.highScaffoldLowSurface;
    case 'FlexSurfaceMode.highScaffoldLowSurfaces':
      return FlexSurfaceMode.highScaffoldLowSurfaces;
    case 'FlexSurfaceMode.levelSurfacesLowScaffoldVariantDialog':
      return FlexSurfaceMode.levelSurfacesLowScaffoldVariantDialog;
    case 'FlexSurfaceMode.levelSurfacesLowScaffold':
      return FlexSurfaceMode.levelSurfacesLowScaffold;
    case 'FlexSurfaceMode.level':
      return FlexSurfaceMode.level;
    case 'FlexSurfaceMode.highSurfaceLowScaffold':
      return FlexSurfaceMode.highSurfaceLowScaffold;
    case 'FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog':
      return FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog;
    default:
      return FlexSurfaceMode.highScaffoldLowSurface;
  }
}

getAppBarStyle(json) {
  switch (json) {
    case 'FlexAppBarStyle.custom':
      return FlexAppBarStyle.custom;
    case 'FlexAppBarStyle.primary':
      return FlexAppBarStyle.primary;
    case 'FlexAppBarStyle.surface':
      return FlexAppBarStyle.surface;
    case 'FlexAppBarStyle.background':
      return FlexAppBarStyle.background;
    default:
      return FlexAppBarStyle.material;
  }
}

getTabBarStyle(json) {
  switch (json) {
    case 'FlexTabBarStyle.flutterDefault':
      return FlexTabBarStyle.flutterDefault;
    case 'FlexTabBarStyle.forBackground':
      return FlexTabBarStyle.forBackground;
    case 'FlexTabBarStyle.universal':
      return FlexTabBarStyle.universal;
    default:
      return FlexTabBarStyle.forAppBar;
  }
}

getVisualDensity(json) {
  switch (json) {
    case 'FlexColorScheme.comfortablePlatformDensity':
      return FlexColorScheme.comfortablePlatformDensity;
    default:
      return FlexColorScheme.comfortablePlatformDensity;
  }
}

getInputDecoratorBorderType(json) {
  switch (json) {
    case 'FlexInputBorderType.outline':
      return FlexInputBorderType.outline;
    default:
      return FlexInputBorderType.underline;
  }
}
