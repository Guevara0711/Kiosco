import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'search_results_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  
  // Datos dummy para las búsquedas anteriores
  List<String> _lastSearches = [
    'Electronics',
    'Pants',
    'Three Second',
    'Long shirt',
  ];
  
  // Datos dummy para búsquedas populares
  final List<Map<String, dynamic>> _popularSearches = [
    {
      'name': 'Lunilo Hits jacket',
      'searches': '1.6k Search today',
      'tag': 'Hot',
      'color': Colors.red[100],
      'tagColor': Colors.red,
      'image': 'jacket',
    },
    {
      'name': 'Denim Jeans',
      'searches': '1k Search today',
      'tag': 'New',
      'color': Colors.orange[100],
      'tagColor': Colors.orange,
      'image': 'jeans',
    },
    {
      'name': 'Redil Backpack',
      'searches': '1,23k Search today',
      'tag': 'Popular',
      'color': Colors.green[100],
      'tagColor': Colors.green,
      'image': 'backpack',
    },
    {
      'name': 'JBL Speakers',
      'searches': '1,1k Search today',
      'tag': 'New',
      'color': Colors.orange[100],
      'tagColor': Colors.orange,
      'image': 'speaker',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      // Agregar a búsquedas anteriores
      _addToLastSearches(query.trim());
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(
            searchQuery: query.trim(),
          ),
        ),
      );
    }
  }

  void _addToLastSearches(String query) {
    setState(() {
      if (_lastSearches.contains(query)) {
        _lastSearches.remove(query);
      }
      _lastSearches.insert(0, query);
      if (_lastSearches.length > 6) {
        _lastSearches = _lastSearches.take(6).toList();
      }
    });
  }

  void _clearLastSearches() {
    setState(() {
      _lastSearches.clear();
    });
  }

  void _removeLastSearch(int index) {
    setState(() {
      _lastSearches.removeAt(index);
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
            
            // Contenido principal
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección de búsquedas anteriores
                      if (_lastSearches.isNotEmpty) ...[
                        _buildLastSearchSection(),
                        const SizedBox(height: 30),
                      ],
                      
                      // Sección de búsquedas populares
                      _buildPopularSearchSection(),
                    ],
                  ),
                ),
              ),
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
                autofocus: true,
                onSubmitted: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
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
        ],
      ),
    );
  }

  Widget _buildLastSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Last Search',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _clearLastSearches,
              child: Text(
                'Clear All',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _lastSearches.asMap().entries.map((entry) {
            int index = entry.key;
            String search = entry.value;
            
            return GestureDetector(
              onTap: () => _performSearch(search),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      search,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeLastSearch(index),
                      child: Icon(
                        FIcons.x,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Search',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _popularSearches.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = _popularSearches[index];
            return _buildPopularSearchItem(
              item['name'],
              item['searches'],
              item['tag'],
              item['color'],
              item['tagColor'],
              item['image'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPopularSearchItem(
    String name,
    String searches,
    String tag,
    Color backgroundColor,
    Color tagColor,
    String imageType,
  ) {
    return GestureDetector(
      onTap: () => _performSearch(name),
      child: Container(
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
            // Imagen del producto
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  _getIconForType(imageType),
                  color: Colors.grey[600],
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    searches,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: tagColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'jacket':
        return FIcons.shirt;
      case 'jeans':
        return FIcons.shirt;
      case 'backpack':
        return FIcons.backpack;
      case 'speaker':
        return FIcons.speaker;
      default:
        return FIcons.package;
    }
  }
}
