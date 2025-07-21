import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SearchFilterPage extends StatefulWidget {
  final Map<String, dynamic> currentFilters;

  const SearchFilterPage({
    super.key,
    required this.currentFilters,
  });

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  late RangeValues _priceRange;
  int _selectedColorIndex = 0;
  String _selectedLocation = 'San Diego';
  
  final List<Color> _colors = [
    Colors.black,
    const Color(0xFF8B7FD1), // Purple
    const Color(0xFF87CEEB), // Sky blue
    const Color(0xFFFFF8DC), // Cream
    const Color(0xFFFFB6C1), // Light pink
  ];
  
  final List<String> _locations = [
    'San Diego',
    'New York',
    'Amsterdam',
    'Los Angeles',
    'Miami',
  ];

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.currentFilters['minPrice']?.toDouble() ?? 0.0,
      widget.currentFilters['maxPrice']?.toDouble() ?? 200.0,
    );
    
    _selectedLocation = widget.currentFilters['selectedLocation'] ?? 'San Diego';
    
    // Encontrar el índice del color actual
    String currentColor = widget.currentFilters['selectedColor'] ?? 'Black';
    _selectedColorIndex = _getColorIndex(currentColor);
  }

  int _getColorIndex(String colorName) {
    switch (colorName) {
      case 'Black': return 0;
      case 'Purple': return 1;
      case 'Blue': return 2;
      case 'Cream': return 3;
      case 'Pink': return 4;
      default: return 0;
    }
  }

  String _getColorName(int index) {
    switch (index) {
      case 0: return 'Black';
      case 1: return 'Purple';
      case 2: return 'Blue';
      case 3: return 'Cream';
      case 4: return 'Pink';
      default: return 'Black';
    }
  }

  void _applyFilters() {
    final filters = {
      'minPrice': _priceRange.start,
      'maxPrice': _priceRange.end,
      'selectedColor': _getColorName(_selectedColorIndex),
      'selectedLocation': _selectedLocation,
    };
    
    Navigator.pop(context, filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Contenido de filtros
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filtro de precio
                      _buildPriceFilter(),
                      const SizedBox(height: 30),
                      
                      // Filtro de color
                      _buildColorFilter(),
                      const SizedBox(height: 30),
                      
                      // Filtro de ubicación
                      _buildLocationFilter(),
                      const SizedBox(height: 100), // Espacio para el botón
                    ],
                  ),
                ),
              ),
            ),
            
            // Botón de aplicar filtros
            _buildApplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          Text(
            'Filter By',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 20),
        
        // Rango de precios
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RangeSlider(
            values: _priceRange,
            min: 0.0,
            max: 500.0,
            divisions: 50,
            activeColor: Colors.blue[600],
            inactiveColor: Colors.grey[300],
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
        ),
        
        // Valores de precio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_priceRange.start.round()}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '\$${_priceRange.end.round()}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Color',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            Text(
              _getColorName(_selectedColorIndex),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Selector de colores
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _colors.asMap().entries.map((entry) {
            int index = entry.key;
            Color color = entry.value;
            bool isSelected = index == _selectedColorIndex;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColorIndex = index;
                });
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue[600]! : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: isSelected
                  ? Icon(
                      FIcons.check,
                      color: color == Colors.black ? Colors.white : Colors.white,
                      size: 20,
                    )
                  : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 20),
        
        // Lista de ubicaciones
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _locations.map((location) {
            bool isSelected = location == _selectedLocation;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLocation = location;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[600] : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: FButton(
          onPress: _applyFilters,
          style: FButtonStyle.primary(),
          child: const Text('Apply Filter'),
        ),
      ),
    );
  }
}
