import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../providers/menu_provider.dart';
import '../utils/app_theme.dart';
import 'menu_management_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    DashboardHomeScreen(),
    MenuManagementScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 640;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Management System'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Show notifications
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No hay notificaciones nuevas'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundColor: AppColors.cream,
              child: Text(
                authProvider.currentUser?.name.substring(0, 1) ?? 'U',
                style: TextStyle(
                  color: AppColors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Mi Perfil'),
                value: 'profile',
              ),
              PopupMenuItem(
                child: Text('Cambiar Contraseña'),
                value: 'change_password',
              ),
              PopupMenuItem(
                child: Text('Cerrar Sesión'),
                value: 'logout',
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                authProvider.logout();
              } else if (value == 'profile') {
                setState(() {
                  _selectedIndex = 3;
                });
              } else if (value == 'change_password') {
                _showChangePasswordDialog();
              }
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Side Navigation for larger screens
          if (!isSmallScreen) _buildSideNavigation(authProvider),
          // Main content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      drawer: isSmallScreen ? _buildDrawer(authProvider) : null,
      bottomNavigationBar: isSmallScreen
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.gold,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu),
                  label: 'Menú',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: 'Pedidos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Config',
                ),
              ],
            )
          : null,
    );
  }

  // Método para construir el drawer en pantallas pequeñas
  Widget _buildDrawer(AuthProvider authProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.brown,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 32,
                  child: Icon(
                    Icons.restaurant,
                    size: 32,
                    color: AppColors.gold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Restaurant Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  authProvider.currentUser?.name ?? 'Usuario',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            index: 0,
          ),
          _buildDrawerItem(
            icon: Icons.restaurant_menu,
            title: 'Gestión de Menú',
            index: 1,
          ),
          _buildDrawerItem(
            icon: Icons.receipt_long,
            title: 'Pedidos',
            index: 2,
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Configuración',
            index: 3,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              authProvider.logout();
              Navigator.of(context).pop(); // Cerrar el drawer
            },
          ),
        ],
      ),
    );
  }

  // Método para construir la navegación lateral en pantallas grandes
  Widget _buildSideNavigation(AuthProvider authProvider) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: AppColors.brown,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 24,
                  child: Icon(
                    Icons.restaurant,
                    size: 24,
                    color: AppColors.gold,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Restaurant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Management',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSideNavItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  index: 0,
                ),
                _buildSideNavItem(
                  icon: Icons.restaurant_menu,
                  title: 'Gestión de Menú',
                  index: 1,
                ),
                _buildSideNavItem(
                  icon: Icons.receipt_long,
                  title: 'Pedidos',
                  index: 2,
                ),
                _buildSideNavItem(
                  icon: Icons.settings,
                  title: 'Configuración',
                  index: 3,
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.cream,
              child: Text(
                authProvider.currentUser?.name.substring(0, 1) ?? 'U',
                style: TextStyle(
                  color: AppColors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              authProvider.currentUser?.name ?? 'Usuario',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(authProvider.currentUser?.email ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.red),
              onPressed: () {
                authProvider.logout();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para mostrar el diálogo de cambio de contraseña
  void _showChangePasswordDialog() {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    bool _obscureCurrentPassword = true;
    bool _obscureNewPassword = true;
    bool _obscureConfirmPassword = true;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Cambiar Contraseña'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _currentPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña Actual',
                        prefixIcon: Icon(Icons.lock, color: AppColors.gold),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.brown,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureCurrentPassword = !_obscureCurrentPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureCurrentPassword,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Nueva Contraseña',
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.gold),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.brown,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureNewPassword,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Nueva Contraseña',
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.gold),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.brown,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validar contraseñas
                    if (_currentPasswordController.text.isEmpty ||
                        _newPasswordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor complete todos los campos'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    if (_newPasswordController.text != _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Las contraseñas no coinciden'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    if (_newPasswordController.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('La contraseña debe tener al menos 6 caracteres'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    // Cambiar contraseña
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    authProvider.changePassword(
                      _currentPasswordController.text,
                      _newPasswordController.text,
                    ).then((success) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'Contraseña actualizada correctamente'
                              : 'Error al actualizar la contraseña'),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    });
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Método para construir los elementos del drawer
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.gold : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.gold : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.of(context).pop(); // Cerrar el drawer después de seleccionar
      },
    );
  }

  // Método para construir los elementos de la navegación lateral
  Widget _buildSideNavItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.gold : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.gold : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      tileColor: isSelected ? AppColors.cream.withOpacity(0.3) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class DashboardHomeScreen extends StatelessWidget {
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.darkBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          
          // Stats Cards
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 
                          MediaQuery.of(context).size.width < 960 ? 2 : 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                context,
                title: 'Ventas del Día',
                value: 'Bs. ${orderProvider.getTotalSalesByDate(DateTime.now()).toStringAsFixed(2)}',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
              _buildStatCard(
                context,
                title: 'Pedidos Pendientes',
                value: '${orderProvider.getOrdersByStatus('pendiente').length}',
                icon: Icons.access_time,
                color: AppColors.orange,
              ),
              _buildStatCard(
                context,
                title: 'Productos',
                value: '${menuProvider.products.length}',
                icon: Icons.restaurant_menu,
                color: AppColors.brown,
              ),
              _buildStatCard(
                context,
                title: 'Promociones Activas',
                value: '${menuProvider.getActivePromotions().length}',
                icon: Icons.local_offer,
                color: AppColors.gold,
              ),
            ],
          ),
          SizedBox(height: 24),
          
          // Recent Orders
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pedidos Recientes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navegar a la pantalla de pedidos
                          final dashboardState = context.findAncestorStateOfType<_DashboardScreenState>();
                          if (dashboardState != null) {
                            dashboardState.setState(() {
                              dashboardState._selectedIndex = 2; // Índice de OrdersScreen
                            });
                          }
                        },
                        child: Text('Ver Todos'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderProvider.orders.length > 5 ? 5 : orderProvider.orders.length,
                    itemBuilder: (context, index) {
                      final order = orderProvider.orders[index];
                      
                      return ListTile(
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
                        onTap: () {
                          // Navegar a los detalles del pedido
                          final dashboardState = context.findAncestorStateOfType<_DashboardScreenState>();
                          if (dashboardState != null) {
                            dashboardState.setState(() {
                              dashboardState._selectedIndex = 2; // Índice de OrdersScreen
                            });
                            // Aquí podrías también abrir los detalles específicos del pedido
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          
          // Popular Products
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Productos Populares',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navegar a la pantalla de menú
                          final dashboardState = context.findAncestorStateOfType<_DashboardScreenState>();
                          if (dashboardState != null) {
                            dashboardState.setState(() {
                              dashboardState._selectedIndex = 1; // Índice de MenuManagementScreen
                            });
                          }
                        },
                        child: Text('Ver Todos'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 
                                    MediaQuery.of(context).size.width < 960 ? 2 : 3,
                      childAspectRatio: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: menuProvider.products.length > 6 ? 6 : menuProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = menuProvider.products[index];
                      
                      return InkWell(
                        onTap: () {
                          // Navegar a la pantalla de menú y mostrar detalles del producto
                          final dashboardState = context.findAncestorStateOfType<_DashboardScreenState>();
                          if (dashboardState != null) {
                            dashboardState.setState(() {
                              dashboardState._selectedIndex = 1; // Índice de MenuManagementScreen
                            });
                            // Aquí podrías también abrir los detalles específicos del producto
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.cream,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.restaurant,
                                    color: AppColors.gold,
                                    size: 32,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Bs. ${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: AppColors.gold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navegar a la sección correspondiente según el tipo de estadística
          final dashboardState = context.findAncestorStateOfType<_DashboardScreenState>();
          if (dashboardState != null) {
            if (title.contains('Pedidos')) {
              dashboardState.setState(() {
                dashboardState._selectedIndex = 2; // Índice de OrdersScreen
              });
            } else if (title.contains('Productos') || title.contains('Promociones')) {
              dashboardState.setState(() {
                dashboardState._selectedIndex = 1; // Índice de MenuManagementScreen
              });
            }
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
