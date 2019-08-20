import 'dart:io'; // required by "fileOperations"
import 'dart:convert'; // required by "whereCollection"
import 'package:path/path.dart'; // required by "fileOperations"
import 'package:cli/cli.dart' as cli;
import 'package:cli/Bibles.dart';
import 'package:cli/BibleParser.dart';
import 'package:cli/Helpers.dart';


var bible1, bible2;

main(List<String> arguments) {
  print(arguments);

  // testing: search bible
  // try command "bin/main.dart KJV Christ Jesus" to search for verses containing "Christ Jesus"
  // try command "bin/main.dart KJV Christ.*?Jesus" to search for verses containing "Christ", followed by "Jesus" anywhere in the same verse.  
  if (arguments.isNotEmpty) searchBible(1, arguments[0], arguments.sublist(1).join(" "));
}

loadBible(int bibleID, String bibleModule) {
  //return null;
  switch (bibleID) {
    case 1:
      if ((bible1 == null) || ((bible1 != null) && (bible1.module != bibleModule))) {
        bible1 = Bible(bibleModule);
        print("bible 1 loaded");
      }
      return bible1;
      break;
    case 2:
      if ((bible2 == null) || ((bible2 != null) && (bible2.module != bibleModule))) {
        bible2 = Bible(bibleModule);
        print("bible 2 loaded");
      }
      return bible2;
      break;
  }
}

searchBible(int bibleID, String bibleModule, String searchString) {
  loadBible(bibleID, bibleModule)?.search(searchString);
}

Future fileOperations () async {
  // File: https://api.dart.dev/stable/2.4.1/dart-io/File-class.html
  // Directory: https://api.dart.dev/stable/2.4.1/dart-io/Directory-class.html
  
  var file = File("lib/test.txt");
  // get file name
  String filename = basename(file.path);
  print(filename);
  
  // check, delete
  var check;
  check = await file.exists();
  print(check);
  if (check) file.delete();
  check = await file.exists();
  print(check);
}

useFunctionsInLibFolderFile() {
  print('Hello world: ${cli.calculate()}!');
}

getParser() {
  var parser = BibleParser("ENG");
  //print(parser.standardAbbreviation);
  //print(parser.bcvToVerseReference(43, 3, 16));
  //print(parser.bcvToVerseReference(43, 3, 16, 3, 18));
  //print(parser.bcvToVerseReference(43, 3, 16, 4, 2));
  //print(parser.parseText('<ref onclick="bcv(1,1,1)">3 Jn. 10</ref>, 11; Rom 3:23, 24; 8:1-3'));
  //print(parser.extractAllReferences('<ref onclick="bcv(1,1,1)">3 Jn. 10</ref>, 11; Rom 3:23, 24; 8:1-3'));
  //parser.tagFiles(["lib/test.txt", "lib/test1.txt"]);
  parser.tagFilesInsideFolder("lib/files");
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
  
  // python3-equivalent: aStringList = [i.upper() for i in aStringList]
  print(aStringList);
  aStringList = aStringList.map((i) => i.toUpperCase()).toList();
  print(aStringList);
  
  // python3-equivalent: aStringList2 = [int(i) for i in aStringList2]
  List aStringList2 = <String>["43", "3", "16"];
  print(aStringList2);
  aStringList2 = aStringList2.map((i) => int.parse(i)).toList();
  print(aStringList2);
}

combineCollection() {
  List list1 = [4, 5, 3, 1, 9, 2];
  List list2 = [1, 2, 3, 4, 5];
  print([...list1, ...list2]);
  
  Set set1 = {4, 5, 3, 1, 9, 2};
  Set set2 = {1, 2, 3, 4, 5};
  print({...set1, ...set2});
  
  Map map1 = {"test1": 1, "test2": 2};
  Map map2 = {"test1": 11, "test3": 3};
  print({...map1, ...map2}); // note: test1: 11 replaces test1: 1
}

whereCollection() {
  List list1 = [4, 5, 3, 1, 9, 2];
  print(list1.where((i) => i > 4).toList());

  List list2 = ["one", "two", "three", "four", "five", "six", "seven"];
  print(list2.where((i) => i.contains("e")).toList());

  Map map1 = {"b": 1, "c": 1, "v": 1, "text": "aaaaa"};
  Map map2 = {"b": 1, "c": 1, "v": 2, "text": "bbbbb"};
  List list3 = [map1, map2];
  print(list3);
  print(list3[0].runtimeType);
  print(list3[0]["text"].runtimeType);
  print(list3.where((i) => i["text"].contains("b")).toList());
  
  String jsonString = '''
    [
      {
        "bNo": 1,
        "cNo": 1,
        "vText": "In the beginning God created the heaven and the earth.",
        "vNo": 1
      },
      {
        "bNo": 1,
        "cNo": 1,
        "vText": "¶ And the earth was without form, and void; and darkness [was] upon the face of the deep. And the Spirit of God moved upon the face of the waters.",
        "vNo": 2
      }
    ]
  ''';
  var verses = jsonDecode(jsonString);
  print(verses[0].runtimeType);
  print(verses[0]["vText"].runtimeType);
  print(verses.where((i) => (i["vText"].contains("b") as bool)).toList()); // not "as bool" is required in this case to convert (dynamic) => dynamic to (dynamic) => bool
}

getSubList() {
  List list1 = [1, 2, 3, 4, 5, 6, 7];
  
  // take away the beginning item
  // python3-equivalent: list1[1:]
  List list2 = list1.sublist(1);
  print(list2);
  
  // take away the last item
  // python3-equivalent: list1[:-1]
  List list3 = list1.sublist(0, (list1.length - 1));
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
  var addedText = "ADDED_TEXT";
  print(replaceAllSmart(aString, RegExp(r"(T).*?(s).*?(i).*?(g).*?(r).*?(e).*?(g).*?(u).*?(l).*?(a).*?(r)"), "$addedText \\11"));

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
  print(aString);
  
  print("Both single quotation mark ' and double quotation mark ${'"'} in a single string");
}
