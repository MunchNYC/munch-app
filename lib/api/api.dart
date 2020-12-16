import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:munch/config/app_config.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/util/app.dart';
import 'package:path/path.dart';

abstract class Api {
  static String backendBaseUrl = AppConfig.getInstance().apiUrl;

  static const String POST = "POST";
  static const String PATCH = "PATCH";
  static const String GET = "GET";
  static const String PUT = "PUT";
  static const String DELETE = "DELETE";

  String baseUrl;

  Api({String endpointSetPrefix, int version}) {
    baseUrl = backendBaseUrl + "/" + endpointSetPrefix + "/v" + version.toString();
  }

  Api.thirdParty(this.baseUrl);

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<Map<String, String>> generateHeaders(
      {String contentType = "application/json", String accept = "application/json", bool authRequired = true}) async {
    String correlationId = getRandomString(32);
    print("CorrelationID: " + correlationId);
    Map<String, String> map = Map.of({
      HttpHeaders.contentTypeHeader: contentType,
      HttpHeaders.acceptHeader: accept,
      "X-Cloud-Trace-Context": correlationId,
    });

    if (authRequired) {
      map.addAll(await accessTokenHeader());
    }

    return map;
  }

  // Wrapper function which in case of UnauthorisedException, refreshes Auth token and retries the request
  Future<dynamic> performHttpRequest(
      {Map<String, String> headers, Function(Map<String, String>) requestFunction}) async {
    if (headers == null) {
      headers = await generateHeaders();
    }

    for (int attempt = 0; attempt <= CommunicationSettings.numOfRetries; attempt++) {
      print("Headers: " + headers.toString());
      try {
        final response = await requestFunction(headers)
            .timeout(Duration(seconds: CommunicationSettings.maxServerWaitTimeSec), onTimeout: () {
          throw ServerConnectionException.fromMessage(App.translate("api.error.request_timeout"));
        });

        return returnResponse(response);
      } on UnauthorisedException catch (e) {
        print("Attempt ${attempt + 1} failed due to UnauthorisedException.");

        if (attempt == CommunicationSettings.numOfRetries) {
          throw e;
        }

        await refreshAuthToken(headers);
      } on SocketException {
        throw InternetConnectionException();
      }
    }
  }

  Future<dynamic> get(String url, [Map<String, String> headers]) async {
    print("Getting from: " + baseUrl + url);

    return await performHttpRequest(
        headers: headers,
        requestFunction: (headers) async {
          return await http.get(baseUrl + url, headers: headers);
        });
  }

  Future<dynamic> post(String url, Map<String, dynamic> body, [Map<String, String> headers]) async {
    print("Posting to: " + baseUrl + url);

    return await performHttpRequest(
        headers: headers,
        requestFunction: (headers) async {
          return await http.post(baseUrl + url, headers: headers, body: json.encode(body));
        });
  }

  Future<dynamic> put(String url, Map<String, dynamic> body, [Map<String, String> headers]) async {
    print("Putting to: " + baseUrl + url);

    return await performHttpRequest(
        headers: headers,
        requestFunction: (headers) async {
          return await http.put(baseUrl + url, headers: headers, body: json.encode(body));
        });
  }

  Future<dynamic> patch(String url, Map<String, dynamic> body, [Map<String, String> headers]) async {
    print("Patching to: " + baseUrl + url);

    return await performHttpRequest(
        headers: headers,
        requestFunction: (headers) async {
          return await http.patch(baseUrl + url, headers: headers, body: json.encode(body));
        });
  }

  Future<dynamic> delete(String url, [Map<String, String> headers]) async {
    print("Deleting from: " + baseUrl + url);

    return await performHttpRequest(
        headers: headers,
        requestFunction: (headers) async {
          return await http.delete(baseUrl + url, headers: headers);
        });
  }

