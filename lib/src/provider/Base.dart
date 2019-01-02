final Map<String, String> MiddlewareType = {'REQ': 'REQ', 'RES': 'RES'};

class UseMiddleware {
  dynamic use;
}

class Middleware {
  UseMiddleware request = new UseMiddleware();
  UseMiddleware response = new UseMiddleware();
}

class BaseProvider {
  String url;
  Map reqMiddleware;
  Map resMiddleware;

  Middleware middleware = new Middleware();

  BaseProvider(Map reqMiddleware, Map resMiddleware) {
    this.reqMiddleware = reqMiddleware is Map ? reqMiddleware : {'*': []};
    this.resMiddleware = resMiddleware is Map ? resMiddleware : {'*': []};
    this.middleware.request.use = (Function fn, {String match: '*'}) =>
        this._pushMiddleware(fn, MiddlewareType['REQ'], match);
    this.middleware.response.use = (Function fn, {String match: '*'}) =>
        this._pushMiddleware(fn, MiddlewareType['RES'], match);
  }

  void _pushMiddleware(Function fn, String type, String match) {
    if (type == MiddlewareType['REQ'] && type == MiddlewareType['RES']) {
      throw 'Please specify the type of middleware being added';
    }

    if (type == MiddlewareType['REQ']) {
      var current =
          this.reqMiddleware[match] != null ? this.reqMiddleware[match] : [];
      var matchers = List.from(current);
      matchers.add(fn);
      this
          .reqMiddleware
          .update(match, (found) => matchers, ifAbsent: () => matchers);
    } else {
      var current =
          this.resMiddleware[match] != null ? this.resMiddleware[match] : [];
      var matchers = List.from(current);
      matchers.add(fn);
      this
          .resMiddleware
          .update(match, (found) => matchers, ifAbsent: () => matchers);
    }
  }

  List<List<dynamic>> getMiddleware(method) {
    var reqFns = [];
    var resFns = [];

    for (var ent in this.reqMiddleware.entries) {
      var key = ent.key;
      var transformers = ent.value;
      if (key is String && key != '*' && key == method) {
        reqFns.addAll(transformers);
      }

      if (key is RegExp && key.hasMatch(method)) {
        reqFns.addAll(transformers);
      }

      if (key == '*') {
        reqFns.addAll(transformers);
      }
    }

    for (var ent in this.resMiddleware.entries) {
      var key = ent.key;
      var transformers = ent.value;
      if (key is String && key != '*' && key == method) {
        resFns.addAll(transformers);
      }

      if (key is RegExp && key.hasMatch(method)) {
        resFns.addAll(transformers);
      }

      if (key == '*') {
        resFns.addAll(transformers);
      }
    }

    return [reqFns, resFns];
  }
}
