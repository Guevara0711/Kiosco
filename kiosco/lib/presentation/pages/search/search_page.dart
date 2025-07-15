import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [
    'Coca Cola',
    'Sandwich',
    'Café',
    'Galletas',
    'Agua',
  ];
  
  List<Map<String, String>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simular búsqueda
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchResults = _getMockResults(query);
          _isSearching = false;
        });
      }
    });
  }

  List<Map<String, String>> _getMockResults(String query) {
    final allProducts = [
      {'name': 'Coca Cola', 'price': '\$2.50', 'image': '🥤', 'category': 'Bebidas'},
      {'name': 'Coca Cola Zero', 'price': '\$2.50', 'image': '🥤', 'category': 'Bebidas'},
      {'name': 'Sandwich de jamón', 'price': '\$4.99', 'image': '🥪', 'category': 'Comida'},
      {'name': 'Sandwich de pollo', 'price': '\$5.99', 'image': '🥪', 'category': 'Comida'},
      {'name': 'Galletas de chocolate', 'price': '\$1.75', 'image': '🍪', 'category': 'Dulces'},
      {'name': 'Galletas saladas', 'price': '\$1.50', 'image': '🍪', 'category': 'Snacks'},
      {'name': 'Café americano', 'price': '\$3.25', 'image': '☕', 'category': 'Bebidas'},
      {'name': 'Café con leche', 'price': '\$3.75', 'image': '☕', 'category': 'Bebidas'},
      {'name': 'Papas fritas', 'price': '\$2.99', 'image': '🍟', 'category': 'Snacks'},
      {'name': 'Agua mineral', 'price': '\$1.25', 'image': '💧', 'category': 'Bebidas'},
    ];

    return allProducts
        .where((product) =>
            product['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _addToSearchHistory(String query) {
    if (_searchHistory.contains(query)) {
      _searchHistory.remove(query);
    }
    _searchHistory.insert(0, query);
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.take(10).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar productos...',
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: _performSearch,
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              _addToSearchHistory(query);
            }
          },
          autofocus: true,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults = [];
                  _isSearching = false;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filtros de categoría
          if (_searchResults.isNotEmpty || _isSearching) ...[
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip('Todos', true),
                  _buildFilterChip('Bebidas', false),
                  _buildFilterChip('Comida', false),
                  _buildFilterChip('Snacks', false),
                  _buildFilterChip('Dulces', false),
                ],
              ),
            ),
            const Divider(height: 1),
          ],

          // Contenido principal
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // TODO: Implementar filtros
        },
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchController.text.isEmpty) {
      return _buildSearchHistory();
    }

    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildSearchHistory() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Búsquedas recientes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchHistory.clear();
                });
              },
              child: const Text('Limpiar'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._searchHistory.map((query) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(query),
              trailing: IconButton(
                icon: const Icon(Icons.call_made),
                onPressed: () {
                  _searchController.text = query;
                  _performSearch(query);
                },
              ),
              onTap: () {
                _searchController.text = query;
                _performSearch(query);
              },
            )),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron resultados',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otros términos de búsqueda',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  product['image']!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            title: Text(
              product['name']!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(product['category']!),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  product['price']!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  iconSize: 20,
                  onPressed: () {
                    // TODO: Agregar al carrito
                  },
                ),
              ],
            ),
            onTap: () {
              // TODO: Navegar a detalle del producto
            },
          ),
        );
      },
    );
  }
}
