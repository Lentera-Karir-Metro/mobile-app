# 📚 Dokumentasi API - Lentera Karir
## Endpoint untuk User (Non-Admin)

**Versi:** 1.0  
**Base URL:** `https://your-domain.com/api/v1`  
**Tanggal Dokumentasi:** 11 Januari 2026

## 🔗 Dokumentasi Terkait
- **[ENDPOINT_VERIFICATION.md](./ENDPOINT_VERIFICATION.md)**: Verifikasi backend (36/36 endpoints = 100% implemented)
- **[ARCHITECTURE_PLAN.md](./ARCHITECTURE_PLAN.md)**: Mobile app architecture dengan mapping 49 files ke endpoint API ini

---

## 📋 Daftar Isi
1. [Autentikasi (Auth)](#autentikasi-auth) - 8 endpoints
2. [Dashboard User](#dashboard-user) - 3 endpoints
3. [Learning Experience](#learning-experience) - 9 endpoints
4. [Sertifikat User](#sertifikat-user) - 7 endpoints
5. [Pembayaran](#pembayaran) - 3 endpoints
6. [Katalog Publik](#katalog-publik) - 6 endpoints

**Total: 36 Endpoints** (100% implemented - verified)

---

## 🔐 Informasi Autentikasi

Sebagian besar endpoint memerlukan **Bearer Token** di header request:
```
Authorization: Bearer <access_token>
```

Token didapat setelah login berhasil.

---

## 🔐 AUTENTIKASI (AUTH)

**Prefix:** `/api/v1/auth`

| No | Method | Endpoint | Deskripsi | Auth Required |
|----|--------|----------|-----------|---------------|
| 1 | POST | `/register` | Mendaftarkan user baru | Tidak |
| 2 | GET | `/verify-email` | Verifikasi email via link | Tidak |
| 3 | POST | `/login` | Login user | Tidak |
| 4 | POST | `/forgot-password` | Request reset password | Tidak |
| 5 | POST | `/reset-password` | Set password baru | Tidak |
| 6 | POST | `/refresh-token` | Perbarui access token | Tidak |
| 7 | GET | `/me` | Ambil data user yang login | Ya |
| 8 | GET | `/check-status` | Cek status akun user | Ya |

---

### 1.1 Register User Baru
**Endpoint:** `POST /api/v1/auth/register`  
**Access:** Public

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123",
  "name": "Nama Lengkap"
}
```

**Response Success (201):**
```json
{
  "message": "Registrasi berhasil. Silakan cek email untuk verifikasi.",
  "user": {
    "id": "user-uuid",
    "email": "user@example.com",
    "name": "Nama Lengkap"
  }
}
```

---

### 1.2 Verify Email
**Endpoint:** `GET /api/v1/auth/verify-email?token=xxx`  
**Access:** Public

**Query Params:**
- `token`: Email verification token

**Response Success (200):**
```json
{
  "message": "Email verified successfully"
}
```

---

### 1.3 Login
**Endpoint:** `POST /api/v1/auth/login`  
**Access:** Public

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123"
}
```

**Response Success (200):**
```json
{
  "message": "Login berhasil",
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "user-uuid",
    "email": "user@example.com",
    "name": "Nama Lengkap",
    "role": "user"
  }
}
```

---

### 1.4 Forgot Password
**Endpoint:** `POST /api/v1/auth/forgot-password`  
**Access:** Public

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Response Success (200):**
```json
{
  "message": "Link reset password telah dikirim ke email Anda."
}
```

---

### 1.5 Reset Password
**Endpoint:** `POST /api/v1/auth/reset-password`  
**Access:** Public

**Request Body:**
```json
{
  "token": "reset_token_from_email",
  "newPassword": "newpassword123"
}
```

**Response Success (200):**
```json
{
  "message": "Password reset successful"
}
```

---

### 1.6 Refresh Token
**Endpoint:** `POST /api/v1/auth/refresh-token`  
**Access:** Public

**Request Body:**
```json
{
  "refreshToken": "refresh_token_here"
}
```

**Response Success (200):**
```json
{
  "accessToken": "new_access_token",
  "refreshToken": "new_refresh_token"
}
```

---

### 1.7 Get Current User
**Endpoint:** `GET /api/v1/auth/me`  
**Access:** Private (requires token)

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "id": "user-uuid",
  "email": "user@example.com",
  "name": "Nama Lengkap",
  "role": "user",
  "is_active": true,
  "createdAt": "2026-01-01T00:00:00.000Z"
}
```

---

### 1.8 Check User Status
**Endpoint:** `GET /api/v1/auth/check-status`  
**Access:** Private (requires token)

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "status": "active",
  "message": "Account is active"
}
```

---

## 📊 DASHBOARD USER

**Prefix:** `/api/v1/dashboard`  
**Auth Required:** Ya (semua endpoint)

| No | Method | Endpoint | Deskripsi |
|----|--------|----------|----------|
| 1 | GET | `/stats` | Statistik dashboard (total kelas, ebook, sertifikat) |
| 2 | GET | `/continue-learning` | Kelas yang sedang dipelajari |
| 3 | GET | `/recommended` | Rekomendasi kelas |

---

### 2.1 Get Dashboard Stats
**Endpoint:** `GET /api/v1/dashboard/stats`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "totalCourses": 5,
  "totalEbooks": 12,
  "totalCertificates": 3,
  "completionRate": 65
}
```

---

### 2.2 Continue Learning
**Endpoint:** `GET /api/v1/dashboard/continue-learning`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "courses": [
    {
      "id": "course-uuid",
      "title": "Belajar JavaScript",
      "thumbnail_url": "https://...",
      "progress": 45,
      "lastModuleId": "module-uuid",
      "lastModuleTitle": "Bab 3: Functions"
    }
  ]
}
```

---

### 2.3 Get Recommended Courses
**Endpoint:** `GET /api/v1/dashboard/recommended`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "courses": [
    {
      "id": "course-uuid",
      "title": "Advanced JavaScript",
      "thumbnail_url": "https://...",
      "category": "Programming",
      "price": 500000,
      "discount_amount": 100000
    }
  ]
}
```

---

## 🎓 LEARNING EXPERIENCE

**Prefix:** `/api/v1/learn`  
**Auth Required:** Ya (semua endpoint)

| No | Method | Endpoint | Deskripsi |
|----|--------|----------|----------|
| 1 | GET | `/dashboard` | Daftar Learning Path yang dibeli |
| 2 | GET | `/my-courses` | Daftar courses yang di-enroll |
| 3 | GET | `/ebooks` | Semua ebook yang dimiliki |
| 4 | GET | `/learning-paths/:lp_id` | Konten Learning Path + progress |
| 5 | GET | `/courses/:course_id` | Konten Course untuk halaman belajar |
| 6 | POST | `/modules/:module_id/complete` | Tandai modul sebagai selesai |
| 7 | POST | `/quiz/:quiz_id/start` | Mulai atau lanjutkan quiz |
| 8 | POST | `/attempts/:attempt_id/answer` | Simpan jawaban quiz |
| 9 | POST | `/attempts/:attempt_id/submit` | Submit quiz untuk penilaian |

---

### 3.1 Get Learning Path Content
**Endpoint:** `GET /api/v1/learn/learning-paths/:lp_id`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "id": "lp-uuid",
  "title": "Full Stack Web Developer",
  "description": "Belajar menjadi full stack developer...",
  "courses": [
    {
      "id": "course-uuid",
      "title": "Belajar JavaScript",
      "sequence_order": 1,
      "progress": 45,
      "is_locked": false,
      "modules": [
        {
          "id": "module-uuid",
          "title": "Pengenalan JavaScript",
          "type": "video",
          "duration_minutes": 15,
          "is_completed": true,
          "is_locked": false
        }
      ]
    }
  ]
}
```

---

### 3.2 Get Course Content
**Endpoint:** `GET /api/v1/learn/courses/:course_id`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "id": "course-uuid",
  "title": "Belajar JavaScript",
  "description": "Kursus JavaScript untuk pemula",
  "modules": [
    {
      "id": "module-uuid",
      "title": "Pengenalan JavaScript",
      "sequence_order": 1,
      "video_url": "https://...",
      "ebook_url": null,
      "quiz_id": null,
      "is_completed": false
    }
  ]
}
```

---

### 3.3 Mark Module as Complete
**Endpoint:** `POST /api/v1/learn/modules/:module_id/complete`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "message": "Modul berhasil ditandai selesai.",
  "progress": {
    "courseProgress": 50,
    "totalCompleted": 5,
    "totalModules": 10
  }
}
```

---

### 3.4 Start Quiz
**Endpoint:** `POST /api/v1/learn/quiz/:quiz_id/start`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "attempt_id": "attempt-uuid",
  "quiz": {
    "id": "quiz-uuid",
    "title": "Quiz Akhir JavaScript",
    "time_limit_minutes": 30,
    "passing_score": 70
  },
  "questions": [
    {
      "id": "question-uuid",
      "question_text": "Apa output dari console.log(typeof null)?",
      "options": [
        {
          "id": "opt-1",
          "option_text": "null"
        },
        {
          "id": "opt-2",
          "option_text": "object"
        },
        {
          "id": "opt-3",
          "option_text": "undefined"
        },
        {
          "id": "opt-4",
          "option_text": "string"
        }
      ]
    }
  ]
}
```

---

### 3.5 Save Quiz Answer
**Endpoint:** `POST /api/v1/learn/attempts/:attempt_id/answer`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "question_id": "question-uuid",
  "selected_option_id": "opt-2"
}
```

