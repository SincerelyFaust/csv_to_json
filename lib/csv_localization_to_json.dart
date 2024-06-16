import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:csv/csv.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Path to the input CSV file')
    ..addOption('output',
        abbr: 'o', help: 'Directory to save the output JSON files');

  final argResults = parser.parse(arguments);

  final csvFilePath = argResults['input'];
  final outputDir = argResults['output'];

  if (csvFilePath == null || outputDir == null) {
    print('Please provide both input CSV file path and output directory.');
    print(parser.usage);
    exit(1);
  }

  convertCsvToJson(csvFilePath, outputDir);
}

void convertCsvToJson(String csvFilePath, String outputDir) async {
  final input = File(csvFilePath).openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .toList();

  if (fields.isEmpty) {
    print('The CSV file is empty.');
    return;
  }

  final headers = fields.first.cast<String>();
  final languages = headers.sublist(1);
  final translations = {for (var lang in languages) lang: <String, String>{}};

  for (var row in fields.sublist(1)) {
    final key = row[0] as String;
    for (var i = 1; i < row.length; i++) {
      translations[languages[i - 1]]![key] = row[i] as String;
    }
  }

  final outputDirectory = Directory('$outputDir/output');
  if (!outputDirectory.existsSync()) {
    outputDirectory.createSync(recursive: true);
  }

  final jsonEncoder = JsonEncoder.withIndent('  ');

  translations.forEach((lang, content) {
    final jsonFilePath = '${outputDirectory.path}/$lang.json';
    final jsonFile = File(jsonFilePath);
    jsonFile.writeAsStringSync(jsonEncoder.convert(content),
        mode: FileMode.write, flush: true);
    print('$jsonFilePath has been created.');
  });
}
