import 'package:cli/Bibles.dart';

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