**Response Success (200):**
```json
{
  "message": "Jawaban berhasil disimpan"
}
```

---

### 3.6 Submit Quiz
**Endpoint:** `POST /api/v1/learn/attempts/:attempt_id/submit`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "message": "Quiz berhasil disubmit.",
  "result": {
    "score": 85,
    "passed": true,
    "totalQuestions": 10,
    "correctAnswers": 8,
    "passingScore": 70
  }
}
```

---

## 🎖️ SERTIFIKAT USER

### 4.1 Certificate Routes
**Prefix:** `/api/v1/certificates`  
**Auth Required:** Ya

| No | Method | Endpoint | Deskripsi |
|----|--------|----------|----------|
| 1 | GET | `/` | Get semua sertifikat user |
| 2 | GET | `/:id` | Get detail sertifikat |
| 3 | GET | `/status/:course_id` | Status sertifikat untuk course |

### 4.2 User Certificate Routes
**Prefix:** `/api/v1/user-certificates`  
**Auth Required:** Ya

| No | Method | Endpoint | Deskripsi |
|----|--------|----------|----------|
| 1 | GET | `/check/:course_id` | Cek apakah eligible untuk sertifikat |
| 2 | GET | `/templates` | Get template yang tersedia |
| 3 | POST | `/preview` | Preview sertifikat sebelum generate |
| 4 | POST | `/generate` | Generate sertifikat |

---

### 4.3 Get My Certificates
**Endpoint:** `GET /api/v1/certificates`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "certificates": [
    {
      "id": "cert-uuid",
      "certificate_number": "CERT-2026-001",
      "course_id": "course-uuid",
      "course_title": "Belajar JavaScript",
      "certificate_url": "https://...",
      "issued_at": "2026-01-10T00:00:00.000Z"
    }
  ]
}
```

