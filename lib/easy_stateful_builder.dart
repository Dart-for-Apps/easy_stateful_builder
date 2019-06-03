library easy_stateful_builder;

import 'package:flutter/material.dart';

/// The signature of builder function. This builder will be given
/// the current BuildContext and the current value (or object) state.
typedef EasyStatefulWidgetBuilder<T> = Widget Function(BuildContext, T);

typedef EasyStatefulValueSetter = Function(_EasyStateHolder);

/// Implements the easy state management.
class EasyStatefulBuilder<T> extends StatefulWidget {
  EasyStatefulBuilder({
    Key key,
    this.initialValue,
    @required this.builder,
    @required this.identifier,
    this.keepAlive = true,
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

  /// Get the `identifier`'s state. Null if not exists.
  /// Returned state can be `null`.
  static ImmutableState getState(String identifier) =>
      ImmutableState(_stateRegistry[identifier]?.currentState);

  /// Explicitly remove the state
  static void dispose(String identifier) {
    _setterRegistry.remove(identifier);
    _stateRegistry.remove(identifier);
  }

  /// The widget builder. You can call setState in this builder if you want to.
  final EasyStatefulWidgetBuilder<T> builder;

  /// The ID of the state. You have responsibility to distinguish this with other state.
  final String identifier;

  /// Initial state
  final initialValue;

  /// Whether to keep this state alive even though all the widget that refers this state are disposed.
  final bool keepAlive;

  Widget build(BuildContext context) {
    return builder(context, _stateRegistry[this.identifier].currentState);
  }

  /// Register the new listener
  void _register(StateSetter setter) {
    if (_setterRegistry[this.identifier] != null) {
      _setterRegistry[this.identifier].add(setter);
      if (this.keepAlive) {
        _stateRegistry[this.identifier].keepAlive = true;
      }
    } else {
      _setterRegistry.addEntries([
        MapEntry(this.identifier, [setter])
      ]);
      if (_stateRegistry[this.identifier] == null) {
        _stateRegistry.addEntries([
          MapEntry(this.identifier,
              _EasyStateHolder(this.initialValue, keepAlive: this.keepAlive)),
        ]);
      }
    }
  }

  /// Unregister the listener of the disposed widget
  void _unregister(StateSetter setState) {
    _setterRegistry[this.identifier].remove(setState);
    if (_setterRegistry[this.identifier].isEmpty) {
      _setterRegistry.remove(this.identifier);
      if (!_stateRegistry[this.identifier].keepAlive) {
        _stateRegistry.remove(this.identifier);
      }
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

/// Wrapper for the state
class _EasyStateHolder<T> {
  _EasyStateHolder(this._state, {this.keepAlive = true});

  /// Whether to keep this state alive even though all the widget that refers this state are disposed.
  bool keepAlive;

  /// The current state;
  T _state;
  T get currentState => _state;

  /// Set new state
  set nextState(state) => _state = state;
}

/// To provide the checkability of the state registry
/// Users can not modify the current state with this.
@immutable
class ImmutableState<T> {
  ImmutableState(this._state);
  final T _state;

  T get currentState => _state;
}
