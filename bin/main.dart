/// The command line version is taking shape ...
/// 
/// At the moment , you may try commands like:
/// 
/// To open John 3:16 in KJV bible:
/// * dart bin/main.dart open KJV John 3:16
/// 
/// To open multiple verses (e.g. John 3:16-18, Rom 5:8, 3:23, 2Ti 3:14-16, Ge 1:5, 8, 13) in KJV bible:
/// * dart bin/main.dart open KJV John 3:16-18, Rom 5:8, 3:23, 2Ti 3:14-1, Ge 1:5, 8, 13
/// 
/// To search for verses containing "Christ Jesus":
/// * dart bin/main.dart search KJV Christ Jesus
/// 
/// To search for verses containing "Christ", followed by "Jesus" anywhere in the rest of the same verse:
/// * dart bin/main.dart search KJV Christ.*?Jesus
/// 
/// To compare John 3:16 in all installed bibles:
/// * dart bin/main.dart compare ALL John 3:16
/// 
/// To compare John 3:16 only in CUV and KJV:
/// * dart bin/main.dart compare CUV_KJV John 3:16
/// 
/// <i><b>Remarks:</b></i>
/// * Please use "," instead of ";" to separate verses in command lines.
/// * Common abbreviations are supported.
/// * Regular expression is turned on by default for searching bibles.  Use \ to escape characters like ()[].*? .

import 'package:cli/BibleParser.dart';
import 'package:cli/Bibles.dart';
import 'package:cli/config.dart' as config;

var bible1, bible2;

main(List<String> arguments) {
  if ((arguments.isNotEmpty) && (arguments.length >= 3)) {
    var features = {
      "open": openBible,
      "search": searchBible,
      "compare": compareBibles,
	  "parallel": parallelBibles,
    };
    if (features.keys.contains(arguments[0].toLowerCase())) {
      var feature = features[arguments[0]];
      var module = arguments[1];
      var entry = arguments.sublist(2).join(" ");
      feature(1, module, entry);
    } else {
      openBible(1, config.bible1, arguments.join(" "));
    }
  } else {
    openBible(1, config.bible1, arguments.join(" "));
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

Future parallelBibles(int bibleID, String bibleString, String referenceString) async {
  String versesFound = "";
  
  var bibles = Bibles();
  var bibleList = await bibles.getValidBibleList(bibleString.split("_"));
  if (bibleList.length >= 2) {
    await loadBible(1, bibleList[0]);
	await loadBible(2, bibleList[1]);

	var referenceList = BibleParser().extractAllReferences(referenceString);
	if (referenceList.length >= 1) {
	  var bcvList = referenceList[0];
	  versesFound += "[${BibleParser().bcvToChapterReference(bcvList)}]\n";
	  
	  var b = bcvList[0];
	  var c = bcvList[1];
	  var v = bcvList[2];

	  var bible1VerseList = await bible1.getVerseList(b, c);
	  var vs1 = bible1VerseList[0];
	  var ve1 = bible1VerseList[(bible1VerseList.length - 1)];
	  
	  var bible2VerseList = await bible2.getVerseList(b, c);
	  var vs2 = bible2VerseList[0];
	  var ve2 = bible2VerseList[(bible2VerseList.length - 1)];
	  
	  var vs, ve;
	  (vs1 <= vs2) ? vs = vs1 : vs = vs2;
	  (ve1 >= ve2) ? ve = ve1 : ve = ve2;
	  
	  for (var i = vs; i <= ve; i++) {
        var verseText1 = await bible1.openSingleVerse([b, c, i]);
		var verseText2 = await bible2.openSingleVerse([b, c, i]);
		if (i == v) {
		  versesFound += "**********\n[$i] [${bible1.module}] $verseText1\n";
		  versesFound += "[$i] [${bible2.module}] $verseText2\n**********\n";		
		} else {
		  versesFound += "\n[$i] [${bible1.module}] $verseText1\n";
		  versesFound += "[$i] [${bible2.module}] $verseText2\n\n";
		}
	  }
	}
  }
  print(versesFound);
}
