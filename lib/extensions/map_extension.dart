//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-28 09:33:02
//
extension MapExtension on Map{
  bool containsMap(Map<String,dynamic> dic){
    for(dynamic key in keys){
      if(dic[key] != this[key]){
        return false;
      }
    }
    return true;
  }
}
