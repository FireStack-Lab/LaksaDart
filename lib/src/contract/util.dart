enum ContractStatus {
  INITIALISED,
  TESTED,
  ERROR,
  SIGNED,
  SENT,
  REJECTED,
  DEPLOYED
}
/**
 * @function setParamValues
 * @param  {Array<object>} rawParams {init params get from ABI}
 * @param  {Array<object>} newValues {init params set for ABI}
 * @return {Array<object>} {new array of params objects}
 */
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
