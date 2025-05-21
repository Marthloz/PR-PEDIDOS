import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/responsive_wrapper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return ResponsiveWrapper(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            
            TabBar(
              controller: _tabController,
              labelColor: AppColors.gold,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.gold,
              tabs: [
                Tab(text: 'Perfil de Restaurante'),
                Tab(text: 'Usuarios'),
              ],
            ),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  RestaurantProfileTab(),
                  UsersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantProfileTab extends StatefulWidget {
  @override
  _RestaurantProfileTabState createState() => _RestaurantProfileTabState();
}

class _RestaurantProfileTabState extends State<RestaurantProfileTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Mi Restaurante');
  final _nitController = TextEditingController(text: '123456789');
  final _phoneController = TextEditingController(text: '123456789');
  final _addressController = TextEditingController(text: 'Av. Principal #123');
  
  // Controladores para las coordenadas GPS
  final _latitudeController = TextEditingController(text: '-16.5000');
  final _longitudeController = TextEditingController(text: '-68.1500');
  
  bool _isLoading = false;
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nitController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  // Simular obtención de ubicación GPS
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });
    
    try {
      // En una aplicación real, aquí usaríamos el paquete geolocator
      // para obtener la ubicación actual del dispositivo
      await Future.delayed(Duration(seconds: 2)); // Simular tiempo de espera
      
      // Simular coordenadas obtenidas (en una app real, estas vendrían del GPS)
      setState(() {
        _latitudeController.text = '-16.4897';
        _longitudeController.text = '-68.1193';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ubicación actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener la ubicación: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Logo
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 60,
                      color: AppColors.gold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    // Upload logo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Funcionalidad de carga de logo implementada'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                  icon: Icon(Icons.upload),
                  label: Text('Cambiar Logo'),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          
          // Restaurant Information Form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información del Restaurante',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Restaurante',
                    prefixIcon: Icon(Icons.business, color: AppColors.gold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nitController,
                  decoration: InputDecoration(
                    labelText: 'NIT',
                    prefixIcon: Icon(Icons.badge, color: AppColors.gold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el NIT';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: Icon(Icons.phone, color: AppColors.gold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el teléfono';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Dirección',
                    prefixIcon: Icon(Icons.location_on, color: AppColors.gold),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la dirección';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                
                Text(
                  'Ubicación GPS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 48,
                              color: AppColors.brown,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Mapa de ubicación',
                              style: TextStyle(
                                color: AppColors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Latitud: ${_latitudeController.text}, Longitud: ${_longitudeController.text}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Marcador de posición
                      Center(
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latitudeController,
                        decoration: InputDecoration(
                          labelText: 'Latitud',
                          enabled: false,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _longitudeController,
                        decoration: InputDecoration(
                          labelText: 'Longitud',
                          enabled: false,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _isGettingLocation ? null : _getCurrentLocation,
                  icon: _isGettingLocation 
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.my_location),
                  label: Text(_isGettingLocation ? 'Obteniendo ubicación...' : 'Actualizar Ubicación'),
                ),
                SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _isLoading ? null : () {
                        // Reset form
                        _nameController.text = 'Mi Restaurante';
                        _nitController.text = '123456789';
                        _phoneController.text = '123456789';
                        _addressController.text = 'Av. Principal #123';
                        _latitudeController.text = '-16.5000';
                        _longitudeController.text = '-68.1500';
                      },
                      child: Text('Cancelar'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          
                          // Simular guardado
                          await Future.delayed(Duration(seconds: 1));
                          
                          setState(() {
                            _isLoading = false;
                          });
                          
                          // Save restaurant profile
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Perfil actualizado correctamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text('Guardar Cambios'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Usuarios del Sistema',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Add new user
                  showDialog(
                    context: context,
                    builder: (context) => AddUserDialog(),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Nuevo Usuario'),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Users List
          Expanded(
            child: ListView(
              children: [
                _buildUserCard(
                  name: 'Admin Principal',
                  phone: '123456789',
                  role: 'Administrador',
                  status: 'Activo',
                ),
                _buildUserCard(
                  name: 'Juan Pérez',
                  phone: '987654321',
                  role: 'Cajero',
                  status: 'Activo',
                ),
                _buildUserCard(
                  name: 'María López',
                  phone: '456789123',
                  role: 'Mesero',
                  status: 'Inactivo',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard({
    required String name,
    required String phone,
    required String role,
    required String status,
  }) {
    final isActive = status.toLowerCase() == 'activo';
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.gold.withOpacity(0.2),
          child: Icon(
            Icons.person,
            color: AppColors.gold,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Teléfono: $phone'),
            Text('Rol: $role'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.brown),
              onPressed: () {
                // Edit user
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Delete user
              },
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

class AddUserDialog extends StatefulWidget {
  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Cajero';
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Nuevo Usuario'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: Icon(Icons.person, color: AppColors.gold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone, color: AppColors.gold),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el teléfono';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock, color: AppColors.gold),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.brown,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Rol',
                  prefixIcon: Icon(Icons.badge, color: AppColors.gold),
                ),
                value: _selectedRole,
                items: [
                  'Administrador',
                  'Cajero',
                  'Mesero',
                  'Cocinero',
                ].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
            ],
          ),
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
            if (_formKey.currentState!.validate()) {
              // Create new user
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Usuario creado correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
