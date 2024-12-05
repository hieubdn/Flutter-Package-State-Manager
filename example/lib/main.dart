import 'package:flutter/material.dart';
import 'package:flutter_package_state_manager/flutter_package_state_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management Hiubdn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StateManagementScreen(),
    );
  }
}

class StateManagementScreen extends StatefulWidget {
  const StateManagementScreen({Key? key}) : super(key: key);

  @override
  _StateManagementScreenState createState() => _StateManagementScreenState();
}

class _StateManagementScreenState extends State<StateManagementScreen> {
  final stateManager = StateManager();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    stateManager.createState<List<String>>('itemList', []);
    stateManager.observeState('itemList', () {
      setState(() {});
    });
  }

  // Thêm
  void _addItem() {
    final newItem = _controller.text;
    if (newItem.isNotEmpty) {
      final currentList = stateManager.getState<List<String>>('itemList');
      currentList.add(newItem); // Thêm item vào danh sách
      stateManager.updateState<List<String>>('itemList', currentList); // Cập nhật lại trạng thái
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item Added')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter an item')));
    }
  }

  // Cập nhật
  void _updateItem(int index, String newItem) {
    final currentList = stateManager.getState<List<String>>('itemList');
    currentList[index] = newItem;
    stateManager.updateState<List<String>>('itemList', currentList);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item Updated')));
  }

  // Xóa
  void _removeItem(int index) {
    final currentList = stateManager.getState<List<String>>('itemList');
    currentList.removeAt(index);
    stateManager.updateState<List<String>>('itemList', currentList);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item Deleted')));
  }

  // Reset 
  void _resetList() {
    stateManager.updateState<List<String>>('itemList', []);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('List Reset')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management style CRUD'),
        backgroundColor: const Color(0xFF5E5E5E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter item',
                labelStyle: TextStyle(color: const Color(0xFF5E5E5E)), 
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: const Color(0xFF919191)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E5E5E),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Add Item',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetList,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC6C6C6),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Reset List',
                style: TextStyle(color: Color(0xFF303030)),
              ),
            ),
            const SizedBox(height: 20),

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
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            itemList[index],
                            style: TextStyle(color: const Color(0xFF303030)), 
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: const Color(0xFF5E5E5E), 
                                onPressed: () {
                                  _controller.text = itemList[index];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Edit Item'),
                                        content: TextField(
                                          controller: _controller,
                                          decoration: const InputDecoration(
                                            labelText: 'Edit item',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              _updateItem(index, _controller.text);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Save'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: const Color(0xFF303030), 
                                onPressed: () => _removeItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
