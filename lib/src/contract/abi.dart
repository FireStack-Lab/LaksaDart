import 'dart:convert';

abstract class ABIObject {
  List<Map> events;
  List<Map> fields;
  String name;
  List<Map> params;
  List<Map> transitions;
}

/*
 * ABI object is extracted from scilla contract code.
 * In Zilliqa's network, each contract code is deployed and executed through scilla-runner,
 * which runs along-side with the Full-Node.
 * For developer's side, we can use scilla-checker to check the code, parse for the ABI, 
 * and use scilla-runner try make contract call.
 * You can run a scilla runner/checker from your local machine, or make api calls remotely to [https://scilla-runner.zilliqa.com]
 * In laksa, we use remote endpont call to get ABI, however you can set scillaProvider using your own local address.
 */
class ABI implements ABIObject {
  List<Map> events;
  List<Map> fields;
  String name;
  List<Map> params;
  List<Map> transitions;

  ABI(Map<String, dynamic> Abi) {
    // because ABI is <String,dynamic>, to get the type annotation ready,
    // we need to use List.from(),which will get the correct list.
    // then we can extract the List<dynamic> type to List<Map>
    this.events = List.from(Abi['events']);
    this.fields = List.from(Abi['fields']);
    this.name = Abi['name'];
    this.params = List.from(Abi['params']);
    this.transitions = List.from(Abi['transitions']);
  }

  String getName() {
    return this.name;
  }

  List<Map> getInitParams() {
    return this.params;
  }

  List<String> getInitParamTypes() {
    if (this.params.length > 0) {
      return getParamTypes(this.params);
    } else
      return null;
  }

  List<Map<String, dynamic>> getFields() {
    return this.fields;
  }

  List<String> getFieldsTypes() {
    if (this.fields.length > 0) {
      return getParamTypes(this.fields);
    } else
      return null;
  }

  List<Map> getTransitions() {
    return this.transitions;
  }

  List<Map> getTransitionsParamTypes() {
    List returnArray = [];
    if (this.transitions.length > 0) {
      for (int i = 0; i < this.transitions.length; i += 1) {
        returnArray[i] = getParamTypes(this.transitions[i]['params']);
      }
    }
    if (returnArray.length > 0) {
      return returnArray;
    } else
      return null;
  }

  List<Map> getEvents() {
    return this.events;
  }
}

List<String> getParamTypes(List<Map> list) {
  List<String> keyList2 = [];
  var boolList = list.map<bool>((obj) {
    keyList2.addAll(obj.keys);
    return false;
  });
  if (boolList.length > 0) {
    return keyList2;
  } else
    return null;
}
