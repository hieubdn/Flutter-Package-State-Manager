<h1 align="center"> FLUTTER PACKAGE STATE MANAGER</h1>

<p align="center">
  <img src="https://img.shields.io/github/last-commit/hieubdn/Flutter-Package-State-Manager" />
  <img src="https://img.shields.io/badge/Updated-May-blue" />
  <img src="https://img.shields.io/badge/Dart-60%25-blue?logo=dart" />
  <img src="https://img.shields.io/github/languages/count/hieubdn/Flutter-Package-State-Manager" />
</p>

---

### <p align="center">Built with the tools and technologies:</p>

<p align="center">
  <img src="https://img.shields.io/badge/Dart-blue?logo=dart" />
  <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter" />
  <img src="https://img.shields.io/badge/Markdown-000000?logo=markdown" />
  <img src="https://img.shields.io/badge/JSON-000000?logo=json" />
  <img src="https://img.shields.io/badge/Test%20Driven-Testing-red?logo=testing-library" />
  <img src="https://img.shields.io/badge/Testing-green" /> </br>
  <img src="https://img.shields.io/badge/State%20Management-grey" />
  <img src="https://img.shields.io/badge/Custom%20Lightweight-purple" />
  <img src="https://img.shields.io/badge/No%20Bloc%2FProvider%2FRiverpod-lightgrey" />
</p>



## Introduction

`flutter_package_state_manager` is a lightweight, simple, and easy-to-use Flutter package that enables efficient state management without the need to integrate complex solutions like `Provider`, `Riverpod`, or `Bloc`.  
This package allows you to create and manage widget states with ease, enabling straightforward add, update, and delete operations without requiring advanced state management knowledge.


## Benefits

- **Easy state management**: Provides methods to store and update the application's state.
- **Automatic UI updates**: The UI is automatically refreshed when the state changes, without any manual intervention.
- **Simple and user-friendly**: Does not require knowledge of complex state management solutions.

## Guide to Cloning the Source Code and Testing the Package
1. Clone the source code using the command:
```terminal
git clone https://github.com/hieubdn/Flutter-Package-State-Manager.git
```
2. To run the package's test file:
```
flutter test
```
3. To view the UI test:
```
cd example

flutter run
```

## Installation & Usage Guide
### Installing the Package

To use `flutter_package_state_manager` in your Flutter project, follow these steps:

1. Open the `pubspec.yaml` file of your Flutter project.
2. Add `flutter_package_state_manager` under the `dependencies` section:


``` yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_package_state_manager: ^1.0.0
```
3. Run the following command to install the package:
```
flutter pub get
```
### Usage Guide
To use this package, follow the steps below:

#### 1. Initialize and Use `StateManager`

To use `StateManager`, you need to create an instance of it in your Flutter application.
```dart
final stateManager = StateManager();
```

#### 2. Create and Manage State
You can create a state with any data type you prefer.  
(For example, to create a list of items (`List<String>`), you can do the following:)

```dart
stateManager.createState<List<String>>('itemList', []);
```

#### 3. Observe State Changes
To update the UI when the state changes, use the `observeState` method.  
This method allows you to listen for state changes and automatically refresh the UI accordingly.

```dart
stateManager.observeState('itemList', () {
  setState(() {
    // UI sẽ được cập nhật mỗi khi trạng thái thay đổi
  });
});
```

#### 4. Add an Item to the List
To add an item to the list, you can use the following method:

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

#### 5. Update an Item in the List
To update an item in the list, provide its index and the new value:

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

#### 6. Remove an Item from the List
To remove an item from the list, use the following method:

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

#### 7. Reset the List
To reset the list (i.e., remove all items), you can use the following method:

```dart
void _resetList() {
  stateManager.updateState<List<String>>('itemList', []);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('List Reset')));
}
```

#### 8. Display the List in the UI
To display the list of items, use a `StreamBuilder` to automatically update the UI when the state changes.  
Here’s how to render the list:

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

## Summary of Core Methods

- `createState<T>(String key, T initialState)`: Creates a new state with the given key and initial value `initialState`.
- `getState<T>(String key)`: Retrieves the current state by its key.
- `updateState<T>(String key, T newState)`: Updates the state with a new value.
- `observeState(String key, StateListener listener)`: Observes state changes and triggers the listener when updates occur.

---

## Why Use `flutter_package_state_manager`

- **Simple and easy to use**: No need to learn complex concepts—just create and update state.
- **Automatic UI updates**: The UI is refreshed automatically whenever the state changes.
- **No dependency on complex state management solutions**: A lightweight solution that’s easy to integrate into your Flutter project.

# References

* [Flutter State Management](https://pub.dev/packages/flutter_package_state_manager)
