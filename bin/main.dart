/*
The command line version is taking shape ...

At the moment , you may try commands like:

To open John 3:16 in KJV bible:
* dart bin/main.dart open KJV John 3:16

To open multiple verses (e.g. John 3:16-18, Rom 5:8, 3:23, 2Ti 3:14-16, Ge 1:5, 8, 13) in KJV bible:
* dart bin/main.dart open KJV John 3:16-18, Rom 5:8, 3:23, 2Ti 3:14-1, Ge 1:5, 8, 13

To search for verses containing "Christ Jesus":
* dart bin/main.dart search KJV Christ Jesus

To search for verses containing "Christ", followed by "Jesus" anywhere in the same verse:
* dart bin/main.dart search KJV Christ.*?Jesus

To compare John 3:16 in all installed bibles:
* dart bin/main.dart compare ALL John 3:16

To compare John 3:16 only in CUV and KJV:
* dart bin/main.dart compare CUV_KJV John 3:16

<i><b>Remarks:</b></i>
* Please use "," instead of ";" to separate verses in command lines.
* Common abbreviations are supported.
*/


import 'package:cli/BibleParser.dart';
import 'package:cli/Bibles.dart';

var bible1, bible2;

main(List<String> arguments) {
  if ((arguments.isNotEmpty) && (arguments.length > 3)) {
    //print(arguments);
    var features = {
      "open": openBible,
      "search": searchBible,
      "compare": compareBibles,
    };
    var feature = features[arguments[0]];
    var module = arguments[1];
    var entry = arguments.sublist(2).join(" ");
    feature(1, module, entry);
  }
}

Future loadBible(int bibleID, String bibleModule) async {
  if (!(await Bibles().isValidBible(bibleModule))) return null;

  switch (bibleID) {
    case 1:
      if ((bible1 == null) || ((bible1 != null) && (bible1.module != bibleModule))) {
        bible1 = Bible(bibleModule);
        print("Bible 1 loaded");
      }
      return bible1;
      break;
    case 2:
      if ((bible2 == null) || ((bible2 != null) && (bible2.module != bibleModule))) {
        bible2 = Bible(bibleModule);
        print("Bible 2 loaded");
      }
      return bible2;
      break;
  }
}

Future openBible(int bibleID, String bibleModule, String referenceString) async {
  if (referenceString.isNotEmpty) {
    var bible = await loadBible(bibleID, bibleModule);
    if (bible != null) {
      var referenceList = BibleParser().extractAllReferences(referenceString);
      if (referenceList.isNotEmpty) bible.open(referenceList);
    }
  }
}

Future searchBible(int bibleID, String bibleModule, String searchString) async {
  if (searchString.isNotEmpty) {
    var bible = await loadBible(bibleID, bibleModule);
    if (bible != null) bible.search(searchString);
  }
}

Future compareBibles(int bibleID, String bibleString, String referenceString) async {
  var bibles = Bibles();
  var bibleList;
  (bibleString == "ALL") ? bibleList = await bibles.getALLBibleList() : bibleList = await bibles.getValidBibleList(bibleString.split("_"));
  if (bibleList.isNotEmpty) {
    var referenceList = BibleParser().extractAllReferences(referenceString);
    if (referenceList.isNotEmpty) bibles.compareVerses(referenceList, bibleList);  
  }
}
