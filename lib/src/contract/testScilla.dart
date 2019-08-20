import 'dart:async';
import 'dart:convert';
import 'package:laksadart/src/messenger/Messenger.dart';
import 'package:laksadart/src/transaction/transaction.dart';
import 'package:laksadart/src/provider/Middleware.dart';
import 'package:laksadart/src/provider/net.dart';
import 'util.dart';
import 'abi.dart';

import 'contract.dart';

class TestScilla extends Contract {
  String code = '';
  List<Map> init;
  String ContractAddress;
  int version;
  Messenger messenger;
  ContractStatus status;
  Transaction transaction;
  List<Map> blockchain = [];
  ABI abi;

  TestScilla({Map params, Messenger messenger, ContractStatus status})
      : super(params: params, messenger: messenger, status: status) {
    this.code = params['code'] ?? '';
    this.init = params['init'] ?? [];
    this.version = params['version'] ?? 0;
    this.ContractAddress = params['ContractAddress'] ?? '';
    this.status = status;
    this.messenger = messenger;
    this.transaction = null;
  }

  Future<TestScilla> testCall(gasLimit) async {
    try {
      Map<String, dynamic> callContractJson = {
        'code': this.code,
        'init': json.encode(this.init),
        'blockchain': json.encode(this.blockchain),
        'gaslimit': gasLimit.toString()
      };

      /// the endpoint for sendServer has been set to scillaProvider
      RPCMiddleWare res = await this
          .messenger
          .sendServer(Endpoint.ScillaCall, callContractJson);

      if (res.result.toString() != 'error') {
        this.setStatus(ContractStatus.TESTED);
      } else {
        this.setStatus(ContractStatus.ERROR);
      }
      return this;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getABI({String code}) async {
    /// the endpoint for sendServer has been set to scillaProvider
    try {
      RPCMiddleWare res =
          await this.messenger.sendServer(Endpoint.ScillaCheck, {'code': code});

      if (res.result.toString() != 'error' && res.message != null) {
        var decoded = json.decode(res.message);
        return decoded['contract_info'];
      } else
        throw res.message;
    } catch (error) {
      rethrow;
    }
  }

  get testPayload => this.getTestPayload();

  Map getTestPayload() {
    var payload = this.deployDayload;
    var newList = List.from(this.init);
    newList.addAll(this.blockchain);
    var newMap = {
      'code': this.code,
      'data': json.encode(newList).replaceAll(new RegExp(r'\\'), '')
    };
    payload.addAll(newMap);
    return payload;
  }

  Future<TestScilla> decodeABI({String code}) async {
    try {
      this.setCode(code);
      var abiObj = await this.getABI(code: code);
      this.setABI(abiObj);
      return this;
    } catch (error) {
      rethrow;
    }
  }

  Future<TestScilla> setBlockNumber(int number) async {
    try {
      if (number != null) {
        this.setBlockchain(number.toString());
        this.setCreationBlock(number.toString());
        return this;
      } else if (number == null) {
        var res = await this.messenger.send(RPCMethod.GetLatestTxBlock);
        if (res.result != null) {
          this.setBlockchain(res.result.toMap()['header']['BlockNum']);
          this.setCreationBlock(res.result.toMap()['header']['BlockNum']);
          return this;
        } else
          return this;
      } else
        return this;
    } catch (error) {
      rethrow;
    }
  }

  TestScilla setABI(Map abi) {
    this.abi = new ABI(abi);
    return this;
  }

  TestScilla setCode(String code) {
    this.code = code ?? '';
    return this;
  }

  TestScilla setInitParamsValues(
      List<Map> initParams, List<Map> arrayOfValues) {
    this.init = setParamValues(initParams, arrayOfValues);
    return this;
  }

  TestScilla setCreationBlock(String blockNumber) {
    var result = setParamValues([
      {'vname': '_creation_block', 'type': 'BNum'}
    ], [
      {
        'vname': '_creation_block',
        'type': 'BNum',
        'value': BigInt.from(int.parse(blockNumber)).toString()
      }
    ]);
    var block = result[0];
    List newList = List.from(this.init);
    newList.add(block);
    this.init = List.from(newList);
    return this;
  }

  TestScilla setBlockchain(String blockNumber) {
    var result = setParamValues([
      {'vname': 'BLOCKNUMBER', 'type': 'BNum'}
    ], [
      {
        'vname': 'BLOCKNUMBER',
        'type': 'BNum',
        'value': BigInt.from(int.parse(blockNumber)).toString()
      }
    ]);
    var block = result[0];
    List newList = List.from(this.blockchain);
    newList.add(block);
    this.blockchain = List.from(newList);
    return this;
  }
}
