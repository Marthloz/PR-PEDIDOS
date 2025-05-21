import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../utils/app_theme.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/promotion.dart';
import '../widgets/responsive_wrapper.dart';
import '../utils/responsive_utils.dart';

class MenuManagementScreen extends StatefulWidget {
  @override
  _MenuManagementScreenState createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gestión de Menú',
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
              Tab(text: 'Productos'),
              Tab(text: 'Categorías'),
              Tab(text: 'Promociones'),
            ],
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ProductsTab(),
                CategoriesTab(),
                PromotionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final products = menuProvider.products;
    final categories = menuProvider.categories;
    
    return Padding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveUtils.isMobile(context)
              ? Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar productos...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddProductDialog(categories: categories),
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text('Nuevo Producto'),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar productos...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddProductDialog(categories: categories),
                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text('Nuevo Producto'),
                    ),
                  ],
                ),
          SizedBox(height: 16),
          
          Expanded(
            child: products.isEmpty
                ? Center(child: Text('No hay productos disponibles'))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final category = categories.firstWhere(
                        (c) => c.id == product.category,
                        orElse: () => Category(
                          id: '',
                          name: 'Sin categoría',
                          description: '',
                          imageUrl: '',
                        ),
                      );
                      
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.cream,
                                    AppColors.lightBrown.withOpacity(0.5),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.restaurant,
                                  size: 48,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: product.isAvailable
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            product.isAvailable ? 'Disponible' : 'Agotado',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: product.isAvailable
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Bs. ${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: AppColors.gold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Categoría: ${category.name}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: AppColors.brown),
                                          onPressed: () {
                                            // Edit product
                                            showDialog(
                                              context: context,
                                              builder: (context) => EditProductDialog(
                                                product: product,
                                                categories: categories,
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            // Delete product
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Eliminar Producto'),
                                                content: Text('¿Está seguro de eliminar este producto?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancelar'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      menuProvider.deleteProduct(product.id);
                                                      Navigator.of(context).pop();
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Producto eliminado correctamente'),
                                                          backgroundColor: Colors.green,
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Eliminar'),
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
                                  ],
                                ),
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
    );
  }
}

class CategoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final categories = menuProvider.categories;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar categorías...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddCategoryDialog(),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Nueva Categoría'),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          Expanded(
            child: categories.isEmpty
                ? Center(child: Text('No hay categorías disponibles'))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 
                                    MediaQuery.of(context).size.width < 960 ? 2 : 3,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.category,
                                  size: 48,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            category.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: category.isActive
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            category.isActive ? 'Activa' : 'Inactiva',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: category.isActive
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      category.description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: AppColors.brown),
                                          onPressed: () {
                                            // Edit category
                                            showDialog(
                                              context: context,
                                              builder: (context) => EditCategoryDialog(
                                                category: category,
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            // Delete category
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Eliminar Categoría'),
                                                content: Text('¿Está seguro de eliminar esta categoría?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancelar'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      menuProvider.deleteCategory(category.id);
                                                      Navigator.of(context).pop();
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Categoría eliminada correctamente'),
                                                          backgroundColor: Colors.green,
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Eliminar'),
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
                                  ],
                                ),
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
    );
  }
}

