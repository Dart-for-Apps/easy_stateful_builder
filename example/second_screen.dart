import 'package:flutter/material.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen({Key key}) : super(key: key);

  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: EasyStatefulBuilder(
          identifier: 'counter2',
          builder: (context, count) {
            return Center(
              child: Text("Count2 is still $count"),
            );
          },
        ),
      ),
    );
  }
}
