import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:my_demo/model/loginresult.dart';
import 'dart:convert';
import 'package:my_demo/model/myfeedback.dart';
import 'package:my_demo/model/myresponse.dart';
import 'package:my_demo/viewmodel/login_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFeedbackApiProvider {
  Future<LoginResult> loginEquipment(LoginViewModel loginViewModel) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    http.Response response =
        //await http.post(
        //'http://pricingfmsapi.azurewebsites.net/api/v1/equipments/login.json',
        await ioClient.post(
      'https://10.0.2.2:5001/api/v1/equipments/login.json',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'EquipmentId': loginViewModel.equipmentCode,
        'EquipmentSercurityCode': loginViewModel.securityCode
      }),
    );
    if (response.statusCode == 307) {
      String url = response.headers['location'];
      response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'EquipmentId': loginViewModel.equipmentCode,
          'EquipmentSercurityCode': loginViewModel.securityCode
        }),
      );
    }
    if (response.statusCode == 200) {
      return LoginResult.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<int> sendResponse(List<MyResponse> listResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    http.Response response =
        // await http.post(
        // 'http://pricingfmsapi.azurewebsites.net/api/v1/responses',
        await ioClient.post(
      'https://10.0.2.2:5001/api/v1/responses',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + prefs.getString('ACCESS_TOKEN'),
      },
      body: jsonEncode(listResponse.map((e) => e.toJson()).toList()),
    );
    if (response.statusCode == 307) {
      String url = response.headers['location'];
      response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + prefs.getString('ACCESS_TOKEN'),
        },
        body: jsonEncode(listResponse.map((e) => e.toJson()).toList()),
      );
    }
    if (response.statusCode == 200) {
      return 0;
    } else {
      return response.statusCode;
    }
  }

  Future<int> sendPersonalIdea(MyResponse myResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.post(
      'http://pricingfmsapi.azurewebsites.net/api/v1/responses/opinions',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + prefs.getString('ACCESS_TOKEN'),
      },
      body: jsonEncode(myResponse.personalIdeaToJson()),
    );
    if (response.statusCode == 307) {
      String url = response.headers['location'];
      response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + prefs.getString('ACCESS_TOKEN'),
        },
        body: jsonEncode(myResponse.personalIdeaToJson()),
      );
    }
    if (response.statusCode == 200) {
      return 0;
    } else {
      return response.statusCode;
    }
  }

  Future<bool> sendFCMToken(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    http.Response response =
        // await http.get(
        // 'http://pricingfmsapi.azurewebsites.net/api/v1/equipments/fcmtokens?t=' +
        //     fcmToken,
        await ioClient.get(
      'https://10.0.2.2:5001/api/v1/equipments/fcmtokens?t=' + fcmToken,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + prefs.getString('ACCESS_TOKEN'),
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<MyFeedback> getFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    http.Response response =
        // await http.get(
        // 'http://pricingfmsapi.azurewebsites.net/api/v1/questions',
        await ioClient.get(
      'https://10.0.2.2:5001/api/v1/questions',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + prefs.getString('ACCESS_TOKEN'),
      },
    );

    if (response.statusCode == 200) {
      return MyFeedback.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.get(
      'http://pricingfmsapi.azurewebsites.net/api/v1/equipments/logout?id=' +
          prefs.getString('EQUIPMENT_ID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + prefs.getString('ACCESS_TOKEN'),
      },
    );

    if (response.statusCode == 200) {
      print("logout success");
      return true;
    } else {
      print("logout fail");
      return false;
    }
  }

  Future<bool> sendGiftToMail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    http.Response response =
        // await http.post(
        // 'http://pricingfmsapi.azurewebsites.net/api/v1/gifts/emails',
        await ioClient.post(
      'https://10.0.2.2:5001/api/v1/gifts/emails',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + prefs.getString('ACCESS_TOKEN'),
      },
      body: jsonEncode(<String, String>{'CustomerEmail': email}),
    );
    if (response.statusCode == 307) {
      String url = response.headers['location'];
      response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + prefs.getString('ACCESS_TOKEN'),
        },
        body: jsonEncode(<String, String>{'CustomerEmail': email}),
      );
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
