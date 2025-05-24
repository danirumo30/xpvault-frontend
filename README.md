# XPVault - Frontend

**XPVault** es la aplicación frontend desarrollada con **Flutter**, diseñada para ofrecer una interfaz fluida, multiplataforma y segura. Se conecta al backend de XPVault para gestionar información personal relacionada con perfiles de Steam, películas y series.

## 🚀 Tecnologías utilizadas

- Flutter 3.x
- Dart
- Provider (para gestión de estado)
- HTTP (para consumo de API REST)
- Flutter Secure Storage (almacenamiento seguro local)
- Shared Preferences
- GoRouter (navegación)
- Material Design

## ⚙️ Requisitos previos

- Flutter SDK 3.x
- Dart SDK
- Un emulador o dispositivo físico (Android/iOS)
- Conexión con el backend de XPVault en ejecución

## 🔧 Configuración

> **Importante:** Este frontend requiere que el [backend de XPVault](https://github.com/danirumo30/xpvault) esté correctamente configurado y en ejecución.  
> Sigue los pasos descritos en su `README.md` para asegurar que el servidor backend esté operativo antes de iniciar la app frontend.


1. Clona el repositorio:

   ```bash
   git clone https://github.com/tuusuario/xpvault-gui.git
   cd xpvault-gui
   ```

2. Instala las dependencias de Flutter:

   ```bash
   flutter pub get
   ```

3. Configura la URL base del backend en el archivo `lib/core/constants/environment.dart`:

   ```dart
   class Environment {
     static const String apiUrl = "http://10.0.2.2:8080/api"; // Cambia por tu IP si es necesario
   }
   ```

   > **Nota:** En emuladores Android usa `10.0.2.2` para acceder al `localhost` del host. En dispositivos físicos o iOS, usa la IP local del backend.

4. Ejecuta la aplicación:

   ```bash
   flutter run
   ```

   Puedes especificar el dispositivo con:

   ```bash
   flutter devices
   flutter run -d <device_id>
   ```

## 📁 Estructura del proyecto

```
xpvault-gui/
├── lib/
│   ├── core/             # Configuraciones y constantes generales
│   ├── data/             # Modelos y servicios API
│   ├── providers/        # Gestión de estado
│   ├── screens/          # Vistas principales
│   ├── widgets/          # Componentes reutilizables
│   └── main.dart         # Punto de entrada
├── assets/               # Recursos estáticos (imágenes, etc.)
├── pubspec.yaml
└── android/ios/          # Código nativo
```

## 🔐 Autenticación

La app utiliza **JWT** para autenticación. Los tokens se almacenan de forma segura usando `flutter_secure_storage`, y se manejan automáticamente para mantener la sesión del usuario.

## 📲 Funcionalidades

- Registro e inicio de sesión de usuario
- Conexión segura con el backend
- Visualización de perfil de Steam
- Listado de películas y series favoritas
- UI responsive y adaptativa para distintas plataformas

## 🧪 Pruebas

Para ejecutar pruebas (si están implementadas):

```bash
flutter test
```

## 👥 Autores

- Daniel Rubio Mora  
- David Calderón Daza  
- Manuel Martín Rodríguez

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## 🙋‍♀️ Contribuciones

¡Las contribuciones son bienvenidas! Abre un issue o un pull request con tus mejoras o sugerencias.
