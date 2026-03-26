import 'package:flutter/material.dart';

void main() {
  runApp(const GroceryListApp());
}

class GroceryListApp extends StatelessWidget {
  const GroceryListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      home: const GroceryListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({Key? key}) : super(key: key);

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  int currentNavIndex = 0;
  final List<GroceryListModel> lists = [
    GroceryListModel(
      id: '1',
      name: 'Weekly Shopping',
      items: [
        GroceryItemModel(
          id: '1',
          name: 'Apples',
          quantity: 5,
          unit: 'pcs',
          category: 'Fruits',
          emoji: '🍎',
          isCompleted: false,
          notes: 'Red apples preferred',
        ),
        GroceryItemModel(
          id: '2',
          name: 'Milk',
          quantity: 2,
          unit: 'L',
          category: 'Dairy',
          emoji: '🥛',
          isCompleted: false,
          notes: 'Full fat',
        ),
        GroceryItemModel(
          id: '3',
          name: 'Spinach',
          quantity: 500,
          unit: 'g',
          category: 'Vegetables',
          emoji: '🥬',
          isCompleted: false,
          notes: 'Fresh spinach',
        ),
      ],
    ),
  ];

  GroceryListModel? activeList;

  @override
  void initState() {
    super.initState();
    if (lists.isNotEmpty) {
      activeList = lists.first;
    }
  }

  void addList(String name) {
    setState(() {
      lists.add(
        GroceryListModel(
          id: DateTime.now().toString(),
          name: name,
          items: [],
        ),
      );
    });
  }

  void deleteList(String id) {
    setState(() {
      lists.removeWhere((list) => list.id == id);
      if (activeList?.id == id) {
        activeList = lists.isNotEmpty ? lists.first : null;
      }
    });
  }

  void addItem(
    String name,
    int quantity,
    String unit,
    String category,
    String emoji,
    String notes,
  ) {
    if (activeList != null) {
      setState(() {
        activeList!.items.add(
          GroceryItemModel(
            id: DateTime.now().toString(),
            name: name,
            quantity: quantity,
            unit: unit,
            category: category,
            emoji: emoji,
            isCompleted: false,
            notes: notes.isEmpty ? null : notes,
          ),
        );
      });
    }
  }

  void toggleItem(String id) {
    if (activeList != null) {
      setState(() {
        final index = activeList!.items.indexWhere((item) => item.id == id);
        if (index != -1) {
          activeList!.items[index].isCompleted =
              !activeList!.items[index].isCompleted;
        }
      });
    }
  }

  void deleteItem(String id) {
    if (activeList != null) {
      setState(() {
        activeList!.items.removeWhere((item) => item.id == id);
      });
    }
  }

