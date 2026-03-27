import 'package:flutter/material.dart';
import '../models/grocery_item.dart';
import '../models/grocery_list.dart';

class HomeTab extends StatelessWidget {
  final GroceryList list;
  final VoidCallback onAdd;
  final VoidCallback onRefresh;
  final Function(GroceryItem) onEdit;
  final Function(GroceryItem) onDelete;

  const HomeTab({
    super.key,
    required this.list,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    int done = list.items.where((i) => i.isChecked).length;
    double prog = list.items.isEmpty ? 0 : done / list.items.length;
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF43A047)]),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat("${list.items.length}", "Total"),
              _stat("$done", "Done"),
              _stat("${list.items.length - done}", "Left"),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(value: prog, minHeight: 8, color: Colors.white, backgroundColor: Colors.white24),
        ]),
      ),
      Expanded(
        child: list.items.isEmpty
            ? const Center(child: Text("Empty List. Tap + to add items!"))
            : ListView.builder(
                itemCount: list.items.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, i) {
                  final item = list.items[i];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      onTap: () {
                        item.isChecked = !item.isChecked;
                        onRefresh();
                      },
                      leading: Icon(
                        item.isChecked ? Icons.check_circle : Icons.circle_outlined,
                        color: item.isChecked ? Colors.green : Colors.grey,
                      ),
                      title: Text(
                        "${item.emoji} ${item.name}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: item.isChecked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text("${item.qty} ${item.unit} • ${item.category}"),
                      trailing: PopupMenuButton(
                        onSelected: (v) => v == 'edit' ? onEdit(item) : onDelete(item),
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text("Edit")),
                          const PopupMenuItem(value: 'delete', child: Text("Delete", style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: onAdd,
          label: const Text("Add Item", style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    ]);
  }

  Widget _stat(String v, String l) => Column(children: [
        Text(v, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(l, style: const TextStyle(color: Colors.white70)),
      ]);
}
