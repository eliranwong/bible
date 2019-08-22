/// The command line version is taking shape ...
/// 
/// At the moment , you may try commands like:
/// 
/// To "open" John 3:16 in KJV bible:
/// * dart bin/main.dart open KJV John 3:16
/// 
/// To "open" multiple verses (e.g. John 3:16-18, Rom 5:8, 3:23, 2Ti 3:14-16, Ge 1:5, 8, 13) in KJV bible:
/// * dart bin/main.dart open KJV John 3:16-18, Rom 5:8, 3:23, 2Ti 3:14-1, Ge 1:5, 8, 13
/// 
/// To "search" for verses containing "Christ Jesus":
/// * dart bin/main.dart search KJV Christ Jesus
/// 
/// To "search" with standard regular expressions, e.g.:
/// * dart bin/main.dart search KJV Christ.*?Jesus
/// 
/// To "compare" John 3:16 in all installed bibles:
/// * dart bin/main.dart compare ALL John 3:16
/// 
/// To "compare" John 3:16 only in NET and KJV:
/// * dart bin/main.dart compare NET_KJV John 3:16
/// 
/// To "compare" multiple entries, e.g.:
/// * dart bin/main.dart compare ALL John 3:16, Rom 5:8
/// * dart bin/main.dart compare NET_KJV_WEB John 3:16, Rom 5:8
/// 
/// To display chapter John 3 in "parallel" modes, with verse 16 highlighted (e.g. NET & KJV):
/// * dart bin/main.dart parallel NET_KJV John 3:16
/// 
/// To display cross-"reference" verse(s) related to John 3:16 in KJV bible:
/// * dart bin/main.dart reference KJV John 3:16
/// 
/// <i><b>Remarks:</b></i>
/// * Please use "," instead of ";" to separate verses in command lines.
/// * Common abbreviations are supported.
/// * Please note the difference between "compare" and "parallel".
/// * "compare" accepts multiple entries of verse references whereas "parallel" ignores.
/// * "parallel" displays a full chapter with a particular verse highlighted whereas "compare" shows particular verse(s) only.
/// * "parallel" can use no more than 2 versions [at the moment] whereas "compare" can use as many as installed versions.
/// * Regular expression is turned on by default for searching bibles.  Use \ to escape characters like ()[].*? .

import 'package:cli/Bibles.dart';
import 'package:cli/config.dart' as config;

var bibles;

main(List<String> arguments) {
  bibles = Bibles();

  if ((arguments.isNotEmpty) && (arguments.length >= 3)) {
    var actions = {
      "open": bibles.openBible,
      "search": bibles.searchBible,
      "compare": bibles.compareBibles,
      "parallel": bibles.parallelBibles,
      "reference": bibles.crossReference,
    };
    var action = arguments[0];
    if (actions.keys.contains(action.toLowerCase())) {
      var module = arguments[1];
      var entry = arguments.sublist(2).join(" ");
      actions[action](module, entry);
    } else {
      bibles.openBible(config.bible1, arguments.join(" "));
    }
  } else {
    bibles.openBible(config.bible1, arguments.join(" "));
  }
}
