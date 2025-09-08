import 'package:flutter/material.dart';
import 'package:pixel_pos/data/database_category_service.dart';
import 'package:pixel_pos/data/database_invoice_service.dart';
import 'package:pixel_pos/data/database_products_service.dart';
import 'package:pixel_pos/data/database_sale_order_service.dart';
import 'package:pixel_pos/theme/app_theme.dart';
import 'package:pixel_pos/utils/horizontal_scroll_behavior.dart';

class PosOrderScreen extends StatefulWidget {
  final int? invoiceId;
  final void Function(int, {int? invoiceId}) onTabChange;
  const PosOrderScreen({super.key, this.invoiceId, required this.onTabChange});

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
  final List<Map<String, dynamic>> _selectedProducts = [];

  final TextEditingController _invoiceNameController = TextEditingController();

  int? _selectedCategory;

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
      if (_selectedCategory == id) {
        _selectedCategory = null;
        _filteredProducts = _products;
      } else {
        _selectedCategory = id;
        _filteredProducts = _products
            .where((prod) => prod['category_id'] == id)
            .toList();
      }
    });
  }

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _selectedProducts.add(product);
    });
  }

  void removeProduct(int index) {
    _selectedProducts.removeAt(index);
  }

  Future<void> _placeOrder() async {
    // validation
    if (_invoiceNameController.text.isEmpty || _selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invoice name and products are required")),
      );
      return;
    }
    // calculate total
    double total = _selectedProducts.fold(
      0,
      (sum, prod) => sum + (prod['price'] as num).toDouble(),
    );

    // create / update invoice
    int invoiceId;

    if (widget.invoiceId == null) {
      invoiceId = await _dbInvoiceService.createInvoice(
        _invoiceNameController.text,
        'pending',
        total,
      );
    } else {
      invoiceId = widget.invoiceId!;
      await _dbInvoiceService.updateInvoice(
        invoiceId,
        _invoiceNameController.text,
        'pending',
        total,
      );
    }

    // clear old sale orders if editing existed
    if (widget.invoiceId != null) {
      final saleOrders = await _dbSaleOrderService.getSaleOrdersByInvoiceId(
        invoiceId,
      );
      for (final saleOrder in saleOrders) {
        await _dbSaleOrderService.deleteSaleOrder(saleOrder['id']);
      }
    }

    // create sale orders
    for (final prod in _selectedProducts) {
      await _dbSaleOrderService.createSaleOrder(prod['id'], invoiceId);
    }

    // reset state
    setState(() {
      _selectedProducts.clear();
      _invoiceNameController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully")),
      );
    }
  }

  Future<void> _loadInvoice(int invoiceId) async {
    // fetch invoice and its sale orders from DB
    final invoice = await _dbInvoiceService.getInvoiceById(invoiceId);
    if (invoice == null) return;

    final saleOrders = await _dbSaleOrderService.getSaleOrdersByInvoiceId(
      invoiceId,
    );
    final products = <Map<String, dynamic>>[];
    for (final saleOrder in saleOrders) {
      final prod = _products.firstWhere(
        (p) => p['id'] == saleOrder['product_id'],
      );
      products.add(prod);
    }
    // setState with invoice and orders
    setState(() {
      _invoiceNameController.text = invoice['name'];
      _selectedProducts.clear();
      _selectedProducts.addAll(products);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndProducts();

    if (widget.invoiceId != null) {
      debugPrint('loaded invoice: ${widget.invoiceId}');
      _loadInvoice(widget.invoiceId!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _invoiceNameController.dispose();
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
                                backgroundColor: _selectedCategory == cat['id']
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
                            onTap: () => _addProduct(prod),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            controller: _invoiceNameController,
            decoration: const InputDecoration(
              labelText: "Invoice name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedProducts.isEmpty
                ? const Center(child: Text("No products added"))
                : ListView.builder(
                    itemCount: _selectedProducts.length,
                    itemBuilder: (context, index) {
                      final prod = _selectedProducts[index];
                      return Dismissible(
                        key: ValueKey(prod['id'].toString() + index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: AppTheme.errorColor,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete),
                        ),
                        child: ListTile(
                          title: Text(prod['name']),
                          subtitle: Text(prod['price'].toString()),
                        ),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: _placeOrder,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text("Place Order"),
          ),
        ],
      ),
    );
  }
}
