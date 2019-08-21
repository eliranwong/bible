import 'Helpers.dart';
import 'package:cli/BibleParser.dart';

class Bibles {

  Future getALLBibleList() async {
    var fileIO = FileIOHelper();
	var bibleFolder = fileIO.getDataPath("bible");
	var bibleList = await fileIO.getFileListInFolder(bibleFolder);
	bibleList = bibleList.where((i) => (i.endsWith(".json") as bool)).toList();
	bibleList = bibleList.map((i) => fileIO.getBasename(i.substring(0, (i.length - 5)))).toList();
	return bibleList;
  }

  Future getValidBibleList(List bibleList) async {
    var validBibleList = [];
    var allBibleList = await this.getALLBibleList();
    for (var bible in bibleList) {
      if (allBibleList.contains(bible)) validBibleList.add(bible);
    }
    return validBibleList;
  }

  Future isValidBible(String bible) async {
    var bibleList = await this.getALLBibleList();
	return (bibleList.contains(bible));
  }

  Future compareVerses(List listOfBcvList, List bibleList) async {
    String versesFound = "";

    for (var bcvList in listOfBcvList) {
      versesFound += "[Compare ${BibleParser().bcvToVerseReference(bcvList)}]\n";
      for (var bible in bibleList) {
        var verseText = await Bible(bible).openSingleVerse(bcvList);
        versesFound += "[$bible] $verseText\n";
      }
    }
    print("$versesFound\n");
  }

  Future parallelVerses(List bcvList) async {
    print("pending");
  }

  Future parallelChapters(List bcvList) async {
    print("pending");
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

  Future getBookList() async {
    if (this.data == null) await this.loadData();

    Set books = {};
	for (var i in this.data) {
	  books.add(i["bNo"]);
	}
	return books.toList();
  }

  Future getChapterList(int b) async {
    if (this.data == null) await this.loadData();

    Set chapters = {};
	var searchResults = this.data.where((i) => (i["bNo"] == b)).toList();
	for (var i in searchResults) {
	  chapters.add(i["cNo"]);
	}
	return chapters.toList();
  }

  Future getVerseList(int b, int c) async {
    if (this.data == null) await this.loadData();

    Set verses = {};
	var searchResults = this.data.where((i) => ((i["bNo"] == b) && (i["cNo"] == c))).toList();
	for (var i in searchResults) {
	  verses.add(i["vNo"]);
	}
	return verses.toList();
  }

  Future openSingleVerse(List bcvList) async {
    if (this.data == null) await this.loadData();

    String versesFound = "";

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

    String versesFound = "";

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
          var verseText = "[${found["vNo"]}] ${found["vText"].trim()}";
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

    String versesFound = "[${BibleParser().bcvToChapterReference(bcvList)}]\n";
    var searchResults = this.data.where((i) => ((i["bNo"] == bcvList[0]) && (i["cNo"] == bcvList[1]))).toList();
    for (var found in searchResults) {
      var b = found["bNo"];
      var c = found["cNo"];
      var v = found["vNo"];
      var verseText = found["vText"].trim();
      (v == bcvList[2]) ? versesFound += "**********\n[$v] $verseText\n**********\n" : versesFound += "[$v] $verseText\n";
    }
    print(versesFound);
  }

  Future openMultipleVerses(List listOfBcvList) async {
    if (this.data == null) await this.loadData();

    String versesFound = "";
    for (var bcvList in listOfBcvList) {
      versesFound += "[${BibleParser().bcvToVerseReference(bcvList)}] ";
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
      var bcvRef = BibleParser().bcvToVerseReference([b, c, v]);
      var verseText = found["vText"];
      versesFound += "[$bcvRef] $verseText\n\n";
    }
    print(versesFound);
    print("$searchString is found in ${searchResults.length} verse(s).");
  }

}