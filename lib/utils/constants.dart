class AppConstants {
  // Storage keys
  static const String accessTokenKey = "access_token";
  static const String refreshTokenKey = "refresh_token";
  static const String userDataKey = "user_data";
  static const String isLoggedInKey = "is_logged_in";
  static const String deviceIdKey = "device_id";
  static const String onboardingKey = "onboarding_complete";

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Error messages
  static const String networkError =
      "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.";
  static const String serverError =
      "Terjadi kesalahan pada server. Silakan coba lagi nanti.";
  static const String timeoutError = "Koneksi timeout. Silakan coba lagi.";
  static const String unknownError = "Terjadi kesalahan. Silakan coba lagi.";
  static const String sessionExpired =
      "Sesi Anda telah berakhir. Silakan login kembali.";

  // Success messages
  static const String loginSuccess = "Login berhasil!";
  static const String registerSuccess =
      "Registrasi berhasil! Silakan verifikasi email Anda.";
  static const String logoutSuccess = "Logout berhasil.";

  // Validation messages
  static const String emailRequired = "Email tidak boleh kosong";
  static const String emailInvalid = "Format email tidak valid";
  static const String passwordRequired = "Password tidak boleh kosong";
  static const String passwordMinLength = "Password minimal 8 karakter";
  static const String nameRequired = "Nama tidak boleh kosong";
  static const String confirmPasswordMatch = "Konfirmasi password tidak cocok";

  // App info
  static const String appName = "Lentera Karir";
  static const String appVersion = "1.0.0";

  // Regex patterns
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp phoneRegex = RegExp(r'^[0-9]{10,13}$');
}
