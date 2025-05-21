import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/ToppingOption.dart';
import '../../models/order.dart';
import '../../utils/app_theme.dart';
import 'customer_order_success_screen.dart';

class CustomerCheckoutScreen extends StatefulWidget {
  @override
  _CustomerCheckoutScreenState createState() => _CustomerCheckoutScreenState();
}

class _CustomerCheckoutScreenState extends State<CustomerCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  String _deliveryType = 'pickup';
  String _paymentType = 'efectivo';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Finalizar Pedido'),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.gold,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Procesando su pedido...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información de Contacto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre Completo',
                        prefixIcon: Icon(Icons.person, color: AppColors.gold),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Número de WhatsApp',
                        prefixIcon: Icon(Icons.phone, color: AppColors.gold),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su número de WhatsApp';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        prefixIcon: Icon(Icons.email, color: AppColors.gold),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su correo electrónico';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Tipo de Entrega',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    RadioListTile<String>(
                      title: Text('Recoger en Restaurante'),
                      value: 'pickup',
                      groupValue: _deliveryType,
                      activeColor: AppColors.gold,
                      onChanged: (value) {
                        setState(() {
                          _deliveryType = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Entrega a Domicilio'),
                      value: 'delivery',
                      groupValue: _deliveryType,
                      activeColor: AppColors.gold,
                      onChanged: (value) {
                        setState(() {
                          _deliveryType = value!;
                        });
                      },
                    ),
                    if (_deliveryType == 'delivery') ...[
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Dirección de Entrega',
                          prefixIcon: Icon(Icons.location_on, color: AppColors.gold),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su dirección';
                          }
                          return null;
                        },
                      ),
                    ],
                    SizedBox(height: 24),
                    Text(
                      'Método de Pago',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    RadioListTile<String>(
                      title: Text('Efectivo'),
                      value: 'efectivo',
                      groupValue: _paymentType,
                      activeColor: AppColors.gold,
                      onChanged: (value) {
                        setState(() {
                          _paymentType = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Transferencia Bancaria'),
                      value: 'transferencia',
                      groupValue: _paymentType,
                      activeColor: AppColors.gold,
                      onChanged: (value) {
                        setState(() {
                          _paymentType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    // Resumen del Pedido
Text(
  'Resumen del Pedido',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
SizedBox(height: 16),
...cartProvider.items.map((item) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            '${item.quantity}x',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(item.product.name),
          ),
          Text(
            'Bs. ${(item.product.price * item.quantity).toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      if (item.selectedToppings.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(left: 32.0, top: 4.0, bottom: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: item.selectedToppings.entries.map((entry) {
        final toppingName = entry.key;
        final quantity = entry.value;
        final toppingPrice = item.product.toppings.firstWhere(
          (t) => t.name == toppingName,
          orElse: () => ToppingOption(name: toppingName, extraCost: 0),
        ).extraCost;

        return Text(
          '• ${quantity}x $toppingName (Bs. ${(quantity * toppingPrice).toStringAsFixed(2)})',
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        );
      }).toList(),
    ),
  ),
    ],
  );
}).toList(),

                    Divider(height: 32),
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
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (_deliveryType == 'delivery') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Costo de Entrega',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Bs. 10.00',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
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
                          'Bs. ${(_deliveryType == 'delivery' ? cartProvider.total + 10.0 : cartProvider.total).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitOrder,
                        child: Text(
                          'Confirmar Pedido',
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
            ),
    );
  }

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        
        final orderItems = cartProvider.items.map((item) => OrderItem(
          productId: item.product.id,
          productName: item.product.name,
          unitPrice: item.product.price,
          quantity: item.quantity,
          specialInstructions: item.specialInstructions,
          toppings: item.selectedToppings,
        )).toList();

        final order = Order(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          customerName: _nameController.text,
          whatsappNumber: _phoneController.text,
          deliveryType: _deliveryType,
          address: _deliveryType == 'delivery' ? _addressController.text : null,
          paymentType: _paymentType,
          status: 'pendiente',
          orderDate: DateTime.now(),
          items: orderItems,
          deliveryFee: _deliveryType == 'delivery' ? 10.0 : null,
          email: _emailController.text,
        );

        await orderProvider.addOrder(order);
        cartProvider.clearCart();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerOrderSuccessScreen(order: order),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar el pedido: $e'),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}