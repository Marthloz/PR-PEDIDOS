import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_theme.dart';

class CustomerProductDetailScreen extends StatefulWidget {
  final Product product;
  final int? initialQuantity;
  final Map<String, int>? initialToppings;
  final String? initialInstructions;
  final bool isEditing;

  const CustomerProductDetailScreen({
    Key? key,
    required this.product,
    this.initialQuantity,
    this.initialToppings,
    this.initialInstructions,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _CustomerProductDetailScreenState createState() => _CustomerProductDetailScreenState();
}

class _CustomerProductDetailScreenState extends State<CustomerProductDetailScreen> {
  int _quantity = 1;
  String? _specialInstructions;
  Map<String, int> _selectedToppings = {}; // nombre del topping -> cantidad
  final TextEditingController _instructionsController = TextEditingController();

  double _calculateTotal() {
  double base = widget.product.price * _quantity;

  double toppingsTotal = widget.product.toppings.fold(0.0, (sum, topping) {
    final qty = _selectedToppings[topping.name] ?? 0;
    return sum + (qty * topping.extraCost);
  });

  return base + toppingsTotal;
}
@override
void initState() {
  super.initState();
  _quantity = widget.initialQuantity ?? 1;
  _selectedToppings = Map.from(widget.initialToppings ?? {});
  _specialInstructions = widget.initialInstructions;
  _instructionsController.text = _specialInstructions ?? '';
}

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Producto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 250,
              width: double.infinity,
              color: AppColors.cream,
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: 80,
                  color: AppColors.gold,
                ),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Bs. ${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  // Ingredients
                  if (widget.product.ingredients.isNotEmpty) ...[
                    SizedBox(height: 24),
                    Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.product.ingredients.map((ingredient) {
                        return Chip(
                          label: Text(ingredient),
                          backgroundColor: AppColors.cream,
                          labelStyle: TextStyle(color: AppColors.brown),
                        );
                      }).toList(),
                    ),
                  ],
                  
                  // Allergens
                  if (widget.product.allergens.isNotEmpty) ...[
                    SizedBox(height: 24),
                    Text(
                      'Alérgenos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.product.allergens.map((allergen) {
                        return Chip(
                          label: Text(allergen),
                          backgroundColor: Colors.red.withOpacity(0.1),
                          labelStyle: TextStyle(color: Colors.red),
                        );
                      }).toList(),
                    ),
                  ],
                  
                  // Toppings
                  if (widget.product.toppings.isNotEmpty) ...[
  SizedBox(height: 24),
  Text(
    'Toppings',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  SizedBox(height: 8),
  Column(
    children: widget.product.toppings.map((topping) {
      final count = _selectedToppings[topping.name] ?? 0;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('${topping.name} (+Bs. ${topping.extraCost.toStringAsFixed(2)} cada uno)'),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: count > 0
                      ? () {
                          setState(() {
                            _selectedToppings[topping.name] = count - 1;
                            if (_selectedToppings[topping.name] == 0) {
                              _selectedToppings.remove(topping.name);
                            }
                          });
                        }
                      : null,
                ),
                Text('$count'),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      _selectedToppings[topping.name] = count + 1;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }).toList(),
  ),
],

                  // Quantity Selector
                  SizedBox(height: 24),
                  Text(
                    'Cantidad',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        color: AppColors.brown,
                        onPressed: _quantity > 1
                            ? () {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$_quantity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        color: AppColors.brown,
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  
                  // Special Instructions
                  SizedBox(height: 24),
                  Text(
                    'Instrucciones Especiales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _instructionsController,
                    decoration: InputDecoration(
                      hintText: 'Ej: Sin cebolla, extra picante, etc.',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      _specialInstructions = value.isEmpty ? null : value;
                    },
                  ),
                  
                  // Total
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Bs. ${_calculateTotal().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  
                  // Add to Cart Button
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final cartProvider = Provider.of<CartProvider>(context, listen: false);
                        if (widget.isEditing) {
  cartProvider.removeFromCart(widget.product.id);
}
                        cartProvider.addToCart(
  widget.product,
  _quantity,
  _specialInstructions,
  selectedToppings: _selectedToppings,
);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
  content: Text(widget.isEditing
      ? 'Producto actualizado en el carrito'
      : 'Producto agregado al carrito'),
  backgroundColor: Colors.green,
  action: SnackBarAction(
    label: 'Ver Carrito',
    textColor: Colors.white,
    onPressed: () {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/cart');
    },
  ),
),
                        );
                        
                        Navigator.pop(context);
                      },
                      child: Text(
  widget.isEditing ? 'Actualizar Producto' : 'Agregar al Carrito',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

