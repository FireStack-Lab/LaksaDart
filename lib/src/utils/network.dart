//https://dev.zilliqa.com/docs/apis/api-introduction/
import 'package:laksadart/src/data/network/network_info.dart';

class Network {
  static late NetworkInfo current;
}

var zilliqaNetworks = {
  "mainnet": NetworkInfo(
      chainID: 1,
      networkID: "Zilliqa Mainnet",
      nodeProviderUrl: "https://api.zilliqa.com/",
      blockExplorerUrl: "https://viewblock.io/zilliqa",
      blockExplorerNetwork: "mainnet"),
  "dev": NetworkInfo(
      chainID: 333,
      networkID: "Developer Testnet",
      nodeProviderUrl: "https://dev-api.zilliqa.com/",
      blockExplorerUrl: "https://viewblock.io/zilliqa?network=testnet",
      blockExplorerNetwork: "testnet"),
  "local": NetworkInfo(
      chainID: 2,
      networkID: "Local Testnet",
      nodeProviderUrl: "http://localhost:4201/"),
  "isolated": NetworkInfo(
      chainID: 63,
      networkID: "Isolated Server",
      nodeProviderUrl: "https://zilliqa-isolated-server.zilliqa.com/"),
};
