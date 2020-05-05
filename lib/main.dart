import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _lista = List();

  void imagem() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    List<int> imageBytes = image.readAsBytesSync();
    //cria o item
    Map<String, dynamic> item = Map();
    item['data'] = DateFormat('dd/MM').format(DateTime.now());
    item['imagem'] = imageBytes;

    setState(() {
      _lista.add(item);
    });

    //salva a lista
    _saveFile();
  }

  _saveFile() async {
    var arq = await _getFile();
    arq.writeAsStringSync(json.encode(_lista));
    print("salvo");
  }

  Future<File>_getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/dados.json");
  }

  _readFile() async {
    try {
      final arq = await _getFile();
      return arq.readAsString();
    } catch (e) {
      print("erro $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _readFile().then((dados) {
      setState(() {
        _lista = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagem'),
      ),
      body: Column(children: [
        Expanded(
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: <Widget>[
                        Imagem(
                                data: _lista[index]['data'],
                                bytes: _lista[index]['imagem'])
                            .showData(),
                        Imagem(
                                data: _lista[index]['data'],
                                bytes: _lista[index]['imagem'])
                            .showImagem()
                      ],
                    ),
                  ),
                );
              },
              itemCount: _lista.length,
            ),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: imagem,
        tooltip: 'Adicionar',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}

class Imagem {
  List<int> bytes;
  String data;

  Imagem({this.bytes, this.data});

  Widget showData() {
    return Text(
      "$data",
      style: TextStyle(fontSize: 24),
    );
  }

  Widget showImagem() {
    return Image.memory(
      bytes,
      height: 300,
    );
  }
}
