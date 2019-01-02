import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './Base.dart';
import './net.dart';

class HttpProvider extends BaseProvider implements RPCRequest {
  // TODO: implement the request timeout
  final int timeout = 120000;
  final String cache = 'no-cache';
  final String mode = 'cors';
  final String redirect = 'follow';
  final String referrer = 'no-referrer';

  Map<String, String> headers = {'Content-Type': 'application/json'};

  @override
  String url;

  RPCRequestPayload payload;
  RPCRequestOptions options;

  http.Client client;

  HttpProvider(url, [req, res]) : super(req, res) {
    this.url = url;
    this.client = new http.Client();
  }

  Map<String, dynamic> buildPayload(String method, String params) {
    return {
      'url': this.url,
      'payload': {
        'id': 1,
        'jsonrpc': '2.0',
        'method': method,
        'params': [params]
      }
    };
  }

  Future<dynamic> send(String method, String params) async {
    var middleware = this.getMiddleware(method);
    var reqMiddleware = this.composeMiddleware(middleware.first);
    var resMiddleware = this.composeMiddleware(middleware.last);
    var req = reqMiddleware(this.buildPayload(method, params));
    return this.performRPC(req, resMiddleware);
  }

  dynamic composeMiddleware(Iterable<dynamic> middwareList) {
    if (middwareList.length == 0) {
      return (dynamic arg) => arg;
    }

    if (middwareList.length == 1) {
      return middwareList.first;
    }

    if (middwareList.length > 1) {
      return List.from(middwareList)
          .reduce((a, b) => (dynamic any) => a(b(any)));
    }
  }

  Future<dynamic> performRPC(dynamic request, dynamic handler) async {
    var response = await this
        .client
        .post(this.url,
            headers: this.headers, body: json.encode(request['payload']))
        .whenComplete(client.close);
    Map<String, dynamic> body = json.decode(response.body);
    // response.statusCode;
    if (response.statusCode >= 400) throw Future.error('connection error');
    var newMapEntry = MapEntry('req', response.request);
    body.addEntries([newMapEntry]);
    return handler(body);
  }
}
