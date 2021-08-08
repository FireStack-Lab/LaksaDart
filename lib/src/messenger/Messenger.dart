import 'dart:async';
import 'package:laksadart/src/provider/Http.dart';
import 'package:laksadart/src/provider/net.dart';
import 'package:laksadart/src/provider/Middleware.dart';

class Messenger {
  HttpProvider? nodeProvider;
  HttpProvider? scillaProvider;
  String? _networkID;

  String? get nodeUrl => this.nodeProvider!.url;
  String? get scillaUrl => this.scillaProvider!.url;
  void set networkID(String? networkID) => this._networkID = networkID;
  String? get networkID => this._networkID;

  Function middleware = (data) => new RPCMiddleWare(data);
  String? middlewareApply = '*';

  Messenger(
      {HttpProvider? nodeProvider,
      HttpProvider? scillaProvider,
      String? networkID}) {
    this.nodeProvider = nodeProvider is HttpProvider ? nodeProvider : null;
    this.scillaProvider =
        scillaProvider is HttpProvider ? scillaProvider : this.nodeProvider;
    this._networkID = networkID;
  }
  void setNodeProvider(HttpProvider provider) {
    this.nodeProvider = provider;
  }

  void setScillaProvider(HttpProvider provider) {
    this.scillaProvider = provider;
  }

  void setMiddleware(Function middware, {String? match}) {
    this.middleware = middware;
    this.middlewareApply = match;
  }

  void useMiddleware(Function middleware, {String? match}) {
    this.nodeProvider!.middleware.response.use(middleware, match: match);
  }

  Future<RPCMiddleWare> send(String method, [dynamic params]) async {
    // use middleware

    var methodMap = new RPCMethod().Mapping;
    if (methodMap[method] == null) {
      throw '${method} is not found in RPCMethod list';
    } else {
      return await this.nodeProvider!.send(method, params);
    }
  }

  Future<RPCMiddleWare> sendServer(String endpoint, [dynamic params]) async {
    // use middleware

    var methodMap = new Endpoint().Mapping;
    if (methodMap[endpoint] == null) {
      throw '${endpoint} is not found in Endpoint list';
    } else {
      return await this.scillaProvider!.sendServer(endpoint, params);
    }
  }
}
