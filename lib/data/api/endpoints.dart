class ApiEndpoints {
  // Base URL - ganti dengan localhost untuk development lokal
  // atau gunakan ngrok URL untuk testing dari device fisik
  static const String baseUrl =
      "https://api-lentera-karir.respatibc.com/api/v1";

  // ============================================================
  // AUTH ENDPOINTS (mounted at /api/v1/auth)
  // ============================================================
  static const String register = "/auth/register";
  static const String verifyEmail = "/auth/verify-email"; // GET with ?token=
  static const String login = "/auth/login";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resetPassword = "/auth/reset-password";
  static const String refreshToken = "/auth/refresh-token";
  static const String me = "/auth/me";
  static const String checkStatus = "/auth/check-status";

  // ============================================================
  // DASHBOARD ENDPOINTS (mounted at /api/v1/dashboard)
  // ============================================================
  static const String dashboardStats = "/dashboard/stats";
  static const String dashboardContinueLearning = "/dashboard/continue-learning";
  static const String dashboardRecommended = "/dashboard/recommended";

  // ============================================================
  // LEARNING ENDPOINTS (mounted at /api/v1)
  // ============================================================
  // Dashboard belajar (daftar LP yang dimiliki user)
  static const String learnDashboard = "/learn/dashboard";
  // Daftar course yang sudah di-enroll
  static const String myCourses = "/learn/my-courses";
  // Ebook yang dimiliki user
  static const String myEbooks = "/learn/ebooks";
  // Konten learning path (detail + progress)
  static String learningPathContent(String lpId) => "/learn/learning-paths/$lpId";
  // Konten course (detail + modules + progress)
  static String courseContent(String courseId) => "/learn/courses/$courseId";
  // Tandai module selesai (POST)
  static String completeModule(String moduleId) =>
      "/learn/modules/$moduleId/complete";

  // ============================================================
  // QUIZ ENDPOINTS (mounted at /api/v1)
  // ============================================================
  // Mulai atau resume quiz (POST)
  static String startQuiz(String quizId) => "/learn/quiz/$quizId/start";
  // Simpan jawaban parsial (POST)
  static String saveQuizAnswer(String attemptId) =>
      "/learn/attempts/$attemptId/answer";
  // Submit quiz untuk grading (POST)
  static String submitQuiz(String attemptId) =>
      "/learn/attempts/$attemptId/submit";

  // ============================================================
  // CERTIFICATE ENDPOINTS (mounted at /api/v1/certificates)
  // ============================================================
  static const String certificates = "/certificates";
  static String certificateDetail(String certificateId) =>
      "/certificates/$certificateId";
  static String certificateStatus(String courseId) =>
      "/certificates/status/$courseId";

  // ============================================================
  // USER CERTIFICATE ENDPOINTS (mounted at /api/v1/user-certificates)
  // User bisa generate sertifikat sendiri setelah menyelesaikan course
  // ============================================================
  static String checkCourseCompletion(String courseId) =>
      "/user-certificates/check/$courseId";
  static const String certificateTemplates = "/user-certificates/templates";
  static const String previewCertificate = "/user-certificates/preview";
  static const String generateCertificate = "/user-certificates/generate";

  // ============================================================
  // PAYMENT ENDPOINTS (mounted at /api/v1)
  // ============================================================
  static const String createPayment = "/payments/checkout";
  static String paymentStatus(String orderId) => "/payments/status/$orderId";
  static const String syncPayments = "/payments/sync";

  // ============================================================
  // PUBLIC/CATALOG ENDPOINTS (mounted at /api/v1)
  // Tidak memerlukan autentikasi
  // ============================================================
  static const String catalogLearningPaths = "/catalog/learning-paths";
  static String catalogLearningPathDetail(String pathId) =>
      "/catalog/learning-paths/$pathId";
  static const String catalogCourses = "/catalog/courses";
  static String catalogCourseDetail(String courseId) =>
      "/catalog/courses/$courseId";
  static const String catalogCategories = "/catalog/categories";
  static const String catalogMentors = "/catalog/mentors";
}
