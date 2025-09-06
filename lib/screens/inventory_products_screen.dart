import 'package:flutter/material.dart';
import 'package:pixel_pos/data/database_category_service.dart';
import 'package:pixel_pos/data/database_products_service.dart';
import 'package:pixel_pos/theme/app_theme.dart';

class InventoryProductsScreen extends StatefulWidget {
  const InventoryProductsScreen({super.key});

  @override
  State<InventoryProductsScreen> createState() =>
      _InventoryProductsScreenState();
}

class _InventoryProductsScreenState extends State<InventoryProductsScreen> {
  final DatabaseCategoryService _dbCategoryService = DatabaseCategoryService();
  final DatabaseProductService _dbProductsService = DatabaseProductService();

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _products = [];

  Future<void> _loadData() async {
    final cats = await _dbCategoryService.getAllCategories();
    final prods = await _dbProductsService.getAllProducts();

    setState(() {
      _categories = cats;
      _products = prods;
    });
  }

  Future<void> _addOrEditProduct({Map<String, dynamic>? product}) async {
    final TextEditingController nameController = TextEditingController(
      text: product?['name'] ?? "",
    );
    final TextEditingController priceController = TextEditingController(
      text: product?['price']?.toString() ?? "",
    );
    int? selectedCategoryId = product?['category_id'];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? "Add Product" : "Edit Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: selectedCategoryId,
              decoration: const InputDecoration(labelText: "Category"),
              items: _categories
                  .map(
                    (cat) => DropdownMenuItem<int>(
                      value: cat['id'],
                      child: Text(cat['name']),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                selectedCategoryId = val;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text) ?? 0.0;

              if (name.isNotEmpty && selectedCategoryId != null) {
                if (product == null) {
                  await _dbProductsService.createProduct(
                    name,
                    price,
                    selectedCategoryId!,
                  );
                } else {
                  await _dbProductsService.updateProduct(
                    product['id'],
                    name,
                    price,
                    selectedCategoryId!,
                  );
                }
                await _loadData();
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(product == null ? "Save" : "Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(int id) async {
    await _dbProductsService.deleteProduct(id);
    await _loadData();
  }

  String _getCategoryName(int categoryId) {
    final cat = _categories.firstWhere(
      (c) => c['id'] == categoryId,
      orElse: () => {'name': 'Unknown category'},
    );
    return cat['name'];
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _products.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final prod = _products[index];
                return ListTile(
                  title: Text("${prod['name']} - ${prod['price']}"),
                  subtitle: Text(_getCategoryName(prod['category_id'])),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _addOrEditProduct(product: prod),
                        icon: const Icon(
                          Icons.edit,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _deleteProduct(prod['id']),
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
        onPressed: () => _addOrEditProduct(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
