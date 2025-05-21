import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_theme.dart';
import 'customer_checkout_screen.dart';

class CustomerCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Vaciar Carrito'),
                    content: Text('¿Está seguro de vaciar el carrito?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cartProvider.clearCart();
                          Navigator.of(context).pop();
                        },
                        child: Text('Vaciar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Su carrito está vacío',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Agregue productos para realizar un pedido',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ver Menú'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.cream,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.restaurant,
                                    size: 32,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              // Product Info
                              Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        item.product.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      SizedBox(height: 4),

      // 🔸 Mostrar toppings
      if (item.selectedToppings.isNotEmpty) ...[
        Text(
          'Toppings:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        ...item.selectedToppings.entries.map((entry) => Text(
          '• ${entry.key} x${entry.value}',
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        )),
        SizedBox(height: 4),
      ],

      // 🔸 Mostrar instrucciones especiales
      if (item.specialInstructions != null) ...[
        Text(
          'Nota: ${item.specialInstructions}',
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
      ],

      // 🔸 Precio base x cantidad
      Text(
        'Bs. ${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
        style: TextStyle(
          color: Colors.grey[700],
        ),
      ),

      SizedBox(height: 8),

      // 🔸 Controles +/-
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove_circle),
            color: AppColors.brown,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              if (item.quantity > 1) {
                cartProvider.updateQuantity(item.product.id, item.quantity - 1);
              } else {
                cartProvider.removeFromCart(item.product.id);
              }
            },
          ),
          SizedBox(width: 8),
          Text(
            '${item.quantity}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.add_circle),
            color: AppColors.brown,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              cartProvider.updateQuantity(item.product.id, item.quantity + 1);
            },
          ),
          Spacer(),

          // 🔸 Total del producto con toppings
          Text(
            'Bs. ${item.total.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
          SizedBox(width: 8),
          IconButton(
  icon: Icon(Icons.edit),
  color: AppColors.brown,
  padding: EdgeInsets.zero,
  constraints: BoxConstraints(),
  onPressed: () {
    Navigator.pushNamed(
      context,
      '/edit-product', // creamos una ruta lógica
      arguments: {
        'product': item.product,
        'quantity': item.quantity,
        'toppings': item.selectedToppings,
        'instructions': item.specialInstructions,
      },
    );
  },
),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              cartProvider.removeFromCart(item.product.id);
            },
          ),
        ],
      ),
    ],
  ),
),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Order Summary
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Bs. ${cartProvider.subtotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Bs. ${cartProvider.total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerCheckoutScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Proceder al Pago',
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
    );
  }
}
