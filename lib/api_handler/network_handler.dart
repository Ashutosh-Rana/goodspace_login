import 'dart:convert';

import 'package:goodspace_login/device_info/device_info.dart';
import 'package:goodspace_login/models/product.dart';
import 'package:http/http.dart' as http;

late String token;


class NetworkHandler {
  final String baseUrl = "https://api.ourgoodspace.com";
  // final DeviceInfo deviceInfo=DeviceInfo();
  final String deviceId = DeviceInfo().getId().toString();
  final String deviceType = DeviceInfo().getDeviceInfo().toString();
  

  Future<bool> sendOTP(String endpoint, String phone,String selectedCountryCode) async {
    final String apiUrl = baseUrl + endpoint;
    print(deviceId);
    print(deviceType);
    print(apiUrl);
    print(selectedCountryCode);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Replace with your actual token if required
      'device-id': deviceId, // Replace with your actual device ID
      'device-type': deviceType, // Replace with your actual device type
    };
    // print(object)
    final Map<String, dynamic> body = {
      'number': phone,
      'countryCode': selectedCountryCode,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Successful response, handle the data
        print('Response: ${response.body}');
        return true;
      } else {
        // Handle errors
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      // Handle network errors or exceptions
      print('Error: $error');
    }
    return false;
  }

  Future<bool> confirmOTP(String endpoint, String phone, String otp) async {
    final String apiUrl = baseUrl + endpoint;

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Replace with your actual token if required
      'device-id': deviceId, // Replace with your actual device ID
      'device-type': deviceType, // Replace with your actual device type
    };

    final Map<String, dynamic> body = {
      'number': phone,
      'otp': otp,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        // Successful response, handle the data
        print('Response: ${response.body}');
        String responseBody = response.body;
        Map<String, dynamic> jsonMap = json.decode(responseBody);
        String msg = jsonMap['message'];
        print(msg);
        if(msg=="Your OTP has been successfully verified"){
          // print("hello");
          token=jsonMap['data']['token'];
          // print(token);
          return true;
        }
      } else {
        // Handle errors
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      // Handle network errors or exceptions
      print('Error: $error');
    }
    return false;
  }

  Future<List<Product>> getInactiveProducts(String endpoint) async {
    final String apiUrl = baseUrl+endpoint;
    print(token);
    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        // print("hello");
        final List<dynamic> data = json.decode(response.body)['data'];
        // print(data);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        // print('Failed to load products');
        throw Exception('Failed to load products');
      }
    } catch (error) {
      // print("Exception has come");
      throw Exception('Error: $error');
    }
  }
}
