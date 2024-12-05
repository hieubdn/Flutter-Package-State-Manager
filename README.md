# flutter_package_state_manager

## Giới thiệu

`flutter_package_state_manager` là một package Flutter nhẹ, đơn giản và dễ sử dụng, giúp quản lý trạng thái ứng dụng một cách hiệu quả mà không cần phải tích hợp các giải pháp quản lý trạng thái phức tạp như `Provider`, `Riverpod`, hay `Bloc`. 
Package này giúp bạn tạo và quản lý trạng thái cho các widget của mình, dễ dàng thêm, sửa, xóa dữ liệu mà không cần phải sử dụng các kiến thức phức tạp.

## Tác dụng

- **Quản lý trạng thái dễ dàng**: Cung cấp các phương thức để lưu trữ và cập nhật trạng thái của ứng dụng.
- **Cập nhật UI tự động**: Sau khi thay đổi trạng thái, UI sẽ tự động được cập nhật mà không cần phải làm thủ công.
- **Đơn giản và dễ sử dụng**: Không yêu cầu kiến thức về các giải pháp quản lý trạng thái phức tạp.

# Hướng dẫn Clone source code và test Package
1. Clone source code về thông qua lệnh:
```terminal
git clone https://github.com/hieubdn/Flutter-Package-State-Manager.git
```
2. Để chạy file test của Package:
```
flutter test
```
3. Để xem UI test
```
cd example

flutter run
```

# Cài đặt & Hướng dẫn sử dụng Package
## Cài đặt Package

Để sử dụng `flutter_package_state_manager` trong dự án Flutter của bạn, làm theo các bước sau:

1. Mở file `pubspec.yaml` của dự án Flutter.
2. Thêm `flutter_package_state_manager` vào phần `dependencies`:

``` yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_package_state_manager: ^1.0.0
```
3. Chạy lệnh sau để cài đặt package:
```
flutter pub get
```
## Hướng dẫn sử dụng 
Để sử dụng package này, bạn cần làm theo các bước sau:

### 1. Khởi tạo và sử dụng `StateManager`

Để sử dụng `StateManager`, bạn cần tạo một instance của nó trong ứng dụng Flutter của bạn.
```dart
final stateManager = StateManager();
```

### 2. Tạo và quản lý trạng thái

Bạn có thể tạo một trạng thái với bất kỳ kiểu dữ liệu nào mà bạn muốn `(Ví dụ, để tạo một danh sách các item (List<String>))` bạn sẽ làm như sau:

```dart
stateManager.createState<List<String>>('itemList', []);
```

### 3. Quan sát thay đổi trạng thái
Để cập nhật UI khi trạng thái thay đổi, bạn cần sử dụng phương thức `observeState`. Phương thức này sẽ cho phép bạn theo dõi sự thay đổi của trạng thái và tự động cập nhật UI khi có thay đổi.

```dart
stateManager.observeState('itemList', () {
  setState(() {
    // UI sẽ được cập nhật mỗi khi trạng thái thay đổi
  });
});
```

### 4. Thêm item vào danh sách
Để thêm một item vào danh sách, bạn có thể sử dụng phương thức sau:

```dart
void _addItem() {
  // Lấy giá trị từ TextField
  final newItem = _controller.text;
  if (newItem.isNotEmpty) {
    final currentList = stateManager.getState<List<String>>('itemList');
    // Thêm item vào danh sách
    currentList.add(newItem);
    // Cập nhật trạng thái
    stateManager.updateState<List<String>>('itemList', currentList); 
    // Làm sạch TextField
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item Added')));
  }
}
```

### 5. Cập nhật item trong danh sách
Để cập nhật một item trong danh sách, bạn cần truyền vào vị trí của item và giá trị mới:

```dart
void _updateItem(int index, String newItem) {
  final currentList = stateManager.getState<List<String>>('itemList');
  // Cập nhật item tại index
  currentList[index] = newItem;
  // Cập nhật trạng thái
  stateManager.updateState<List<String>>('itemList', currentList); 
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item Updated')));
}
```

### 6. Xóa item khỏi danh sách
Để xóa một item khỏi danh sách, bạn có thể sử dụng phương thức sau:

```dart
void _removeItem(int index) {
  final currentList = stateManager.getState<List<String>>('itemList');
  // Xóa item tại index
  currentList.removeAt(index);
  // Cập nhật trạng thái
  stateManager.updateState<List<String>>('itemList', currentList); 
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item Deleted')));
}
```

### 7. Reset danh sách
Để reset lại danh sách `(xóa tất cả item trong danh sách)`, bạn có thể sử dụng phương thức sau:

```dart
void _resetList() {
  stateManager.updateState<List<String>>('itemList', []);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('List Reset')));
}
```

### 8. Hiển thị danh sách trong UI
Để hiển thị danh sách các item, bạn có thể sử dụng `StreamBuilder` để tự động cập nhật UI khi trạng thái thay đổi. Dưới đây là cách hiển thị danh sách:

```dart
Expanded(
  child: StreamBuilder<List<String>>(
    stream: Stream.periodic(const Duration(milliseconds: 100), (_) {
      return stateManager.getState<List<String>>('itemList');
    }),
    initialData: [],
    builder: (context, snapshot) {
      final itemList = snapshot.data ?? [];
      return ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(itemList[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeItem(index),
              ),
            ),
          );
        },
      );
    },
  ),
),
```

## Tóm tắt các phương thức chính
`createState<T>(String key, T initialState)`: Tạo một trạng thái mới với key và giá trị ban đầu `initialState`.

`getState<T>(String key)`: Lấy trạng thái hiện tại từ key.

`updateState<T>(String key, T newState)`: Cập nhật trạng thái với giá trị mới.

`observeState(String key, StateListener listener)`: Quan sát thay đổi của trạng thái và gọi listener khi có thay đổi.

## Lý do sử dụng flutter_package_state_manager

- **Đơn giản và dễ sử dụng**: Không cần phải học các khái niệm phức tạp, chỉ cần tạo trạng thái và cập nhật nó.
- **Cập nhật UI tự động**: UI sẽ tự động được cập nhật mỗi khi trạng thái thay đổi.
- **Không phụ thuộc vào các giải pháp quản lý trạng thái phức tạp**: Giải pháp nhẹ và dễ dàng tích hợp vào dự án Flutter của bạn.

# Tài liệu tham khảo
* [Flutter State Management](https://pub.dev/packages/flutter_package_state_manager)
