# Kiosco - Aplicación de E-commerce

Una aplicación Flutter moderna para gestionar un kiosco digital con capacidades offline y sincronización en línea.

## 🚀 Características

- ✅ **Autenticación**: Login y registro de usuarios
- ✅ **Navegación Principal**: 5 secciones principales (Inicio, Búsqueda, Pedidos, Favoritos, Perfil)
- ✅ **Catálogo de Productos**: Navegación por categorías
- ✅ **Búsqueda**: Búsqueda inteligente con historial
- ✅ **Gestión de Pedidos**: Seguimiento en tiempo real
- ✅ **Favoritos**: Gestión de productos favoritos
- ✅ **Perfil de Usuario**: Configuración y estadísticas
- ✅ **Tema Moderno**: Material Design 3 con modo claro/oscuro
- 🔄 **Base de Datos Híbrida**: SQLite local + sincronización con servidor
- 🔄 **Modo Offline**: Funcionalidad completa sin conexión

## 📱 Pantallas Implementadas

### Autenticación
- **Login**: Acceso con email y contraseña
- **Registro**: Creación de nuevas cuentas

### Navegación Principal
- **Inicio**: Dashboard con productos populares y categorías
- **Búsqueda**: Búsqueda avanzada con filtros y historial
- **Pedidos**: Gestión de pedidos actuales e historial
- **Favoritos**: Productos marcados como favoritos
- **Perfil**: Información del usuario y configuraciones

### Configuración
- **Ajustes**: Notificaciones, tema, idioma y más
- **Información**: Términos, privacidad y soporte

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework principal
- **Material Design 3**: Sistema de diseño
- **SQLite**: Base de datos local
- **HTTP**: Comunicación con API
- **SharedPreferences**: Configuraciones locales
- **Connectivity Plus**: Detección de conectividad

## 📁 Estructura del Proyecto

```
lib/
├── core/
│   ├── constants/          # Constantes de la aplicación
│   ├── themes/            # Temas y estilos
│   └── utils/             # Utilidades y helpers
├── data/
│   ├── models/            # Modelos de datos
│   ├── repositories/      # Repositorios de datos
│   └── datasources/       # Fuentes de datos (local/remoto)
└── presentation/
    ├── pages/             # Pantallas de la aplicación
    │   ├── auth/          # Autenticación
    │   ├── home/          # Página principal
    │   ├── search/        # Búsqueda
    │   ├── orders/        # Pedidos
    │   ├── favorites/     # Favoritos
    │   ├── profile/       # Perfil
    │   └── settings/      # Configuración
    ├── widgets/           # Widgets reutilizables
    └── providers/         # Gestión de estado
```

## 🎨 Diseño y UI/UX

- **Material Design 3**: Última versión del sistema de diseño de Google
- **Tema Adaptativo**: Soporte para modo claro y oscuro
- **Iconografía Consistente**: Icons de Material Design
- **Tipografía**: Jerarquía clara y legible
- **Colores**: Paleta moderna y accesible
- **Animaciones**: Transiciones suaves y naturales

## 🗄️ Arquitectura de Datos

### Base de Datos Local (SQLite)
- **users**: Información de usuarios
- **products**: Catálogo de productos
- **orders**: Pedidos del usuario
- **favorites**: Productos favoritos
- **cart**: Carrito de compras

### Sincronización
- **Modo Offline**: Funcionalidad completa sin conexión
- **Sincronización Automática**: Cuando hay conexión disponible
- **Resolución de Conflictos**: Estrategias para datos conflictivos

## 🚦 Instalación y Uso

### Prerrequisitos
- Flutter SDK (>= 3.8.1)
- Dart SDK
- Android Studio / Xcode (para desarrollo móvil)

### Instalación
```bash
# Clonar el repositorio
git clone https://github.com/Guevara0711/Kiosco.git

# Navegar al directorio
cd kiosco

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

### Comandos Útiles
```bash
# Analizar código
flutter analyze

# Ejecutar tests
flutter test

# Compilar para producción
flutter build apk --release
flutter build ios --release
```

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  intl: ^0.19.0              # Formateo de fechas y números
  sqflite: ^2.3.0            # Base de datos SQLite
  http: ^1.2.0               # Peticiones HTTP
  path_provider: ^2.1.2      # Gestión de archivos
  shared_preferences: ^2.2.2  # Preferencias locales
  connectivity_plus: ^5.0.2   # Estado de conectividad
```

## 🔄 Estado del Proyecto

### ✅ Completado
- [x] Estructura del proyecto
- [x] Navegación principal
- [x] Pantallas de autenticación
- [x] UI/UX de todas las pantallas principales
- [x] Modelos de datos básicos
- [x] Configuración de dependencias

### 🔄 En Desarrollo
- [ ] Implementación de SQLite
- [ ] API REST para sincronización
- [ ] Gestión de estado con Provider/Riverpod
- [ ] Carrito de compras funcional
- [ ] Procesamiento de pagos
- [ ] Notificaciones push
- [ ] Tests unitarios y de integración

### 📋 Próximas Características
- [ ] Geolocalización para delivery
- [ ] Chat de soporte
- [ ] Sistema de reseñas
- [ ] Programa de puntos/loyalty
- [ ] Integración con pasarelas de pago
- [ ] Dashboard administrativo

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/NuevaCaracteristica`)
3. Commit tus cambios (`git commit -m 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/NuevaCaracteristica`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👨‍💻 Autor

**Guevara0711**
- GitHub: [@Guevara0711](https://github.com/Guevara0711)
- Email: alejandrocast0724@live.com

## 📞 Soporte

Si tienes preguntas o necesitas ayuda:
- 📧 Email: alejandrocast0724@live.com
- 💬 GitHub Issues: [Crear un issue](https://github.com/Guevara0711/Kiosco/issues)

---

⭐ ¡Si te gusta este proyecto, no olvides darle una estrella!
