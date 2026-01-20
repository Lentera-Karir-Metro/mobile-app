# 🏗️ Arsitektur Lentera Karir Mobile App

## 📋 Status Dokumen
- **Referensi Pattern**: geo-attendance-app (Clean Architecture)
- **Total Files to Create**: 49 files
- **Backend Status**: ✅ 36/36 endpoints (100% implemented)
- **Last Updated**: Dengan detail endpoint API implementation

## 🔗 Sinkronisasi Dokumen
File ini sinkron dengan:
- **[ENDPOINT_VERIFICATION.md](./ENDPOINT_VERIFICATION.md)**: Verifikasi backend endpoints (36 endpoints)
- **[API_DOCUMENTATION.md](./API_DOCUMENTATION.md)**: Dokumentasi lengkap request/response API

### Summary Backend Endpoints (Total: 36)
| Category | Count | Prefix | Status |
|----------|-------|--------|--------|
| **Auth** | 8 | `/api/v1/auth` | ✅ Verified |
| **Dashboard** | 3 | `/api/v1/user/dashboard` | ✅ Verified |
| **Learning** | 9 | `/api/v1/user/learning` | ✅ Verified |
| **Certificate** | 7 | `/api/v1/user/certificates` | ✅ Verified |
| **Payment** | 3 | `/api/v1/user/payment` | ✅ Verified |
| **Catalog** | 6 | `/api/v1/public` | ✅ Verified |

---

## 📂 Penjelasan Struktur Folder

### 1. `lib/data/api/`
**Fungsi:** Layer API yang menangani komunikasi HTTP dengan backend.

| File | Fungsi |
|------|--------|
| `api_service.dart` | Base HTTP client dengan method GET, POST, PUT, PATCH, DELETE. Menangani headers, token auth, dan response parsing |
| `endpoints.dart` | Konstanta URL endpoint API (single source of truth) |
| `services/` | Folder berisi service khusus per fitur yang menggunakan ApiService |

### 2. `lib/data/api/services/`
**Fungsi:** Service layer yang memanggil ApiService untuk fitur spesifik.

Setiap service file:
- Mengimport `ApiService` dan `Endpoints`
- Membuat method untuk setiap API call
- Menangani transformasi data sebelum/sesudah API call
- Menyimpan cache ke SharedPreferences jika diperlukan

### 3. `lib/data/models/`
**Fungsi:** Data model/entity dengan serialization (fromJson/toJson).

Setiap model file:
- Class dengan typed properties
- Factory constructor `fromJson()`
- Method `toJson()`
- Optional: `copyWith()`, `toString()`

### 4. `lib/data/repositories/`
**Fungsi:** Repository layer sebagai abstraksi antara Service dan Provider.

Setiap repository file berisi:
- **Abstract class** (interface) mendefinisikan kontrak
- **Implementation class** yang mengimplementasi interface menggunakan Service

**Manfaat Pattern Ini:**
- Memudahkan unit testing (bisa mock repository)
- Loose coupling antara layer
- Single Responsibility Principle

### 5. `lib/providers/`
**Fungsi:** State management dengan ChangeNotifier (Provider pattern).

Setiap provider file:
- Extends `ChangeNotifier`
- Menerima Repository via constructor (dependency injection)
- Mengelola state (loading, error, data)
- Method untuk aksi user (login, fetch data, dll)
- Memanggil `notifyListeners()` saat state berubah

### 6. `lib/utils/`
**Fungsi:** Utility classes dan helper functions.

| File | Fungsi |
|------|--------|
| `shared_prefs_utils.dart` | Helper untuk SharedPreferences (save/get token, user data, dll) |
| `constants.dart` | Konstanta aplikasi |
| `validators.dart` | Validasi form (email, password, dll) |
| `date_utils.dart` | Helper untuk format tanggal |
| `currency_utils.dart` | Helper untuk format mata uang |

### 7. `lib/service_locator.dart`
**Fungsi:** Dependency Injection menggunakan get_it package.

- Register singleton untuk SharedPreferences, ApiService
- Register repositories
- Register providers dengan dependency injection

---

## 🔄 Alur Data (Data Flow)

