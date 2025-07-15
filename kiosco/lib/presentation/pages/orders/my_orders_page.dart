import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _currentOrders = [
    {
      'id': 'ORD-001',
      'status': 'preparando',
      'items': ['Sandwich de jamón', 'Coca Cola', 'Papas fritas'],
      'total': '\$8.48',
      'date': DateTime.now().subtract(const Duration(minutes: 15)),
      'estimatedTime': '10 min',
    },
    {
      'id': 'ORD-002',
      'status': 'listo',
      'items': ['Café americano', 'Galletas'],
      'total': '\$5.00',
      'date': DateTime.now().subtract(const Duration(hours: 1)),
      'estimatedTime': 'Listo para recoger',
    },
  ];

  final List<Map<String, dynamic>> _orderHistory = [
    {
      'id': 'ORD-003',
      'status': 'completado',
      'items': ['Agua mineral', 'Sandwich de pollo', 'Café con leche'],
      'total': '\$10.99',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 'ORD-004',
      'status': 'completado',
      'items': ['Coca Cola Zero', 'Galletas de chocolate'],
      'total': '\$4.25',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 'ORD-005',
      'status': 'cancelado',
      'items': ['Papas fritas', 'Agua mineral'],
      'total': '\$4.24',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Actuales'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCurrentOrders(),
          _buildOrderHistory(),
        ],
      ),
    );
  }

  Widget _buildCurrentOrders() {
    if (_currentOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'No tienes pedidos activos',
        subtitle: 'Cuando hagas un pedido, aparecerá aquí',
        actionText: 'Explorar productos',
        onAction: () {
          // TODO: Navegar a la página principal
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _currentOrders.length,
      itemBuilder: (context, index) {
        final order = _currentOrders[index];
        return _buildCurrentOrderCard(order);
      },
    );
  }

  Widget _buildOrderHistory() {
    if (_orderHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No tienes historial de pedidos',
        subtitle: 'Tus pedidos completados aparecerán aquí',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orderHistory.length,
      itemBuilder: (context, index) {
        final order = _orderHistory[index];
        return _buildHistoryOrderCard(order);
      },
    );
  }

  Widget _buildCurrentOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedido ${order['id']}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                _buildStatusChip(order['status']),
              ],
            ),
            const SizedBox(height: 12),
            
            // Items del pedido
            ...List.generate(
              (order['items'] as List).length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      order['items'][index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: ${order['total']}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['estimatedTime'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (order['status'] == 'preparando')
                      OutlinedButton(
                        onPressed: () {
                          _showCancelDialog(order['id']);
                        },
                        child: const Text('Cancelar'),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _showOrderDetails(order);
                      },
                      child: const Text('Ver detalles'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order['status']).withOpacity(0.1),
          child: Icon(
            _getStatusIcon(order['status']),
            color: _getStatusColor(order['status']),
          ),
        ),
        title: Text('Pedido ${order['id']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${order['items'].length} productos • ${order['total']}'),
            Text(
              _formatDate(order['date']),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusChip(order['status']),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _reorderItems(order);
              },
              tooltip: 'Volver a pedir',
            ),
          ],
        ),
        onTap: () {
          _showOrderDetails(order);
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = _getStatusColor(status);
    String text = _getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'preparando':
        return Colors.orange;
      case 'listo':
        return Colors.green;
      case 'completado':
        return Colors.blue;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'preparando':
        return Icons.restaurant;
      case 'listo':
        return Icons.check_circle;
      case 'completado':
        return Icons.done_all;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'preparando':
        return 'Preparando';
      case 'listo':
        return 'Listo';
      case 'completado':
        return 'Completado';
      case 'cancelado':
        return 'Cancelado';
      default:
        return 'Desconocido';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ayer ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    // TODO: Implementar página de detalles del pedido
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Detalles del pedido ${order['id']}')),
    );
  }

  void _showCancelDialog(String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar pedido'),
        content: const Text('¿Estás seguro de que quieres cancelar este pedido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cancelOrder(orderId);
            },
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  void _cancelOrder(String orderId) {
    // TODO: Implementar cancelación del pedido
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pedido $orderId cancelado')),
    );
  }

  void _reorderItems(Map<String, dynamic> order) {
    // TODO: Implementar re-orden
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Productos agregados al carrito')),
    );
  }
}
