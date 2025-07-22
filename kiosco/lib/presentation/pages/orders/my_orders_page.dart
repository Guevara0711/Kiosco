import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0; // 0 = Cart, 1 = My Order, 2 = History

  // Carrito actual con productos por comprar
  List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Bix Bag Limited Edition 229',
      'color': 'Brown',
      'quantity': 1,
      'price': 24.00,
      'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=400&fit=crop',
    },
    {
      'id': '2',
      'name': 'Bix Bag 319',
      'color': 'Brown',
      'quantity': 1,
      'price': 21.50,
      'image': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop',
    },
  ];

  // Órdenes activas (en progreso)
  List<Map<String, dynamic>> _myOrders = [
    {
      'id': 'ORD-001',
      'name': 'Box Headphone 234',
      'color': 'Black',
      'quantity': 1,
      'price': 66.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'On Progress',
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop',
    },
    {
      'id': 'ORD-002',
      'name': 'Bix Bag 319',
      'color': 'Brown',
      'quantity': 1,
      'price': 21.50,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'On Progress',
      'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=400&fit=crop',
    },
  ];

  // Historial de órdenes (completadas/canceladas)
  List<Map<String, dynamic>> _orderHistory = [
    {
      'id': 'ORD-003',
      'name': 'Smartphone Case Pro',
      'color': 'Black',
      'quantity': 1,
      'price': 12.99,
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'status': 'Completed',
      'image': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop',
    },
    {
      'id': 'ORD-004',
      'name': 'Wireless Earbuds',
      'color': 'White',
      'quantity': 2,
      'price': 45.00,
      'date': DateTime.now().subtract(const Duration(days: 14)),
      'status': 'Completed',
      'image': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=400&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _cartTotal {
    return _cartItems.fold(0.0, (sum, item) => sum + ((item['price'] ?? 0.0) * (item['quantity'] ?? 1)));
  }

  void _updateQuantity(String itemId, int change) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item['id'] == itemId);
      if (index != -1) {
        final currentQuantity = _cartItems[index]['quantity'] ?? 1;
        _cartItems[index]['quantity'] = currentQuantity + change;
        if ((_cartItems[index]['quantity'] ?? 0) <= 0) {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  void _proceedToPayment() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tu carrito está vacío'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Simular procesamiento de pago
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Procesar Pago'),
        content: Text('Total a pagar: \$${_cartTotal.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _completeOrder();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Pagar'),
          ),
        ],
      ),
    );
  }

  void _completeOrder() {
    // Mover items del carrito a mis órdenes
    final newOrder = {
      'id': 'ORD-${_myOrders.length + 4}',
      'items': _cartItems.map((item) => {
        'name': item['name'] ?? 'Producto sin nombre',
        'quantity': item['quantity'] ?? 1,
        'price': item['price'] ?? 0.0,
      }).toList(),
      'total': _cartTotal,
      'date': DateTime.now(),
      'status': 'Procesando',
      'trackingNumber': 'TRK-2024-${_myOrders.length + 4}',
      'estimatedDelivery': DateTime.now().add(const Duration(days: 3)),
      'currentLocation': 'Preparando Envío',
      'deliveryType': 'Domicilio',
      'address': 'Av. Principal 123, Col. Centro',
    };

    setState(() {
      _myOrders.insert(0, newOrder);
      _cartItems.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Orden procesada exitosamente!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Carrito de Compras',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      FIcons.shoppingCart,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Tabs alineados a la izquierda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildTab('Cart', 0),
                  const SizedBox(width: 40),
                  _buildTab('My Order', 1),
                  const SizedBox(width: 40),
                  _buildTab('History', 2),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contenido de los tabs
            Expanded(
              child: _selectedTab == 0 
                  ? _buildCartContent() 
                  : _selectedTab == 1 
                      ? _buildMyOrderContent() 
                      : _buildHistoryContent(),
            ),

            // Botón de pagar (solo visible en el tab del carrito)
            if (_selectedTab == 0 && _cartItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${_cartTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _proceedToPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Proceder al Pago',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
        _tabController.animateTo(index);
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          if (isSelected)
            Container(
              height: 3,
              // Hacer que la barrita se ajuste al ancho del texto
              width: _getTextWidth(title, const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  // Función para calcular el ancho del texto
  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  Widget _buildCartContent() {
    if (_cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FIcons.shoppingCart,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'Tu carrito está vacío',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Añade productos para comenzar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        return _buildCartItem(item);
      },
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Imagen del producto
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? 'Producto sin nombre',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Color: ${item['color'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty: ${item['quantity'] ?? 1}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Precio
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${((item['price'] ?? 0.0) * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Botones de acción
          Row(
            children: [
              // Botón Detail
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Mostrar detalles del producto
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(0, 48), // Misma altura que los controles de cantidad
                  ),
                  child: const Text(
                    'Product detail',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Controles de cantidad (a la derecha)
              Container(
                height: 48, // Misma altura que el botón Detail
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _updateQuantity(item['id'] ?? '', -1),
                      icon: const Icon(Icons.remove, size: 18),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item['quantity'] ?? 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _updateQuantity(item['id'] ?? '', 1),
                      icon: const Icon(Icons.add, size: 18),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyOrderContent() {
    if (_myOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FIcons.package,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No tienes órdenes activas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tus órdenes en progreso aparecerán aquí',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _myOrders.length,
      itemBuilder: (context, index) {
        final order = _myOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildHistoryContent() {
    if (_orderHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FIcons.clock,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No tienes historial de órdenes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tus órdenes completadas aparecerán aquí',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _orderHistory.length,
      itemBuilder: (context, index) {
        final order = _orderHistory[index];
        return _buildOrderCard(order, showDate: true);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, {bool showDate = false}) {
    Color statusColor = _getOrderStatusColor(order['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Imagen del producto
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['name'] ?? 'Producto sin nombre',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Color: ${order['color'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty: ${order['quantity'] ?? 1}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (showDate) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatOrderDate(order['date'] ?? DateTime.now()),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Precio y status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      order['status'] ?? 'Sin Estado',
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${(order['price'] ?? 0.0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Botones de acción
          Row(
            children: [
              // Botón Detail
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _showOrderDetails(order);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(0, 48),
                  ),
                  child: const Text(
                    'Detail',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              
              // Botón Tracking (solo si NO está en History)
              if (!showDate) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showTrackingDetails(order);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(0, 48),
                    ),
                    child: const Text('Tracking'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getOrderStatusColor(String status) {
    switch (status) {
      case 'On Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
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
              const SizedBox(height: 20),
              
              // Título
              const Text(
                'Detalles de la Orden',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Tag de estado debajo del título
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getOrderStatusColor(order['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getOrderStatusColor(order['status']),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      order['status'] ?? 'Sin Estado',
                      style: TextStyle(
                        fontSize: 14,
                        color: _getOrderStatusColor(order['status']),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información del producto
                      _buildDetailSection(
                        'Información del Producto',
                        [
                          _buildDetailRow('Nombre', order['name'] ?? 'N/A'),
                          _buildDetailRow('Color', order['color'] ?? 'N/A'),
                          _buildDetailRow('Cantidad', '${order['quantity'] ?? 1}'),
                          _buildDetailRow('Precio', '\$${(order['price'] ?? 0.0).toStringAsFixed(2)}'),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Información de entrega (solo si existe)
                      if (order['deliveryType'] != null) ...[
                        _buildDetailSection(
                          'Información de Entrega',
                          [
                            _buildDetailRow('Tipo de Entrega', order['deliveryType'] ?? 'N/A'),
                            _buildDetailRow('Dirección', order['address'] ?? 'N/A'),
                            if (order['estimatedDelivery'] != null)
                              _buildDetailRow('Entrega Estimada', _formatDeliveryDate(order['estimatedDelivery'])),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                      
                      // Información de la orden
                      _buildDetailSection(
                        'Información de la Orden',
                        [
                          if (order['id'] != null)
                            _buildDetailRow('ID de Orden', order['id']),
                          if (order['trackingNumber'] != null)
                            _buildDetailRow('Número de Tracking', order['trackingNumber']),
                          _buildDetailRow('Fecha de Compra', _formatOrderDate(order['date'] ?? DateTime.now())),
                          if (order['total'] != null)
                            _buildDetailRow('Total Pagado', '\$${(order['total'] ?? 0.0).toStringAsFixed(2)}', isTotal: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Botón cerrar
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTrackingDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.6,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
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
              const SizedBox(height: 20),
              
              // Título
              Row(
                children: [
                  Icon(
                    FIcons.truck,
                    color: Colors.blue[600],
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Seguimiento de Orden',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Estado actual
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getOrderStatusColor(order['status']),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    order['status'] ?? 'Sin Estado',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _formatOrderDate(DateTime.now()),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _getStatusDescription(order['status'] ?? ''),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  FIcons.mapPin,
                                  color: Colors.blue[600],
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    order['currentLocation'] ?? _getCurrentLocation(order['status'] ?? ''),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Timeline de tracking
                      _buildTrackingTimeline(order),
                      
                      const SizedBox(height: 24),
                      
                      // Información adicional
                      _buildDetailSection(
                        'Información de Entrega',
                        [
                          _buildDetailRow('Número de Tracking', order['trackingNumber'] ?? 'TRK-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'),
                          _buildDetailRow('Tipo de Entrega', order['deliveryType'] ?? 'Domicilio'),
                          _buildDetailRow('Dirección', order['address'] ?? 'Calle Principal #123, Ciudad'),
                          if (order['estimatedDelivery'] != null)
                            _buildDetailRow('Entrega Estimada', _formatDeliveryDate(order['estimatedDelivery']))
                          else
                            _buildDetailRow('Entrega Estimada', _getEstimatedDelivery(order['status'] ?? '')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Botón cerrar
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: isTotal ? Colors.green[700] : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(Map<String, dynamic> order) {
    String currentStatus = order['status'] ?? 'On Progress';
    List<Map<String, dynamic>> timeline = _getTrackingTimeline(currentStatus);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado del Envío',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...timeline.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> step = entry.value;
          bool isCompleted = step['isCompleted'];
          bool isCurrent = step['isCurrent'];
          bool isLast = index == timeline.length - 1;
          
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted || isCurrent ? Colors.blue[600] : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : (isCurrent ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: isCompleted ? Colors.blue[600] : Colors.grey[300],
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isCompleted || isCurrent ? Colors.black87 : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isCompleted || isCurrent ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
                      if (step['time'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          step['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'On Progress':
        return 'Tu pedido está siendo preparado';
      case 'Completed':
        return 'Tu pedido ha sido entregado exitosamente';
      case 'Cancelled':
        return 'Tu pedido ha sido cancelado';
      default:
        return 'Estado del pedido no disponible';
    }
  }

  String _getCurrentLocation(String status) {
    switch (status) {
      case 'On Progress':
        return 'Centro de Distribución - Preparando pedido';
      case 'Completed':
        return 'Entregado en destino';
      case 'Cancelled':
        return 'Pedido cancelado';
      default:
        return 'Ubicación no disponible';
    }
  }

  String _getEstimatedDelivery(String status) {
    switch (status) {
      case 'On Progress':
        return '2-3 días hábiles';
      case 'Completed':
        return 'Ya entregado';
      case 'Cancelled':
        return 'Pedido cancelado';
      default:
        return 'No disponible';
    }
  }

  List<Map<String, dynamic>> _getTrackingTimeline(String currentStatus) {
    List<Map<String, dynamic>> timeline = [
      {
        'title': 'Pedido Confirmado',
        'description': 'Tu pedido ha sido recibido y confirmado',
        'time': 'Hace 2 días',
        'isCompleted': true,
        'isCurrent': false,
      },
      {
        'title': 'Preparando Pedido',
        'description': 'Tu pedido está siendo preparado para envío',
        'time': currentStatus == 'On Progress' ? 'En progreso' : 'Hace 1 día',
        'isCompleted': currentStatus != 'On Progress',
        'isCurrent': currentStatus == 'On Progress',
      },
      {
        'title': 'En Camino',
        'description': 'Tu pedido está en camino a su destino',
        'time': null,
        'isCompleted': currentStatus == 'Completed',
        'isCurrent': false,
      },
      {
        'title': 'Entregado',
        'description': 'Tu pedido ha sido entregado exitosamente',
        'time': currentStatus == 'Completed' ? 'Completado' : null,
        'isCompleted': currentStatus == 'Completed',
        'isCurrent': false,
      },
    ];

    if (currentStatus == 'Cancelled') {
      timeline = timeline.take(2).toList();
      timeline.add({
        'title': 'Pedido Cancelado',
        'description': 'Tu pedido ha sido cancelado',
        'time': 'Cancelado',
        'isCompleted': false,
        'isCurrent': true,
      });
    }

    return timeline;
  }

  String _formatDeliveryDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Mañana';
    } else if (difference.inDays > 0) {
      return 'En ${difference.inDays} días';
    } else {
      return 'Ya entregado';
    }
  }

  String _formatOrderDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else {
      return '${difference.inDays} días atrás';
    }
  }
}
