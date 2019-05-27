library easy_stateful_builder;

import 'package:flutter/material.dart';

/// The signature of builder function. This builder will be given
/// the current BuildContext, setState(), and the current value (or object) state.
/// You can explicitly call the setState() inside this builder but
/// I encourage you to separate the view and logic according to BLoC (or other patterns).
typedef EasyStatefulWidgetBuilder = Widget Function(BuildContext, dynamic);

typedef EasyStatefulValueSetter = Function(_EasyStateHolder);

/// Implements the easy state management.
class EasyStatefulBuilder<T> extends StatefulWidget {
  EasyStatefulBuilder({
    Key key,
    this.initialValue,
    @required this.builder,
    @required this.identifier,
  }) : super(key: key);

  /// Set of setState holder.
  static final Map<String, List<StateSetter>> _setterRegistry = {};

  /// Set of state holder.
  static final Map<String, _EasyStateHolder> _stateRegistry = {};

  static void setState(
      String identifier, EasyStatefulValueSetter setNextState) {
    if (_setterRegistry[identifier] == null) {
      throw Exception("Can not find setState for identified $identifier.");
    }
    setNextState(_stateRegistry[identifier]);
    for (StateSetter setState in _setterRegistry[identifier]) {
      setState(() {});
    }
  }

  /// The widget builder. You can call setState in this builder if you want to.
  final EasyStatefulWidgetBuilder builder;
  final String identifier;
  final initialValue;

  Widget build(BuildContext context) {
    return builder(context, _stateRegistry[this.identifier].currentState);
  }

  void _register(StateSetter setter) {
    if (_setterRegistry[this.identifier] != null) {
      _setterRegistry[this.identifier].add(setter);
    } else {
      _setterRegistry.addEntries([
        MapEntry(this.identifier, [setter])
      ]);
      _stateRegistry.addEntries([
        MapEntry(this.identifier, _EasyStateHolder(this.initialValue)),
      ]);
    }
  }

  void _unregister(StateSetter setState) {
    _setterRegistry[this.identifier].remove(setState);
    if (_setterRegistry[this.identifier].isEmpty) {
      _setterRegistry.remove(this.identifier);
      _stateRegistry.remove(this.identifier);
    }
  }

  _EasyStatefulBuilderState createState() => _EasyStatefulBuilderState();
}

/// This is just a state holder.
class _EasyStatefulBuilderState extends State<EasyStatefulBuilder> {
  @override
  void initState() {
    super.initState();

    /// Register the setState method.
    widget._register(setState);
  }

  @override
  Widget build(BuildContext context) => widget.build(context);

  @override
  void dispose() {
    widget._unregister(setState);
    super.dispose();
  }
}

class _EasyStateHolder<T> {
  _EasyStateHolder(T initialState) : _state = initialState;

  T _state;
  T get currentState => _state;
  set nextState(state) => _state = state;
}
