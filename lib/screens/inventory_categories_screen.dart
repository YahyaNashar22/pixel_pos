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

  Future<void> _loadCategories() async {
    final categoriesResult = await _dbCategoryService.getAllCategories();
    setState(() {
      _categories = categoriesResult;
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
          decoration: const InputDecoration(hintText: "Category name"),
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
          decoration: const InputDecoration(hintText: "Category name"),
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

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _categories.isEmpty
          ? const Center(child: Text("No categories found"))
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return ListTile(
                  title: Text(cat['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _editCategory(cat['id'], cat['name']),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}
