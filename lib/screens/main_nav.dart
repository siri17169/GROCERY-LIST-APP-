import 'package:flutter/material.dart';
import '../models/grocery_item.dart';
import '../models/grocery_list.dart';
import '../data/categories_data.dart';
import 'home_tab.dart';
import 'lists_tab.dart';
import 'category_tab.dart';
import 'logout_page.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;
  int _activeListIndex = 0;

  List<GroceryList> allLists = [
    GroceryList(title: "Weekly Shopping", items: [
      GroceryItem(name: "Apples", qty: "5", unit: "pcs", category: "Fruits", emoji: "🍎"),
    ]),
  ];

  void _createNewList() {
    final titleC = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("New Grocery List"),
        content: TextField(controller: titleC, decoration: const InputDecoration(hintText: "Enter Name...")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {
            if (titleC.text.isNotEmpty) {
              setState(() {
                allLists.add(GroceryList(title: titleC.text, items: []));
                _activeListIndex = allLists.length - 1;
                _currentIndex = 0;
              });
              Navigator.pop(context);
            }
          }, child: const Text("Create")),
        ],
      ),
    );
  }

  void _addOrEditItem({GroceryItem? oldItem}) {
    final nameC = TextEditingController(text: oldItem?.name ?? "");
    String q = oldItem?.qty ?? "1";
    String u = oldItem?.unit ?? "pcs";
    String c = oldItem?.category ?? "Vegetables";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder(builder: (context, setST) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(oldItem == null ? "Add New Item" : "Edit Item", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: nameC, decoration: const InputDecoration(labelText: "Item Name", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))))),
              const SizedBox(height: 15),
              Row(children: [
                Expanded(child: _drop("Qty", q, ["1", "2", "5", "10", "25"], (v) => setST(() => q = v!))),
                const SizedBox(width: 10),
                Expanded(child: _drop("Unit", u, ["pcs", "kg", "L", "g", "pkt"], (v) => setST(() => u = v!))),
              ]),
              const SizedBox(height: 15),
              _drop("Category", c, categoriesData.map((e) => e['n'] as String).toList(), (v) => setST(() => c = v!)),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  if (nameC.text.isNotEmpty) {
                    setState(() {
                      String emoji = categoriesData.firstWhere((cat) => cat['n'] == c)['i'];
                      if (oldItem == null) {
                        allLists[_activeListIndex].items.add(GroceryItem(name: nameC.text, qty: q, unit: u, category: c, emoji: emoji));
                      } else {
                        oldItem.name = nameC.text; oldItem.qty = q; oldItem.unit = u; oldItem.category = c; oldItem.emoji = emoji;
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Item", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _drop(String l, String val, List<String> opts, ValueChanged<String?> onCh) => DropdownButtonFormField<String>(
    initialValue: val,
    decoration: InputDecoration(labelText: l, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    items: opts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    onChanged: onCh,
  );

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeTab(
        list: allLists[_activeListIndex],
        onAdd: _addOrEditItem,
        onEdit: (item) => _addOrEditItem(oldItem: item),
        onDelete: (item) => setState(() => allLists[_activeListIndex].items.remove(item)),
        onRefresh: () => setState(() {}),
      ),
      ListsTab(
        lists: allLists,
        onCreate: _createNewList,
        onSelect: (i) => setState(() {
          _activeListIndex = i;
          _currentIndex = 0;
        }),
      ),
      CategoryTab(items: allLists[_activeListIndex].items),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        title: Text(allLists[_activeListIndex].title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LogoutPage())),
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: "Lists"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Categories"),
        ],
      ),
    );
  }
}
