import 'dart:io'; // required by "FileIOHelper"
import 'dart:convert'; // required by "FileIOHelper"

class FileIOHelper {

  Future readTextFile(String filePath, Function actionOnContent, {String actionFilePath}) async {
    var textFile = File(filePath);
    try {
      var contents = await textFile.readAsString();
      (actionFilePath != null) ? actionOnContent(contents, actionFilePath) : actionOnContent(contents);
    } catch (e) {
      print(e);
    }
  }

  Future readTextFileStreaming(String filePath, Function actionOnLine, {String actionFilePath}) async {
    var textFile = File(filePath);
    Stream<List<int>> inputStream = textFile.openRead();

    var outputFile;
    var sink;
    if (actionFilePath != null) {
      outputFile = File(actionFilePath);
      sink = outputFile.openWrite(mode: FileMode.append);
    }

    var lines = utf8.decoder.bind(inputStream).transform(LineSplitter());
    try {
      await for (var line in lines) {
        if (actionFilePath != null) {
          line = actionOnLine(line);
          sink.write("$line\n");
          await sink.flush();
        } else {
          actionOnLine(line);
        }
      }
      // print('File "$filePath" is now closed.');
    } catch (e) {
      print(e);
    }
    if (actionFilePath != null) await sink.close();
  }

  Future writeTextFile(String content, String filePath) async {
    var textFile = File(filePath);
    var sink = textFile.openWrite();
    sink.write(content);
    await sink.flush();
    await sink.close();
  }
  
  Future appendTextFile(String content, String filePath) async {
    var textFile = File(filePath);
    var sink = textFile.openWrite(mode: FileMode.append);
    sink.write(content);
    await sink.flush();
    await sink.close();
  }

}

class RegexHelper {

  var searchReplace;

  var searchPattern;
  
  var patternString;

  String Function(Match) replacement(String pattern) => (Match match) => pattern.replaceAllMapped(new RegExp(r'\\(\d+)'), (m) => match[int.parse(m[1])]);

  String replaceAllSmart(String source, Pattern pattern, String replacementPattern) => source.replaceAllMapped(pattern, replacement(replacementPattern));

  String doSearchReplace(String text, {bool multiLine = false, bool caseSensitive = true, bool unicode = false, bool dotAll = false}) {
    var replacedText = text;
    for (var i in this.searchReplace) {
      var search = i[0];
      var replace = i[1];
      replacedText = this.replaceAllSmart(replacedText, RegExp(search, multiLine: multiLine, caseSensitive: caseSensitive, unicode: unicode, dotAll: dotAll), replace);
    }
    return replacedText;
  }

}