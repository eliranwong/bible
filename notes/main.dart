import 'package:cli/cli.dart' as cli;

main(List<String> arguments) {
  // try command "bin/main.dart testing arguments"
  print(arguments);
}

useFunctionsInLibFolder() {
  print('Hello world: ${cli.calculate()}!');
}

sortList() {
  List list1 = <int>[4, 5, 3, 1, 9, 2];
  
  // python3-equivalent: list1.sort()
  list1.sort();
  print(list1);
  
  // python3-equivalent: list2 = sorted(list1)
  List list2 = list1..sort();
  print(list2);
  
  List list3 = <String>["aaa", "a", "aa"];
  
  // python3-equivalent: list3.sort(key=len)
  list3.sort((a, b) => a.length.compareTo(b.length));
  print(list3);
  
  // python3-equivalent: list3.sort(key=len, reverse=True)
  list3.sort((a, b) => b.length.compareTo(a.length));
  print(list3);
}

transformAList() {
  List aStringList = <String>["a", "b", "c"];
  
  // python3-equivalent: aStringList = [s.upper() for s in aStringList]
  aStringList = aStringList.map((s) => s.toUpperCase()).toList();
  print(aStringList);
}
