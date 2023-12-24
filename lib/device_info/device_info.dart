import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo{

    Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
    return "";
  }

  String? getDeviceInfo() {
    try {
      if (Platform.isAndroid) {
        return "android";
      } else if (Platform.isIOS) {
        return "ios";
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
    return "";
  }

}