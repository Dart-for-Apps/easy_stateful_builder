# easy_stateful_builder

[![pub badge](https://img.shields.io/pub/v/easy_stateful_builder.svg)](https://pub.dev/packages/easy_stateful_builder)

[Korean](https://github.com/Dart-for-Apps/easy_stateful_builder/blob/master/README-kr.md)

**This package is under development. Please, see the [changelog](https://pub.dev/packages/easy_stateful_builder#-changelog-tab-) to get the latest API.** The example may not contain the
latest API. 

A helper widget to manage the state of the app. Using this package, you can manage the global states easily.
This package is always under the development and **not fully tested**, thus **I highly recommend you to use this package
only for your toy project.** Issues and PR are always welcome.

I was highly inspired by the source code of `StatefulBuilder` and `GlobalKey` of basic flutter widget/object. 

Using this package may incur high memory usage. 

## Install

[Installation Guide](https://pub.dev/packages/easy_stateful_builder#-installing-tab-)

## Example

This package provides just one important widget called `EasyStatefulBuilder`.
`EasyStatefulBuilder` takes several named parameter. 

- **builder** (requried, `Function`): A build function to create widget that you want to render.
Its type is `Function(BuildContext, dynamic)`. The first argument is the usual `BuildContext context`.
The second argument is the snapshot of the widget's state. I will describe it later in detail.
- **identifier** (required, `String`): The ID of the `state` to maintain. This ID will be used as global key, so you have to
distinguish this carefully. 
- initialValue (optional, `dynamic`): The initial value of the `state`. If not given, then initial state will be set to `null`.
- keepAlive (options, `bool` default `true`): Whether to keep `identifier` state alive even though all the widget that refers `identifier` state are disposed.
- key (optional, `Key`): The usual `Key` object. 

And `EasyStatefulBuilder` provides only one simple but powerful method `EasyStatefulBuilder.setState`.
The type of the `EasyStatefulBuilder.setState` is `Function(String, _EasyStateHolder)`. 
Basic usage is `EasyStatefulBuilder.setState('identifier', (state) { state.nextState = state.currentState + 1 });`.
The `state.currentState` and `state.nextState` are the same type and they can be any type you want to use. 

It is really easy to use this package so that you can find the usage by yourself through the example below. 

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        onPressed: () {
          // call the `setState` of the widget identified by `counter`. 
          EasyStatefulBuilder.setState('counter', (state) {
            // `state` holds the current snapshot of the `counter` state. 
            // You can set the nextState using currentState or the other value. 
            // The nextState you want to project should be sotred in `state.nextState`.
            state.nextState = state.currentState + 1;
          });
        },
      ),
      body: EasyStatefulBuilder(
        identifier: 'counter', // this will be used as ID 
        initialValue: 0, // set initial value to `int 0` if the ID `counter` was not initialized
        builder: (context, count) { // I initialized a state to `int 0`, so the type of `count` is `int`.
          return SafeArea(
            child: Text("Counter is $count"),
          );
        },
      ),
    );
  }
}
```

### Same identifier in multiple widget

Same as the basic usage. 

```dart
import 'package:flutter/material.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        onPressed: () {
          // call the `setState` of the widget identified by `counter`. 
          EasyStatefulBuilder.setState('counter', (state) {
            // `state` holds the current snapshot of the `counter` state. 
            // You can set the nextState using currentState or the other value. 
            // The nextState you want to project should be sotred in `state.nextState`.
            state.nextState = state.currentState + 1;
          });
        },
      ),
      body: Column(
        children: [
          EasyStatefulBuilder<int>( // `<int>` can be skipped. 
            identifier: 'counter', // this will be used as ID 
            initialValue: 0, // set initial value to `int 0` if the ID `counter` was not initialized
            builder: (context, count) { // I initialized a state to `int 0`, so the type of `count` is `int`.
              return SafeArea(
                child: Text("Counter is $count"),
              );
            },
          ),
          EasyStatefulBuilder<int>( // `<int>` can be skipped. 
            identifier: 'counter', // Use same ID
            builder: (context, count) { // The count will be same as the above. 
              return SafeArea(
                child: Text("This also use counter $count"),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### Using Custom object as a state


```dart
// Custom state class
class MyState {
  int _counter;
  MyState(int counter) : _counter = counter;
  int get counter => _counter;
  int get doubleCounter => _counter * 2;
  set counter(int newCount) => this._counter = newCount;
}

// ... same as basic example code, modify FloatingActionButton -> onPressed
        onPressed: () {
          // call the `setState` of the widget identified by `counter`.
          EasyStatefulBuilder.setState('counter', (state) {
            MyState next = state.currentState as MyState;
            next.counter = next.counter + 1;
            state.nextState = next;
          });
        },
        
// ... same as multiple widget example code, modify Column -> children
          EasyStatefulBuilder(
            identifier: 'counter',
            initialValue: MyState(0),
            builder: (context, myState) {
              return Center(child: Text("Counter is ${myState.counter}"));
            },
          ),
          EasyStatefulBuilder(
            identifier: 'counter',
            builder: (context, myState) {
              return Center(
                  child: Text("Double Counter is ${myState.doubleCounter}"));
            },
          ),
    
```