---

### 4.4 Generate Certificate
**Endpoint:** `POST /api/v1/user-certificates/generate`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "course_id": "course-uuid",
  "template_id": "template-uuid"
}
```

**Response Success (201):**
```json
{
  "message": "Sertifikat berhasil dibuat.",
  "certificate": {
    "id": "cert-uuid",
    "certificate_number": "CERT-2026-002",
    "certificate_url": "https://..."
  }
}
```

---

## 💳 PEMBAYARAN

**Prefix:** `/api/v1/payments`  
**Auth Required:** Ya

| No | Method | Endpoint | Deskripsi |
|----|--------|----------|----------|
| 1 | POST | `/checkout` | Buat sesi checkout Midtrans |
| 2 | GET | `/status/:order_id` | Cek status pembayaran |
| 3 | POST | `/sync` | Sinkronisasi pembayaran pending |

---

### 5.1 Create Checkout Session
**Endpoint:** `POST /api/v1/payments/checkout`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "learning_path_id": "lp-uuid"
}
```

**Response Success (200):**
```json
{
  "token": "midtrans-snap-token",
  "redirect_url": "https://app.midtrans.com/snap/v2/vtweb/...",
  "order_id": "ORDER-2026-001"
}
```

---

### 5.2 Check Payment Status
**Endpoint:** `GET /api/v1/payments/status/:order_id`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "order_id": "ORDER-2026-001",
  "status": "settlement",
  "payment_type": "bank_transfer",
  "transaction_time": "2026-01-10T10:00:00.000Z",
  "gross_amount": "150000.00"
}
```

---

### 5.3 Sync Pending Payments
**Endpoint:** `POST /api/v1/payments/sync`  
**Access:** Private

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response Success (200):**
```json
{
  "message": "Pembayaran berhasil disinkronisasi",
  "updated": 2
}
```

---

## 📚 KATALOG PUBLIK

**Prefix:** `/api/v1/catalog`  
**Auth Required:** Tidak (Public Access)

| No | Method | Endpoint | Deskripsi |
|----|--------|----------|----------|
| 1 | GET | `/learning-paths` | Daftar semua Learning Path |
| 2 | GET | `/learning-paths/:id` | Detail Learning Path |
| 3 | GET | `/courses` | Daftar semua Course |
| 4 | GET | `/courses/:id` | Detail Course |
| 5 | GET | `/categories` | Daftar kategori |
| 6 | GET | `/mentors` | Daftar mentor |

---

### 6.1 Get Learning Paths
**Endpoint:** `GET /api/v1/catalog/learning-paths`  
**Access:** Public

---

### 6.1 Get Learning Paths
**Endpoint:** `GET /api/v1/catalog/learning-paths`  
**Access:** Public

**Query Parameters (Optional):**
- `category_id`: Filter by kategori
- `search`: Pencarian by title
- `page`: Halaman (default: 1)
- `limit`: Jumlah per halaman (default: 10)

**Response Success (200):**
```json
{
  "learningPaths": [
    {
      "id": "lp-uuid",
      "title": "Full Stack Web Developer",
      "description": "Belajar menjadi full stack developer...",
      "thumbnail_url": "https://...",
      "price": 500000,
      "discount_amount": 100000,
      "total_courses": 5,
      "total_duration_hours": 40
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 25,
    "totalPages": 3
  }
}
```

---

### 6.2 Get Learning Path Detail
**Endpoint:** `GET /api/v1/catalog/learning-paths/:id`  
**Access:** Public

**Response Success (200):**
```json
{
  "id": "lp-uuid",
  "title": "Full Stack Web Developer",
  "description": "Belajar menjadi full stack developer...",
  "thumbnail_url": "https://...",
  "price": 500000,
  "discount_amount": 100000,
  "courses": [
    {
      "id": "course-uuid",
      "title": "Belajar JavaScript",
      "sequence_order": 1,
      "thumbnail_url": "https://...",
      "modules_count": 10,
      "quizzes_count": 2
    }
  ]
}
```

---

### 6.3 Get Courses
**Endpoint:** `GET /api/v1/catalog/courses`  
**Access:** Public

**Query Parameters (Optional):**
- `search`: Pencarian by title
- `category`: Filter by category
- `page`: Halaman (default: 1)
- `limit`: Jumlah per halaman (default: 10)

**Response Success (200):**
```json
{
  "courses": [
    {
      "id": "course-uuid",
      "title": "Belajar JavaScript",
      "description": "Kursus JavaScript untuk pemula",
      "thumbnail_url": "https://...",
      "price": 100000,
      "discount_amount": 20000,
      "category": "Programming",
      "mentor_name": "John Doe",
      "status": "published"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 50,
    "totalPages": 5
  }
}
```

---

### 6.4 Get Course Detail
**Endpoint:** `GET /api/v1/catalog/courses/:id`  
**Access:** Public

**Response Success (200):**
```json
{
  "id": "course-uuid",
  "title": "Belajar JavaScript",
  "description": "Kursus JavaScript untuk pemula",
  "thumbnail_url": "https://...",
  "price": 100000,
  "discount_amount": 20000,
  "category": "Programming",
  "mentor_name": "John Doe",
  "mentor_title": "Senior Developer",
  "modules": [
    {
      "id": "module-uuid",
      "title": "Pengenalan JavaScript",
      "sequence_order": 1,
      "video_url": "https://...",
      "ebook_url": null
    }
  ],
  "quizzes": [
    {
      "id": "quiz-uuid",
      "title": "Quiz JavaScript",
      "passing_score": 70
    }
  ]
}
```

---

### 6.5 Get Categories
**Endpoint:** `GET /api/v1/catalog/categories`  
**Access:** Public

**Response Success (200):**
```json
{
  "categories": [
    {
      "id": "cat-uuid",
      "name": "Programming",
      "icon": "code",
      "color": "#3B82F6"
    },
    {
      "id": "cat-uuid-2",
      "name": "Design",
      "icon": "palette",
      "color": "#EC4899"
    }
  ]
}
```

---

### 6.6 Get Mentors
**Endpoint:** `GET /api/v1/catalog/mentors`  
**Access:** Public

**Response Success (200):**
```json
{
  "mentors": [
    {
      "id": "mentor-uuid",
      "name": "John Doe",
      "title": "Senior Developer",
      "photo_url": "https://...",
      "bio": "10 years experience in web development",
      "status": "active"
    }
  ]
}
```

---

## 📌 HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | OK - Request berhasil |
| 201 | Created - Resource berhasil dibuat |
| 400 | Bad Request - Request tidak valid |
| 401 | Unauthorized - Token tidak valid/expired |
| 403 | Forbidden - Tidak memiliki akses |
| 404 | Not Found - Resource tidak ditemukan |
| 409 | Conflict - Data sudah ada |
| 500 | Internal Server Error |

---

## 📊 Ringkasan Total Endpoint User

| Kategori | Jumlah | Akses |
|----------|--------|-------|
| Autentikasi | 8 | Public/Protected |
| Dashboard User | 3 | Protected |
| Learning Experience | 9 | Protected |
| Sertifikat | 7 | Protected |
| Pembayaran | 3 | Protected |
| Katalog Publik | 6 | Public |
| **Total** | **36** | - |

---

## 🗄️ Database Schema Reference

### Tabel Users
```sql
users:
  - id (varchar 16, PK)
  - email (varchar 255, unique)
  - username (varchar 255)
  - password (varchar 255)
  - role (enum: user/admin)
  - status (enum: active/inactive)
  - is_verified (boolean)
  - verification_token (varchar 255)
  - resetPasswordToken (varchar 255)
  - resetPasswordExpires (datetime)
```

### Tabel Courses
```sql
courses:
  - id (varchar 16, PK)
  - title (varchar 255)
  - description (text)
  - price (decimal 10,2)
  - discount_amount (decimal 10,2)
  - thumbnail_url (varchar 255)
  - status (varchar: published/draft)
  - category_id (varchar 16, FK → categories.id)
  - mentor_id (varchar 16, FK → mentors.id)
  - certificate_template_id (int, FK → certificatetemplates.id)
```

### Tabel Modules
```sql
modules:
  - id (varchar 16, PK)
  - course_id (varchar 16, FK → courses.id)
  - title (varchar 255)
  - sequence_order (int)
  - video_url (varchar 255)
  - ebook_url (varchar 255)
  - quiz_id (varchar 16, FK → quizzes.id)
```

### Tabel UserEnrollments
```sql
userenrollments:
  - id (varchar 16, PK)
  - user_id (varchar 16, FK → users.id)
  - course_id (varchar 16, FK → courses.id)
  - midtrans_transaction_id (varchar 255)
  - status (enum: pending/success/failed)
  - amount_paid (decimal 10,2)
  - payment_method (varchar 255)
  - enrolled_at (datetime)
  - Unique: (user_id, course_id)
```

### Tabel UserModuleProgress
```sql
usermoduleprogresses:
  - id (int, PK, auto_increment)
  - user_id (varchar 16, FK → users.id)
  - module_id (varchar 16, FK → modules.id)
  - is_completed (boolean)
  - Unique: (user_id, module_id)
```

### Tabel UserQuizAttempts
```sql
userquizattempts:
  - id (int, PK, auto_increment)
  - user_id (varchar 16, FK → users.id)
  - quiz_id (varchar 16, FK → quizzes.id)
  - status (enum: in_progress/completed)
  - score (float)
  - started_at (datetime)
  - completed_at (datetime)
```

### Tabel Certificates
```sql
certificates:
  - id (varchar 16, PK)
  - user_id (varchar 16, FK → users.id)
  - course_id (varchar 16, FK → courses.id)
  - certificate_url (varchar 255)
  - issued_at (datetime)
  - total_hours (int)
  - recipient_name (varchar 255)
  - course_title (varchar 255)
  - instructor_name (varchar 255)
  - status (enum: pending/generated)
  - Unique: (user_id, course_id)
```

---

## 🎯 Mobile App Implementation Notes

### 1. Authentication Flow
- Save `accessToken`, `refreshToken`, dan user data ke **secure storage** (flutter_secure_storage)
- Implementasi auto-logout jika token expired
- Cek token validity sebelum setiap API call
- Refresh token otomatis menggunakan endpoint `/auth/refresh-token`

### 2. API Configuration
```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://api.lenterakarir.com/api/v1';
  // Development: 'http://localhost:3000/api/v1'
  
  static Map<String, String> getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
```

### 3. Service Layer Pattern
```dart
// lib/services/auth_service.dart
class AuthService {
  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: ApiConfig.getHeaders(null),
      body: jsonEncode({'email': email, 'password': password}),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save tokens to secure storage
      await _saveTokens(data['accessToken'], data['refreshToken']);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Login failed');
    }
  }
}
```

### 4. Error Handling Pattern
```dart
// lib/utils/api_error_handler.dart
class ApiErrorHandler {
  static String getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400: return 'Request tidak valid';
      case 401: return 'Sesi Anda telah berakhir, silakan login kembali';
      case 403: return 'Akun Anda tidak aktif';
      case 404: return 'Data tidak ditemukan';
      case 409: return 'Data sudah ada';
      case 500: return 'Terjadi kesalahan server';
      default: return 'Terjadi kesalahan';
    }
  }
}
```

### 5. Midtrans Integration (Flutter)
```dart
// pubspec.yaml
dependencies:
  midtrans_sdk: ^latest_version

