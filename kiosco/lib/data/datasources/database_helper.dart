import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kiosco/core/constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Obtener el directorio de documentos de la aplicación
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, AppConstants.databaseName);

    // Abrir/crear la base de datos
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Crear las tablas cuando se crea la base de datos por primera vez
  Future<void> _onCreate(Database db, int version) async {
    // Tabla de usuarios
    await db.execute('''
      CREATE TABLE ${AppConstants.userTable} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        phone TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    // Tabla de productos
    await db.execute('''
      CREATE TABLE ${AppConstants.productsTable} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        image_url TEXT,
        is_available INTEGER DEFAULT 1,
        stock INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Tabla de pedidos
    await db.execute('''
      CREATE TABLE ${AppConstants.ordersTable} (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        status TEXT NOT NULL,
        total REAL NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        estimated_time TEXT,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES ${AppConstants.userTable} (id)
      )
    ''');

    // Tabla de items de pedidos
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES ${AppConstants.ordersTable} (id),
        FOREIGN KEY (product_id) REFERENCES ${AppConstants.productsTable} (id)
      )
    ''');

    // Tabla de favoritos
    await db.execute('''
      CREATE TABLE ${AppConstants.favoritesTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES ${AppConstants.userTable} (id),
        FOREIGN KEY (product_id) REFERENCES ${AppConstants.productsTable} (id),
        UNIQUE(user_id, product_id)
      )
    ''');

    // Tabla del carrito
    await db.execute('''
      CREATE TABLE ${AppConstants.cartTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        FOREIGN KEY (user_id) REFERENCES ${AppConstants.userTable} (id),
        FOREIGN KEY (product_id) REFERENCES ${AppConstants.productsTable} (id),
        UNIQUE(user_id, product_id)
      )
    ''');

    // Tabla de configuraciones de usuario
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        setting_key TEXT NOT NULL,
        setting_value TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES ${AppConstants.userTable} (id),
        UNIQUE(user_id, setting_key)
      )
    ''');

    // Insertar datos de ejemplo
    await _insertSampleData(db);
  }

  // Manejar actualizaciones de la base de datos
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Aquí puedes manejar migraciones de base de datos
    if (oldVersion < 2) {
      // Ejemplo: agregar nueva columna en versión 2
      // await db.execute('ALTER TABLE products ADD COLUMN new_column TEXT');
    }
  }

  // Insertar datos de ejemplo para testing
  Future<void> _insertSampleData(Database db) async {
    // Productos de ejemplo
    final sampleProducts = [
      {
        'id': '1',
        'name': 'Coca Cola',
        'description': 'Bebida refrescante con gas',
        'price': 2.50,
        'category': 'Bebidas',
        'image_url': null,
        'is_available': 1,
        'stock': 50,
        'created_at': DateTime.now().toIso8601String(),
        'synced': 0,
      },
      {
        'id': '2',
        'name': 'Sandwich de jamón',
        'description': 'Sandwich fresco con jamón y vegetales',
        'price': 4.99,
        'category': 'Comida',
        'image_url': null,
        'is_available': 1,
        'stock': 20,
        'created_at': DateTime.now().toIso8601String(),
        'synced': 0,
      },
      {
        'id': '3',
        'name': 'Café americano',
        'description': 'Café negro recién preparado',
        'price': 3.25,
        'category': 'Bebidas',
        'image_url': null,
        'is_available': 1,
        'stock': 30,
        'created_at': DateTime.now().toIso8601String(),
        'synced': 0,
      },
      {
        'id': '4',
        'name': 'Galletas de chocolate',
        'description': 'Galletas crujientes con chispas de chocolate',
        'price': 1.75,
        'category': 'Dulces',
        'image_url': null,
        'is_available': 1,
        'stock': 40,
        'created_at': DateTime.now().toIso8601String(),
        'synced': 0,
      },
      {
        'id': '5',
        'name': 'Papas fritas',
        'description': 'Papas crujientes y doradas',
        'price': 2.99,
        'category': 'Snacks',
        'image_url': null,
        'is_available': 1,
        'stock': 25,
        'created_at': DateTime.now().toIso8601String(),
        'synced': 0,
      },
    ];

    for (final product in sampleProducts) {
      await db.insert(AppConstants.productsTable, product);
    }
  }

  // Cerrar la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Limpiar la base de datos (para testing)
  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
