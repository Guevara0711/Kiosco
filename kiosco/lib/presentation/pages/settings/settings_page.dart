import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Español';
  String _selectedCurrency = 'COP (\$)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de Notificaciones
          _buildSectionHeader('Notificaciones'),
          _buildSwitchTile(
            title: 'Notificaciones push',
            subtitle: 'Recibir alertas de pedidos y ofertas',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            icon: Icons.notifications,
          ),
          _buildSwitchTile(
            title: 'Sonidos',
            subtitle: 'Reproducir sonidos de notificación',
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
            icon: Icons.volume_up,
          ),
          _buildSwitchTile(
            title: 'Vibración',
            subtitle: 'Vibrar al recibir notificaciones',
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
            icon: Icons.vibration,
          ),

          const SizedBox(height: 24),

          // Sección de Apariencia
          _buildSectionHeader('Apariencia'),
          _buildSwitchTile(
            title: 'Modo oscuro',
            subtitle: 'Usar tema oscuro en la aplicación',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
            icon: Icons.dark_mode,
          ),

          const SizedBox(height: 24),

          // Sección de Idioma y Región
          _buildSectionHeader('Idioma y región'),
          _buildListTile(
            title: 'Idioma',
            subtitle: _selectedLanguage,
            icon: Icons.language,
            onTap: () => _showLanguageDialog(),
          ),
          _buildListTile(
            title: 'Moneda',
            subtitle: _selectedCurrency,
            icon: Icons.attach_money,
            onTap: () => _showCurrencyDialog(),
          ),

          const SizedBox(height: 24),

          // Sección de Cuenta
          _buildSectionHeader('Cuenta'),
          _buildListTile(
            title: 'Cambiar contraseña',
            subtitle: 'Actualizar tu contraseña de acceso',
            icon: Icons.lock,
            onTap: () => _showChangePasswordDialog(),
          ),
          _buildListTile(
            title: 'Eliminar cuenta',
            subtitle: 'Eliminar permanentemente tu cuenta',
            icon: Icons.delete_forever,
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () => _showDeleteAccountDialog(),
          ),

          const SizedBox(height: 24),

          // Sección de Aplicación
          _buildSectionHeader('Aplicación'),
          _buildListTile(
            title: 'Versión',
            subtitle: '1.0.0',
            icon: Icons.info,
            trailing: const SizedBox(),
          ),
          _buildListTile(
            title: 'Términos y condiciones',
            subtitle: 'Leer los términos de uso',
            icon: Icons.description,
            onTap: () => _showTermsDialog(),
          ),
          _buildListTile(
            title: 'Política de privacidad',
            subtitle: 'Cómo manejamos tus datos',
            icon: Icons.privacy_tip,
            onTap: () => _showPrivacyDialog(),
          ),
          _buildListTile(
            title: 'Limpiar caché',
            subtitle: 'Borrar datos temporales',
            icon: Icons.cleaning_services,
            onTap: () => _showClearCacheDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: textColor != null ? TextStyle(color: textColor) : null,
        ),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Español'),
              value: 'Español',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar moneda'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Peso Colombiano (COP)'),
              value: 'COP (\$)',
              groupValue: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Dólar Estadounidense (USD)'),
              value: 'USD (\$)',
              groupValue: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirmar nueva contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contraseña actualizada')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar eliminación de cuenta
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función no implementada'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'Aquí irían los términos y condiciones completos de la aplicación...\n\n'
            '1. Uso de la aplicación\n'
            '2. Privacidad de datos\n'
            '3. Políticas de compra\n'
            '4. Devoluciones y reembolsos\n'
            '5. Limitaciones de responsabilidad\n\n'
            'Al usar esta aplicación, aceptas estos términos.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'Tu privacidad es importante para nosotros...\n\n'
            '• Recopilamos información para mejorar tu experiencia\n'
            '• No compartimos datos personales con terceros\n'
            '• Usamos cifrado para proteger tu información\n'
            '• Puedes solicitar la eliminación de tus datos\n\n'
            'Para más información, visita nuestro sitio web.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar caché'),
        content: const Text(
          '¿Quieres limpiar el caché de la aplicación? Esto puede ayudar a resolver problemas de rendimiento.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Caché limpiado')),
              );
            },
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }
}
