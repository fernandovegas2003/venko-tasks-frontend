# Venko Tasks - Gestor de Tareas

Aplicación móvil para gestión de tareas desarrollada en Flutter con funcionalidades completas de CRUD, autenticación de usuarios y conexión a API REST.

## Características Principales

### Autenticación
- Registro de nuevos usuarios
- Inicio de sesión seguro
- Tokens JWT para autorización
- Persistencia de sesión

### Gestión de Tareas
- Crear, leer, actualizar y eliminar tareas (CRUD completo)
- Asignar prioridades (Baja, Media, Alta, Urgente)
- Establecer fechas de vencimiento
- Seguimiento de estado (Pendiente, En Progreso, Completada, Cancelada)
- DatePicker integrado para selección de fechas
- Filtrado y organización de tareas

### Tecnologías Utilizadas
- **Flutter 3.x** - Framework multiplataforma
- **Riverpod** - Gestión de estado
- **HTTP Client** - Conexión a API REST
- **Shared Preferences** - Almacenamiento local
- **Material Design 3** - Interfaz de usuario moderna

### Arquitectura
- Clean Architecture con separación de responsabilidades
- State Management con Riverpod
- Modelos de datos con Equatable
- Manejo de excepciones personalizado
- Servicios para comunicación con API

## Estructura del Proyecto
