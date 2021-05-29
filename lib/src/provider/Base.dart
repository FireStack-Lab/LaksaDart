enum MiddlewareType { REQ, RES }

class UseMiddleware {
  late dynamic use;
}

class Middleware {
  UseMiddleware request = new UseMiddleware();
  UseMiddleware response = new UseMiddleware();
}

abstract class ReqMiddleware<I> {
  I? reqMiddleware;
}

abstract class ResMiddleware<O> {
  O? resMiddleware;
}

typedef Transformer<I, O> = O Function(I payload);

abstract class MiddlewarePair<R, S> {}

class BaseProvider
    implements
        ReqMiddleware<Map<dynamic, List<Transformer>>>,
        ResMiddleware<Map<dynamic, List<Transformer>>> {
  String? url;
  Map<dynamic, List<Transformer>>? reqMiddleware;
  Map<dynamic, List<Transformer>>? resMiddleware;

  Middleware middleware = new Middleware();

  BaseProvider(Map? reqMiddleware, Map? resMiddleware) {
    this.reqMiddleware = reqMiddleware is Map ? reqMiddleware as Map<dynamic, List<dynamic Function(dynamic)>>? : {'*': []};
    this.resMiddleware = resMiddleware is Map ? resMiddleware as Map<dynamic, List<dynamic Function(dynamic)>>? : {'*': []};
    this.middleware.request.use = (Transformer fn, {String match = '*'}) =>
        this._pushMiddleware(fn, MiddlewareType.REQ, match);
    this.middleware.response.use = (Transformer fn, {String match = '*'}) =>
        this._pushMiddleware(fn, MiddlewareType.RES, match);
  }

  void _pushMiddleware(Transformer fn, MiddlewareType type, String match) {
    if (type == MiddlewareType.REQ && type == MiddlewareType.RES) {
      throw 'Please specify the type of middleware being added';
    }

    if (type == MiddlewareType.REQ) {
      var current = this.reqMiddleware![match] ?? [];
      List<Transformer> matchers = List.from(current);
      matchers.add(fn);
      this
          .reqMiddleware!
          .update(match, (found) => matchers, ifAbsent: () => matchers);
    } else {
      var current = this.resMiddleware![match] ?? [];
      List<Transformer> matchers = List.from(current);
      matchers.add(fn);
      this
          .resMiddleware!
          .update(match, (found) => matchers, ifAbsent: () => matchers);
    }
  }

  List<List<Transformer>> getMiddleware(String? method) {
    List<Transformer> reqFns = [];
    List<Transformer> resFns = [];

    for (var ent in this.reqMiddleware!.entries) {
      var key = ent.key;
      var transformers = ent.value;
      if (key is String && key != '*' && key == method) {
        reqFns.addAll(transformers);
      }

      if (key is RegExp && key.hasMatch(method!)) {
        reqFns.addAll(transformers);
      }

      if (key == '*') {
        reqFns.addAll(transformers);
      }
    }

    for (var ent in this.resMiddleware!.entries) {
      var key = ent.key;
      var transformers = ent.value;
      if (key is String && key != '*' && key == method) {
        resFns.addAll(transformers);
      }

      if (key is RegExp && key.hasMatch(method!)) {
        resFns.addAll(transformers);
      }

      if (key == '*') {
        resFns.addAll(transformers);
      }
    }

    return [reqFns, resFns];
  }
}
