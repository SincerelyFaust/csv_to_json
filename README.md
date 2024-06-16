# csv_to_json

A Dart script that generates a JSON file for each column inside the CSV file.

## Usage

```sh
dart run lib/csv_localization_to_json.dart -i example/example_file.csv -o example
```

## Example

### Input CSV file

```csv
str,hr,en
helloWorld,Pozdrav svijete,Hello world
newText,Novi tekst,New text
```

### Output

- en.json

```json
{
  "helloWorld": "Hello world",
  "newText": "New text"
}
```

- hr.json

```json
{
  "helloWorld": "Pozdrav svijete",
  "newText": "Novi tekst"
}
```