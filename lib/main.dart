import 'package:flutter/material.dart';

void main() => runApp(const MeraDukhanApp());

class MeraDukhanApp extends StatelessWidget {
  const MeraDukhanApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF1F4F1),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}

// --- MODELS ---
class GroceryItem {
  String name, qty, unit, category, emoji;
  bool isChecked;
  GroceryItem({required this.name, required this.qty, required this.unit, required this.category, required this.emoji, this.isChecked = false});
}

class GroceryList {
  String title;
  List<GroceryItem> items;
  GroceryList({required this.title, required this.items});
}

// --- GLOBAL CATEGORY DATA ---
final List<Map<String, dynamic>> categoriesData = [
  {"n": "Fruits", "c": const Color(0xFFF8BBD0), "i": "🍎"},
  {"n": "Vegetables", "c": const Color(0xFFC8E6C9), "i": "🥦"},
  {"n": "Dairy", "c": const Color(0xFFFFF9C4), "i": "🥛"},
  {"n": "Meat & Fish", "c": const Color(0xFFFFCDD2), "i": "🥩"},
  {"n": "Bakery", "c": const Color(0xFFD7CCC8), "i": "🍞"},
  {"n": "Snacks", "c": const Color(0xFFFFE0B2), "i": "🍿"},
  {"n": "Beverages", "c": const Color(0xFFBBDEFB), "i": "🥤"},
  {"n": "Grains", "c": const Color(0xFFF5F5F5), "i": "🌾"},
  {"n": "Frozen", "c": const Color(0xFFE1F5FE), "i": "🧊"},
  {"n": "Household", "c": const Color(0xFFE1BEE7), "i": "🧼"},
  {"n": "Personal Care", "c": const Color(0xFFF3E5F5), "i": "🧴"},
  {"n": "Spices", "c": const Color(0xFFFFE082), "i": "🌶️"},
];

// --- LOGIN PAGE ---
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_basket_outlined, size: 100, color: Colors.white),
            const Text("MeraDukhan", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 40),
            _loginField("Email Address"), const SizedBox(height: 15),
            _loginField("Password", obscure: true), const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav())),
                child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _loginField(String hint, {bool obscure = false}) => TextField(
    obscureText: obscure,
    decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
  );
}

// --- NEW: LOGOUT PAGE ---
class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.exit_to_app, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              const Text("Logging Out?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Are you sure you want to exit MeraDukhan?", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false),
                  child: const Text("Yes, Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No, Take me back", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// --- MAIN NAVIGATION ---
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
        title: const Text("Create New List"),
        content: TextField(controller: titleC, decoration: const InputDecoration(hintText: "e.g. Monthly Ration")),
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
              TextField(controller: nameC, decoration: const InputDecoration(labelText: "Item Name", border: OutlineInputBorder())),
              const SizedBox(height: 15),
              Row(children: [
                Expanded(child: _drop("Qty", q, ["1", "2", "5", "10", "25", "50"], (v) => setST(() => q = v!))),
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
    value: val, decoration: InputDecoration(labelText: l, border: const OutlineInputBorder()),
    items: opts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    onChanged: onCh,
  );

  @override
  Widget build(BuildContext context) {
    final screens = [
      _HomeTab(
        list: allLists[_activeListIndex], 
        onAdd: _addOrEditItem, 
        onEdit: (item) => _addOrEditItem(oldItem: item), 
        onDelete: (item) => setState(() => allLists[_activeListIndex].items.remove(item)),
        onRefresh: () => setState(() {}),
      ),
      _ListsTab(lists: allLists, onCreate: _createNewList, onSelect: (i) => setState(() { _activeListIndex = i; _currentIndex = 0; })),
      _CategoryTab(items: allLists[_activeListIndex].items),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        title: Text(allLists[_activeListIndex].title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LogoutPage())),
          )
        ],
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: screens[_currentIndex]),
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

// --- TAB COMPONENTS (Home, Lists, Category) ---

class _HomeTab extends StatelessWidget {
  final GroceryList list;
  final VoidCallback onAdd, onRefresh;
  final Function(GroceryItem) onEdit, onDelete;
  const _HomeTab({required this.list, required this.onAdd, required this.onEdit, required this.onDelete, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    int done = list.items.where((i) => i.isChecked).length;
    double prog = list.items.isEmpty ? 0 : done / list.items.length;
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF43A047)]), borderRadius: BorderRadius.circular(25)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_stat("${list.items.length}", "Total"), _stat("$done", "Done"), _stat("${list.items.length - done}", "Left")]),
          const SizedBox(height: 20),
          LinearProgressIndicator(value: prog, minHeight: 8, color: Colors.white, backgroundColor: Colors.white24),
        ]),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: list.items.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, i) {
            final item = list.items[i];
            return Card(
              elevation: 0, margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                onTap: () { item.isChecked = !item.isChecked; onRefresh(); },
                leading: Icon(item.isChecked ? Icons.check_circle : Icons.circle_outlined, color: item.isChecked ? Colors.green : Colors.grey),
                title: Text("${item.emoji} ${item.name}", style: TextStyle(fontWeight: FontWeight.bold, decoration: item.isChecked ? TextDecoration.lineThrough : null)),
                subtitle: Text("${item.qty} ${item.unit} • ${item.category}"),
                trailing: PopupMenuButton(
                  onSelected: (v) => v == 'edit' ? onEdit(item) : onDelete(item),
                  itemBuilder: (_) => [const PopupMenuItem(value: 'edit', child: Text("Edit")), const PopupMenuItem(value: 'delete', child: Text("Delete", style: TextStyle(color: Colors.red)))],
                ),
              ),
            );
          },
        ),
      ),
      Padding(padding: const EdgeInsets.all(16), child: FloatingActionButton.extended(backgroundColor: Colors.green, onPressed: onAdd, label: const Text("Add Item", style: TextStyle(color: Colors.white)), icon: const Icon(Icons.add, color: Colors.white))),
    ]);
  }
  Widget _stat(String v, String l) => Column(children: [Text(v, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text(l, style: const TextStyle(color: Colors.white70))]);
}

class _ListsTab extends StatelessWidget {
  final List<GroceryList> lists;
  final VoidCallback onCreate;
  final Function(int) onSelect;
  const _ListsTab({required this.lists, required this.onCreate, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: onCreate, icon: const Icon(Icons.add, color: Colors.white), label: const Text("Create New List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(height: 25),
        Expanded(
          child: ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => onSelect(i),
              child: Card(
                color: const Color(0xFFE8F5E9), margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.green, width: 1.5)),
                child: ListTile(title: Text("${lists[i].title} 🛒", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)), subtitle: Text("${lists[i].items.length} items")),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final List<GroceryItem> items;
  const _CategoryTab({required this.items});

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
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _CatDetail(name: cat['n'], items: filtered, color: cat['c']))),
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

class _CatDetail extends StatelessWidget {
  final String name; final List<GroceryItem> items; final Color color;
  const _CatDetail({required this.name, required this.items, required this.color});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: color),
      body: items.isEmpty ? const Center(child: Text("No items here!")) : ListView.builder(padding: const EdgeInsets.all(16), itemCount: items.length, itemBuilder: (context, i) => Card(child: ListTile(leading: Text(items[i].emoji), title: Text(items[i].name)))),
    );
  }
}

import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: Colors.green, // Matching your grocery theme
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.exit_to_app,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                "Are you sure you want to log out?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "You will need to enter your credentials to access your grocery list again.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    // 1. Clear user session logic goes here
                    
                    // 2. Navigate back to Login Screen and clear navigation stack
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      '/login', 
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}