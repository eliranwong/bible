import 'Helpers.dart';
import 'package:cli/BibleParser.dart';

class Bibles {

  Future getBibleList() async {
    var fileIO = FileIOHelper();
	var bibleFolder = fileIO.getDataPath("bible");
	var bibleList = await fileIO.getFileListInFolder(bibleFolder);
	bibleList = bibleList.where((i) => (i.endsWith(".json") as bool)).toList();
	bibleList = bibleList.map((i) => fileIO.getBasename(i.substring(0, (i.length - 5)))).toList();
	return bibleList;
  }

  Future isValidBible(String bible) async {
    var bibleList = await this.getBibleList();
	return (bibleList.contains(bible));
  }

}

class Bible {

  var biblePath;
  var module;
  var data;

  Bible(String bible) {
    this.biblePath = FileIOHelper().getDataPath("bible", bible);
    this.module = bible;
  }

  Future loadData() async {
    this.data = await JsonHelper().getJsonObject(this.biblePath);
  }

  Future open(List referenceList) async {
    if (this.data == null) await this.loadData();

    ((referenceList.length == 1) && (referenceList[0].length == 3)) ? this.openSingleChapter(referenceList[0]) : this.openMultipleVerses(referenceList);
  }

  Future openSingleVerse(List bcvList) async {
    if (this.data == null) await this.loadData();

    String versesFound = "[${BibleParser("ENG").bcvToVerseReference(bcvList)}] ";

    var b = bcvList[0];
    var c = bcvList[1];
    var v = bcvList[2];

    var searchResults = this.data.where((i) => ((i["bNo"] == b) && (i["cNo"] == c) && (i["vNo"] == v))).toList();
    for (var found in searchResults) {
      var verseText = found["vText"].trim();
      versesFound += "$verseText";
    }

    return versesFound.trimRight();
  }

  Future openSingleVerseRange(List bcvList) async {
    if (this.data == null) await this.loadData();

    String versesFound = "[${BibleParser("ENG").bcvToVerseReference(bcvList)}] ";

    var b = bcvList[0];
    var c = bcvList[1];
    var v = bcvList[2];
    var c2 = bcvList[3];
    var v2 = bcvList[4];

    var check, searchResults;

    if ((c2 == c) && (v2 > v)) {
      check = v;
      while (check <= v2) {
        searchResults = this.data.where((i) => ((i["bNo"] == b) && (i["cNo"] == c) && (i["vNo"] == check))).toList();
        for (var found in searchResults) {
          var verseText = found["vText"].trim();
          versesFound += "$verseText ";
        }
        check += 1;
      }
    } else if (c2 > c) {
      check = c;
      while (check < c2) {
        searchResults = this.data.where((i) => ((i["bNo"] == b) && (i["cNo"] == check))).toList();
        for (var found in searchResults) {
          var verseText = found["vText"].trim();
          versesFound += "$verseText ";
        }
        check += 1;
      }
      check = 0; // some bible versions may have chapters starting with verse 0.
      while (check <= v2) {
        searchResults = this.data.where((i) => ((i["bNo"] == b) && (i["cNo"] == c) && (i["vNo"] == check))).toList();
        for (var found in searchResults) {
          var verseText = found["vText"].trim();
          versesFound += "$verseText ";
        }
        check += 1;
      }
    }

    return versesFound.trimRight();
  }

  Future openSingleChapter(List bcvList) async {
    if (this.data == null) await this.loadData();

    String versesFound = "";
    var searchResults = this.data.where((i) => ((i["bNo"] == bcvList[0]) && (i["cNo"] == bcvList[1]))).toList();
    for (var found in searchResults) {
      var b = found["bNo"];
      var c = found["cNo"];
      var v = found["vNo"];
      var bcvRef = BibleParser("ENG").bcvToVerseReference([b, c, v]);
      var verseText = found["vText"].trim();
      (v == bcvList[2]) ? versesFound += "**********\n[$bcvRef] $verseText\n**********\n" : versesFound += "[$bcvRef] $verseText\n";
    }
    print(versesFound);
  }

  Future openMultipleVerses(List listOfBcvList) async {
    if (this.data == null) await this.loadData();

    String versesFound = "";
    for (var bcvList in listOfBcvList) {
      if (bcvList.length == 5) {
        var verse = await openSingleVerseRange(bcvList);
        versesFound += "$verse\n\n";
      } else {
        var verse = await openSingleVerse(bcvList);
        versesFound += "$verse\n\n";
      }
    }
    print(versesFound);
  }

  Future search(String searchString) async {
    if (this.data == null) await this.loadData();

    String versesFound = "";
    var searchResults = this.data.where((i) => (i["vText"].contains(RegExp(searchString)) as bool)).toList();
    for (var found in searchResults) {
      var b = found["bNo"];
      var c = found["cNo"];
      var v = found["vNo"];
      var bcvRef = BibleParser("ENG").bcvToVerseReference([b, c, v]);
      var verseText = found["vText"];
      versesFound += "[$bcvRef] $verseText\n\n";
    }
    print(versesFound);
    print("$searchString is found in ${searchResults.length} verse(s).");
  }

}