```
┌─────────────────────────────────────────────────────────────────────┐
│                           UI (Screen/Widget)                         │
│                                  │                                   │
│                           [User Action]                              │
│                                  ▼                                   │
├─────────────────────────────────────────────────────────────────────┤
│                        Provider (State Management)                   │
│                                  │                                   │
│        - Kelola loading/error state                                  │
│        - Panggil repository method                                   │
│        - Update state & notifyListeners()                            │
│                                  ▼                                   │
├─────────────────────────────────────────────────────────────────────┤
│                        Repository (Abstraction)                      │
│                                  │                                   │
│        - Abstract interface untuk kontrak                            │
│        - Implementation memanggil service                            │
│                                  ▼                                   │
├─────────────────────────────────────────────────────────────────────┤
│                           Service (Feature API)                      │
│                                  │                                   │
│        - Method per endpoint                                         │
│        - Gunakan ApiService untuk HTTP call                          │
│        - Cache handling jika perlu                                   │
│                                  ▼                                   │
├─────────────────────────────────────────────────────────────────────┤
│                         ApiService (HTTP Client)                     │
│                                  │                                   │
│        - GET/POST/PUT/PATCH/DELETE                                   │
│        - Set headers (Authorization, Content-Type)                   │
│        - Response parsing                                            │
│                                  ▼                                   │
├─────────────────────────────────────────────────────────────────────┤
│                            Backend API                               │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📱 Daftar Screen Yang Sudah Ada

### 1. Auth Screens (`lib/screens/auth/`)
| File | Fungsi |
|------|--------|
| `login_screen.dart` | Halaman login user dengan email & password |
| `register_screen.dart` | Halaman registrasi user baru |
| `reset_password.dart` | Halaman input password baru (setelah klik link email) |
| `reset_password_input_email.dart` | Halaman input email untuk reset password |

### 2. Splash Screens (`lib/screens/splash/`)
| File | Fungsi |
|------|--------|
| `splash_screen.dart` | Splash screen dengan animasi logo |
| `onboarding.dart` | Onboarding 3 halaman intro sebelum login |

### 3. Home Screens (`lib/screens/home/`)
| File | Fungsi |
|------|--------|
| `home.dart` | Dashboard utama: profil user, search, quick buttons, lanjutkan belajar, rekomendasi |
| `home_search.dart` | Halaman pencarian kursus |
| `quick_kelas.dart` | Daftar kelas yang sudah dibeli user (Kelas Saya) |
| `quick_sertif.dart` | Daftar sertifikat yang dimiliki user |
| `quick_ebook.dart` | Daftar ebook yang dimiliki user |

### 4. Explore Screens (`lib/screens/explore/`)
| File | Fungsi |
|------|--------|
| `explore.dart` | Katalog semua kursus publik dengan filter & search |

### 5. Kelas Screens (`lib/screens/kelas/`)
| File | Fungsi |
|------|--------|
| `detail_kelas.dart` | Detail kelas (preview sebelum beli) |
| `belum_beli/beli_kelas.dart` | Halaman konfirmasi pembelian kelas |
| `belum_beli/payment.dart` | Halaman pembayaran dengan countdown & metode bayar |
| `sudah_beli/mulai_kelas.dart` | Halaman belajar (video player, overview, ebook, sertifikat) |

### 6. Learning Path Screens (`lib/screens/learning-path/`)
| File | Fungsi |
|------|--------|
| `learn_path_list.dart` | Daftar semua learning path |
| `learn_path_detail.dart` | Detail learning path dengan daftar kelas |
| `learn_path_detail_dialogs.dart` | Dialog follow/unfollow learning path |

### 7. Quiz Screens (`lib/screens/quiz/`)
| File | Fungsi |
|------|--------|
| `quiz.dart` | Halaman mengerjakan quiz |
| `quiz_result.dart` | Halaman hasil quiz (lulus/tidak lulus) |

### 8. Profile Screens (`lib/screens/profile/`)
| File | Fungsi |
|------|--------|
| `profile.dart` | Halaman profil user dengan menu |
| `setting.dart` | Halaman pengaturan akun (edit profil, password) |
| `help_center.dart` | Halaman FAQ dan bantuan |
| `contact_us.dart` | Halaman kontak (website, instagram, linkedin) |

---

## 🔗 Mapping Screen ke Data Layer

### Auth Feature
**Screens yang menggunakan:**
- `login_screen.dart`
- `register_screen.dart`
- `reset_password.dart`
- `reset_password_input_email.dart`
- `profile.dart` (logout)
- `setting.dart` (update profile)

| Layer | File | Fungsi |
|-------|------|--------|
| **Service** | `auth_service.dart` | API calls: login, register, forgotPassword, resetPassword, getMe, logout |
| **Repository** | `auth_repository.dart` | Abstraksi auth service |
| **Provider** | `auth_provider.dart` | State: user, isLoggedIn, isLoading, errorMessage |
| **Model** | `user_model.dart` | Data user: id, email, name, avatarUrl, isVerified |
| **Model** | `auth_response_model.dart` | Response login: accessToken, refreshToken, user |

**Screen → Endpoint Flow:**
- `register_screen.dart` → `auth_provider.register()` → `auth_service.register()` → `POST /api/v1/auth/register`
- `login_screen.dart` → `auth_provider.login()` → `auth_service.login()` → `POST /api/v1/auth/login`
- `reset_password_input_email.dart` → `auth_provider.forgotPassword()` → `auth_service.forgotPassword()` → `POST /api/v1/auth/forgot-password`
- `reset_password.dart` → `auth_provider.resetPassword()` → `auth_service.resetPassword()` → `POST /api/v1/auth/reset-password`
- `profile.dart` (onInit) → `auth_provider.loadUserProfile()` → `auth_service.getMe()` → `GET /api/v1/auth/me`
- `profile.dart` (logout button) → `auth_provider.logout()` → `auth_service.logout()` → Local storage clear

---

### Home/Dashboard Feature
**Screens yang menggunakan:**
- `home.dart`
- `home_search.dart`

| Layer | File | Fungsi |
|-------|------|--------|
| **Service** | `dashboard_service.dart` | API calls: getDashboard, searchCourses |
| **Repository** | `dashboard_repository.dart` | Abstraksi dashboard service |
| **Provider** | `dashboard_provider.dart` | State: dashboardData, recentCourses, recommendations |
| **Model** | `dashboard_model.dart` | Data: enrolledCount, completedCount, certificateCount, recentActivity |

**Screen → Endpoint Flow:**
- `home.dart` (onInit) → `dashboard_provider.loadDashboard()` → `dashboard_service.getDashboard()` → `GET /api/v1/user/dashboard`
- `home.dart` (pull to refresh) → `dashboard_provider.getRecentActivity()` → `dashboard_service.getRecentActivity()` → `GET /api/v1/user/dashboard/recent-activity`
- `home_search.dart` (search bar) → `dashboard_provider.searchCourses(query)` → `catalog_service.searchCourses(query)` → `GET /api/v1/public/search?q=keyword`

---

### Kelas/Course Feature
**Screens yang menggunakan:**
- `quick_kelas.dart` (daftar kelas saya)
- `detail_kelas.dart` (preview kelas)
- `mulai_kelas.dart` (belajar kelas)

| Layer | File | Fungsi |
|-------|------|--------|
| **Service** | `course_service.dart` | API calls: getMyCourses, getCourseDetail, getModules, completeModule |
| **Repository** | `course_repository.dart` | Abstraksi course service |
| **Provider** | `course_provider.dart` | State: myCourses, selectedCourse, modules, progress |
| **Model** | `course_model.dart` | Data: id, title, description, price, thumbnail, instructor |
| **Model** | `course_enrollment_model.dart` | Data: courseId, progress, enrolledAt |
| **Model** | `module_model.dart` | Data: id, title, content, duration, type, order |
| **Model** | `module_progress_model.dart` | Data: moduleId, isCompleted, completedAt |

**Screen → Endpoint Flow:**
- `quick_kelas.dart` (onInit) → `course_provider.loadMyCourses()` → `course_service.getMyCourses()` → `GET /api/v1/user/learning/my-courses`
- `detail_kelas.dart` (onInit) → `catalog_provider.getCoursePreview(courseId)` → `catalog_service.getCoursePreview(courseId)` → `GET /api/v1/public/courses/:courseId/preview`
- `mulai_kelas.dart` (onInit) → `course_provider.loadCourseContent(courseId)` → `course_service.getCourseContent(courseId)` → `GET /api/v1/user/learning/courses/:courseId/content`
- `mulai_kelas.dart` (video selesai) → `course_provider.completeModule(moduleId)` → `course_service.completeModule(moduleId)` → `POST /api/v1/user/learning/modules/:moduleId/complete`

---

### Explore/Catalog Feature
**Screens yang menggunakan:**
- `explore.dart`

| Layer | File | Fungsi |
|-------|------|--------|
| **Service** | `catalog_service.dart` | API calls: getCourses, getCoursePreview, filterCourses |
| **Repository** | `catalog_repository.dart` | Abstraksi catalog service |
| **Provider** | `catalog_provider.dart` | State: publicCourses, filters, searchQuery, categories |
| **Model** | `course_model.dart` | (shared dengan Course Feature) |

**Screen → Endpoint Flow:**
- `explore.dart` (onInit) → `catalog_provider.loadAllCourses()` → `catalog_service.getCourses()` → `GET /api/v1/public/courses`
- `explore.dart` (filter by category) → `catalog_provider.filterByCategory(categoryId)` → `catalog_service.getCourses(category: categoryId)` → `GET /api/v1/public/courses?category=:id`
- `explore.dart` (load categories) → `catalog_provider.loadCategories()` → `catalog_service.getCategories()` → `GET /api/v1/public/categories`

---

### Learning Path Feature
**Screens yang menggunakan:**
- `learn_path_list.dart`
- `learn_path_detail.dart`
- `learn_path_detail_dialogs.dart`

| Layer | File | Fungsi |
|-------|------|--------|
| **Service** | `learning_path_service.dart` | API calls: getLearningPaths, getDetail, followPath, unfollowPath |
| **Repository** | `learning_path_repository.dart` | Abstraksi learning path service |
| **Provider** | `learning_path_provider.dart` | State: learningPaths, selectedPath, isFollowing |
| **Model** | `learning_path_model.dart` | Data: id, title, description, courses, duration |

**Screen → Endpoint Flow:**
- `learn_path_list.dart` (onInit) → `learning_path_provider.loadAllPaths()` → `learning_path_service.getLearningPaths()` → `GET /api/v1/user/learning/paths`
- `learn_path_list.dart` (filter "My Paths") → `learning_path_provider.loadMyPaths()` → `learning_path_service.getMyLearningPaths()` → `GET /api/v1/user/learning/my-paths`
- `learn_path_detail.dart` (onInit) → `learning_path_provider.loadPathDetail(pathId)` → `learning_path_service.getLearningPathDetail(pathId)` → `GET /api/v1/user/learning/paths/:pathId`
- `learn_path_detail.dart` (load courses) → `learning_path_provider.loadRelatedCourses(pathId)` → `learning_path_service.getRelatedCourses(pathId)` → `GET /api/v1/user/learning/paths/:pathId/related-courses`
- `learn_path_detail_dialogs.dart` (follow button) → `learning_path_provider.followPath(pathId)` → `learning_path_service.followPath(pathId)` → `POST /api/v1/user/learning/paths/:pathId/follow`

---

### Quiz Feature
**Screens yang menggunakan:**
- `quiz.dart`
- `quiz_result.dart`

| Layer | File | Fungsi |
|-------|------|--------|
| **Service** | `quiz_service.dart` | API calls: getQuiz, submitQuiz, getResult |
| **Repository** | `quiz_repository.dart` | Abstraksi quiz service |
| **Provider** | `quiz_provider.dart` | State: currentQuiz, answers, result, isSubmitting |
| **Model** | `quiz_model.dart` | Data: id, title, questions, duration, passingScore |
| **Model** | `question_model.dart` | Data: id, question, options, correctAnswer, type |
| **Model** | `quiz_result_model.dart` | Data: score, isPassed, correctCount, totalQuestions |

**Screen → Endpoint Flow:**
- `quiz.dart` (onInit) → `quiz_provider.loadQuiz(courseId, moduleId)` → `quiz_service.getQuiz(courseId, moduleId)` → `GET /api/v1/user/learning/courses/:courseId/modules/:moduleId/quiz`
- `quiz.dart` (submit button) → `quiz_provider.submitQuiz(courseId, moduleId, answers)` → `quiz_service.submitQuiz(courseId, moduleId, answers)` → `POST /api/v1/user/learning/courses/:courseId/modules/:moduleId/quiz/submit`
- `quiz_result.dart` (onInit) → `quiz_provider.loadQuizResult(courseId, moduleId)` → `quiz_service.getQuizResult(courseId, moduleId)` → `GET /api/v1/user/learning/courses/:courseId/modules/:moduleId/quiz/result`

---

### Certificate Feature
**Screens yang menggunakan:**
- `quick_sertif.dart`
- `mulai_kelas.dart` (tab sertifikat)

| Layer | File | Fungsi |
|-------|------|--------|
| **Service** | `certificate_service.dart` | API calls: getMyCertificates, downloadCertificate |
| **Repository** | `certificate_repository.dart` | Abstraksi certificate service |
| **Provider** | `certificate_provider.dart` | State: certificates, isDownloading |
| **Model** | `certificate_model.dart` | Data: id, courseTitle, certificateNumber, issuedAt, downloadUrl |

**Screen → Endpoint Flow:**
- `quick_sertif.dart` (onInit) → `certificate_provider.loadMyCertificates()` → `certificate_service.getMyCertificates()` → `GET /api/v1/user/certificates`
- `quick_sertif.dart` (download button) → `certificate_provider.downloadCertificate(certId)` → `certificate_service.downloadCertificate(certId)` → `GET /api/v1/user/certificates/:certificateId/download`
- `mulai_kelas.dart` (tab sertifikat, onInit) → `certificate_provider.getCertificateByCourse(courseId)` → `certificate_service.getCertificateByCourse(courseId)` → `GET /api/v1/user/certificates/course/:courseId`
- `mulai_kelas.dart` (tab sertifikat, check eligibility) → `certificate_provider.checkEligibility(courseId)` → `certificate_service.checkEligibility(courseId)` → `GET /api/v1/user/certificates/course/:courseId/eligibility`
- `mulai_kelas.dart` (request certificate button) → `certificate_provider.requestCertificate(courseId)` → `certificate_service.requestCertificate(courseId)` → `POST /api/v1/user/certificates/request/:courseId`

---

### Payment Feature
**Screens yang menggunakan:**
- `beli_kelas.dart`
- `payment.dart`

| Layer | File | Fungsi |
|-------|------|--------|
| **Service** | `payment_service.dart` | API calls: createPayment, checkStatus, getHistory |
| **Repository** | `payment_repository.dart` | Abstraksi payment service |
| **Provider** | `payment_provider.dart` | State: currentPayment, paymentMethods, isProcessing |
| **Model** | `payment_model.dart` | Data: id, orderId, amount, status, expiredAt, paymentMethod |

**Screen → Endpoint Flow:**
- `beli_kelas.dart` (beli button) → `payment_provider.purchaseCourse(courseId)` → `payment_service.purchaseCourse(courseId)` → `POST /api/v1/user/payment/purchase/:courseId`
  - Response: `{ snapToken, redirectUrl, orderId, expiryDate }`
  - Lalu navigate ke `payment.dart` dengan orderId
- `payment.dart` (onInit) → Open Midtrans webview dengan `snapToken`
- `payment.dart` (polling status) → `payment_provider.checkPaymentStatus(orderId)` → `payment_service.checkPaymentStatus(orderId)` → `GET /api/v1/user/payment/:orderId/status`
  - Poll setiap 3 detik sampai status = "success" atau "failed"
- `profile.dart` (riwayat pembayaran) → `payment_provider.loadPaymentHistory()` → `payment_service.getPaymentHistory()` → `GET /api/v1/user/payment/history`

**Payment Flow Diagram:**
```
1. User klik "Beli Kursus" di detail_kelas.dart
2. Navigate ke beli_kelas.dart (konfirmasi pembelian)
3. Klik "Bayar Sekarang" → POST /purchase/:courseId
4. Backend return { snapToken, redirectUrl, orderId }
5. Navigate ke payment.dart
6. Open Midtrans webview dengan snapToken
7. User bayar di Midtrans (Gopay/BCA/dll)
8. App polling GET /payment/:orderId/status setiap 3 detik
9. Jika status = "success" → Navigate ke mulai_kelas.dart
10. Jika status = "failed" → Show error dialog
```

---

### Ebook Feature
**Screens yang menggunakan:**
- `quick_ebook.dart`
- `mulai_kelas.dart` (tab ebook)

| Layer | File | Fungsi |
|-------|------|--------|
| **Service** | `ebook_service.dart` | API calls: getMyEbooks, downloadEbook |
| **Repository** | `ebook_repository.dart` | Abstraksi ebook service |
| **Provider** | `ebook_provider.dart` | State: ebooks, isDownloading |
| **Model** | `ebook_model.dart` | Data: id, title, courseTitle, pages, downloadUrl |

**Screen → Endpoint Flow:**
- `quick_ebook.dart` (onInit) → `ebook_provider.loadMyEbooks()` → `ebook_service.getMyEbooks()` → `GET /api/v1/user/learning/ebooks` (custom aggregation)
- `mulai_kelas.dart` (tab ebook, onInit) → `ebook_provider.getEbooksByCourse(courseId)` → `ebook_service.getEbooksByCourse(courseId)` → `GET /api/v1/user/learning/courses/:courseId/ebooks`
- `quick_ebook.dart` (download button) → `ebook_provider.downloadEbook(ebookId)` → `ebook_service.downloadEbook(ebookId)` → `GET /api/v1/user/learning/ebooks/:ebookId/download`
- `mulai_kelas.dart` (download ebook) → Same flow as above

---

## 📊 Status File Data Layer (Setelah Dihapus)

### Folder Yang Sudah Ada
| Folder | Status |
|--------|--------|
| `lib/data/api/` | ✅ Ada |
| `lib/data/api/services/` | ✅ Ada (kosong) |
| `lib/data/models/` | ✅ Ada (kosong) |
| `lib/data/repositories/` | ✅ Ada (kosong) |
| `lib/providers/` | ✅ Ada (kosong) |
| `lib/utils/` | ✅ Ada (kosong) |

### File Yang Ada di `lib/data/api/`
| File | Status |
|------|--------|
| `api_service.dart` | ⚠️ Ada (kosong) |
| `endpoints.dart` | ⚠️ Ada (kosong) |

---

## 📝 Daftar Lengkap File Yang Perlu Dibuat

### 1. Core API Layer (`lib/data/api/`)

| No | File | Digunakan Oleh Screen | Fungsi |
|----|------|----------------------|--------|
| 1 | `api_service.dart` | Semua screen | Base HTTP client dengan GET, POST, PUT, PATCH, DELETE |
| 2 | `endpoints.dart` | Semua screen | Konstanta semua endpoint API |

---

### 2. API Services (`lib/data/api/services/`)

| No | File | Digunakan Oleh Screen | Endpoint Backend |
|----|------|----------------------|------------------|
| 3 | `auth_service.dart` | `login_screen`, `register_screen`, `reset_password*`, `profile` | 8 endpoints di `/api/v1/auth` |
| 4 | `dashboard_service.dart` | `home`, `home_search` | 3 endpoints di `/api/v1/user/dashboard` |
| 5 | `course_service.dart` | `quick_kelas`, `detail_kelas`, `mulai_kelas` | 4 endpoints di `/api/v1/user/learning` |
| 6 | `catalog_service.dart` | `explore` | 6 endpoints di `/api/v1/public` |
| 7 | `learning_path_service.dart` | `learn_path_list`, `learn_path_detail` | 5 endpoints di `/api/v1/user/learning/paths` |
| 8 | `quiz_service.dart` | `quiz`, `quiz_result` | 3 endpoints di `/api/v1/user/learning/quiz` |
| 9 | `certificate_service.dart` | `quick_sertif`, `mulai_kelas` | 7 endpoints di `/api/v1/user/certificates` |
| 10 | `payment_service.dart` | `beli_kelas`, `payment` | 3 endpoints di `/api/v1/user/payment` |
| 11 | `ebook_service.dart` | `quick_ebook`, `mulai_kelas` | 2 endpoints di `/api/v1/user/learning/ebooks` |

#### 📋 Detail Endpoint Per Service:

##### `auth_service.dart` (8 endpoints)
**Prefix:** `/api/v1/auth`
- `POST /register` - Register user baru
- `GET /verify-email?token=xxx` - Verifikasi email
- `POST /login` - Login user
- `POST /forgot-password` - Request reset password
- `POST /reset-password` - Reset password dengan token
- `POST /refresh-token` - Refresh access token
- `GET /me` - Get data user login (Protected)
- `GET /check-status` - Cek status akun (Protected)

**Methods:**
```dart
Future<Map<String, dynamic>> register(String email, String password, String name);
Future<Map<String, dynamic>> verifyEmail(String token);
Future<Map<String, dynamic>> login(String email, String password);
Future<Map<String, dynamic>> forgotPassword(String email);
Future<Map<String, dynamic>> resetPassword(String token, String newPassword);
Future<Map<String, dynamic>> refreshToken(String refreshToken);
Future<Map<String, dynamic>> getMe();
Future<Map<String, dynamic>> checkStatus();
Future<void> logout();
```

##### `dashboard_service.dart` (3 endpoints)
**Prefix:** `/api/v1/user/dashboard`
- `GET /` - Get dashboard data (enrolled, completed, certificates count)
- `GET /recent-activity` - Get aktivitas terbaru user
- `GET /stats` - Get statistik pembelajaran

**Methods:**
```dart
Future<Map<String, dynamic>> getDashboard();
Future<Map<String, dynamic>> getRecentActivity();
Future<Map<String, dynamic>> getStats();
```

##### `course_service.dart` (4 endpoints)
**Prefix:** `/api/v1/user/learning`
- `GET /my-courses` - Get daftar kelas yang dimiliki user
- `GET /courses/:courseId/content` - Get konten kelas (modules, quiz, dll)
- `GET /courses/:courseId/modules` - Get semua module dalam kelas
- `POST /modules/:moduleId/complete` - Tandai module selesai

**Methods:**
```dart
Future<Map<String, dynamic>> getMyCourses();
Future<Map<String, dynamic>> getCourseContent(String courseId);
Future<Map<String, dynamic>> getModules(String courseId);
Future<Map<String, dynamic>> completeModule(String moduleId);
```

##### `catalog_service.dart` (6 endpoints - PUBLIC)
**Prefix:** `/api/v1/public`
- `GET /courses` - Get semua kursus publik (dengan pagination & filter)
- `GET /courses/:courseId/preview` - Preview kelas sebelum beli
- `GET /learning-paths` - Get semua learning path
- `GET /learning-paths/:pathId` - Detail learning path
- `GET /categories` - Get semua kategori kursus
- `GET /search?q=keyword` - Search kursus

**Methods:**
```dart
Future<Map<String, dynamic>> getCourses({int page = 1, String? category, String? sort});
Future<Map<String, dynamic>> getCoursePreview(String courseId);
Future<Map<String, dynamic>> getLearningPaths();
Future<Map<String, dynamic>> getLearningPathDetail(String pathId);
Future<Map<String, dynamic>> getCategories();
Future<Map<String, dynamic>> searchCourses(String query);
```

##### `learning_path_service.dart` (5 endpoints)
**Prefix:** `/api/v1/user/learning`
- `GET /paths` - Get semua learning path tersedia
- `GET /paths/:pathId` - Detail learning path
- `GET /my-paths` - Learning path yang di-follow user
- `GET /paths/:pathId/related-courses` - Kursus terkait path
- `GET /paths/:pathId/roadmap` - Roadmap pembelajaran

**Methods:**
```dart
Future<Map<String, dynamic>> getLearningPaths();
Future<Map<String, dynamic>> getLearningPathDetail(String pathId);
Future<Map<String, dynamic>> getMyLearningPaths();
Future<Map<String, dynamic>> getRelatedCourses(String pathId);
Future<Map<String, dynamic>> getRoadmap(String pathId);
Future<Map<String, dynamic>> followPath(String pathId);
Future<Map<String, dynamic>> unfollowPath(String pathId);
```

##### `quiz_service.dart` (3 endpoints)
**Prefix:** `/api/v1/user/learning`
- `GET /courses/:courseId/modules/:moduleId/quiz` - Get quiz detail
- `POST /courses/:courseId/modules/:moduleId/quiz/submit` - Submit jawaban quiz
- `GET /courses/:courseId/modules/:moduleId/quiz/result` - Get hasil quiz

**Methods:**
```dart
Future<Map<String, dynamic>> getQuiz(String courseId, String moduleId);
Future<Map<String, dynamic>> submitQuiz(String courseId, String moduleId, Map<String, dynamic> answers);
Future<Map<String, dynamic>> getQuizResult(String courseId, String moduleId);
```

##### `certificate_service.dart` (7 endpoints)
**Prefix:** `/api/v1/user/certificates`
- `GET /` - Get semua sertifikat user
- `GET /:certificateId` - Detail sertifikat
- `GET /:certificateId/download` - Download PDF sertifikat
- `GET /:certificateId/verify` - Verifikasi sertifikat (PUBLIC)
- `POST /request/:courseId` - Request sertifikat setelah lulus
- `GET /course/:courseId` - Get sertifikat by course
- `GET /course/:courseId/eligibility` - Cek eligibilitas sertifikat

**Methods:**
```dart
Future<Map<String, dynamic>> getMyCertificates();
Future<Map<String, dynamic>> getCertificateDetail(String certificateId);
Future<Map<String, dynamic>> downloadCertificate(String certificateId);
Future<Map<String, dynamic>> verifyCertificate(String certificateId);
Future<Map<String, dynamic>> requestCertificate(String courseId);
Future<Map<String, dynamic>> getCertificateByCourse(String courseId);
Future<Map<String, dynamic>> checkEligibility(String courseId);
```

##### `payment_service.dart` (3 endpoints)
**Prefix:** `/api/v1/user/payment`
- `POST /purchase/:courseId` - Beli kursus (create Midtrans transaction)
- `GET /:orderId/status` - Cek status pembayaran
- `GET /history` - Riwayat pembayaran user

**Methods:**
```dart
Future<Map<String, dynamic>> purchaseCourse(String courseId);
Future<Map<String, dynamic>> checkPaymentStatus(String orderId);
Future<Map<String, dynamic>> getPaymentHistory();
```

**Payment Flow:**
```
1. purchaseCourse() → Returns { snap_token, redirect_url, order_id }
2. Open Midtrans webview dengan snap_token
3. User bayar di Midtrans
4. Polling checkPaymentStatus() setiap 3 detik
5. Jika status = "success" → Navigate ke kelas
```

##### `ebook_service.dart` (2 endpoints)
**Prefix:** `/api/v1/user/learning`
- `GET /courses/:courseId/ebooks` - Get ebooks dalam kursus
- `GET /ebooks/:ebookId/download` - Download ebook PDF

**Methods:**
```dart
Future<Map<String, dynamic>> getMyEbooks();
Future<Map<String, dynamic>> downloadEbook(String ebookId);
```

---

### 3. Data Models (`lib/data/models/`)

| No | File | Digunakan Oleh Screen | Fungsi |
|----|------|----------------------|--------|
| 12 | `user_model.dart` | `login`, `register`, `profile`, `setting`, `home` | Data user: id, email, name, avatarUrl |
| 13 | `auth_response_model.dart` | `login`, `register` | Response: accessToken, refreshToken, user |
| 14 | `dashboard_model.dart` | `home` | enrolledCount, completedCount, certificateCount |
| 15 | `course_model.dart` | `explore`, `detail_kelas`, `quick_kelas`, `mulai_kelas`, `home` | id, title, description, price, thumbnail |
| 16 | `course_enrollment_model.dart` | `quick_kelas`, `home` | courseId, progress, enrolledAt |
| 17 | `module_model.dart` | `mulai_kelas`, `detail_kelas` | id, title, content, duration, type |
| 18 | `module_progress_model.dart` | `mulai_kelas` | moduleId, isCompleted, completedAt |
| 19 | `learning_path_model.dart` | `learn_path_list`, `learn_path_detail` | id, title, description, courses |
| 20 | `quiz_model.dart` | `quiz` | id, title, questions, duration, passingScore |
| 21 | `question_model.dart` | `quiz` | id, question, options, correctAnswer |
| 22 | `quiz_result_model.dart` | `quiz_result` | score, isPassed, correctCount |
| 23 | `certificate_model.dart` | `quick_sertif`, `mulai_kelas` | id, courseTitle, certificateNumber, downloadUrl |
| 24 | `payment_model.dart` | `beli_kelas`, `payment` | id, orderId, amount, status, expiredAt |
| 25 | `ebook_model.dart` | `quick_ebook`, `mulai_kelas` | id, title, courseTitle, downloadUrl |

---

### 4. Repositories (`lib/data/repositories/`)

| No | File | Digunakan Oleh Screen | Fungsi |
|----|------|----------------------|--------|
| 26 | `auth_repository.dart` | `login`, `register`, `reset_password*`, `profile` | Abstract + Impl AuthService |
| 27 | `dashboard_repository.dart` | `home`, `home_search` | Abstract + Impl DashboardService |
| 28 | `course_repository.dart` | `quick_kelas`, `detail_kelas`, `mulai_kelas` | Abstract + Impl CourseService |
| 29 | `catalog_repository.dart` | `explore` | Abstract + Impl CatalogService |
| 30 | `learning_path_repository.dart` | `learn_path_list`, `learn_path_detail` | Abstract + Impl LearningPathService |
| 31 | `quiz_repository.dart` | `quiz`, `quiz_result` | Abstract + Impl QuizService |
| 32 | `certificate_repository.dart` | `quick_sertif`, `mulai_kelas` | Abstract + Impl CertificateService |
| 33 | `payment_repository.dart` | `beli_kelas`, `payment` | Abstract + Impl PaymentService |
| 34 | `ebook_repository.dart` | `quick_ebook`, `mulai_kelas` | Abstract + Impl EbookService |

---

### 5. Providers (`lib/providers/`)

| No | File | Digunakan Oleh Screen | Fungsi |
|----|------|----------------------|--------|
| 35 | `auth_provider.dart` | `login`, `register`, `reset_password*`, `profile`, `setting` | user, isLoggedIn, login(), register(), logout() |
| 36 | `dashboard_provider.dart` | `home`, `home_search` | dashboardData, recentCourses, searchCourses() |
| 37 | `course_provider.dart` | `quick_kelas`, `detail_kelas`, `mulai_kelas` | myCourses, selectedCourse, fetchModules() |
| 38 | `catalog_provider.dart` | `explore` | publicCourses, filters, searchCourses() |
| 39 | `learning_path_provider.dart` | `learn_path_list`, `learn_path_detail` | learningPaths, selectedPath, followPath() |
| 40 | `quiz_provider.dart` | `quiz`, `quiz_result` | currentQuiz, answers, submitQuiz() |
| 41 | `certificate_provider.dart` | `quick_sertif`, `mulai_kelas` | certificates, downloadCertificate() |
| 42 | `payment_provider.dart` | `beli_kelas`, `payment` | currentPayment, createPayment(), checkStatus() |
| 43 | `ebook_provider.dart` | `quick_ebook`, `mulai_kelas` | ebooks, downloadEbook() |

---

### 6. Utilities (`lib/utils/`)

| No | File | Digunakan Oleh Screen | Fungsi |
|----|------|----------------------|--------|
| 44 | `shared_prefs_utils.dart` | Semua screen (via providers) | saveToken, getToken, saveUser, isLoggedIn, clearAll |
| 45 | `constants.dart` | Semua file | BASE_URL, timeout, error messages |
| 46 | `validators.dart` | `login`, `register`, `reset_password*`, `setting` | validateEmail, validatePassword, validateName |
| 47 | `date_utils.dart` | `payment`, `certificate`, `quiz_result` | formatDate, getRelativeTime |
| 48 | `currency_utils.dart` | `detail_kelas`, `beli_kelas`, `explore` | formatRupiah, parseRupiah |

---

### 7. Service Locator (`lib/`)

| No | File | Fungsi |
|----|------|--------|
| 49 | `service_locator.dart` | Register semua dependencies: ApiService, Repositories, Providers |

---

## 🔢 Ringkasan Total File Yang Perlu Dibuat

| Layer | Jumlah File |
|-------|-------------|
| Core API | 2 |
| API Services | 9 |
| Data Models | 14 |
| Repositories | 9 |
| Providers | 9 |
| Utilities | 5 |
| Service Locator | 1 |
| **TOTAL** | **49 file** |

---

## 📦 Dependencies Yang Dibutuhkan

Tambahkan di `pubspec.yaml`:

```yaml
dependencies:
  # State Management
  provider: ^6.1.2
  
  # Dependency Injection
  get_it: ^8.0.3
  
  # HTTP Client
  http: ^1.2.2
  
  # Local Storage
  shared_preferences: ^2.3.5
  
  # Logging
  logger: ^2.5.0
