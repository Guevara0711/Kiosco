class AppConstants {
  // URLs de la API
  static const String baseUrl = 'https://api.kiosco.com';
  static const String apiVersion = '/v1';
  
  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String productsEndpoint = '/products';
  static const String ordersEndpoint = '/orders';
  static const String favoritesEndpoint = '/favorites';
  
  // Base de datos local
  static const String databaseName = 'kiosco_db.db';
  static const int databaseVersion = 1;
  
  // Tablas de la base de datos
  static const String userTable = 'users';
  static const String productsTable = 'products';
  static const String ordersTable = 'orders';
  static const String favoritesTable = 'favorites';
  static const String cartTable = 'cart';
  
  // Configuración de la aplicación
  static const String appName = 'Kiosco';
  static const String appVersion = '1.0.0';
  static const int itemsPerPage = 20;
  static const int maxRetries = 3;
  static const Duration timeoutDuration = Duration(seconds: 30);
  
  // Tipos de productos
  static const List<String> productCategories = [
    'Bebidas',
    'Comida',
    'Snacks',
    'Dulces',
    'Despensa',
    'Otros',
  ];
  
  // Estados de pedidos
  static const String orderStatusPending = 'pending';
  static const String orderStatusPreparing = 'preparing';
  static const String orderStatusReady = 'ready';
  static const String orderStatusCompleted = 'completed';
  static const String orderStatusCancelled = 'cancelled';
  
  // Métodos de pago
  static const List<String> paymentMethods = [
    'Efectivo',
    'Tarjeta de crédito',
    'Tarjeta de débito',
    'Transferencia',
    'PSE',
  ];
  
  // Configuración de notificaciones
  static const String notificationChannelId = 'kiosco_notifications';
  static const String notificationChannelName = 'Kiosco Notifications';
  static const String notificationChannelDescription = 'Notificaciones de pedidos y ofertas';
}
