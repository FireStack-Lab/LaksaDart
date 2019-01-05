import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import 'Base.dart';
import 'net.dart';
import 'Middleware.dart';

typedef MiddleWareFn = dynamic Function(List<dynamic> list);

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

  HttpProvider(url, [req, res]) : super(req, res) {
    this.url = url;
  }

  Map<String, dynamic> buildPayload(String method, [dynamic params]) {
    return {
      'url': this.url,
      'payload': {
        'id': 1,
        'jsonrpc': '2.0',
        'method': method,
        'params': params != null ? [params] : []
      }
    };
  }

  Future<RPCMiddleWare> send(String method, [dynamic params]) async {
    List<List<Transformer>> middleware = this.getMiddleware(method);
    Transformer reqMiddleware = this.composeMiddleware(middleware.first);
    Transformer resMiddleware = this.composeMiddleware(middleware.last);
    var req = reqMiddleware(this.buildPayload(method, params));
    var url = this.url;
    var headers = this.headers;
    RPCMiddleWare result = await performRPC(url, headers, req);
    return resMiddleware(result);
  }

  dynamic composeMiddleware(List<Transformer> middwareList) {
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
}

Future<RPCMiddleWare> performRPC(
    String url, Map headers, Map<String, dynamic> request) async {
  Client client = new Client();

  var response = await client
      .post(url, headers: headers, body: json.encode(request['payload']))
      .whenComplete(client.close);

  Map<String, dynamic> body = json.decode(response.body);

  // response.statusCode;
  if (response.statusCode >= 400) throw Future.error('connection error');
  var newMapEntry = MapEntry('req', response.request);
  body.addEntries([newMapEntry]);

  return new RPCMiddleWare(body);
}
