class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Konfirmasi password tidak cocok';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }

    return null;
  }

  // Phone validation (optional field)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }

    final phoneRegex = RegExp(r'^[0-9]{10,13}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Format nomor telepon tidak valid';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  // Token validation
  static String? validateToken(String? value) {
    if (value == null || value.isEmpty) {
      return 'Token tidak boleh kosong';
    }

    if (value.length < 6) {
      return 'Token tidak valid';
    }

    return null;
  }
}