// lib/services/payment_service.dart
import 'package:midtrans_sdk/midtrans_sdk.dart';

class PaymentService {
  final MidtransSDK midtrans = MidtransSDK();
  
  Future<void> initMidtrans() async {
    await midtrans.init(
      clientKey: 'YOUR_CLIENT_KEY',
      environment: MidtransEnvironment.sandbox, // or production
    );
  }
  
  Future<void> startPayment(String snapToken) async {
    final result = await midtrans.startPayment(
      token: snapToken,
    );
    
    if (result.isSuccess) {
      // Sync payment status with backend
      await checkPaymentStatus(result.orderId);
    }
  }
}
```

---

## 🔧 Recommended Flutter Packages

```yaml
dependencies:
  # HTTP Client
  http: ^1.1.0
  dio: ^5.4.0  # Alternative dengan interceptor
  
  # State Management
  provider: ^6.1.0
  # atau bloc: ^8.1.0
  # atau get: ^4.6.0
  
  # Secure Storage
  flutter_secure_storage: ^9.0.0
  
  # Local Database
  sqflite: ^2.3.0
  
  # Payment
  midtrans_sdk: ^latest
  
  # Video Player
  video_player: ^2.8.0
  chewie: ^1.7.0
  
  # PDF Viewer
  flutter_pdfview: ^1.3.0
  
  # Image
  cached_network_image: ^3.3.0
  
  # JSON Serialization
  json_annotation: ^4.8.0
  