```

---

## 📌 Prioritas Implementasi

### Phase 1: Core (Wajib Pertama)
1. `api_service.dart`
2. `endpoints.dart`
3. `shared_prefs_utils.dart`
4. `constants.dart`
5. `service_locator.dart`

### Phase 2: Auth Flow
6. `user_model.dart`
7. `auth_response_model.dart`
8. `auth_service.dart`
9. `auth_repository.dart`
10. `auth_provider.dart`
11. `validators.dart`

### Phase 3: Home & Dashboard
12. `dashboard_model.dart`
13. `course_model.dart`
14. `course_enrollment_model.dart`
15. `dashboard_service.dart`
16. `dashboard_repository.dart`
17. `dashboard_provider.dart`

### Phase 4: Course & Kelas
18. `module_model.dart`
19. `module_progress_model.dart`
20. `course_service.dart`
21. `course_repository.dart`
22. `course_provider.dart`

### Phase 5: Explore & Catalog
23. `catalog_service.dart`
24. `catalog_repository.dart`
25. `catalog_provider.dart`

### Phase 6: Learning Path
26. `learning_path_model.dart`
27. `learning_path_service.dart`
28. `learning_path_repository.dart`
29. `learning_path_provider.dart`

### Phase 7: Quiz
30. `quiz_model.dart`
31. `question_model.dart`
32. `quiz_result_model.dart`
33. `quiz_service.dart`
34. `quiz_repository.dart`
35. `quiz_provider.dart`

### Phase 8: Payment
36. `payment_model.dart`
37. `payment_service.dart`
38. `payment_repository.dart`
39. `payment_provider.dart`
40. `currency_utils.dart`

### Phase 9: Certificate & Ebook
41. `certificate_model.dart`
42. `certificate_service.dart`
43. `certificate_repository.dart`
44. `certificate_provider.dart`
45. `ebook_model.dart`
46. `ebook_service.dart`
47. `ebook_repository.dart`
48. `ebook_provider.dart`
49. `date_utils.dart`

---

## 📌 Best Practices

1. **Naming Convention:**
   - Models: `xxx_model.dart` (snake_case)
   - Services: `xxx_service.dart`
   - Repositories: `xxx_repository.dart`
   - Providers: `xxx_provider.dart`

2. **Repository Pattern:**
   - Selalu gunakan abstract class untuk repository (interface segregation)
   - Inject dependency via constructor (testability)

3. **Provider Pattern:**
   - Handle loading dan error state
   - Gunakan `notifyListeners()` setelah update state
   - Clear error sebelum request baru

4. **API Service:**
   - Gunakan Logger untuk debugging (jangan print)
   - Handle timeout dan error dengan proper
   - Simpan token di SharedPreferences

---

## 🔍 Endpoint Verification Summary

Semua 36 endpoint backend telah diverifikasi 100% implemented. Detail lengkap ada di:
- **[ENDPOINT_VERIFICATION.md](./ENDPOINT_VERIFICATION.md)**: Verifikasi backend dengan code snippets
- **[API_DOCUMENTATION.md](./API_DOCUMENTATION.md)**: Full API reference dengan request/response examples

### Mapping Service File → Backend Endpoints

| Service File | Endpoints | Backend Routes File | Controller |
|--------------|-----------|---------------------|------------|
| `auth_service.dart` | 8 | `routes/authRoutes.js` | `authController` |
| `dashboard_service.dart` | 3 | `routes/dashboardRoutes.js` | `dashboardController` |
| `course_service.dart` | 4 | `routes/learningRoutes.js` | `learningController` |
| `catalog_service.dart` | 6 | `routes/publicRoutes.js` | `publicController` |
| `learning_path_service.dart` | 5 | `routes/learningRoutes.js` | `learningPathController` |
| `quiz_service.dart` | 3 | `routes/learningRoutes.js` | `quizController` |
| `certificate_service.dart` | 7 | `routes/certificateRoutes.js` | `certificateController` |
| `payment_service.dart` | 3 | `routes/paymentRoutes.js` | `paymentController` |
| `ebook_service.dart` | 2 | `routes/learningRoutes.js` | `ebookController` |
| **TOTAL** | **36** | 6 route files | 9 controllers |

### Quick Reference: Screen → Endpoint

**Example: Login Flow**
```
login_screen.dart
  ↓ onClick "Login"