class PromotionsTab extends StatelessWidget {
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showPromotionDetails(BuildContext context, Promotion promotion, MenuProvider menuProvider) {
    final applicableProducts = menuProvider.products
        .where((product) => promotion.applicableProductIds.contains(product.id))
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles de la Promoción'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                promotion.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(promotion.description),
              SizedBox(height: 16),
              Text(
                'Descuento: ${promotion.discountPercentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
              SizedBox(height: 8),
              Text('Fecha de inicio: ${_formatDate(promotion.startDate)}'),
              Text('Fecha de fin: ${_formatDate(promotion.endDate)}'),
              SizedBox(height: 16),
              Text(
                'Productos aplicables:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              if (applicableProducts.isEmpty)
                Text('No hay productos seleccionados para esta promoción')
              else
                ...applicableProducts.map((product) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.check, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Expanded(child: Text(product.name)),
                      Text(
                        'Bs. ${product.price.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(BuildContext context, Promotion promotion, MenuProvider menuProvider) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.cream,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gold.withOpacity(0.7),
                  AppColors.brown.withOpacity(0.7),
                ],
              ),
            ),
            width: double.infinity,
            child: Center(
              child: Icon(
                Icons.local_offer,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        promotion.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: promotion.isCurrentlyActive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        promotion.isCurrentlyActive ? 'Activa' : 'Inactiva',
                        style: TextStyle(
                          fontSize: 12,
                          color: promotion.isCurrentlyActive
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  promotion.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Descuento: ${promotion.discountPercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Vigencia: ${_formatDate(promotion.startDate)} - ${_formatDate(promotion.endDate)}',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // Ver detalles de la promoción
                        _showPromotionDetails(context, promotion, menuProvider);
                      },
                      icon: Icon(Icons.visibility),
                      label: Text('Ver Detalles'),
                    ),
                    SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        // Editar promoción
                        showDialog(
                          context: context,
                          builder: (context) => EditPromotionDialog(
                            promotion: promotion,
                            products: menuProvider.products,
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Editar'),
                    ),
                    SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        // Eliminar promoción
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Eliminar Promoción'),
                            content: Text('¿Está seguro de eliminar esta promoción?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  menuProvider.deletePromotion(promotion.id);
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Promoción eliminada correctamente'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: Text('Eliminar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                      label: Text(
                        'Eliminar',
                        style: TextStyle(color: Colors.red),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final promotions = menuProvider.promotions;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar promociones...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddPromotionDialog(
                      products: menuProvider.products,
                    ),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Nueva Promoción'),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          Expanded(
            child: promotions.isEmpty
                ? Center(child: Text('No hay promociones disponibles'))
                : ListView.builder(
                    itemCount: promotions.length,
                    itemBuilder: (context, index) {
                      final promotion = promotions[index];
                      return _buildPromotionCard(context, promotion, menuProvider);
                    },
                ),
          ),
        ],
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  final List<Category> categories;

  const AddProductDialog({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategory;
  bool _isAvailable = true;
  List<String> _ingredients = [];
  List<String> _allergens = [];

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first.id;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Nuevo Producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Producto',
                  prefixIcon: Icon(Icons.restaurant_menu, color: AppColors.gold),
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description, color: AppColors.gold),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Precio (Bs.)',
                  prefixIcon: Icon(Icons.attach_money, color: AppColors.gold),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: Icon(Icons.category, color: AppColors.gold),
                ),
                value: _selectedCategory,
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una categoría';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Disponible'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
                activeColor: AppColors.gold,
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
              final menuProvider = Provider.of<MenuProvider>(context, listen: false);
              
              final newProduct = Product(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                description: _descriptionController.text,
                price: double.parse(_priceController.text),
                category: _selectedCategory!,
                imageUrl: 'assets/images/default_product.jpg',
                isAvailable: _isAvailable,
                ingredients: _ingredients,
                allergens: _allergens,
              );
              
              menuProvider.addProduct(newProduct);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Producto agregado correctamente'),
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

class EditProductDialog extends StatefulWidget {
  final Product product;
  final List<Category> categories;

  const EditProductDialog({
    Key? key,
    required this.product,
    required this.categories,
  }) : super(key: key);

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late String? _selectedCategory;
  late bool _isAvailable;
  late List<String> _ingredients;
  late List<String> _allergens;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _selectedCategory = widget.product.category;
    _isAvailable = widget.product.isAvailable;
    _ingredients = List.from(widget.product.ingredients);
    _allergens = List.from(widget.product.allergens);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Producto',
                  prefixIcon: Icon(Icons.restaurant_menu, color: AppColors.gold),
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description, color: AppColors.gold),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Precio (Bs.)',
                  prefixIcon: Icon(Icons.attach_money, color: AppColors.gold),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: Icon(Icons.category, color: AppColors.gold),
                ),
                value: _selectedCategory,
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una categoría';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Disponible'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
                activeColor: AppColors.gold,
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
              final menuProvider = Provider.of<MenuProvider>(context, listen: false);
              
              final updatedProduct = widget.product.copyWith(
                name: _nameController.text,
                description: _descriptionController.text,
                price: double.parse(_priceController.text),
                category: _selectedCategory!,
                isAvailable: _isAvailable,
                ingredients: _ingredients,
                allergens: _allergens,
              );
              
              menuProvider.updateProduct(updatedProduct);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Producto actualizado correctamente'),
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

class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;
  int _displayOrder = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final existingOrders = menuProvider.categories.map((c) => c.displayOrder).toList();
    
    return AlertDialog(
      title: Text('Agregar Nueva Categoría'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Categoría',
                  prefixIcon: Icon(Icons.category, color: AppColors.gold),
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description, color: AppColors.gold),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _displayOrder.toString(),
                decoration: InputDecoration(
                  labelText: 'Orden de Visualización',
                  prefixIcon: Icon(Icons.sort, color: AppColors.gold),
                  helperText: 'Ingrese un número único para el orden de visualización',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _displayOrder = int.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el orden de visualización';
                  }
                  final order = int.tryParse(value);
                  if (order == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  if (existingOrders.contains(order)) {
                    return 'Este orden ya está en uso. Por favor ingrese un valor único';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Activa'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeColor: AppColors.gold,
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
              final menuProvider = Provider.of<MenuProvider>(context, listen: false);
              
              final newCategory = Category(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                description: _descriptionController.text,
                imageUrl: 'assets/images/default_category.jpg',
                isActive: _isActive,
                displayOrder: _displayOrder,
              );
              
              menuProvider.addCategory(newCategory);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Categoría agregada correctamente'),
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

class EditCategoryDialog extends StatefulWidget {
  final Category category;

  const EditCategoryDialog({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late bool _isActive;
  late int _displayOrder;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(text: widget.category.description);
    _isActive = widget.category.isActive;
    _displayOrder = widget.category.displayOrder;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final existingOrders = menuProvider.categories
        .where((c) => c.id != widget.category.id)
        .map((c) => c.displayOrder)
        .toList();
    
    return AlertDialog(
      title: Text('Editar Categoría'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Categoría',
                  prefixIcon: Icon(Icons.category, color: AppColors.gold),
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description, color: AppColors.gold),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _displayOrder.toString(),
                decoration: InputDecoration(
                  labelText: 'Orden de Visualización',
                  prefixIcon: Icon(Icons.sort, color: AppColors.gold),
                  helperText: 'Ingrese un número único para el orden de visualización',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _displayOrder = int.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el orden de visualización';
                  }
                  final order = int.tryParse(value);
                  if (order == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  if (existingOrders.contains(order)) {
                    return 'Este orden ya está en uso. Por favor ingrese un valor único';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Activa'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeColor: AppColors.gold,
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
              final menuProvider = Provider.of<MenuProvider>(context, listen: false);
              
              final updatedCategory = widget.category.copyWith(
                name: _nameController.text,
                description: _descriptionController.text,
                isActive: _isActive,
                displayOrder: _displayOrder,
              );
              
              menuProvider.updateCategory(updatedCategory);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Categoría actualizada correctamente'),
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

class AddPromotionDialog extends StatefulWidget {
  final List<Product> products;

  const AddPromotionDialog({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  _AddPromotionDialogState createState() => _AddPromotionDialogState();
}

class _AddPromotionDialogState extends State<AddPromotionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30));
  List<String> _selectedProductIds = [];
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Nueva Promoción'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Promoción',
                  prefixIcon: Icon(Icons.local_offer, color: AppColors.gold),
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description, color: AppColors.gold),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _discountController,
                decoration: InputDecoration(
                  labelText: 'Porcentaje de Descuento',
                  prefixIcon: Icon(Icons.percent, color: AppColors.gold),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el descuento';
                  }
                  final discount = double.tryParse(value);
                  if (discount == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  if (discount <= 0 || discount > 100) {
                    return 'El descuento debe estar entre 1 y 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Fecha Inicio'),
                      subtitle: Text('${_formatDate(_startDate)}'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Fecha Fin'),
                      subtitle: Text('${_formatDate(_endDate)}'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _endDate = date;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Productos Aplicables',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final product = widget.products[index];
                    return CheckboxListTile(
                      title: Text(product.name),
                      subtitle: Text('Bs. ${product.price.toStringAsFixed(2)}'),
                      value: _selectedProductIds.contains(product.id),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedProductIds.add(product.id);
                          } else {
                            _selectedProductIds.remove(product.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Activa'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeColor: AppColors.gold,
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
              final menuProvider = Provider.of<MenuProvider>(context, listen: false);
              
              final newPromotion = Promotion(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                description: _descriptionController.text,
                discountPercentage: double.parse(_discountController.text),
                startDate: _startDate,
                endDate: _endDate,
                applicableProductIds: _selectedProductIds,
                imageUrl: 'assets/images/default_promotion.jpg',
                isActive: _isActive,
              );
              
              menuProvider.addPromotion(newPromotion);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Promoción agregada correctamente'),
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

class EditPromotionDialog extends StatefulWidget {
  final Promotion promotion;
  final List<Product> products;

  const EditPromotionDialog({
    Key? key,
    required this.promotion,
    required this.products,
  }) : super(key: key);

  @override
  _EditPromotionDialogState createState() => _EditPromotionDialogState();
}

class _EditPromotionDialogState extends State<EditPromotionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountController;
  late DateTime _startDate;
  late DateTime _endDate;
  late List<String> _selectedProductIds;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.promotion.name);
    _descriptionController = TextEditingController(text: widget.promotion.description);
    _discountController = TextEditingController(text: widget.promotion.discountPercentage.toString());
    _startDate = widget.promotion.startDate;
    _endDate = widget.promotion.endDate;
    _selectedProductIds = List.from(widget.promotion.applicableProductIds);
    _isActive = widget.promotion.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Promoción'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Promoción',
                  prefixIcon: Icon(Icons.local_offer, color: AppColors.gold),
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description, color: AppColors.gold),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _discountController,
                decoration: InputDecoration(
                  labelText: 'Porcentaje de Descuento',
                  prefixIcon: Icon(Icons.percent, color: AppColors.gold),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el descuento';
                  }
                  final discount = double.tryParse(value);
                  if (discount == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  if (discount <= 0 || discount > 100) {
                    return 'El descuento debe estar entre 1 y 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Fecha Inicio'),
                      subtitle: Text('${_formatDate(_startDate)}'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Fecha Fin'),
                      subtitle: Text('${_formatDate(_endDate)}'),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _endDate = date;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Productos Aplicables',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final product = widget.products[index];
                    return CheckboxListTile(
                      title: Text(product.name),
                      subtitle: Text('Bs. ${product.price.toStringAsFixed(2)}'),
                      value: _selectedProductIds.contains(product.id),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedProductIds.add(product.id);
                          } else {
                            _selectedProductIds.remove(product.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Activa'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeColor: AppColors.gold,
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
              final menuProvider = Provider.of<MenuProvider>(context, listen: false);
              
              final updatedPromotion = widget.promotion.copyWith(
                name: _nameController.text,
                description: _descriptionController.text,
                discountPercentage: double.parse(_discountController.text),
                startDate: _startDate,
                endDate: _endDate,
                applicableProductIds: _selectedProductIds,
                isActive: _isActive,
              );
              
              menuProvider.updatePromotion(updatedPromotion);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Promoción actualizada correctamente'),
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
