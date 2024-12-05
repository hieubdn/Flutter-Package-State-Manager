typedef StateListener = void Function();

class StateObserver {
  final Map<String, List<StateListener>> _listeners = {};

  void subscribe(String stateKey, StateListener listener) {
    _listeners[stateKey] ??= [];
    _listeners[stateKey]!.add(listener);
  }

  void notify(String stateKey) {
    if (_listeners[stateKey] != null) {
      for (var listener in _listeners[stateKey]!) {
        listener();
      }
    }
  }

  void unsubscribe(String stateKey, StateListener listener) {
    _listeners[stateKey]?.remove(listener);
  }
}
