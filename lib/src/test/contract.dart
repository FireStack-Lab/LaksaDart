@TestOn("vm")

import 'dart:convert';
import 'dart:io';
import "package:test/test.dart";
import "package:laksaDart/src/contract/contract.dart";
import "package:laksaDart/src/contract/testScilla.dart";
import "package:laksaDart/src/contract/util.dart";
import 'package:laksaDart/src/contract/abi.dart';
import 'package:laksaDart/src/laksa.dart';

void main() {
  test("Test Get Contract ABIs", () async {
    File contract = new File('./contracts/helloworld.txt');
    await contract.readAsString().then((contractString) async {
      Laksa laksa = new Laksa(
          nodeUrl: 'https://api.zilliqa.com',
          scillaUrl: 'https://scilla-runner.zilliqa.com');

      var result = await laksa.blockchain.checkCode(code: contractString);
      // var result = await laksa.messenger
      //     .sendServer('/contract/check', {'code': contractString});

      if (result.result != 'error' && result.message != null) {
        var abiObject = new ABI(json.decode(result.message));
        expect(abiObject.name, equals('HelloWorld'));
        expect(abiObject.params.toString(),
            equals('[{name: owner, type: ByStr20}]'));
        expect(abiObject.fields.toString(),
            equals('[{name: welcome_msg, type: String}]'));
        expect(
            abiObject.transitions.toString(),
            equals(
                '[{name: setHello, params: [{name: msg, type: String}]}, {name: getHello, params: []}]'));
        expect(abiObject.events.toString(), equals('[]'));
      }
    });
  });
  test('Test call to scilla-runner', () async {
    File contract = new File('./contracts/helloworld.txt');
    await contract.readAsString().then((contractString) async {
      Laksa laksa = new Laksa(
          nodeUrl: 'https://api.zilliqa.com',
          scillaUrl: 'https://scilla-runner.zilliqa.com');
      // laksa.setScillaProvider('https://scilla-runner.zilliqa.com');
      var init = [
        {
          'value': '0x9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a',
          'vname': 'owner',
          'type': 'ByStr20'
        }
      ];

      var newContract = new TestScilla(
          params: {'code': contractString, 'init': init},
          messenger: laksa.messenger);

      Map result = await newContract
          // decode ABI from code first
          .decodeABI(code: contractString)
          // we set the init params to decoded ABI
          .then((decoded) =>
              decoded.setInitParamsValues(decoded.abi.getInitParams(), init))
          // we get the current block number from node, and set it to params
          .then((inited) => inited.setBlockNumber(null))
          // but we have to give it a test
          .then((ready) => ready.testCall(2000))
          // now we change the status to wait for sign
          .then((state) => state.status == ContractStatus.TESTED
              ? {'abi': state.abi, 'init': state.init, 'status': state.status}
              : false);

      expect(result['status'], equals(ContractStatus.TESTED));
    });
  });
  // test("Test deploy", () async {
  //   File contract = new File('./contracts/helloworld.txt');
  //   await contract.readAsString().then((contractString) async {
  //     Laksa laksa = new Laksa('https://api.zilliqa.com');
  //     // laksa.setScillaProvider('https://scilla-runner.zilliqa.com');
  //     var init = [
  //       {
  //         'value': '0x9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a',
  //         'vname': 'owner',
  //         'type': 'ByStr20'
  //       }
  //     ];

  //     var newContract = new Contract(
  //         params: {'code': contractString, 'init': init},
  //         messenger: laksa.messenger);
  //     // gasLimit: laksa.util.Long.fromNumber(25000000),
  //     //       gasPrice: new laksa.util.BN(1000000000),
  //     //       account: accountA
  //     var acc = laksa.wallet.add(
  //         'e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');
  //     var deployed = await newContract.deploy(
  //         gasLimit: 25000000, gasPrice: BigInt.from(1000000000), account: acc);
  //     print(deployed.ContractAddress);
  //   });
  // });
}
