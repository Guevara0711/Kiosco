import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> _favorites = [
    {
      'id': '1',
      'name': 'Coca Cola',
      'price': '\$2.50',
      'image': '🥤',
      'category': 'Bebidas',
      'description': 'Bebida refrescante con gas',
      'available': true,
    },
    {
      'id': '2',
      'name': 'Sandwich de jamón',
      'price': '\$4.99',
      'image': '🥪',
      'category': 'Comida',
      'description': 'Sandwich fresco con jamón y vegetales',
      'available': true,
    },
    {
      'id': '3',
      'name': 'Café americano',
      'price': '\$3.25',
      'image': '☕',
      'category': 'Bebidas',
      'description': 'Café negro recién preparado',
      'available': false,
    },
    {
      'id': '4',
      'name': 'Galletas de chocolate',
      'price': '\$1.75',
      'image': '🍪',
      'category': 'Dulces',
      'description': 'Galletas crujientes con chispas de chocolate',
      'available': true,
    },
  ];

  void _removeFromFavorites(String productId) {
    setState(() {
      _favorites.removeWhere((product) => product['id'] == productId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto eliminado de favoritos'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    if (!product['available']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este producto no está disponible actualmente'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Implementar agregar al carrito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} agregado al carrito'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [
          if (_favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _showClearAllDialog,
              tooltip: 'Limpiar favoritos',
            ),
        ],
      ),
      body: _favorites.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No tienes favoritos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Los productos que marques como favoritos\naparecerán aquí para acceso rápido',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navegar a la página principal
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Explorar productos'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Column(
      children: [
        // Header con contador
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red[400],
              ),
              const SizedBox(width: 8),
              Text(
                '${_favorites.length} producto${_favorites.length == 1 ? '' : 's'} favorito${_favorites.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        
        // Lista de favoritos
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final product = _favorites[index];
              return _buildFavoriteCard(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> product) {
    final isAvailable = product['available'] as bool;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showProductDetails(product);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Imagen del producto
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isAvailable ? Colors.grey[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Text(
                        product['image'],
                        style: TextStyle(
                          fontSize: 36,
                          color: isAvailable ? null : Colors.grey,
                        ),
                      ),
                      if (!isAvailable)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.not_interested,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['name'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable ? null : Colors.grey,
                                ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => _removeFromFavorites(product['id']),
                          tooltip: 'Eliminar de favoritos',
                        ),
                      ],
                    ),
                    
                    Text(
                      product['category'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      product['description'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isAvailable ? Colors.grey[700] : Colors.grey,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product['price'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isAvailable 
                                    ? Theme.of(context).colorScheme.primary 
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        
                        ElevatedButton.icon(
                          onPressed: isAvailable 
                              ? () => _addToCart(product)
                              : null,
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: Text(isAvailable ? 'Agregar' : 'No disponible'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Imagen del producto
                Center(
                  child: Text(
                    product['image'],
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Información del producto
                Text(
                  product['name'],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product['category'],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      product['price'],
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Descripción',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  product['description'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 32),
                
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _removeFromFavorites(product['id']),
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Quitar de favoritos'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: product['available'] 
                            ? () => _addToCart(product)
                            : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Agregar al carrito'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar favoritos'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar todos los productos de tus favoritos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _favorites.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Favoritos eliminados'),
                ),
              );
            },
            child: const Text('Eliminar todo'),
          ),
        ],
      ),
    );
  }
}