dev_dependencies:
  json_serializable: ^6.7.0
  build_runner: ^2.4.0
```

---

## 📝 Next Steps for Development

### Phase 1: Foundation (Week 1-2)
- ✅ Setup project structure
- ✅ Implementasi authentication flow
- ✅ Setup secure storage
- ✅ Create service layer untuk semua endpoints
- ✅ Implementasi error handling

### Phase 2: Core Features (Week 3-4)
- ✅ Dashboard screen dengan stats
- ✅ Catalog screens (Learning Paths, Courses)
- ✅ Course detail dan preview
- ✅ Payment integration (Midtrans)

### Phase 3: Learning Features (Week 5-6)
- ✅ Video player integration
- ✅ PDF/Ebook viewer
- ✅ Quiz interface
- ✅ Progress tracking

### Phase 4: Advanced Features (Week 7-8)
- ✅ Certificate generation
- ✅ Download management
- ✅ Notifications
- ✅ Offline mode (cache data)

### Phase 5: Polish & Testing (Week 9-10)
- ✅ UI/UX refinements
- ✅ Performance optimization
- ✅ Testing (unit, widget, integration)
- ✅ Bug fixes

---

## 📚 Related Documentation

| Document | Description | Status |
|----------|-------------|--------|
| **API_DOCUMENTATION.md** | Current file - Full API reference dengan 36 endpoints | ✅ Complete |
| **[ENDPOINT_VERIFICATION.md](./ENDPOINT_VERIFICATION.md)** | Backend verification dengan code snippets | ✅ 36/36 (100%) |
| **[ARCHITECTURE_PLAN.md](./ARCHITECTURE_PLAN.md)** | Mobile app architecture - 49 files dengan endpoint mapping | ✅ Complete |

---

**Backend Status:** ✅ 100% Implemented (36/36 endpoints)  
**Mobile Status:** 📋 Architecture Ready - Implementation Pending  
**Documentation Version:** 1.0  
**Last Updated:** 11 Januari 2026

**Dokumentasi ini dibuat untuk keperluan pengembangan dan integrasi API Lentera Karir.**

**© 2026 Lentera Karir**  
**Last Updated:** 11 Januari 2026  
**Version:** 1.0.0
