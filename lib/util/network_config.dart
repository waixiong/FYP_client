import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import '../locator.dart';
import 'package:http/http.dart' as http;
import '../logger.dart';
import '../service/auth_service.dart';

const String API_URL = 'http://tsmappadmin.com';

class ApiError implements Exception {
  int statusCode;
  String errorMessage;

  ApiError(this.statusCode, this.errorMessage);

  @override
  String toString() {
    return 'code ${this.statusCode}, ${this.errorMessage}';
  }
}

class API {
  http.Client client;
  String _access = '';
  // String _refresh = '';
  final log = getLogger('API');
  
  API() {
    client = http.Client();
  }

  void setAuthorization(String accessToken, String refreshToken) {
    _access = accessToken;
    // _refresh = refreshToken;
  }

  Map<String, String> _setHeaders() {
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if(_access != null) header['Authorization'] = _access;
    return header;
  }

  Future<dynamic> post(String domain, String method, Map<String, dynamic> body) async {
    log.d(Uri.parse(domain+method));
    try {
      http.Response response = await client.post(
        domain+method, 
        headers: _setHeaders(), 
        body: json.encode(body)
      );
      log.d('receive response');
      if(response.statusCode == 200) {
        log.d('response ${response.body}');
        return json.decode(response.body);
      } else {
        log.e('Status Code ${response.statusCode}');
        log.e(response.body);
        // throw ErrorDescription(response.body);
        ApiError apiError = ApiError(response.statusCode, response.body);
        throw apiError;
      }
    } catch(e) {
      log.e(e);
      throw e;
    }
  }

  Future<dynamic> get(String domain, String path) async {
    log.d(Uri.parse(domain+path));
    http.Response response = await client.get(
      domain+path, 
      headers: _setHeaders()
    );
    if(response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log.e('Status Code ${response.statusCode}');
      log.e(response.body);
      // throw ErrorDescription(response.body);
      ApiError apiError = ApiError(response.statusCode, response.body);
      throw apiError;
    }
  }

  Future<dynamic> put(String domain, String method, Map<String, dynamic> body) async {
    log.d(Uri.parse(domain+method));
    http.Response response = await client.put(
      domain+method, 
      headers: _setHeaders(), 
      body: json.encode(body)
    );
    if(response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log.e('Status Code ${response.statusCode}');
      log.e(response.body);
      // throw ErrorDescription(response.body);
      ApiError apiError = ApiError(response.statusCode, response.body);
      throw apiError;
    }
  }

  Future<dynamic> delete(String domain, String path) async {
    log.d(Uri.parse(domain+path));
    http.Response response = await client.delete(
      domain+path, 
      headers: _setHeaders()
    );
    if(response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log.e('Status Code ${response.statusCode}');
      log.e(response.body);
      // throw ErrorDescription(response.body);
      ApiError apiError = ApiError(response.statusCode, response.body);
      throw apiError;
    }
  }

  Future<dynamic> _refreshToken(Function func, List args) async {
    log.i('refreshing token...');
    try {
      await locator<AuthService>().refresh();
    } catch (e) {
      log.e('refresh fail, auto sign out');
    }
    return Function.apply(func, args);
  }

  // String getAvatarPath(String image) {
  //   return API_URL+'/storage/avatar/'+image;
  // }

  // String getFeatureImgPath(String image) {
  //   return API_URL+'/storage/feature_img/'+image;
  // }

  // String getImagePath(String image) {
  //   return API_URL+'/storage/image/'+image;
  // }
}