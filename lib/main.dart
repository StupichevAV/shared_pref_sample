import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
//import 'auth_screen.dart';
//import 'files_demo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

void main() {
//runApp(const FilesDemoScreen());
  runApp(const MyApp());
//runApp(const SharedPrefScreen());
//runApp(AuthScreen());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кейс-задание 3.1',
      home: SharedPreferenceScreen(
        storage: CounterStorage(),
      ),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

// Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
// If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

// Write the file
    return file.writeAsString('$counter');
  }
}

class SharedPreferenceScreen extends StatefulWidget {
  const SharedPreferenceScreen({Key? key, required this.storage})
      : super(key: key);

  final CounterStorage storage;

  @override
  _SharedPreferenceScreenState createState() => _SharedPreferenceScreenState();
}

class _SharedPreferenceScreenState extends State<SharedPreferenceScreen> {
  late SharedPreferences _prefs;

  static const String kNumberPrefKey = 'number_pref';
  static const String kBoolPrefKey = 'bool_pref';

  int _counter = 0;
  int _numberPref = 0;
  bool _boolPref = false;

  @override
// Инициализация сохраненных данных
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);

      _loadNumberPref();
      _loadBoolPref();
    });

    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

// Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кейс-задание 3.1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(children: <Widget>[
                  const Text('Read/Write File'),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('$_counter'),
                  ),
                  ElevatedButton(
                    child: const Text('Увеличить'),
                    onPressed: () => _incrementCounter(),
                  ),
                ]),
                TableRow(children: <Widget>[
                  const Text('Number Preference:'),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('$_numberPref'),
                  ),
                  ElevatedButton(
                    child: const Text('Увеличить'),
                    onPressed: () => _setNumberPref(_numberPref + 1),
                  ),
                ]),
                TableRow(children: <Widget>[
                  const Text('Boolean Preference:'),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('$_boolPref'),
                  ),
                  ElevatedButton(
                    child: const Text('Нажми'),
                    onPressed: () => _setBoolPref(!_boolPref),
                  )
                ]),
              ],
            ),
            ElevatedButton(
              child: const Text('Сбросить значения'),
              onPressed: () => _resetDataPref(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _setNumberPref(int value) async {
    await _prefs.setInt(kNumberPrefKey, value);
    _loadNumberPref();
  }

  Future<void> _setBoolPref(bool value) async {
    await _prefs.setBool(kBoolPrefKey, value);
    _loadBoolPref();
  }

// Загрузка данных формата Boolean
  Future<void> _resetDataPref() async {
    await _prefs.remove(kNumberPrefKey);
    await _prefs.remove(kBoolPrefKey);

    _loadNumberPref();
    _loadBoolPref();
  }

// Загрузка данных формата Int
  void _loadNumberPref() {
    setState(() {
      _numberPref = _prefs.getInt(kNumberPrefKey) ?? 0;
    });
  }

// Загрузка данных формата Boolean
  void _loadBoolPref() {
    setState(() {
      _boolPref = _prefs.getBool(kBoolPrefKey) ?? false;
    });
  }
}
