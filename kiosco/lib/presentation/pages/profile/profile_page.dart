import 'package:flutter/material.dart';
import 'package:kiosco/presentation/pages/settings/settings_page.dart';
import 'package:kiosco/presentation/pages/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, dynamic> _userProfile = {
    'name': 'Juan Pérez',
    'email': 'juan.perez@email.com',
    'phone': '+57 300 123 4567',
    'memberSince': 'Marzo 2024',
    'totalOrders': 25,
    'favoriteProducts': 8,
    'avatar': '👤',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header del perfil
            _buildProfileHeader(),
            
            const SizedBox(height: 32),
            
            // Estadísticas
            _buildStatsSection(),
            
            const SizedBox(height: 24),
            
            // Opciones del menú
            _buildMenuSection(),
            
            const SizedBox(height: 24),
            
            // Cerrar sesión
            _buildLogoutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                _userProfile['avatar'],
                style: const TextStyle(fontSize: 48),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Nombre
            Text(
              _userProfile['name'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            
            const SizedBox(height: 4),
            
            // Email
            Text(
              _userProfile['email'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón editar perfil
            OutlinedButton.icon(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Editar perfil'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.shopping_bag,
            title: 'Pedidos',
            value: '${_userProfile['totalOrders']}',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.favorite,
            title: 'Favoritos',
            value: '${_userProfile['favoriteProducts']}',
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.calendar_today,
            title: 'Miembro desde',
            value: _userProfile['memberSince'],
            color: Colors.green,
            isDate: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isDate = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: isDate ? 12 : 18,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'Mis pedidos',
          subtitle: 'Ver historial de compras',
          onTap: () {
            // TODO: Navegar a página de pedidos
          },
        ),
        _buildMenuItem(
          icon: Icons.favorite_outline,
          title: 'Mis favoritos',
          subtitle: 'Productos que me gustan',
          onTap: () {
            // TODO: Navegar a página de favoritos
          },
        ),
        _buildMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Direcciones',
          subtitle: 'Gestionar direcciones de entrega',
          onTap: () {
            _showAddressesDialog();
          },
        ),
        _buildMenuItem(
          icon: Icons.payment_outlined,
          title: 'Métodos de pago',
          subtitle: 'Tarjetas y formas de pago',
          onTap: () {
            _showPaymentMethodsDialog();
          },
        ),
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notificaciones',
          subtitle: 'Configurar alertas',
          onTap: () {
            _showNotificationSettings();
          },
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Ayuda y soporte',
          subtitle: 'Preguntas frecuentes y contacto',
          onTap: () {
            _showHelpDialog();
          },
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'Acerca de',
          subtitle: 'Información de la aplicación',
          onTap: () {
            _showAboutDialog();
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Card(
      color: Colors.red[50],
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: Colors.red[700],
        ),
        title: Text(
          'Cerrar sesión',
          style: TextStyle(
            color: Colors.red[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text('Salir de tu cuenta'),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.red[700],
        ),
        onTap: _showLogoutDialog,
      ),
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar perfil'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
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
                const SnackBar(content: Text('Perfil actualizado')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showAddressesDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de direcciones próximamente')),
    );
  }

  void _showPaymentMethodsDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de métodos de pago próximamente')),
    );
  }

  void _showNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración de notificaciones próximamente')),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda y soporte'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Necesitas ayuda?'),
            SizedBox(height: 16),
            Text('📧 Email: soporte@kiosco.com'),
            SizedBox(height: 8),
            Text('📱 WhatsApp: +57 300 123 4567'),
            SizedBox(height: 8),
            Text('🕒 Horario: Lun-Dom 8:00 AM - 10:00 PM'),
          ],
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

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Kiosco',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.store, size: 48),
      children: const [
        Text('Tu kiosco de confianza, ahora en tu teléfono.'),
        SizedBox(height: 16),
        Text('Desarrollado con ❤️ en Flutter'),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
