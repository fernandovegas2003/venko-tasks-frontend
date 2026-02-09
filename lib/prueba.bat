@echo off
echo ===============================================
echo CREANDO ESTRUCTURA HEXAGONAL FLUTTER
echo ===============================================
echo.

REM Verificar que estamos en lib/
if not exist "..\pubspec.yaml" (
    echo ERROR: Debes ejecutar este script en la carpeta 'lib' de tu proyecto Flutter
    echo Mueve este archivo a: tu_proyecto_flutter\lib\
    pause
    exit /b 1
)

echo [1] Creando directorios CORE...
mkdir core 2>nul
mkdir core\constants 2>nul
mkdir core\exceptions 2>nul
mkdir core\utils 2>nul
mkdir core\widgets 2>nul

echo [2] Creando directorios DOMAIN...
mkdir domain 2>nul
mkdir domain\entities 2>nul

echo [3] Creando directorios APPLICATION...
mkdir application 2>nul
mkdir application\ports 2>nul
mkdir application\ports\in 2>nul
mkdir application\ports\out 2>nul
mkdir application\usecases 2>nul
mkdir application\dto 2>nul

echo [4] Creando directorios INFRASTRUCTURE...
mkdir infrastructure 2>nul
mkdir infrastructure\datasources 2>nul
mkdir infrastructure\repositories 2>nul
mkdir infrastructure\services 2>nul

echo [5] Creando directorios PRESENTATION...
mkdir presentation 2>nul
mkdir presentation\providers 2>nul
mkdir presentation\pages 2>nul
mkdir presentation\widgets 2>nul
mkdir presentation\themes 2>nul

echo [6] Creando archivos base...
REM Crear archivos vacíos para marcar las carpetas
echo // Directorio CORE > core\.gitkeep
echo // Directorio DOMAIN > domain\.gitkeep
echo // Directorio APPLICATION > application\.gitkeep
echo // Directorio INFRASTRUCTURE > infrastructure\.gitkeep
echo // Directorio PRESENTATION > presentation\.gitkeep

echo.
echo ===============================================
echo ESTRUCTURA CREADA EXITOSAMENTE!
echo ===============================================
echo.
echo Directorios creados:
echo.
tree /F /A
echo.
echo Siguientes pasos:
echo 1. Copia los archivos .dart que te di en cada carpeta
echo 2. Asegurate de tener las dependencias en pubspec.yaml
echo 3. Ejecuta: flutter pub get
echo.
echo Presiona cualquier tecla para continuar...
pause >nul