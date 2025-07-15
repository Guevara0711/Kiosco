import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kiosco/data/datasources/database_helper.dart';
import 'package:kiosco/data/models/user.dart';
import 'package:kiosco/core/constants/app_constants.dart';
import 'package:kiosco/core/utils/app_utils.dart';

class AuthRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Registrar nuevo usuario
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final db = await _dbHelper.database;

      // Verificar si el email ya existe
      final existingUsers = await db.query(
        AppConstants.userTable,
        where: 'email = ?',
        whereArgs: [email],
      );

      if (existingUsers.isNotEmpty) {
        return AuthResult(
          success: false,
          message: 'El email ya está registrado',
        );
      }

      // Crear hash de la contraseña
      final passwordHash = _hashPassword(password);

      // Crear nuevo usuario
      final userId = AppUtils.generateId();
      final now = DateTime.now().toIso8601String();

      final userData = {
        'id': userId,
        'name': name,
        'email': email,
        'password_hash': passwordHash,
        'phone': phone,
        'created_at': now,
      };

      await db.insert(AppConstants.userTable, userData);

      return AuthResult(
        success: true,
        message: 'Usuario registrado exitosamente',
        user: User(
          id: userId,
          name: name,
          email: email,
          phone: phone,
          createdAt: DateTime.parse(now),
        ),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error al registrar usuario: $e',
      );
    }
  }

  // Iniciar sesión
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final db = await _dbHelper.database;

      // Buscar usuario por email
      final users = await db.query(
        AppConstants.userTable,
        where: 'email = ?',
        whereArgs: [email],
      );

      if (users.isEmpty) {
        return AuthResult(
          success: false,
          message: 'Usuario no encontrado',
        );
      }

      final userData = users.first;
      final storedPasswordHash = userData['password_hash'] as String;

      // Verificar contraseña
      if (!_verifyPassword(password, storedPasswordHash)) {
        return AuthResult(
          success: false,
          message: 'Contraseña incorrecta',
        );
      }

      // Crear objeto User
      final user = User(
        id: userData['id'] as String,
        name: userData['name'] as String,
        email: userData['email'] as String,
        phone: userData['phone'] as String?,
        createdAt: DateTime.parse(userData['created_at'] as String),
        updatedAt: userData['updated_at'] != null
            ? DateTime.parse(userData['updated_at'] as String)
            : null,
      );

      // Guardar sesión
      await _saveUserSession(user);

      return AuthResult(
        success: true,
        message: 'Login exitoso',
        user: user,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error al iniciar sesión: $e',
      );
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
    await prefs.remove('current_user_data');
  }

  // Verificar si hay una sesión activa
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('current_user_data');

      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final user = await getCurrentUser();
    return user != null;
  }

  // Actualizar perfil de usuario
  Future<AuthResult> updateProfile({
    required String userId,
    String? name,
    String? phone,
  }) async {
    try {
      final db = await _dbHelper.database;

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;

      await db.update(
        AppConstants.userTable,
        updateData,
        where: 'id = ?',
        whereArgs: [userId],
      );

      // Obtener usuario actualizado
      final users = await db.query(
        AppConstants.userTable,
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (users.isNotEmpty) {
        final userData = users.first;
        final user = User(
          id: userData['id'] as String,
          name: userData['name'] as String,
          email: userData['email'] as String,
          phone: userData['phone'] as String?,
          createdAt: DateTime.parse(userData['created_at'] as String),
          updatedAt: userData['updated_at'] != null
              ? DateTime.parse(userData['updated_at'] as String)
              : null,
        );

        // Actualizar sesión
        await _saveUserSession(user);

        return AuthResult(
          success: true,
          message: 'Perfil actualizado exitosamente',
          user: user,
        );
      }

      return AuthResult(
        success: false,
        message: 'Error al actualizar perfil',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error al actualizar perfil: $e',
      );
    }
  }

  // Cambiar contraseña
  Future<AuthResult> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final db = await _dbHelper.database;

      // Verificar contraseña actual
      final users = await db.query(
        AppConstants.userTable,
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (users.isEmpty) {
        return AuthResult(
          success: false,
          message: 'Usuario no encontrado',
        );
      }

      final userData = users.first;
      final storedPasswordHash = userData['password_hash'] as String;

      if (!_verifyPassword(currentPassword, storedPasswordHash)) {
        return AuthResult(
          success: false,
          message: 'Contraseña actual incorrecta',
        );
      }

      // Actualizar contraseña
      final newPasswordHash = _hashPassword(newPassword);
      await db.update(
        AppConstants.userTable,
        {
          'password_hash': newPasswordHash,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );

      return AuthResult(
        success: true,
        message: 'Contraseña actualizada exitosamente',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error al cambiar contraseña: $e',
      );
    }
  }

  // Métodos privados
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool _verifyPassword(String password, String hash) {
    final passwordHash = _hashPassword(password);
    return passwordHash == hash;
  }

  Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_id', user.id);
    await prefs.setString('current_user_data', jsonEncode(user.toJson()));
  }
}

// Clase para manejar resultados de autenticación
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}
