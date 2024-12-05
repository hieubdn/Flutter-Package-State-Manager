import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_package_state_manager/src/package_manager.dart';
import 'dart:math';

void main() {
  test("StateManager basic operations", () {
    final manager = StateManager();

    manager.createState<int>('counter', 0);
    expect(manager.getState<int>('counter'), 0);

    manager.updateState<int>('counter', 1);
    expect(manager.getState<int>('counter'), 1);

    // Kiểm tra ngoại lệ khi truy xuất trạng thái không tồn tại
    expect(() => manager.getState<int>('non_existent'), throwsException);
  });

  test("StateManager updateStateAsync", () async {
    final manager = StateManager();

    manager.createState<int>('counter', 0);

    // Cập nhật state bất đồng bộ
    final updatedValue = await manager.updateStateAsync<int>('counter', Future.value(10));
    expect(updatedValue, 10);
    expect(manager.getState<int>('counter'), 10);

    // Lỗi bất đồng bộ với Future.error
    await expectLater(
      () async => await manager.updateStateAsync<int>('counter', Future.error("Test error")),
      throwsA(isA<String>().having((e) => e, 'message', equals('Test error'))) // Kiểm tra nội dung lỗi trả về
    );
  });

  test("StateManager reset state", () {
    final manager = StateManager();

    manager.createState<int>('counter', 10);
    manager.resetState<int>('counter', 0);

    // Reset state
    expect(manager.getState<int>('counter'), 0);

    // Reset đối với state phức tạp
    manager.createState<List<int>>('numbers', [1, 2, 3]);
    manager.resetState<List<int>>('numbers', [0, 0, 0]);
    expect(manager.getState<List<int>>('numbers'), [0, 0, 0]);
  });

  test("StateManager performance", () {
    final manager = StateManager();
    final int numberOfStates = 1000;
    final random = Random();

    // Đo thời gian tạo nhiều state
    final startTimeCreate = DateTime.now();
    for (int i = 0; i < numberOfStates; i++) {
      manager.createState<int>('state$i', 0);
    }
    final endTimeCreate = DateTime.now();
    expect(endTimeCreate.difference(startTimeCreate).inMilliseconds, lessThan(1000)); 

    // Đo thời gian cập nhật nhiều state
    final startTimeUpdate = DateTime.now();
    for (int i = 0; i < numberOfStates; i++) {
      manager.updateState<int>('state$i', random.nextInt(1000));
    }
    final endTimeUpdate = DateTime.now();
    expect(endTimeUpdate.difference(startTimeUpdate).inMilliseconds, lessThan(1000)); 

    // Kiểm tra giá trị một state bất kỳ để đảm bảo không có lỗi
    expect(manager.getState<int>('state500'), isNotNull);
  });
}
