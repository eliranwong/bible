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

getSubList() {
  List list1 = [1, 2, 3, 4, 5, 6, 7];
  
  // take away the beginning item
  // python3-equivalent: list1[1:]
  List list2 = list1.sublist(1);
  print(list2);
  
  // take away the last item
  // python3-equivalent: list1[:-1]
  List list3 = list1.sublist(0, (list1.length -1));
  print(list3);
  
  // take away both ends
  // python3-equivalent: list1[1:-1]
  List list4 = list1.sublist(1, 6);
  print(list4);
}

// regex helper 1
replacement(String pattern) => (Match match) => pattern.replaceAllMapped(new RegExp(r'\\(\d+)'), (m) => match[int.parse(m[1])]);

// regex helper 2
replaceAllSmart(String source, Pattern pattern, String replacementPattern) => source.replaceAllMapped(pattern, replacement(replacementPattern));

testRegularExpression() {
  String aString = "Testing! Testing!\nTesting! I am testing regular expression. 我們很好！";
  
  // without regular expressions
  print(aString.replaceAll("t", "Z"));
  print(aString.replaceAll("們", "地"));
  print(aString.replaceAll("\n", " "));
  print(aString);
  
  // with regular expressions
  // info on RegExp: https://api.dart.dev/stable/2.4.1/dart-core/RegExp-class.html
  print(aString.replaceAll(RegExp("[eat]"), "Z"));
  print(aString.replaceAll(RegExp("^Test"), "Z"));
  print(aString.replaceAll(RegExp("^Test", multiLine: true), "Z"));
  print(aString.replaceAll(RegExp("^Test.*g"), "Z"));
  print(aString.replaceAll(RegExp("^Test.*?g"), "Z"));
  print(aString.replaceAll(RegExp(r"(Testing).*?\1"), "TTT"));

  // Note: the "replace" string in "replaceAll" method is not interpreted
  // read https://api.dartlang.org/stable/2.4.1/dart-core/String/replaceAll.html for more information
  // Due to the uninterpreted "replace" string, the line below doesn't work:
  // print(aString.replaceAll(RegExp(r"(Testing).*?\1"), "$1"));
  // Use the following line, with command "replaceAllMapped" instead of "replaceAll"
  // read https://github.com/dart-lang/sdk/issues/2336 for more information
  print(aString.replaceAllMapped(RegExp(r"(Testing).*?\1"), (match) => "Replaced with ${match[1]} ONLY"));

  // with functions "replacement" & "replaceAllSmart" in place
  print(replaceAllSmart(aString, RegExp(r"(Testing).*?\1"), r"Replaced with \1 ONLY"));
  print(replaceAllSmart(aString, RegExp(r"(T).*?(t).*?(g)"), r"\1\2\3"));
  print(replaceAllSmart(aString, RegExp(r"(T).*?(s).*?(i).*?(g).*?(r).*?(e).*?(g).*?(u).*?(l).*?(a).*?(r)"), r"\11"));

  // other usage with "replaceAllMapped" method:
  print(aString.replaceAllMapped(RegExp(r"([a-z])"), (match) => "${match[1].toUpperCase()}"));
  
  // use of "allMatches"
  for (var match in RegExp(r"(T).*?(t).*?(g)").allMatches(aString)) {
    print([match.group(0), match.group(1), match.group(2), match.group(3)]);
  }

  // difference between "allMatches" & "replaceAllMapped"
  // "allMatches": https://api.dartlang.org/stable/1.10.1/dart-core/String/allMatches.html
  // "allMatches" is helpful for finding matches; helpful for further processing of the matches; no replacement done on the original string
  // "replaceAllMapped": https://api.dartlang.org/stable/1.10.1/dart-core/String/replaceAllMapped.html
  // "replaceAllMapped" replaces all mapped items

  // use of "hasMatch"
  String aString2 = "ABDJKLSDFHeakjsdhfljhaflh";
  print(aString2);
  var search = RegExp("[A-Z][a-z]");
  while (search.hasMatch(aString2)) {
    aString2 = aString2.replaceAll(search, "z");
  }
  print(aString2);

}

moreStringExamples() {
  print("I am hungry.".split(" "));
  print("Ieamehungry.".split("e"));
  print(["I", "am", "hungry."].join());
  print(["I", "am", "hungry."].join(" "));
  
  //splitMapJoin: https://api.dartlang.org/stable/1.10.1/dart-core/String/splitMapJoin.html
  print('Eats shoots leaves'.splitMapJoin(RegExp(r'shoots'), onMatch: (m) => '${m.group(0)}', onNonMatch: (n) => '*'));
  print("Ieamehungry.".splitMapJoin("e", onMatch: (m) => " ", onNonMatch: (n) => "$n"));
  
  String aString = "  tesing  ";
  print(aString.trim());
  print(aString.trimLeft());
  print(aString.trimRight());
  print(aString.substring(3));
  print(aString.substring(3, 7));
  
  print("Both single quotation mark ' and double quotation mark ${'"'} in a single string");
}
