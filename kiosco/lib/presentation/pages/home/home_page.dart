import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con saludo y iconos
                _buildHeader(),
                const SizedBox(height: 12),
                
                // Tabs Home y Category
                _buildTabs(),
                const SizedBox(height: 25),
                
                // Banner promocional
                _buildPromoBanner(),
                const SizedBox(height: 30),
                
                // Sección New Arrivals
                _buildNewArrivalsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        FHeader(
          title: Row(
            children: [
              FAvatar(
                image: const NetworkImage(''),
                fallback: const Text('J'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, Jonathan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Let's go shopping",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          suffixes: [
            FHeaderAction(
              icon: Icon(FIcons.search, size: 20),
              onPress: () {
                // TODO: Implementar búsqueda
              },
            ),
            FHeaderAction(
              icon: Stack(
                children: [
                  Icon(FIcons.bell, size: 20),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              onPress: () {
                // TODO: Implementar notificaciones
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 11), // Espacio para la barra
              child: Text(
                'Home',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 40),
        Padding(
          padding: const EdgeInsets.only(bottom: 11), // Mismo padding para alinear
          child: Text(
            'Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      height: 170,
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildBannerItem(
                '24% off shipping today on bag purchases',
                '',
                'By Kutuku Store',
                [Colors.blue[100]!, Colors.grey[100]!],
              ),
              _buildBannerItem(
                'Free delivery on orders over \$50',
                '',
                'Limited time offer',
                [Colors.green[100]!, Colors.grey[100]!],
              ),
              _buildBannerItem(
                '30% off electronics this weekend only',
                '',
                'By TechStore',
                [Colors.purple[100]!, Colors.grey[100]!],
              ),
            ],
          ),
          // Indicadores de página
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(String title, String subtitle, String store, List<Color> colors) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          // Círculo decorativo con clipBorderRadius
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Positioned(
              left: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colors[0].withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Contenido del banner
          Positioned(
            left: 25,
            top: 25,
            right: 130, // Espacio para la imagen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Text(
                  store,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Imagen de la bolsa
          Positioned(
            right: 20,
            top: 20,
            bottom: 40,
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300],
              ),
              child: Icon(
                FIcons.shoppingBag,
                color: Colors.grey[600],
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivalsSection() {
    return Column(
      children: [
        // Header de la sección
        Row(
          children: [
            Text(
              'New Arrivals 🔥',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            Text(
              'See All',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Grid de productos
        Row(
          children: [
            Expanded(
              child: _buildProductCard(
                'The Mirac Jiz',
                'Lisa Robber',
                '\$195.00',
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildProductCard(
                'Meriza Kiles',
                'Gazuna Resika',
                '\$143.45',
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildProductCard(
                'Product 3',
                'Brand Name',
                '\$89.99',
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildProductCard(
                'Product 4',
                'Brand Name',
                '\$125.00',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard(String name, String brand, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.grey[200],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    FIcons.shoppingBag,
                    color: Colors.grey[400],
                    size: 50,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FIcons.heart,
                      color: Colors.grey[600],
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Información del producto
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  brand,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
