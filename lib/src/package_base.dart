abstract class StateBase<T> {
  T value;

  StateBase(this.value);

  void setValue(T newValue);

  // Bất đồng bộ
  Future<void> setAsyncValue(Future<T> newValue) async {
    value = await newValue;
  }
}

class ConcreteState<T> implements StateBase<T> {
  @override
  T value;

  ConcreteState(this.value);

  @override
  void setValue(T newValue) {
    value = newValue;
  }

  @override
  Future<void> setAsyncValue(Future<T> newValue) async {
    value = await newValue;
  }

  void updateState(T newValue) {
    value = newValue;
  }

  // các state dạng List
  void updateListItem(int index, dynamic newValue) {
    if (value is List) {
      (value as List)[index] = newValue;
    }
  }

  // các state dạng Map
  void updateMapItem(String key, dynamic newValue) {
    if (value is Map) {
      (value as Map)[key] = newValue;
    }
  }
}
