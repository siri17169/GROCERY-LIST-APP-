import 'package:flutter/material.dart';
import 'main.dart'; // To access GroceryItem and categoriesData

class CategoryTab extends StatelessWidget {
  final List<GroceryItem> items;
  const CategoryTab({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
      itemCount: categoriesData.length,
      itemBuilder: (context, i) {
        final cat = categoriesData[i];
        final filtered = items.where((item) => item.category == cat['n']).toList();
        return Hero(
          tag: "cat-${cat['n']}",
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CatDetail(name: cat['n'], items: filtered, color: cat['c']))),
            child: Container(
              decoration: BoxDecoration(color: cat['c'], borderRadius: BorderRadius.circular(24)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(backgroundColor: Colors.white54, child: Text(cat['i'], style: const TextStyle(fontSize: 24))),
                const SizedBox(height: 8),
                Text(cat['n'], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text("${filtered.length} items", style: const TextStyle(fontSize: 10, color: Colors.black54)),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class CatDetail extends StatelessWidget {
  final String name; final List<GroceryItem> items; final Color color;
  const CatDetail({super.key, required this.name, required this.items, required this.color});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: color),
      body: items.isEmpty ? const Center(child: Text("Empty Category")) : ListView.builder(padding: const EdgeInsets.all(16), itemCount: items.length, itemBuilder: (context, i) => Card(child: ListTile(leading: Text(items[i].emoji), title: Text(items[i].name)))),
    );
  }
}