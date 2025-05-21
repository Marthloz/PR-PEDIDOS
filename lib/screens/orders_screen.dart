import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/responsive_wrapper.dart';
import '../models/order.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;
    
    // Filter orders based on selected filter
    List<Order> filteredOrders;
    switch (_selectedFilter) {
      case 'pending':
        filteredOrders = orders.where((order) => 
          order.status.toLowerCase() == 'pendiente').toList();
        break;
      case 'preparing':
        filteredOrders = orders.where((order) => 
          order.status.toLowerCase() == 'en preparación').toList();
        break;
      case 'delivered':
        filteredOrders = orders.where((order) => 
          order.status.toLowerCase() == 'entregado').toList();
        break;
      case 'cancelled':
        filteredOrders = orders.where((order) => 
          order.status.toLowerCase() == 'cancelado').toList();
        break;
      case 'today':
        filteredOrders = orders.where((order) => 
          order.orderDate.day == DateTime.now().day &&
          order.orderDate.month == DateTime.now().month &&
          order.orderDate.year == DateTime.now().year).toList();
        break;
      default:
        filteredOrders = orders;
    }
    
    // Sort orders by date (newest first)
    filteredOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    
    return ResponsiveWrapper(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestión de Pedidos',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todos', 'all'),
                  SizedBox(width: 8),
                  _buildFilterChip('Pendientes', 'pending'),
                  SizedBox(width: 8),
                  _buildFilterChip('En Preparación', 'preparing'),
                  SizedBox(width: 8),
                  _buildFilterChip('Entregados', 'delivered'),
                  SizedBox(width: 8),
                  _buildFilterChip('Cancelados', 'cancelled'),
                  SizedBox(width: 8),
                  _buildFilterChip('Hoy', 'today'),
                ],
              ),
            ),
            SizedBox(height: 16),
            
            // Orders List
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(child: Text('No hay pedidos disponibles'))
                  : ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        
                        return Card(
                          margin: EdgeInsets.only(bottom: 16),
                          child: ExpansionTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getStatusIcon(order.status),
                                color: _getStatusColor(order.status),
                              ),
                            ),
                            title: Text(
                              'Pedido #${order.id}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${order.customerName} • ${_formatDate(order.orderDate)}',
                            ),
                            trailing: Text(
                              'Bs. ${order.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.gold,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildInfoRow('Cliente', order.customerName),
                                              _buildInfoRow('WhatsApp', order.whatsappNumber),
                                              _buildInfoRow('Tipo de Entrega', order.deliveryType),
                                              _buildInfoRow('Dirección', order.address ?? 'N/A'),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildInfoRow('Fecha', _formatDate(order.orderDate)),
                                              _buildInfoRow('Hora', _formatTime(order.orderDate)),
                                              _buildInfoRow('Pago', order.paymentType),
                                              _buildInfoRow('Estado', order.status),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Productos',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: order.items.length,
                                      itemBuilder: (context, itemIndex) {
                                        final item = order.items[itemIndex];
                                        
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(item.productName),
                                          subtitle: item.specialInstructions != null
                                              ? Text('Nota: ${item.specialInstructions}')
                                              : null,
                                          trailing: Text(
                                            '${item.quantity} x Bs. ${item.unitPrice.toStringAsFixed(2)} = Bs. ${item.subtotal.toStringAsFixed(2)}',
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total: Bs. ${order.total.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildActionButton(
                                          'Aceptar',
                                          Icons.check_circle,
                                          Colors.green,
                                          order.status.toLowerCase() == 'pendiente',
                                          () {
                                            orderProvider.updateOrderStatus(order.id, 'en preparación');
                                          },
                                        ),
                                        _buildActionButton(
                                          'Preparando',
                                          Icons.restaurant,
                                          AppColors.gold,
                                          order.status.toLowerCase() == 'en preparación',
                                          () {
                                            // Update status to preparing
                                          },
                                        ),
                                        _buildActionButton(
                                          'Entregar',
                                          Icons.delivery_dining,
                                          AppColors.brown,
                                          order.status.toLowerCase() == 'en preparación',
                                          () {
                                            orderProvider.updateOrderStatus(order.id, 'entregado');
                                          },
                                        ),
                                        _buildActionButton(
                                          'Cancelar',
                                          Icons.cancel,
                                          Colors.red,
                                          order.status.toLowerCase() != 'entregado' && 
                                          order.status.toLowerCase() != 'cancelado',
                                          () {
                                            orderProvider.updateOrderStatus(order.id, 'cancelado');
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
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
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == value,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: AppColors.gold.withOpacity(0.2),
      checkmarkColor: AppColors.gold,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    bool isEnabled,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.withOpacity(0.3),
        disabledForegroundColor: Colors.grey,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'entregado':
        return Colors.green;
      case 'en preparación':
        return AppColors.gold;
      case 'pendiente':
        return AppColors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'entregado':
        return Icons.check_circle;
      case 'en preparación':
        return Icons.restaurant;
      case 'pendiente':
        return Icons.access_time;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
