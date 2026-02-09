class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es obligatorio';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }
  
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre de usuario es obligatorio';
    }
    
    if (value.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    
    return null;
  }
  
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'El título es obligatorio';
    }
    
    if (value.length > 100) {
      return 'El título no puede exceder 100 caracteres';
    }
    
    return null;
  }
  
  static String? validateDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'La descripción no puede exceder 500 caracteres';
    }
    
    return null;
  }
}