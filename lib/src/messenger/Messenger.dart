import 'dart:async';
import 'package:laksadart/src/provider/Http.dart';
import 'package:laksadart/src/provider/net.dart';
import 'package:laksadart/src/provider/Middleware.dart';
import 'package:laksadart/src/core/ZilliqaConfig.dart';
import 'package:laksadart/src/utils/numbers.dart' as numbers;

class Messenger {
  HttpProvider? nodeProvider;
  HttpProvider? scillaProvider;
  late ZilliqaConfig config;
  String? Network_ID;

  String? get nodeUrl => this.nodeProvider!.url;
  String? get scillaUrl => this.scillaProvider!.url;

  Function middleware = (data) => new RPCMiddleWare(data);
  String? middlewareApply = '*';

  Messenger(
      {HttpProvider? nodeProvider,
      HttpProvider? scillaProvider,
      required ZilliqaConfig config}) {
    this.nodeProvider = nodeProvider is HttpProvider ? nodeProvider : null;
    this.scillaProvider =
        scillaProvider is HttpProvider ? scillaProvider : this.nodeProvider;
    this.config = config;
    this.Network_ID = config.Default!.Network_ID;
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
      throw '$method' + 'is not found in RPCMethod list';
    } else {
      return await this.nodeProvider!.send(method, params);
    }
  }

  Future<RPCMiddleWare> sendServer(String endpoint, [dynamic params]) async {
    // use middleware

    var methodMap = new Endpoint().Mapping;
    if (methodMap[endpoint] == null) {
      throw '$endpoint' + 'is not found in Endpoint list';
    } else {
      return await this.scillaProvider!.sendServer(endpoint, params);
    }
  }

  int setTransactionVersion(int version, String? networkId) {
    int? CHAIN_ID = 1;
    if (networkId == this.config.Default!.Network_ID) {
      CHAIN_ID = this.config.Default!.CHAIN_ID;
      this.setNetworkID(networkId);
    } else if (networkId == this.config.Staging!.Network_ID) {
      CHAIN_ID = this.config.Staging!.CHAIN_ID;
      this.setNetworkID(networkId);
    } else if (networkId == this.config.TestNet!.Network_ID) {
      CHAIN_ID = this.config.TestNet!.CHAIN_ID;
      this.setNetworkID(networkId);
    } else if (networkId == this.config.MainNet!.Network_ID) {
      CHAIN_ID = this.config.MainNet!.CHAIN_ID;
      this.setNetworkID(networkId);
    } else if (networkId == this.config.DevNet!.Network_ID) {
      CHAIN_ID = this.config.DevNet!.CHAIN_ID;
      this.setNetworkID(networkId);
    }
    return numbers.pack(CHAIN_ID!, version);
  }

  void setNetworkID(String? id) {
    this.Network_ID = id;
  }
}
