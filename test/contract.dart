@TestOn("vm")

import 'dart:convert';
import 'dart:io';
import "package:test/test.dart";
import "package:laksadart/src/contract/factory.dart";
import 'package:laksadart/src/contract/abi.dart';
import 'package:laksadart/src/laksa.dart';

void main() {
  test("Test Get Contract ABIs", () async {
    File contract = new File('test/contracts/helloworldversion.txt');
    await contract.readAsString().then((contractString) async {
      Laksa laksa = new Laksa(
          nodeUrl: 'https://dev-api.zilliqa.com',
          scillaUrl: 'https://scilla-runner.zilliqa.com');

      var result = await laksa.blockchain.checkCode(code: contractString);

      if (result.result.toString() != 'error' && result.message != null) {
        var abi = json.decode(result.message)['contract_info'];
        var abiObject = new ABI(abi);
        expect(abiObject.vname, equals('HelloWorld'));
        expect(abiObject.params.toString(),
            equals('[{vname: owner, type: ByStr20}]'));
        expect(abiObject.fields.toString(),
            equals('[{vname: welcome_msg, type: String}]'));
        expect(
            abiObject.transitions.toString(),
            equals(
                '[{vname: setHello, params: [{vname: msg, type: String}]}, {vname: getHello, params: []}]'));
        expect(
            abiObject.events.toString(),
            equals(
                '[{vname: getHello(), params: [{vname: msg, type: String}]}, {vname: setHello(), params: [{vname: code, type: Int32}]}]'));
      }
    });
  });
  test('Test call to scilla-runner', () async {
    File contract = new File('test/contracts/helloworldversion.txt');
    await contract.readAsString().then((contractString) async {
      Laksa laksa = new Laksa(
          nodeUrl: 'https://dev-api.zilliqa.com',
          scillaUrl: 'https://scilla-runner.zilliqa.com');
      // laksa.setScillaProvider('https://scilla-runner.zilliqa.com');
      var init = [
        {'vname': "_scilla_version", 'type': "Uint32", 'value': "0"},
        {
          'value': '0x9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a',
          'vname': 'owner',
          'type': 'ByStr20'
        }
      ];
      var contracts =
          new Contracts(messenger: laksa.messenger, wallet: laksa.wallet);
      var testResult =
          await contracts.testContract(code: contractString, init: init);

      expect(testResult, equals(true));
    });
  });
  // test("Test deploy", () async {
  //   File contract = new File('./contracts/helloworld.txt');
  //   await contract.readAsString().then((contractString) async {
  //     Laksa laksa = new Laksa(nodeUrl: 'https://api.zilliqa.com');
  //     // laksa.setScillaProvider('https://scilla-runner.zilliqa.com');
  //     var init = [
  //       {
  //         'value': '0x9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a',
  //         'vname': 'owner',
  //         'type': 'ByStr20'
  //       }
  //     ];

  //     laksa.wallet.add(
  //         'e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');

  //     var newContract = new Contract(
  //         params: {'code': contractString, 'init': init},
  //         messenger: laksa.messenger,
  //         wallet: laksa.wallet);

  //     var deployed = await newContract.deploy(
  //         gasLimit: 2500000000, gasPrice: BigInt.from(1000000000));
  //     print(deployed.ContractAddress);
  //   });
  // });
}
