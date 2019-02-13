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
  /**
   * @function {testCall}
   * @param  {Int} gasLimit {gasLimit for test call to scilla-runner}
   * @return {Contract} {raw Contract object}
   */
  Future<TestScilla> testCall(gasLimit) async {
    try {
      Map<String, dynamic> callContractJson = {
        'code': this.code,
        'init': json.encode(this.init),
        'blockchain': json.encode(this.blockchain),
        'gaslimit': gasLimit.toString()
      };
      // the endpoint for sendServer has been set to scillaProvider
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
    // the endpoint for sendServer has been set to scillaProvider
    try {
      RPCMiddleWare res =
          await this.messenger.sendServer(Endpoint.ScillaCheck, {'code': code});
      if (res.result.toString() != 'error' && res.message != null) {
        return json.decode(res.message);
      } else
        throw res.message;
    } catch (error) {
      rethrow;
    }
  }

  get testPayload => this.getTestPayload();
  /**
   * @function {generateNewContractJson}
   * @return {Contract} {raw contract with code and init params}
   */
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

  /**
   * @function {decodeABI}
   * @param  {string} { code {scilla code string}
   * @return {Contract} {raw contract}
   */

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

  /**
   * @function {setBlockNumber}
   * @param  {Int} number {block number setted to blockchain}
   * @return {Contract|false} {raw contract}
   */
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

  /**
   * @function {setABIe}
   * @param  {ABI} abi {ABI object}
   * @return {Contract} {raw contract}
   */
  TestScilla setABI(Map abi) {
    this.abi = new ABI(abi);
    return this;
  }

  /**
   * @function {setCode}
   * @param  {string} code {scilla code string}
   * @return {Contract} {raw contract with code}
   */
  TestScilla setCode(String code) {
    this.code = code ?? '';
    return this;
  }

  /**
   * @function {setInitParamsValues}
   * @param  {Array<Object>} initParams    {init params get from ABI}
   * @param  {Array<Object>} arrayOfValues {init params set for ABI}
   * @return {Contract} {raw contract object}
   */
  TestScilla setInitParamsValues(
      List<Map> initParams, List<Map> arrayOfValues) {
    this.init = setParamValues(initParams, arrayOfValues);
    return this;
  }

  /**
   * @function {setCreationBlock}
   * @param  {Int} blockNumber {block number for blockchain}
   * @return {Contract} {raw contract object}
   */
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

  /**
   * @function {setBlockchain}
   * @param  {Int} blockNumber {block number for blockchain}
   * @return {Contract} {raw contract object}
   */
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
