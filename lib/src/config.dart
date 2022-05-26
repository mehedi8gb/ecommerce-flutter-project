class Config {
  /* Replace your sire url and api keys */

  String appName = 'yubizzle';
  String androidPackageName = 'com.yubizzle.app';
  String iosPackageName = 'com.yubizzle.app';

  String consumerKey = 'ck_9a08ba5009371c29b9b82690beabbef42a50a5ba';
  String consumerSecret = 'cs_78d113aedcc0c3e6f4c3ae27b57ae05b4be91a00';
  String url = 'https://yubizzle.com/';
  String mapApiKey = 'AIzaSyBsoiG_HMoZkGhZP-ejAINX-VXu0z0pUZo';

  static Config _singleton = new Config._internal();

  factory Config() {
    return _singleton;
  }

  Config._internal();

  Map<String, dynamic> appConfig = Map<String, dynamic>();

  Config loadFromMap(Map<String, dynamic> map) {
    appConfig.addAll(map);
    return _singleton;
  }

  dynamic get(String key) => appConfig[key];

  bool getBool(String key) => appConfig[key];

  int getInt(String key) => appConfig[key];

  double getDouble(String key) => appConfig[key];

  String getString(String key) => appConfig[key];

  void clear() => appConfig.clear();

  @Deprecated("use updateValue instead")
  void setValue(key, value) => value.runtimeType != appConfig[key].runtimeType
      ? throw ("wrong type")
      : appConfig.update(key, (dynamic) => value);

  void updateValue(String key, dynamic value) {
    if (appConfig[key] != null &&
        value.runtimeType != appConfig[key].runtimeType) {
      throw ("The persistent type of ${appConfig[key].runtimeType} does not match the given type ${value.runtimeType}");
    }
    appConfig.update(key, (dynamic) => value);
  }

  void addValue(String key, dynamic value) =>
      appConfig.putIfAbsent(key, () => value);

  add(Map<String, dynamic> map) => appConfig.addAll(map);
}