  void editItem(
    String id,
    String name,
    int quantity,
    String unit,
    String category,
    String emoji,
    String notes,
  ) {
    if (activeList != null) {
      setState(() {
        final index = activeList!.items.indexWhere((item) => item.id == id);
        if (index != -1) {
          activeList!.items[index] = GroceryItemModel(
            id: id,
            name: name,
            quantity: quantity,
            unit: unit,
            category: category,
            emoji: emoji,
            isCompleted: activeList!.items[index].isCompleted,
            notes: notes.isEmpty ? null : notes,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '🛒 Grocery List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        actions: [
          if (activeList != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${activeList!.items.length} items',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: currentNavIndex == 0
          ? _buildHomeScreen()
          : currentNavIndex == 1
              ? _buildListsScreen()
              : _buildCategoriesScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            activeIcon: Icon(Icons.list),
            label: 'Lists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
        ],
      ),
      floatingActionButton: currentNavIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                if (activeList != null) {
                  _showAddItemDialog(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Create a list first')),
                  );
                }
              },
              backgroundColor: Colors.green.shade700,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildHomeScreen() {
    if (activeList == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 20),
            Text(
              'No List Selected',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Create or select a list to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  activeList!.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      'Total',
                      '${activeList!.items.length}',
                    ),
                    _buildStatColumn(
                      'Completed',
                      '${activeList!.items.where((item) => item.isCompleted).length}',
                    ),
                    _buildStatColumn(
                      'Pending',
                      '${activeList!.items.where((item) => !item.isCompleted).length}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildProgressBar(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green.shade700, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (activeList!.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 60,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No items yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: activeList!.items.length,
              itemBuilder: (context, index) {
                return _buildGroceryItemCard(activeList!.items[index]);
              },
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    if (activeList!.items.isEmpty) {
      return const SizedBox();
    }

    final completed = activeList!.items.where((item) => item.isCompleted).length;
    final total = activeList!.items.length;
    final progress = completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progress',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildGroceryItemCard(GroceryItemModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: item.isCompleted ? Colors.grey.shade50 : Colors.white,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: GestureDetector(
            onTap: () => toggleItem(item.id),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.isCompleted
                      ? Colors.green.shade700
                      : Colors.grey.shade300,
                  width: 2,
                ),
                color: item.isCompleted ? Colors.green.shade700 : Colors.white,
              ),
              child: item.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          title: Text(
            '${item.emoji} ${item.name}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              color: item.isCompleted ? Colors.grey.shade500 : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${item.quantity} ${item.unit} • ${item.category}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              if (item.notes != null && item.notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    item.notes!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => _showEditItemDialog(context, item),
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  deleteItem(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item deleted')),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListsScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _showCreateListDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Create New List'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: lists.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list_outlined,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No lists yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: lists.length,
                  itemBuilder: (context, index) {
                    final list = lists[index];
                    final isActive = activeList?.id == list.id;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: isActive ? 4 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isActive
                              ? Colors.green.shade700
                              : Colors.grey.shade200,
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isActive
                              ? Colors.green.shade50
                              : Colors.white,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            list.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? Colors.green.shade700
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            '${list.items.length} items • ${list.items.where((item) => item.isCompleted).length} completed',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              activeList = list;
                              currentNavIndex = 0;
                            });
                          },
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {
                                  deleteList(list.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('List deleted')),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoriesScreen() {
    const categories = [
      ('Fruits', '🍎', Color.fromARGB(255, 255, 107, 107)),
      ('Vegetables', '🥦', Color.fromARGB(255, 76, 175, 80)),
      ('Dairy', '🥛', Color.fromARGB(255, 255, 193, 7)),
      ('Snacks', '🍿', Color.fromARGB(255, 255, 152, 0)),
      ('Bakery', '🍞', Color.fromARGB(255, 205, 127, 50)),
      ('Beverages', '🥤', Color.fromARGB(255, 33, 150, 243)),
      ('Meat & Fish', '🥩', Color.fromARGB(255, 156, 39, 176)),
      ('Other', '📦', Color.fromARGB(255, 158, 158, 158)),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final (categoryName, emoji, color) = categories[index];
        final itemsInCategory = activeList?.items
                .where((item) => item.category == categoryName)
                .length ??
            0;

        return GestureDetector(
          onTap: () => _showCategoryDetails(context, categoryName),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.5),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    categoryName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$itemsInCategory items',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    final notesController = TextEditingController();

    String selectedUnit = 'pcs';
    String selectedCategory = 'Vegetables';
    String selectedEmoji = '🥦';

    final categoryEmojis = {
      'Fruits': '🍎',
      'Vegetables': '🥦',
      'Dairy': '🥛',
      'Snacks': '🍿',
      'Bakery': '🍞',
      'Beverages': '🥤',
      'Meat & Fish': '🥩',
      'Other': '📦',
    };

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Item'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      hintText: 'Enter item name',
                      prefixIcon: const Icon(Icons.shopping_bag_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green.shade700,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: selectedUnit,
                          decoration: InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: ['pcs', 'kg', 'g', 'L', 'ml', 'cup', 'tbsp', 'dozen']
                              .map((unit) =>
                                  DropdownMenuItem(value: unit, child: Text(unit)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedUnit = value ?? 'pcs'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: categoryEmojis.keys
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value ?? 'Vegetables';
                        selectedEmoji = categoryEmojis[selectedCategory] ?? '📦';
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Add notes...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final quantity = int.tryParse(quantityController.text) ?? 1;
                    addItem(
                      nameController.text,
                      quantity,
                      selectedUnit,
                      selectedCategory,
                      selectedEmoji,
                      notesController.text,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item added successfully'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Item',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, GroceryItemModel item) {
    final nameController = TextEditingController(text: item.name);
    final quantityController = TextEditingController(text: item.quantity.toString());
    final notesController = TextEditingController(text: item.notes ?? '');

    String selectedUnit = item.unit;
    String selectedCategory = item.category;

    final categoryEmojis = {
      'Fruits': '🍎',
      'Vegetables': '🥦',
      'Dairy': '🥛',
      'Snacks': '🍿',
      'Bakery': '🍞',
      'Beverages': '🥤',
      'Meat & Fish': '🥩',
      'Other': '📦',
    };
//to show dialog//
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Item'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: selectedUnit,
                          decoration: InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: ['pcs', 'kg', 'g', 'L', 'ml', 'cup', 'tbsp', 'dozen']
                              .map((unit) =>
                                  DropdownMenuItem(value: unit, child: Text(unit)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedUnit = value ?? 'pcs'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: categoryEmojis.keys
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedCategory = value ?? 'Vegetables'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: 'Notes (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final quantity = int.tryParse(quantityController.text) ?? 1;
                    editItem(
                      item.id,
                      nameController.text,
                      quantity,
                      selectedUnit,
                      selectedCategory,
                      categoryEmojis[selectedCategory] ?? '📦',
                      notesController.text,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item updated successfully'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Update Item',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create List'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'List Name',
              hintText: 'e.g., Weekly Shopping',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  addList(nameController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('List created successfully'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryDetails(BuildContext context, String category) {
    final itemsInCategory = activeList?.items
            .where((item) => item.category == category)
            .toList() ??
        [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              if (itemsInCategory.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      'No items in this category',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: itemsInCategory.length,
                    itemBuilder: (context, index) {
                      final item = itemsInCategory[index];
                      return ListTile(
                        leading: Checkbox(
                          value: item.isCompleted,
                          onChanged: (_) {
                            toggleItem(item.id);
                            Navigator.pop(context);
                          },
                          activeColor: Colors.green.shade700,
                        ),
                        title: Text(
                          '${item.emoji} ${item.name}',
                          style: TextStyle(
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.isCompleted
                                ? Colors.grey.shade500
                                : Colors.black,
                          ),
                        ),
                        subtitle: Text('${item.quantity} ${item.unit}'),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class GroceryItemModel {
  final String id;
  String name;
  int quantity;
  String unit;
  String category;
  String emoji;
  String? notes;
  bool isCompleted;

  GroceryItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.emoji,
    this.notes,
    this.isCompleted = false,
  });
}

class GroceryListModel {
  final String id;
  String name;
  List<GroceryItemModel> items;

  GroceryListModel({
    required this.id,
    required this.name,
    required this.items,
  });
}