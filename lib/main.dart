import 'package:flutter/material.dart';

void main() {
  runApp(const MeraDukhanApp());
}

// ----------------------------------------------------------------             
// SETUP & THEME
// ----------------------------------------------------------------
class MeraDukhanApp extends StatelessWidget {
  const MeraDukhanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeraDukhan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF1F4F1),
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const LoginPage(),
    );
  }
}

// ----------------------------------------------------------------
// DATA MODELS
// ----------------------------------------------------------------
class GroceryItem {
  String name, qty, unit, category, emoji;
  bool isChecked;
  GroceryItem({
    required this.name,
    required this.qty,
    required this.unit,
    required this.category,
    required this.emoji,
    this.isChecked = false,
  });
}

class GroceryList {
  String title;
  List<GroceryItem> items;
  GroceryList({required this.title, required this.items});
}

// ----------------------------------------------------------------
// REUSABLE UI COMPONENTS
// ----------------------------------------------------------------
final List<Map<String, dynamic>> categoriesData = [
  {"n": "Fruits", "c": const Color(0xFFF8BBD0), "i": "🍎"},
  {"n": "Vegetables", "c": const Color(0xFFC8E6C9), "i": "🥦"},
  {"n": "Dairy", "c": const Color(0xFFFFF9C4), "i": "🥛"},
  {"n": "Meat & Fish", "c": const Color(0xFFFFCDD2), "i": "🥩"},
  {"n": "Bakery", "c": const Color(0xFFD7CCC8), "i": "🍞"},
  {"n": "Snacks", "c": const Color(0xFFFFE0B2), "i": " popcorn"},
  {"n": "Beverages", "c": const Color(0xFFBBDEFB), "i": "🥤"},
  {"n": "Grains", "c": const Color(0xFFF5F5F5), "i": "🌾"},
  {"n": "Frozen", "c": const Color(0xFFE1F5FE), "i": "🧊"},
  {"n": "Household", "c": const Color(0xFFE1BEE7), "i": "🧼"},
  {"n": "Personal Care", "c": const Color(0xFFF3E5F5), "i": "🧴"},
  {"n": "Spices", "c": const Color(0xFFFFE082), "i": "🌶️"},
];

// ----------------------------------------------------------------
// PAGES: LOGIN
// ----------------------------------------------------------------
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF81C784), Color(0xFF388E3C)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Icon(Icons.shopping_basket_rounded, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text("MeraDukhan", 
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text("Your Smart Grocery Partner", 
                style: TextStyle(fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 60),
              _buildField(Icons.email_outlined, "Email Address"),
              const SizedBox(height: 20),
              _buildField(Icons.lock_outline, "Password", obscure: true),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF388E3C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const MainNav())),
                  child: const Text("GET STARTED", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {}, // Future: Signup Logic
                child: const Text("Create an Account", 
                  style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(IconData icon, String hint, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }
}

// ----------------------------------------------------------------
// PAGES: LOGOUT
// ----------------------------------------------------------------
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
              const Text("Are you sure you want to leave?", textAlign: TextAlign.center),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 50)),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false),
                child: const Text("Yes, Logout", style: TextStyle(color: Colors.white)),
              ),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// MAIN NAVIGATION & TABS
// ----------------------------------------------------------------
class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;
  int _activeListIndex = 0;

  List<GroceryList> allLists = [
    GroceryList(title: "My Grocery List", items: []),
  ];

  @override
  Widget build(BuildContext context) {
    final screens = [
      _HomeTab(
        list: allLists[_activeListIndex],
        onRefresh: () => setState(() {}),
      ),
      const Center(child: Text("Lists View (Coming Soon)")),
      const Center(child: Text("Categories View")),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        title: Text(allLists[_activeListIndex].title, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LogoutPage())),
          )
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lists"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Categories"),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final GroceryList list;
  final VoidCallback onRefresh;
  const _HomeTab({required this.list, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: list.items.isEmpty 
        ? const Text("No items yet. Ready to shop?") 
        : ListView(children: const []), // Simplified for demo
    );
  }
}