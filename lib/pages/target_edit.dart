import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/targetcat.dart';
import 'targetprovider.dart';


class TargetEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final targetProvider = Provider.of<TargetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Target Categories'),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: targetProvider.targets.length,
                itemBuilder: (context, index) {
                  final target = targetProvider.targets[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(target.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editTarget(context, target),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, targetProvider, target),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton.icon(
                onPressed: () => _addTarget(context),
                icon: Icon(Icons.add),
                label: Text('Add Target Category'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTarget(BuildContext context) {
    final targetProvider = Provider.of<TargetProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Target'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Target Category'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  targetProvider.addTarget(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _editTarget(BuildContext context, TargetCategory target) {
    final targetProvider = Provider.of<TargetProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: target.name);
        return AlertDialog(
          title: const Text('Edit Target'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Target Category'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  targetProvider.editTarget(target.id, controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, TargetProvider targetProvider, TargetCategory target) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Target'),
          content: const Text('Are you sure you want to delete this target?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                targetProvider.deleteTarget(target.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}