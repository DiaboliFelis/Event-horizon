import 'package:flutter/material.dart';
  import'package:flutter/rendering.dart';
  void main() => runApp(
    
        new MyApp(),
      );
  
  class MyApp extends StatelessWidget {
    final _sizeTextBlack = const TextStyle(fontSize: 20.0, color: Colors.black);
  final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);

    @override
    Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  child: new TextFormField(
                    decoration: new InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    style: _sizeTextBlack,
                  ),
                  width: 400.0,
                ),
                new Container(
                  child: new TextFormField(
                    decoration: new InputDecoration(labelText: "Пароль"),
                    obscureText: true,
                    style: _sizeTextBlack,
                  ),
                  width: 400.0,
                  padding: new EdgeInsets.only(top: 10.0),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: new InputDecoration(labelText: "Повторите пароль"),
                    keyboardType: TextInputType.emailAddress,
                    style: _sizeTextBlack,
                  ),
                  width: 400.0,
                ),
                new Padding(
                  padding: new EdgeInsets.only(top: 25.0),
                  child: new MaterialButton(
                    color: Theme
                        .of(context)
                        .colorScheme.onSurface,
                    height: 50.0,
                    minWidth: 200.0,
                    onPressed: () {  },
                    child: new Text(
                      "Логин",
                      style: _sizeTextWhite,
                    ),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
  }