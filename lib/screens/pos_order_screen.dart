import 'package:flutter/material.dart';
import 'package:pixel_pos/data/database_category_service.dart';
import 'package:pixel_pos/data/database_invoice_service.dart';
import 'package:pixel_pos/data/database_products_service.dart';
import 'package:pixel_pos/data/database_sale_order_service.dart';
import 'package:pixel_pos/theme/app_theme.dart';
import 'package:pixel_pos/utils/horizontal_scroll_behavior.dart';

class PosOrderScreen extends StatefulWidget {
  const PosOrderScreen({super.key});

  @override
  State<PosOrderScreen> createState() => _PosOrderScreenState();
}

class _PosOrderScreenState extends State<PosOrderScreen> {
  final DatabaseCategoryService _dbCategoryService = DatabaseCategoryService();
  final DatabaseProductService _dbProductService = DatabaseProductService();
  final DatabaseSaleOrderService _dbSaleOrderService =
      DatabaseSaleOrderService();
  final DatabaseInvoiceService _dbInvoiceService = DatabaseInvoiceService();

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  List<Map<String, dynamic>> _saleOrders = [];
  final Map<String, dynamic> _invoice = {};

  int? selectedCategory;

  Future<void> _fetchCategoriesAndProducts() async {
    final cats = await _dbCategoryService.getAllCategories();
    final prods = await _dbProductService.getAllProducts();
    setState(() {
      _categories = cats;
      _products = prods;
      _filteredProducts = prods;
    });
  }

  void _selectCategory(int id) {
    setState(() {
      if (selectedCategory == id) {
        selectedCategory = null;
        _filteredProducts = _products;
      } else {
        selectedCategory = id;
        _filteredProducts = _products
            .where((prod) => prod['category_id'] == id)
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT SIDE: Categories + Products
          _orderMenu(),
          // RIGHT SIDE: Invoice Preview
          _orderPreview(),
        ],
      ),
    );
  }

  Expanded _orderMenu() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Categories row
            _categories.isEmpty
                ? Center(child: const Text("No categories found!"))
                : SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width - 350,
                    child: ScrollConfiguration(
                      behavior: HorizontalScrollBehavior(),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedCategory == cat['id']
                                    ? AppTheme.secondaryColor
                                    : AppTheme.primaryColor,
                              ),
                              onPressed: () => _selectCategory(cat['id']),
                              child: Text(cat['name']),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            // Products grid
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(child: const Text("No products found!"))
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final prod = _filteredProducts[index];
                        return Card(
                          child: InkWell(
                            onTap: () {},
                            child: Center(child: Text(prod['name'])),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Container _orderPreview() {
    return Container(
      width: 350,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white12),
      child: Column(children: [Expanded(child: const Text("right"))]),
    );
  }
}
