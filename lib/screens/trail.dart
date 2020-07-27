import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          
          scrollDirection:Axis.horizontal ,
          children: <Widget>[
            Card(
              child: Text("Hello this is trail text") ,
            ),
            Card(
              child: Text("Hello this is trail text") ,
            ),
            Card(
              child: Text("Hello this is trail text") ,
            ),
            Card(
              child: Text("Hello this is trail text") ,
            ),
            Card(
              child: Text("Hello this is trail text") ,
            ),
            Card(
              child: Text("Hello this is trail text") ,
            ),
          ],
        ),
      ),
          ),
        ],
      ),
      
    );
  }
}