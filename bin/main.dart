import 'package:cli/BibleParser.dart';
import 'package:cli/Bibles.dart';

var bible1, bible2;

// try commands like:
// "bin/main.dart open John 3:16"
// "bin/main.dart open John 3:16-18; Rom 5:8, 3:23, 25"
// "bin/main.dart search Christ Jesus" to search for verses containing "Christ Jesus"
// "bin/main.dart search Christ.*?Jesus" to search for verses containing "Christ", followed by "Jesus" anywhere in the same verse.

main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    //print(arguments);
    var features = {
      "open": openBible,
      "search": searchBible,
    };
    var feature = features[arguments[0]];
    var entry = arguments.sublist(1).join(" ");
    feature(1, "KJV", entry);
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
      var referenceList = BibleParser("ENG").extractAllReferences(referenceString);
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
