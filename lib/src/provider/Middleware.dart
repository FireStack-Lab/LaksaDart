import 'net.dart';
import 'dart:convert';

class ErrorMiddleware implements RPCError<dynamic> {
  RPCErrorCode code;
  String message;
  dynamic data;
  Map raw;

  Map get toMap => {
        'code': this.code.toString(),
        'data': this.data,
        'message': this.message
      };

  ErrorMiddleware(Map error) {
    this.code = new RPCErrorCode(error['code']);
    this.data = error['data'];
    this.message = error['message'];
    this.raw = error;
  }

  @override
  toString() {
    return json.encode(this.toMap);
  }
}

class SuccessMiddleware {
  String resultString;
  Map<String, dynamic> resultMap;
  List<dynamic> resultList;
  dynamic raw;
  SuccessMiddleware(dynamic data) {
    if (data is String) {
      this.resultString = data;
    } else if (data is Map) {
      this.resultMap = Map.from(data);
    } else if (data is List) {
      this.resultList = List.from(data);
    }
    this.raw = data;
  }

  @override
  String toString() {
    return resultString != null
        ? resultString.toString()
        : resultMap != null
            ? resultMap.toString()
            : resultList != null
                ? resultList.toString()
                : raw != null ? raw.toString() : raw;
  }

  Map toMap() {
    return resultMap;
  }

  List toList() {
    return resultList;
  }
}

class RPCMiddleWare
    implements RPCResponseBody<SuccessMiddleware, ErrorMiddleware> {
  final jsonrpc = '2.0';
  final id = '1';
  SuccessMiddleware result;
  ErrorMiddleware error;
  RPCResponseBody body;
  var req;

  RPCMiddleWare.success(dynamic resultData) {
    result = new SuccessMiddleware(resultData);
  }
  RPCMiddleWare.error(dynamic errorData) {
    error = new ErrorMiddleware(errorData);
  }
  RPCMiddleWare(Map data) {
    if (data['result'] != null) {
      this.result = RPCMiddleWare.success(data['result']).result;
    }
    if (data['error'] != null) {
      this.error = RPCMiddleWare.error(data['error']).error;
    }
    if (data['req'] != null) {
      this.req = data['req'];
    }
  }

  // @override
  // toString() =>
  //     this.result != null ? this.result.toString() : this.error.toString();

  Map get raw => {
        'jsonrpc': jsonrpc,
        'id': id,
        'result': result == null ? null : result.raw,
        'error': error == null ? null : error.raw,
        'req': req
      };
}
