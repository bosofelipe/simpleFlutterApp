import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() {
  runApp(B3App());
}

class B3App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.comfortable,
      ),
      home: B3Home(),
    );
  }
}

class B3Home extends StatefulWidget {
  var items = new List<Item>();

  B3Home() {
    items = [];
    // items.add(Item(title: "ITSA 4", done: false));
    // items.add(Item(title: "OIBR 3", done: true));
    // items.add(Item(title: "ITUB 4", done: false));
  }

  @override
  _B3HomeState createState() => _B3HomeState();
}

class _B3HomeState extends State<B3Home> {
  var newTaskCtrl = TextEditingController();

  void add() {
    setState(() {
      if (newTaskCtrl.text.isEmpty) return;
      widget.items.add(Item(title: newTaskCtrl.text, done: false));
      newTaskCtrl.text = "";
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((e) => Item.fromJson(e)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _B3HomeState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: add,
          child: Icon(Icons.add),
          backgroundColor: Colors.cyan,
        ),
        appBar: AppBar(
          title: TextFormField(
            controller: newTaskCtrl,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
                labelText: "Novo Papel",
                labelStyle: TextStyle(color: Colors.white)),
          ),
        ),
        body: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (BuildContext ctxt, int index) {
            final item = widget.items[index];
            return Dismissible(
                key: Key(item.title),
                background: Container(
                  color: Colors.red.withOpacity(0.2),
                  child: Text("Excluir"),
                ),
                onDismissed: (direction) {
                  remove(index);
                },
                child: CheckboxListTile(
                  title: Text(item.title),
                  key: Key(item.title),
                  value: item.done,
                  onChanged: (value) {
                    setState(() {
                      item.done = value;
                    });
                  },
                ));
          },
        ));
  }
}