  Future<dynamic> multipart(String method, String url, Map<String, dynamic> fields, Map<String, File> files,
      Map<String, MediaType> contentTypes,
      [Map<String, String> headers]) async {
    print("Multipart " + method + " to: " + baseUrl + url);

    return await performHttpRequest(
        headers: headers,
        requestFunction: (headers) async {
          var request = http.MultipartRequest(method, Uri.parse(baseUrl + url));

          fields.forEach((k, v) => request.fields[k] = v);

          files.forEach((k, v) async => request.files.add(http.MultipartFile(k, v.openRead(), await v.length(),
              filename: basename(v.path), contentType: contentTypes[k])));

          request.headers.addAll(headers);
          return await request.send();
        });
  }

  Future<void> refreshAuthToken(Map<String, String> headers) async {
    print("Refreshing Auth token.");

    if (headers.containsKey(CommunicationSettings.tokenHeader)) {
      String newAuthToken = await UserRepo.getInstance().refreshAccessToken();
      headers.update(CommunicationSettings.tokenHeader, (oldValue) => newAuthToken);
    }
  }

  Future<Map<String, String>> accessTokenHeader() async {
    String accessToken = await UserRepo.getInstance().getAccessToken();

    return {CommunicationSettings.tokenHeader: "Bearer " + accessToken};
  }

  dynamic returnResponse(http.Response response) {
    print(response.statusCode);
    print(response.body);

    // if that's response with no content
    if (response.statusCode == 204) {
      return null;
    }

    var responseJson = json.decode(response.body.toString());

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseJson['status']['successful'] == false) {
        throw FetchDataException.fromMessage(json.decode(response.body.toString()));
      }

      return responseJson['data'];
    }

    switch (response.statusCode) {
      case 400:
        throw BadRequestException(response.statusCode, responseJson['status']);
      case 401:
        throw UnauthorisedException(response.statusCode, {"message": App.translate("api.error.unauthorized")});
      case 403:
        throw AccessDeniedException(response.statusCode, responseJson['status']);
      case 404:
        throw NotFoundException(response.statusCode, responseJson['status']);
      case 422:
        throw ValidationException(response.statusCode, responseJson['status']);
      case 500:
        throw InternalServerErrorException(response.statusCode, responseJson['status']);
      default:
        throw FetchDataException.fromMessage(json.decode(response.body.toString()));
    }
  }
}

class ApiException implements Exception {
  int _status;
  String _message;

  ApiException(this._status, Map<String, dynamic> map) {
    _message = map["message"] as String;
  }

  ApiException.fromMessage(this._message);

  String toString() {
    return _message;
  }
}

class FetchDataException extends ApiException {
  FetchDataException.fromMessage(String message) : super.fromMessage(message);

  FetchDataException(int status, Map<String, dynamic> map) : super(status, map);
}

class ServerConnectionException extends FetchDataException {
  ServerConnectionException.fromMessage(String message) : super.fromMessage(message);

  ServerConnectionException(int status, Map<String, dynamic> map) : super(status, map);
}

class InternetConnectionException extends FetchDataException {
  InternetConnectionException() : super.fromMessage(App.translate("api.error.internet_connection"));
}

class InternalServerErrorException extends FetchDataException {
  InternalServerErrorException.fromMessage(String message) : super.fromMessage(message);

  InternalServerErrorException(int status, Map<String, dynamic> map) : super(status, map);
}

class NotFoundException extends ApiException {
  NotFoundException.fromMessage(String message) : super.fromMessage(message);

  NotFoundException(int status, Map<String, dynamic> map) : super(status, map);
}

class BadRequestException extends ApiException {
  BadRequestException(int status, Map<String, dynamic> map) : super(status, map);
}

class AccessDeniedException extends ApiException {
  AccessDeniedException(int status, Map<String, dynamic> map) : super(status, map);
}

class UnauthorisedException extends ApiException {
  UnauthorisedException(int status, Map<String, dynamic> map) : super(status, map);
}

class InvalidInputException extends ApiException {
  InvalidInputException(int status, Map<String, dynamic> map) : super(status, map);
}

class ValidationException extends ApiException {
  ValidationException(int status, Map<String, dynamic> map) : super(status, map);
}
