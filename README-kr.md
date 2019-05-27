# easy_stateful_builder

이 패키지는 아직 flutter의 상태 관리에 익숙하지 않은 초보자들을 위해 작성되었습니다. `StatefulWidget`의 명시적인 사용 없이
`State<StatefulWidget>`의 `setState`와 동일한 효과를 제공하는 위젯 패키지 입니다. 이를 통해서 `BLoC` 패턴, `Redux`, 
`Provider`, `InheritedWidget`, 이나 `scoped_model` 등과 같은 상태관리 패키지 없이, 쉽게 글로벌 상태를 관리할 수 있습니다.

처음 언급한 것 처럼 초보 사용자를 위한 패키지로써, 이제 막 개발의 시작단계 있으므로 완전히 테스트 되지 않은 버그들이 산재할 수 있습니다.
실제 프로덕트에 사용하는것은 추천하지 않고, 빠르게 프로토타이핑을 하고 싶거나, 토이 프로젝트를 진행할 때 사용하길 권장합니다. 
Issue나 PR은 언제든지 환영합니다. 

패키지는 flutter의 기본 위젯 및 객체인 `StatefulBuilder`와 `GlobalKey`의 소스코드에서 영감을 받아 작성하였습니다. 테스트가 되지 않았고,
코드 구조상 매우 큰 메모리 사용을 유발할 가능성이 있습니다. 다만, 대부분의 경우에는 사용하기 안전합니다. 

## 설치하기 

`pubspec.yaml` 파일의 `dependencies` 파트에 `easy_stateful_builder: ^0.2.2` 를 추가하고 `flutter pub get`을 수행합니다.

```yaml
# pubspec.yaml

dependencies:
  easy_stateful_builder: ^0.2.2
```

## Example

이 패키지에서 제공하는 것은 `EasyStatefulBuilder` 위젯 단 하나입니다. `EasyStatefulBuilder`는 총 4개의 파라미터를 생성 인자로 받습니다.

- **identifier** (required, `String`): 관리할 `state`를 구분 짓는 구분자 (ID) 입니다. 앱의 전역에 걸쳐서 `state`를 구분하는데 사용되므로, 
다른 `state`를 저장하고 싶은 경우에는 다른 `identifier`를 부여해야 합니다. 예제를 보면 쉽게 이해가능합니다.
- **builder** (requried, `Function`): 반드시 주어져야 하는 인자 입니다. 실제 사용자가 원하는 위젯을 만들기 위해 사용됩니다.
`builder` 함수에는 `BuildContext, dynamic`의 총 2개 인자가 주어집니다. 첫 번째 인자는 일반적인 `BuildContext context` 객체로, flutter의
다른 위젯이나 builder에서도 사용되는 것과 동일합니다. 두 번째 인자는 관리하고자 하는 `state`의 현재 상태 입니다. 예제를 보면 쉽게 이해가능합니다.
- initialValue (optional, `dynamic`): `identifier` ID로 관리할 `state`의 초기 값 입니다. 주어지지 않을 경우 `null`이 됩니다.
- key (optional, `Key`): 일반 적인 위젯에 들어가는 `Key` 입니다. 

상태의 변경을 위해 `EasyStatefulBuilder` 위젯은 `EasyStatefulBuilder.setState`라는 단 하나의 상태관리 메소드를 제공합니다.
사용법은 매우 간단하고 일반적으로 `EasyStatefulBuilder.setState('identifier', (state) { state.nextState = state.currentState + 1 });` 와
같은 형태로 사용됩니다. 예제를 보면 쉽게 이해가능합니다.

### 기본 

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
          // `counter`라는 아이디로 관리되는 `state`를 변경하기 위한, 
          // `setState`메소드를 호출합니다.
          EasyStatefulBuilder.setState('counter', (state) {
            // `state`는 `counter`라는 아이디로 관리되는 상태를 보관합니다. 
            // `state.currentState`를 통해 현재 상태를 활요하여 다음 상태를 생성하거나
            // 단순히 다른 값을 할당할 수 있습니다.
            // 단, 다음 상태를 반영하기 위해선 아래와 같이 반드시 `state.nextState`에 할당해야 합니다.
            // 예제에서는 count를 하기 위해 state를 +1 하는 단순 작업을 수행합니다. 
            state.nextState = state.currentState + 1;
          });
        },
      ),
      body: EasyStatefulBuilder(
        identifier: 'counter', // count 상태를 관리할 id를 `counter`로 지정합니다.
        initialValue: 0, // `counter` 상태의 초기값을 0으로 설정합니다. 
        builder: (context, count) { 
          // builder 함수의 두 번째 인자에는 `counter` state의 현재 상태가 주어집니다.
          // 초기값을 0으로 설정했으므로 state는 `int`타입이 되고, 변경 작업 전까지는 0으로 초기화 되어 있습니다.
          // 코드의 명확성을 위해 두 번째 인자의 이름을 임의로 count로 정의하였습니다. 
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
          // 단 한번의 `EasyStatefulBuilder.setState` 호출로, 
          // `counter` ID를 사용하는 다수의 위젯을 변경할 수 있습니다. 
          EasyStatefulBuilder.setState('counter', (state) {
            state.nextState = state.currentState + 1;
          });
        },
      ),
      body: Column(
        children: [
          EasyStatefulBuilder<int>( // `<int>` 는 제거 가능합니다. 
            identifier: 'counter', // 기본 예제와 동일
            initialValue: 0, // 기본 예제와 동일
            builder: (context, count) { // 기본 예제와 동일. 
              return SafeArea(
                child: Text("Counter is $count"),
              );
            },
          ),
          EasyStatefulBuilder<int>( //  `<int>` 는 제거 가능합니다. 
            identifier: 'counter', // 위의 위젯과 같은 상태를 공유하기 위해 같은 ID를 부여합니다. 
            builder: (context, count) { // 같은 ID를 갖고 있으므로, 같은 state가 주어집니다. 
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

### Custom object를 상태로 사용하기

일반적인 사용법은 똑같으므로 설명을 생략합니다.

```dart
// 예제를 위한 임의의 클래스입니다.
// 아무 클래스나 사용가능합니다. 
class MyState {
  int _counter;
  MyState(int counter) : _counter = counter;
  int get counter => _counter;
  int get doubleCounter => _counter * 2;
  set counter(int newCount) => this._counter = newCount;
}

// ... 기본 예제와 동일한 코드, FloatingActionButton의 onPressed
        onPressed: () {
          // call the `setState` of the widget identified by `counter`.
          EasyStatefulBuilder.setState('counter', (state) {
            MyState next = state.currentState as MyState;
            next.counter = next.counter + 1;
            state.nextState = next;
          });
        },
        
// ... Multiple widget 예제와 동일한 코드, body: Column의 children 
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
