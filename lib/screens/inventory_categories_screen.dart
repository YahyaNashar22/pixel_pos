import 'package:flutter/material.dart';
import 'package:pixel_pos/data/database_category_service.dart';
import 'package:pixel_pos/theme/app_theme.dart';

class InventoryCategoriesScreen extends StatefulWidget {
  const InventoryCategoriesScreen({super.key});

  @override
  State<InventoryCategoriesScreen> createState() =>
      _InventoryCategoriesScreenState();
}

class _InventoryCategoriesScreenState extends State<InventoryCategoriesScreen> {
  final DatabaseCategoryService _dbCategoryService = DatabaseCategoryService();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];

  final TextEditingController _searchController = TextEditingController();

  Future<void> _loadCategories() async {
    final categoriesResult = await _dbCategoryService.getAllCategories();
    setState(() {
      _categories = categoriesResult;
      _filteredCategories = _categories;
    });
  }

  Future<void> _addCategory() async {
    final TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Add Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Category Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await _dbCategoryService.createCategory(controller.text);
                await _loadCategories();
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _editCategory(int id, String currentName) async {
    final TextEditingController controller = TextEditingController(
      text: currentName,
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Edit Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Category Name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await _dbCategoryService.updateCategory(id, controller.text);
                await _loadCategories();
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(int id) async {
    await _dbCategoryService.deleteCategory(id);
    await _loadCategories();
  }

  void _filterCategories(String query) {
    final String q = query.toLowerCase();
    setState(() {
      _filteredCategories = _categories.where((c) {
        final categoryName = c['name'].toString().toLowerCase();
        return categoryName.contains(q);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();

    _searchController.addListener(() {
      _filterCategories(_searchController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search category...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredCategories.isEmpty
                ? const Center(child: Text("No categories found"))
                : ListView.builder(
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, index) {
                      final cat = _filteredCategories[index];
                      return ListTile(
                        title: Text(cat['name']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  _editCategory(cat['id'], cat['name']),
                              icon: const Icon(
                                Icons.edit,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _deleteCategory(cat['id']),
                              icon: const Icon(
                                Icons.delete,
                                color: AppTheme.errorColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}
