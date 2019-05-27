import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';

import './second_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        onPressed: () {
          try {
            EasyStatefulBuilder.setState('counter', (state) {
              state.nextState = state.currentState + 1;
            });
            EasyStatefulBuilder.setState('counter2', (state) {
              state.nextState = state.currentState + 2;
            });
            setState(() {});
          } catch (e) {
            print(e);
          }
        },
      ),
      body: ListView(
        children: <Widget>[
          EasyStatefulBuilder(
            identifier: 'counter',
            initialValue: 0,
            builder: (context, count) {
              return Center(
                child: Text("Counter: $count"),
              );
            },
          ),
          EasyStatefulBuilder(
            identifier: 'counter2',
            initialValue: 0,
            builder: (context, count) {
              return Center(
                child: Text("Counter2: $count"),
              );
            },
          ),
          CupertinoButton(
            child: Text("Goto next page"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SecondScreen()));
            },
          ),
        ],
      ),
    );
  }
}
