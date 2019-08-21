import 'dart:io'; // required by "FileIOHelper"
import 'dart:convert'; // required by "FileIOHelper", "JsonHelper"
import 'package:path/path.dart' as p; // required by "FileIOHelper"

class FileIOHelper {

  // File: https://api.dart.dev/stable/2.4.1/dart-io/File-class.html
  // Directory: https://api.dart.dev/stable/2.4.1/dart-io/Directory-class.html

  String getDataPath(String dataType, [String module]) {
    var resourceFolder = "data";
    if (module == null) {
      return p.join(resourceFolder, dataType);
    } else {
      return p.join(resourceFolder, dataType, "$module.json");
    }
  }

  String getBasename(String filePath) {
    var file = File(filePath);
    String filename = p.basename(file.path);
    return filename;
  }

  Future isFile(String filePath) async {
    var file = File(filePath);
    var check = await file.exists();
    return check;
  }

  Future getFileListInFolder(String folderPath) async {
    var dir = Directory(folderPath);
    try {
      var dirList = dir.list();
      var fileList = [];
      await for (FileSystemEntity f in dirList) {
        if (f is File) fileList.add(f.path);
      }
      return fileList;
    } catch (e) {
      var errors = [];
      errors.add(e.toString());
      return errors;
    }
  }

  Future readTextFile(String filePath) async {
    var textFile = File(filePath);
    try {
      var contents = await textFile.readAsString();
      return contents;
    } catch (e) {
      return(e);
    }
  }

  Future formatTextFile(String filePath, Function actionOnContent, [String actionFilePath]) async {
    if (actionFilePath == null) actionFilePath = filePath;

    var textFile = File(filePath);
    try {
      var contents = await textFile.readAsString();
      contents = await actionOnContent(contents);
      await writeTextFile(contents, actionFilePath);
      print("Formatted file: $actionFilePath");
    } catch (e) {
      print(e);
    }
  }

  Future formatTextFileStreaming(String filePath, Function actionOnLine, [String actionFilePath]) async {
    var outputFile;
    if (actionFilePath == null) {
      actionFilePath = filePath;
      outputFile = File(actionFilePath);
      this.appendTextFile("\n\n/* Formatted content */\n\n", actionFilePath);
    } else {
      outputFile = File(actionFilePath);
      var existingFile = await this.isFile(actionFilePath);
      if (existingFile) await outputFile.delete();
    }
    
    var textFile = File(filePath);
    Stream<List<int>> inputStream = textFile.openRead();

    var sink;
    sink = outputFile.openWrite(mode: FileMode.append);

    var lines = utf8.decoder.bind(inputStream).transform(LineSplitter());
    try {
      await for (var line in lines) {
        line = await actionOnLine(line);
        sink.write("$line\n");
        await sink.flush();
      }
      print("Formatted file: $actionFilePath");
    } catch (e) {
      print(e);
    }
    await sink.close();
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

class JsonHelper {

  Future getJsonObject(filePath) async {
    var fileIO = FileIOHelper();
    var jsonString = await fileIO.readTextFile(filePath);
    var jsonObject = jsonDecode(jsonString);
    return jsonObject;
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
