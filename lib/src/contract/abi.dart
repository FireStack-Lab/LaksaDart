abstract class ABIObject {
  List<dynamic> events;
  List<Map<String, dynamic>> fields;
  String name;
  List<dynamic> params;
  List<dynamic> transitions;
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
  List<dynamic> events;
  List<Map<String, dynamic>> fields;
  String name;
  List<dynamic> params;
  List<dynamic> transitions;

  ABI(this.events, this.fields, this.name, this.params, this.transitions);

  String getName() {
    return this.name;
  }

  List<dynamic> getInitParams() {
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

  List<dynamic> getTransitions() {
    return this.transitions;
  }

  List<dynamic> getTransitionsParamTypes() {
    List returnArray = [];
    if (this.transitions.length > 0) {
      for (int i = 0; i < this.transitions.length; i += 1) {
        returnArray[i] = getParamTypes(this.transitions[i].params);
      }
    }
    if (returnArray.length > 0) {
      return returnArray;
    } else
      return null;
  }

  List<dynamic> getEvents() {
    return this.events;
  }
}

List<String> getParamTypes(List<Map<String, dynamic>> list) {
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
