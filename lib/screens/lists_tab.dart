import 'package:flutter/material.dart';
import '../models/grocery_list.dart';

class ListsTab extends StatelessWidget {
  final List<GroceryList> lists;
  final VoidCallback onCreate;
  final Function(int) onSelect;

  const ListsTab({
    super.key,
    required this.lists,
    required this.onCreate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: onCreate,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Create New List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 25),
        Expanded(
          child: ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => onSelect(i),
              child: Card(
                color: const Color(0xFFE8F5E9),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.green, width: 1.5),
                ),
                child: ListTile(
                  title: Text("${lists[i].title} 🛒", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  subtitle: Text("${lists[i].items.length} items"),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
