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
  List<Map<String, dynamic>> _filteredProducts = [];

  final TextEditingController _searchController = TextEditingController();

  Future<void> _loadData() async {
    final cats = await _dbCategoryService.getAllCategories();
    final prods = await _dbProductsService.getAllProductsWithCategory();

    setState(() {
      _categories = cats;
      _products = prods;
      _filteredProducts = prods;
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

  void _filterProducts(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((p) {
        final productName = p['name'].toString().toLowerCase();
        final categoryName = p['category_name'].toString().toLowerCase();
        return productName.contains(q) || categoryName.contains(q);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();

    _searchController.addListener(() {
      _filterProducts(_searchController.text);
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
                hintText: "Search by product or category...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text("No products found"))
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final prod = _filteredProducts[index];
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(prod['name']),
                            Text("${prod['price']}\$"),
                          ],
                        ),
                        subtitle: Text(
                          _getCategoryName(prod['category_id']),
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditProduct(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
