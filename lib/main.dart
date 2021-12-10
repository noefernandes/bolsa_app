import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
  ));
}

Future<Map> getData(String symbol) async {
  var request = Uri.parse(
      "https://api.hgbrasil.com/finance/stock_price?key=b37d1ec9&symbol=" +
          symbol);
  http.Response response = await http.get(request);
  //print(response.statusCode);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController symbolController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool mostrar = false;
  late Map data;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ações na bolsa"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 0.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Insira o código da empresa',
                        hintStyle: TextStyle(color: Colors.blueAccent)),
                    style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                    controller: symbolController,
                    validator: (value) {
                      if (value!.isEmpty) return "Insira a empresa!";
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                print(symbolController.text);
                                data = await getData(symbolController.text);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Result(
                                            symbolController.text, data)));
                              }
                            },
                            child: Text(
                              "Buscar",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                textStyle: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ))),
                ],
              )),
        ));
  }
}

class Result extends StatelessWidget {
  Map _data;
  String _symbol;

  Result(this._symbol, this._data);

  @override
  Widget build(BuildContext context) {
    //print(_symbol.toUpperCase());
    //print("->>>>>> " + _data["results"][_symbol.toUpperCase()]["name"]);
    return Scaffold(
      appBar:
          AppBar(title: Text("Detalhes"), backgroundColor: Colors.blueAccent),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _data["results"][_symbol.toUpperCase()]["company_name"],
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          Text(
            _data["results"][_symbol.toUpperCase()]["description"],
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
          ),
          Text(
            _data["results"][_symbol.toUpperCase()]["website"],
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
          ),
          Text(
            _data["results"][_symbol.toUpperCase()]["region"],
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
          ),
          Text(
            _data["results"][_symbol.toUpperCase()]["price"].toString() +
                " " +
                _data["results"][_symbol.toUpperCase()]["currency"],
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }
}
