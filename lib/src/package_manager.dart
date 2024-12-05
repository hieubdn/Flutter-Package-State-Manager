import 'package:flutter_package_state_manager/flutter_package_state_manager.dart';
import 'package:flutter_package_state_manager/src/package_base.dart';

class StateManager {
  final Map<String, StateBase> _states = {};
  final StateObserver _observer = StateObserver();

  // Tạo mớii state
  void createState<T>(String key, T defaultValue) {
    if (_states.containsKey(key)) {
      throw Exception("State $key already exists!");
    }
    _states[key] = ConcreteState<T>(defaultValue);
  }

  // Lấy trạng thái
  T getState<T>(String key) {
    if (!_states.containsKey(key)) {
      throw Exception("State $key not found!");
    }
    return _states[key]!.value as T;
  }

  // Cập nhật
  void updateState<T>(String key, T newValue) {
    if (!_states.containsKey(key)) {
      throw Exception("State $key not found!");
    }
    var state = _states[key]!;
    if (state.value != newValue) {
      state.setValue(newValue);
      _observer.notify(key);
    }
  }

  // Đăng ký listener theo dõi
  void observeState(String key, StateListener listener) {
    _observer.subscribe(key, listener);
  }

  // Xóa state
  void removeState(String key) {
    _states.remove(key);
    _observer.notify(key); 
  }

  // Đặt lại giá trị mặc định
  void resetState<T>(String key, T defaultValue) {
    if (!_states.containsKey(key)) {
      throw Exception("State $key not found!");
    }
    _states[key]!.setValue(defaultValue);
    _observer.notify(key);
  }

  // Cập nhật 
  Future<T> updateStateAsync<T>(String key, Future<T> newValue) async {
    if (!_states.containsKey(key)) {
      throw Exception("State $key not found!");
    }
    try {
      final resolvedValue = await newValue;
      _states[key]!.setValue(resolvedValue);
      _observer.notify(key);
      return resolvedValue;
    } catch (e) {
      rethrow;
    }
  }

  // Đo lường hiệu suất
  void measurePerformance(Function() task) {
    final start = DateTime.now();
    task();
    final duration = DateTime.now().difference(start);
    print('Task took ${duration.inMilliseconds}ms');
  }
}

