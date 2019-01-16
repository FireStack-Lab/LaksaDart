import 'package:laksaDart/src/provider/Http.dart';
import 'package:laksaDart/src/provider/net.dart';
import 'package:laksaDart/src/provider/Middleware.dart';
import 'package:laksaDart/src/core/ZilliqaConfig.dart';
import 'package:laksaDart/src/utils/numbers.dart' as numbers;

class Messenger {
  HttpProvider nodeProvider;
  HttpProvider scillaProvider;
  ZilliqaConfig config;

  String get nodeUrl => this.nodeProvider.url;
  String get scillaUrl => this.scillaProvider.url;

  Function middleware = (data) => new RPCMiddleWare(data);
  String middlewareApply = '*';

  Messenger(
      {HttpProvider nodeProvider,
      HttpProvider scillaProvider,
      ZilliqaConfig config}) {
    this.nodeProvider = nodeProvider is HttpProvider ? nodeProvider : null;
    this.scillaProvider =
        scillaProvider is HttpProvider ? scillaProvider : this.nodeProvider;
    this.config = config;
  }
  void setNodeProvider(HttpProvider provider) {
    this.nodeProvider = provider;
  }

  void setScillaProvider(HttpProvider provider) {
    this.scillaProvider = provider;
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

  Future<RPCMiddleWare> sendServer(String endpoint, [dynamic params]) async {
    // use middleware

    var methodMap = new Endpoint().Mapping;
    if (methodMap[endpoint] == null) {
      throw '$endpoint' + 'is not found in Endpoint list';
    } else {
      return await this.scillaProvider.sendServer(endpoint, params);
    }
  }

  int setTransactionVersion(int version) {
    var CHAIN_ID = 1;
    if (this.nodeProvider.url == this.config.Default.nodeProviderUrl) {
      CHAIN_ID = this.config.Default.CHAIN_ID;
    } else if (this.nodeProvider.url == this.config.Staging.nodeProviderUrl) {
      CHAIN_ID = this.config.Staging.CHAIN_ID;
    } else if (this.nodeProvider.url == this.config.TestNet.nodeProviderUrl) {
      CHAIN_ID = this.config.TestNet.CHAIN_ID;
    } else if (this.nodeProvider.url == this.config.MainNet.nodeProviderUrl) {
      CHAIN_ID = this.config.MainNet.CHAIN_ID;
    }
    return numbers.pack(CHAIN_ID, version);
  }
}
