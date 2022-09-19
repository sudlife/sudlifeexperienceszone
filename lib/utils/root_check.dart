import 'package:flutter/services.dart';

class Root {
  static const MethodChannel _channel = MethodChannel('root');

// Function to Run shell commands
  static Future<String?> exec({String? cmd}) async {
    String? result =
    await _channel.invokeMethod('ExecuteCommand', {"cmd": cmd});
    if(result!=""){
      //print(result);
      if(result!.contains("magisk")
          //|| result.contains("reflectlyApp")
          || result.contains("xposed")
          || result.contains("romtoolbox")
          || result.contains("titaniumbackup")
          || result.contains("sdmaid")
          || result.contains("busybox")
          || result.contains("superuser")
          || result.contains("supersu")
          || result.contains("root")
          || result.contains("cynogen")
      ){
        result = "true";
      //print("Root Detected");
      }else{
        result = "false";
      }
    }else{
      result = "false";
    }
    return result;
  }

// Function to check Root status
  static Future<bool?> isRooted() async {
    bool? result = await _channel.invokeMethod("isRooted");
    //bool? result = await _channel.name == "root";
    return result;
  }

}
