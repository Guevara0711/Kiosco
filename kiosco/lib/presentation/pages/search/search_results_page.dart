import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'search_filter_page.dart';
import '../product/product_detail_page.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;

  const SearchResultsPage({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  // String _selectedSort = 'Latest'; // Removed unused variable
  
  // Datos dummy para los productos encontrados
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _filteredResults = [];
  bool _isLoading = false;

  final List<String> _filterOptions = ['All', 'Latest', 'Most Popular', 'Cheapest'];
  
  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _isLoading = true;
    });

    // Simular búsqueda con delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _searchResults = _getMockResults(widget.searchQuery);
          _filteredResults = List.from(_searchResults);
          _isLoading = false;
        });
      }
    });
  }

  List<Map<String, dynamic>> _getMockResults(String query) {
    final List<Map<String, dynamic>> allProducts = [
      {
        'id': '1',
        'name': 'Bag Box 283',
        'brand': 'Lisa Robber',
        'price': 163.00,
        'image': 'bag',
        'rating': 4.8,
        'category': 'Bags',
        'isFavorite': false,
      },
      {
        'id': '2',
        'name': 'Box Biggan 992',
        'brand': 'Gazuna Resika',
        'price': 163.00,
        'image': 'bag',
        'rating': 4.5,
        'category': 'Bags',
        'isFavorite': true,
      },
      {
        'id': '3',
        'name': 'Big Biggan 283',
        'brand': 'Gazuna Resika',
        'price': 134.00,
        'image': 'bag',
        'rating': 4.6,
        'category': 'Bags',
        'isFavorite': false,
      },
      {
        'id': '4',
        'name': 'Bag Bag 223',
        'brand': 'Lisa Robber',
        'price': 105.00,
        'image': 'backpack',
        'rating': 4.3,
        'category': 'Backpacks',
        'isFavorite': false,
      },
      {
        'id': '5',
        'name': 'Electronics Box',
        'brand': 'TechStore',
        'price': 85.00,
        'image': 'electronics',
        'rating': 4.2,
        'category': 'Electronics',
        'isFavorite': false,
      },
      {
        'id': '6',
        'name': 'Fashion Pants',
        'brand': 'Three Second',
        'price': 45.00,
        'image': 'pants',
        'rating': 4.4,
        'category': 'Clothing',
        'isFavorite': true,
      },
    ];

    return allProducts
        .where((product) =>
            product['name'].toLowerCase().contains(query.toLowerCase()) ||
            product['brand'].toLowerCase().contains(query.toLowerCase()) ||
            product['category'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _filteredResults = List.from(_searchResults);
      
      // Aplicar filtro por precio
      if (filters['minPrice'] != null && filters['maxPrice'] != null) {
        _filteredResults = _filteredResults.where((product) {
          double price = product['price'].toDouble();
          return price >= filters['minPrice'] && price <= filters['maxPrice'];
        }).toList();
      }
      
      // Aplicar filtro por color (simulado)
      if (filters['selectedColor'] != null && filters['selectedColor'] != 'Black') {
        // En una app real, aquí filtrarías por color
      }
      
      // Aplicar filtro por ubicación
      if (filters['selectedLocation'] != null && filters['selectedLocation'] != 'San Diego') {
        // En una app real, aquí filtrarías por ubicación
      }
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      _filteredResults[index]['isFavorite'] = !_filteredResults[index]['isFavorite'];
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
      
      switch (filter) {
        case 'Latest':
          _filteredResults.sort((a, b) => b['id'].compareTo(a['id']));
          break;
        case 'Most Popular':
          _filteredResults.sort((a, b) => b['rating'].compareTo(a['rating']));
          break;
        case 'Cheapest':
          _filteredResults.sort((a, b) => a['price'].compareTo(b['price']));
          break;
        default:
          _filteredResults = List.from(_searchResults);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header con barra de búsqueda
            _buildSearchHeader(),
            
            // Información de la tienda (si hay resultados)
            if (_filteredResults.isNotEmpty && !_isLoading)
              _buildStoreInfo(),
            
            // Filtros
            if (_filteredResults.isNotEmpty && !_isLoading)
              _buildFilters(),
            
            // Contenido principal
            Expanded(
              child: _isLoading
                ? _buildLoadingState()
                : _filteredResults.isEmpty
                    ? _buildNoResultsState()
                    : _buildResultsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                FIcons.chevronLeft,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    // Actualizar búsqueda
                    setState(() {
                      _isLoading = true;
                    });
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          _searchResults = _getMockResults(query.trim());
                          _filteredResults = List.from(_searchResults);
                          _isLoading = false;
                        });
                      }
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: widget.searchQuery,
                  hintStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    FIcons.search,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchFilterPage(
                    currentFilters: {
                      'minPrice': 0.0,
                      'maxPrice': 200.0,
                      'selectedColor': 'Black',
                      'selectedLocation': 'San Diego',
                    },
                  ),
                ),
              );
              
              if (result != null) {
                _applyFilters(result);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                FIcons.settings,
                color: Colors.grey[700],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              FIcons.store,
              color: Colors.blue[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upbox Bag',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '104 Products • 1.3k Followers',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            FIcons.chevronRight,
            color: Colors.grey[500],
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FButton(
              onPress: () => _onFilterSelected(filter),
              style: isSelected 
                ? FButtonStyle.primary() 
                : FButtonStyle.secondary(),
              child: Text(filter),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.blue[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Searching products...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FIcons.search,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredResults.length,
      itemBuilder: (context, index) {
        final product = _filteredResults[index];
        return _buildProductCard(product, index);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              productId: product['id'],
              productName: product['name'],
              productImage: '',
              price: product['price'].toDouble(),
              rating: product['rating'].toDouble(),
              brand: product['brand'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _getIconForProduct(product['image']),
                        color: Colors.grey[400],
                        size: 40,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _toggleFavorite(index),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            FIcons.heart,
                            color: product['isFavorite'] ? Colors.red : Colors.grey[600],
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Información del producto
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['brand'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '\$${product['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
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
  }

  IconData _getIconForProduct(String type) {
    switch (type) {
      case 'bag':
        return FIcons.shoppingBag;
      case 'backpack':
        return FIcons.backpack;
      case 'electronics':
        return FIcons.smartphone;
      case 'pants':
        return FIcons.shirt;
      default:
        return FIcons.package;
    }
  }
}
