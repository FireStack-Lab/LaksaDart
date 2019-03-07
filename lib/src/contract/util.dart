enum ContractStatus {
  INITIALISED,
  TESTED,
  ERROR,
  SIGNED,
  SENT,
  REJECTED,
  DEPLOYED
}

List<Map> setParamValues(List<Map> rawParams, List<Map> newValues) {
  List<Map> newParams = [];

  for (int i = 0; i < rawParams.length; i += 1) {
    var v = rawParams[i];
    var newMap = {
      'value': newValues[i]['value'],
      'vname': v['name'] ?? v['vname']
    };
    Map newObj = Map.from(v);
    newObj.addAll(newMap);
    if (newObj['name'] != null) {
      newObj.remove('name');
    }
    newParams.add(newObj);
  }

  return newParams;
}
