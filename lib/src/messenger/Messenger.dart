import 'package:laksaDart/src/provider/Http.dart';
import 'package:laksaDart/src/provider/net.dart';
import 'package:laksaDart/src/provider/Middleware.dart';

class Messenger {
  HttpProvider nodeProvider;
  HttpProvider scillaProvider;

  String get nodeUrl => this.nodeProvider.url;
  String get scillaUrl => this.scillaProvider.url;

  Function middleware = (data) => new RPCMiddleWare(data);
  String middlewareApply = '*';

  Messenger({HttpProvider nodeProvider, HttpProvider scillaProvider}) {
    this.nodeProvider = nodeProvider is HttpProvider ? nodeProvider : null;
    this.scillaProvider =
        scillaProvider is HttpProvider ? scillaProvider : this.nodeProvider;
  }
  Messenger.setNodeProvider(HttpProvider provider) {
    new Messenger(nodeProvider: provider);
  }
  Messenger.setScillaProvider(HttpProvider provider) {
    new Messenger(scillaProvider: provider);
  }

  void setMiddleware(Function middware, {String match}) {
    this.middleware = middware;
    this.middlewareApply = match;
  }

  void useMiddleware(Function middleware, {String match}) {
    this.nodeProvider.middleware.response.use(middleware, match: match);
  }

  Future<RPCMiddleWare> send(String method, [dynamic params]) async {
    // use middleware

    var methodMap = new RPCMethod().Mapping;
    if (methodMap[method] == null) {
      throw '$method' + 'is not found in RPCMethod list';
    } else {
      return await this.nodeProvider.send(method, params);
    }
  }
}