auth_provider.login(email, password)
  ↓ call
auth_repository.login(email, password)
  ↓ call
auth_service.login(email, password)
  ↓ HTTP POST
POST /api/v1/auth/login
  ↓ Backend
authController.login() in routes/authRoutes.js
  ↓ Response
{ accessToken, refreshToken, user: {...} }
```

**Example: Payment Flow**
```
beli_kelas.dart → klik "Bayar"
  ↓
payment_provider.purchaseCourse(courseId)
  ↓
POST /api/v1/user/payment/purchase/:courseId
  ↓ Returns { snapToken, redirectUrl, orderId }
  ↓
payment.dart → Open Midtrans webview
  ↓ Polling setiap 3 detik
GET /api/v1/user/payment/:orderId/status
  ↓ Until status = "success"
  ↓
Navigate to mulai_kelas.dart
```

---

## 📚 Related Documentation

| File | Description | Link |
|------|-------------|------|
| **API_DOCUMENTATION.md** | Full API reference dengan request/response examples untuk 36 endpoints | [View](./API_DOCUMENTATION.md) |
| **ENDPOINT_VERIFICATION.md** | Backend verification dengan code snippets dari 6 route files | [View](./ENDPOINT_VERIFICATION.md) |
| **ARCHITECTURE_PLAN.md** | File ini - Complete mobile app architecture plan | Current File |

---

## 🎯 Next Steps

1. **Baca dokumentasi API**: Review [API_DOCUMENTATION.md](./API_DOCUMENTATION.md) untuk memahami request/response format
2. **Verify backend**: Cek [ENDPOINT_VERIFICATION.md](./ENDPOINT_VERIFICATION.md) untuk konfirmasi semua endpoint sudah jalan
3. **Start implementation**: Mulai dari Phase 1 (Core) sesuai prioritas implementasi di atas
4. **Test incrementally**: Test setiap feature setelah selesai sebelum lanjut ke feature berikutnya

---

*Dokumen ini dibuat berdasarkan analisis geo-attendance-app dan disesuaikan dengan konteks Lentera Karir (Online Learning Platform).*  
*Total 23 screen files di-mapping ke 49 file data layer.*  
*Semua 36 endpoint backend telah diverifikasi 100% implemented.*

**Generated by**: GitHub Copilot  
**Architecture Pattern**: Clean Architecture + Repository Pattern + Provider State Management
