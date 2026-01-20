# 📋 Langkah Selanjutnya - Lentera Karir Mobile App

**Dokumen ini dibuat:** 12 Januari 2026  
**Last Updated:** 12 Januari 2026 - Detailed Screen Implementation Guide  
**Status:** Siap untuk implementasi

---

## 📊 STATUS LENGKAP

### ✅ Data Layer (SELESAI - 49 files)
| Folder | Files | Status |
|--------|-------|--------|
| `lib/data/api/` | `api_service.dart`, `endpoints.dart` | ✅ |
| `lib/data/models/` | 14 models | ✅ |
| `lib/data/services/` | 9 services | ✅ |
| `lib/data/repositories/` | 9 repositories | ✅ |
| `lib/providers/` | 9 providers | ✅ |
| `lib/utils/` | 5 utils | ✅ |
| `lib/service_locator.dart` | 1 file | ✅ |

### ⚠️ PERLU IMPLEMENTASI
| File/Folder | Status | Priority |
|-------------|--------|----------|
| `main.dart` | ⚠️ Perlu update | **P0 - WAJIB PERTAMA** |
| `router/app_router.dart` | ⚠️ Perlu update | **P0 - WAJIB PERTAMA** |
| `screens/auth/` | ⚠️ 4 files perlu update | **P1 - PRIORITAS 1** |
| `screens/home/` | ⚠️ 5 files perlu update | **P2 - PRIORITAS 2** |
| `screens/explore/` | ⚠️ 1 file perlu update | **P2 - PRIORITAS 2** |
| `screens/profile/` | ⚠️ 4 files perlu update | **P2 - PRIORITAS 2** |
| `screens/kelas/` | ⚠️ 4 files perlu update | **P3 - PRIORITAS 3** |
| `screens/learning-path/` | ⚠️ 3 files perlu update | **P4 - PRIORITAS 4** |
| `screens/quiz/` | ⚠️ 2 files perlu update | **P5 - PRIORITAS 5** |
| `screens/splash/` | ⚠️ 2 files perlu update | **P6 - PRIORITAS 6** |
| `widgets/` | ✅ Tidak perlu update | - |

---

# 🎯 TAHAP P0: SETUP WAJIB (Kerjakan Pertama!)

## P0.1: Update `main.dart`

**File:** `lib/main.dart`

**Kondisi Saat Ini:**
```dart
// ❌ SEKARANG - BELUM LENGKAP
import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'styles/styles.dart';

void main() {
  runApp(const MyApp());
}
```

**Yang Harus Ditambahkan:**
```dart
// ✅ HARUS JADI SEPERTI INI
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'styles/styles.dart';
import 'service_locator.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';

void main() async {
  // ⭐ WAJIB: Tambah ini sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // ⭐ WAJIB: Panggil setupServiceLocator
  await setupServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ⭐ WAJIB: Wrap dengan MultiProvider untuk global providers
    return MultiProvider(
      providers: [
        // AuthProvider = GLOBAL (dibutuhkan di banyak screen)
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        // DashboardProvider = GLOBAL (dibutuhkan di home & search)
        ChangeNotifierProvider(create: (_) => getIt<DashboardProvider>()),
      ],
      child: MaterialApp.router(
        title: 'Lentera Karir',
        theme: AppTheme.lightTheme.copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: NoTransitionsBuilder(),
              TargetPlatform.iOS: NoTransitionsBuilder(),
            },
          ),
        ),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
```

---

## P0.2: Update `app_router.dart`

**File:** `lib/router/app_router.dart`

**Tambahkan import di bagian atas:**
```dart
import 'package:provider/provider.dart';
import 'package:lentera_karir/service_locator.dart';
import 'package:lentera_karir/providers/catalog_provider.dart';
import 'package:lentera_karir/providers/course_provider.dart';
import 'package:lentera_karir/providers/learning_path_provider.dart';
import 'package:lentera_karir/providers/quiz_provider.dart';
import 'package:lentera_karir/providers/payment_provider.dart';
import 'package:lentera_karir/providers/certificate_provider.dart';
import 'package:lentera_karir/providers/ebook_provider.dart';
```

**Contoh update route dengan ChangeNotifierProvider:**
```dart
// Contoh: Route /explore dengan CatalogProvider
GoRoute(
  path: '/explore',
  pageBuilder: (context, state) => NoTransitionPage(
    key: state.pageKey,
    child: ChangeNotifierProvider(
      create: (_) => getIt<CatalogProvider>(),
      child: const ExploreScreen(),
    ),
  ),
),

// Contoh: Route /kelas/:id dengan CourseProvider
GoRoute(
  path: '/kelas/:id',
  builder: (context, state) {
    final courseId = state.pathParameters['id']!;
    return ChangeNotifierProvider(
      create: (_) => getIt<CourseProvider>(),
      child: DetailKelasScreen(courseId: courseId),
    );
  },
),
```

---

# 🎯 TAHAP P1: AUTH SCREENS (Prioritas 1)

## Kenapa Prioritas 1?
- **Blocking**: Tanpa auth, user tidak bisa akses fitur lain
- **Foundation**: Token auth dibutuhkan semua API call protected

## Files yang perlu diupdate:
| No | File | Provider | Endpoint |
|----|------|----------|----------|
| 1 | `login_screen.dart` | `AuthProvider` | `POST /auth/login` |
| 2 | `register_screen.dart` | `AuthProvider` | `POST /auth/register` |
| 3 | `reset_password_input_email.dart` | `AuthProvider` | `POST /auth/forgot-password` |
| 4 | `reset_password.dart` | `AuthProvider` | `POST /auth/reset-password` |

---

### P1.1: Update `login_screen.dart`

**File:** `lib/screens/auth/login_screen.dart`

**Kondisi Saat Ini:**
```dart
// ❌ SEKARANG - HARDCODE
void _handleLogin() async {
  if (_formKey.currentState!.validate()) {
    setState(() { _isLoading = true; });
    await Future.delayed(const Duration(milliseconds: 800)); // FAKE!
    context.go('/home'); // LANGSUNG TANPA AUTH
  }
}
```

**Yang Harus Diubah:**
```dart
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

// Di _LoginScreenState, hapus _isLoading karena sudah ada di provider

void _handleLogin() async {
  if (_formKey.currentState!.validate()) {
    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    
    if (mounted) {
      if (success) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Login gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Di build(), gunakan provider untuk loading state:
@override
Widget build(BuildContext context) {
  final isLoading = context.watch<AuthProvider>().isLoading;
  
  // ... sisanya sama, ganti _isLoading dengan isLoading
}
```

---

### P1.2: Update `register_screen.dart`

**File:** `lib/screens/auth/register_screen.dart`

**Yang Harus Diubah:**
```dart
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

void _handleRegister() async {
  if (_formKey.currentState!.validate()) {
    // Validasi password match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak sama')),
      );
      return;
    }
    
    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(), // Tambah field name jika belum ada
    );
    
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan cek email untuk verifikasi.'),
            backgroundColor: AppColors.primaryPurple,
          ),
        );
        context.go('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Registrasi gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
```

---

### P1.3: Update `reset_password_input_email.dart`

**File:** `lib/screens/auth/reset_password_input_email.dart`

**Yang Harus Diubah:**
```dart
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

void _handleSendResetEmail() async {
  if (_formKey.currentState!.validate()) {
    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.forgotPassword(
      _emailController.text.trim(),
    );
    
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link reset password telah dikirim ke email Anda'),
            backgroundColor: AppColors.primaryPurple,
          ),
        );
        // Opsional: kembali ke login
        context.go('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Gagal mengirim email'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
```

---

### P1.4: Update `reset_password.dart`

**File:** `lib/screens/auth/reset_password.dart`

**Yang Harus Diubah:**
```dart
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

// Screen ini menerima token dari deep link email
class ResetPasswordScreen extends StatefulWidget {
  final String? token; // Terima dari route parameter
  
  const ResetPasswordScreen({super.key, this.token});
  // ...
}

void _handleResetPassword() async {
  if (_formKey.currentState!.validate()) {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak sama')),
      );
      return;
    }
    
    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.resetPassword(
      token: widget.token!, // Token dari email
      newPassword: _newPasswordController.text,
    );
    
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password berhasil diubah! Silakan login.'),
            backgroundColor: AppColors.primaryPurple,
          ),
        );
        context.go('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Gagal reset password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
```

---

# 🎯 TAHAP P2: HOME, EXPLORE, PROFILE (Prioritas 2)

## Kenapa Prioritas 2?
- **Main Navigation**: Ini adalah screen utama setelah login
- **User Journey**: User pertama kali melihat home → explore → profile

## Files yang perlu diupdate:
| No | File | Provider | Endpoint |
|----|------|----------|----------|
| 1 | `home.dart` | `DashboardProvider`, `AuthProvider` | `GET /dashboard`, `GET /auth/me` |
| 2 | `home_search.dart` | `CatalogProvider` | `GET /public/search` |
| 3 | `quick_kelas.dart` | `CourseProvider` | `GET /learning/my-courses` |
| 4 | `quick_ebook.dart` | `EbookProvider` | `GET /learning/ebooks` |
| 5 | `quick_sertif.dart` | `CertificateProvider` | `GET /certificates` |
| 6 | `explore.dart` | `CatalogProvider` | `GET /public/courses`, `GET /public/categories` |
| 7 | `profile.dart` | `AuthProvider` | `GET /auth/me`, logout |
| 8 | `setting.dart` | `AuthProvider` | Update profile |
| 9 | `help_center.dart` | - | Static content |
| 10 | `contact_us.dart` | - | Static content |

---

### P2.1: Update `home.dart`

**File:** `lib/screens/home/home.dart`

**Kondisi Saat Ini:**
```dart
// ❌ SEKARANG - HARDCODE
Text('Ridho Dwi Syahputra'), // Hardcode nama
// QuickButton dengan count hardcode
```

**Yang Harus Diubah:**
```dart
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  
  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final dashboardProvider = context.read<DashboardProvider>();
    
    // Load user profile jika belum ada
    if (authProvider.currentUser == null) {
      await authProvider.loadUserProfile();
    }
    
    // Load dashboard stats
    await dashboardProvider.loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dashboardProvider = context.watch<DashboardProvider>();
    
    final user = authProvider.currentUser;
    final dashboard = dashboardProvider.dashboardData;
    
    return Scaffold(
      // ... 
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // User header - DYNAMIC
                Text(user?.name ?? 'Guest'),
                
                // Quick buttons - DYNAMIC
                QuickButton(
                  count: dashboard?.enrolledCount ?? 0,
                  label: 'Kelas',
                  route: '/quick-kelas',
                ),
                QuickButton(
                  count: dashboard?.ebookCount ?? 0,
                  label: 'Ebook',
                  route: '/quick-ebook',
                ),
                QuickButton(
                  count: dashboard?.certificateCount ?? 0,
                  label: 'Sertifikat',
                  route: '/quick-sertif',
                ),
                
                // Continue learning - DYNAMIC
                if (dashboardProvider.continueLearning.isNotEmpty)
                  ...dashboardProvider.continueLearning.map((course) => 
                    ProgressCard(
                      title: course.title,
                      progressPercent: course.progress,
                      onTap: () => context.push('/kelas/mulai/${course.id}'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### P2.2: Update `explore.dart`

**File:** `lib/screens/explore/explore.dart`

**Kondisi Saat Ini:**
```dart
// ❌ SEKARANG - HARDCODE
final List<Map<String, dynamic>> courses = [
  {'thumbnail': '...', 'title': '...', 'price': 'Rp 150.000', 'category': 'Design'},
  // ... data hardcode
];
```

**Yang Harus Diubah:**

**1. Pertama, update route di `app_router.dart`:**
```dart
GoRoute(
  path: '/explore',
  pageBuilder: (context, state) => NoTransitionPage(
    key: state.pageKey,
    child: ChangeNotifierProvider(
      create: (_) => getIt<CatalogProvider>(),
      child: const ExploreScreen(),
    ),
  ),
),
```

**2. Lalu update `explore.dart`:**
```dart
import 'package:provider/provider.dart';
import '../../providers/catalog_provider.dart';
import '../../data/models/course_model.dart';
import '../../utils/currency_utils.dart';

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  
  Future<void> _loadData() async {
    final provider = context.read<CatalogProvider>();
    await provider.loadAllCourses();
    await provider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CatalogProvider>();
    
    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final courses = provider.courses;
    final categories = provider.categories;
    
    return Scaffold(
      // ... gunakan courses dan categories dari provider
      body: GridView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            thumbnailPath: course.thumbnailUrl ?? 'assets/hardcode/sample_image.png',
            title: course.title,
            price: CurrencyUtils.formatRupiah(course.price),
            onTap: () => context.push('/kelas/${course.id}'),
          );
        },
      ),
    );
  }
}
```

---

### P2.3: Update `quick_kelas.dart`, `quick_ebook.dart`, `quick_sertif.dart`

**Pattern yang sama untuk ketiga file:**

**1. Update route di `app_router.dart` dengan provider masing-masing**
**2. Load data di initState**
**3. Gunakan provider di build()**

Contoh untuk `quick_kelas.dart`:
```dart
// Di app_router.dart:
GoRoute(
  path: '/quick-kelas',
  pageBuilder: (context, state) => NoTransitionPage(
    key: state.pageKey,
    child: ChangeNotifierProvider(
      create: (_) => getIt<CourseProvider>(),
      child: const QuickKelasScreen(),
    ),
  ),
),

// Di quick_kelas.dart:
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<CourseProvider>().loadMyCourses();
  });
}

@override
Widget build(BuildContext context) {
  final provider = context.watch<CourseProvider>();
  final myCourses = provider.myCourses;
  
  // Gunakan myCourses untuk render list
}
```

---

### P2.4: Update `profile.dart`

**File:** `lib/screens/profile/profile.dart`

**Yang Harus Diubah:**
```dart
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

@override
Widget build(BuildContext context) {
  final authProvider = context.watch<AuthProvider>();
  final user = authProvider.currentUser;
  
  return Scaffold(
    body: Column(
      children: [
        // Avatar & Name - DYNAMIC
        CircleAvatar(
          backgroundImage: user?.avatarUrl != null 
            ? NetworkImage(user!.avatarUrl!) 
            : const AssetImage('assets/hardcode/sample_image.png') as ImageProvider,
        ),
        Text(user?.name ?? 'Guest'),
        Text(user?.email ?? ''),
        
        // Logout button
        _buildMenuItem(
          icon: 'assets/profile/logout.svg',
          title: 'Logout',
          onTap: () async {
            await context.read<AuthProvider>().logout();
            if (mounted) {
              context.go('/login');
            }
          },
        ),
      ],
    ),
  );
}
```

---

# 🎯 TAHAP P3: KELAS SCREENS (Prioritas 3)

## Kenapa Prioritas 3?
- **Core Feature**: Ini adalah fitur utama - beli dan belajar kelas
- **Revenue**: Payment flow ada di sini

## Files yang perlu diupdate:
| No | File | Provider | Endpoint |
|----|------|----------|----------|
| 1 | `detail_kelas.dart` | `CatalogProvider` | `GET /public/courses/:id/preview` |
| 2 | `beli_kelas.dart` | `PaymentProvider` | `POST /payment/purchase/:courseId` |
| 3 | `payment.dart` | `PaymentProvider` | `GET /payment/:orderId/status` |
| 4 | `mulai_kelas.dart` | `CourseProvider`, `CertificateProvider`, `EbookProvider` | Multiple endpoints |

---

### P3.1: Update `detail_kelas.dart`

**File:** `lib/screens/kelas/detail_kelas.dart`

**Kondisi Saat Ini:**
```dart
// ❌ SEKARANG - HARDCODE
final String coursePrice = "Rp 4.999.225";
final String thumbnailPath = "assets/hardcode/sample_image.png";
final int videoCount = 22;
```

**Yang Harus Diubah:**

**1. Update route di `app_router.dart`:**
```dart
GoRoute(
  path: '/kelas/:id',
  builder: (context, state) {
    final courseId = state.pathParameters['id']!;
    return ChangeNotifierProvider(
      create: (_) => getIt<CatalogProvider>(),
      child: DetailKelasScreen(courseId: courseId),
    );
  },
),
```

**2. Update `detail_kelas.dart`:**
```dart
import 'package:provider/provider.dart';
import '../../providers/catalog_provider.dart';
import '../../utils/currency_utils.dart';

class _DetailKelasScreenState extends State<DetailKelasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogProvider>().loadCoursePreview(int.parse(widget.courseId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CatalogProvider>();
    
    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final course = provider.selectedCourse;
    if (course == null) {
      return const Scaffold(body: Center(child: Text('Kelas tidak ditemukan')));
    }
    
    return Scaffold(
      body: Stack(
        children: [
          // Content dengan data dari course
          CardDetailKelas(
            thumbnailPath: course.thumbnailUrl ?? 'assets/hardcode/sample_image.png',
            price: CurrencyUtils.formatRupiah(course.price),
            videoText: '${course.moduleCount} Video',
            ebookText: '${course.ebookCount} Ebook',
          ),
          
          PreviewWidget(
            price: CurrencyUtils.formatRupiah(course.price),
            onBuyTap: () => context.push('/kelas/beli/${course.id}'),
          ),
        ],
      ),
    );
  }
}
```

---

### P3.2: Update `beli_kelas.dart`

**File:** `lib/screens/kelas/belum_beli/beli_kelas.dart`

**Yang Harus Diubah:**
```dart
import 'package:provider/provider.dart';
import '../../../providers/payment_provider.dart';

// Di route:
GoRoute(
  path: '/kelas/beli/:id',
  builder: (context, state) {
    final courseId = state.pathParameters['id']!;
    return ChangeNotifierProvider(
      create: (_) => getIt<PaymentProvider>(),
      child: BeliKelasScreen(courseId: courseId),
    );
  },
),

// Di screen:
void _handleBuyNow() async {
  final paymentProvider = context.read<PaymentProvider>();
  
  final result = await paymentProvider.purchaseCourse(int.parse(widget.courseId));
  
  if (mounted && result != null) {
    // Navigate ke payment screen dengan data dari backend
    context.push(
      '/kelas/payment/${widget.courseId}',
      extra: {
        'orderId': result.orderId,
        'totalAmount': result.totalAmount.toString(),
        'expiredAt': result.expiredAt.toIso8601String(),
        'snapToken': result.snapToken,
        'redirectUrl': result.redirectUrl,
      },
    );
  }
}
```

---

### P3.3: Update `payment.dart`

**File:** `lib/screens/kelas/belum_beli/payment.dart`

**Yang Harus Diubah:**
```dart
import 'package:provider/provider.dart';
import '../../../providers/payment_provider.dart';

class _PaymentScreenState extends State<PaymentScreen> {
  Timer? _pollingTimer;
  
  @override
  void initState() {
    super.initState();
    // Start polling payment status setiap 3 detik
    _startPolling();
  }
  
  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final provider = context.read<PaymentProvider>();
      final status = await provider.checkPaymentStatus(widget.orderId);
      
      if (status == 'success') {
        _pollingTimer?.cancel();
        if (mounted) {
          // Payment sukses → navigate ke mulai kelas
          context.go('/kelas/mulai/${widget.courseId}');
        }
      } else if (status == 'failed' || status == 'expired') {
        _pollingTimer?.cancel();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pembayaran gagal atau expired')),
          );
          context.pop();
        }
      }
    });
  }
  
  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
```

---

### P3.4: Update `mulai_kelas.dart`

**File:** `lib/screens/kelas/sudah_beli/mulai_kelas.dart`

**Ini screen yang paling kompleks karena butuh 3 provider:**
- `CourseProvider` - untuk video/module content
- `EbookProvider` - untuk tab ebook
- `CertificateProvider` - untuk tab sertifikat

**Di route:**
```dart
GoRoute(
  path: '/kelas/mulai/:id',
  builder: (context, state) {
    final courseId = state.pathParameters['id']!;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<CourseProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<EbookProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CertificateProvider>()),
      ],
      child: MulaiKelasScreen(courseId: courseId),
    );
  },
),
```

**Di screen:**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final courseId = int.parse(widget.courseId);
    context.read<CourseProvider>().loadCourseContent(courseId);
    context.read<EbookProvider>().getEbooksByCourse(courseId);
    context.read<CertificateProvider>().checkEligibility(courseId);
  });
}

// Saat video selesai:
void _onVideoComplete(int moduleId) async {
  await context.read<CourseProvider>().completeModule(moduleId);
}

// Tab Overview - gunakan CourseProvider
// Tab Ebook - gunakan EbookProvider
// Tab Sertifikat - gunakan CertificateProvider
```

---

# 🎯 TAHAP P4: LEARNING PATH SCREENS (Prioritas 4)

## Files yang perlu diupdate:
| No | File | Provider | Endpoint |
|----|------|----------|----------|
| 1 | `learn_path_list.dart` | `LearningPathProvider` | `GET /learning/paths` |
| 2 | `learn_path_detail.dart` | `LearningPathProvider` | `GET /learning/paths/:id` |
| 3 | `learn_path_detail_dialogs.dart` | `LearningPathProvider` | `POST /learning/paths/:id/follow` |

---

### P4.1: Update `learn_path_list.dart`

**Kondisi Saat Ini:**
```dart
// ❌ SEKARANG - HARDCODE
final List<Map<String, String>> _allLearningPaths = [
  {'id': '1', 'title': 'Professional UI/UX Designer Path', ...},
  // ... data hardcode
];
```

**Yang Harus Diubah:**
```dart
// Di app_router.dart:
GoRoute(
  path: '/learn-path',
  pageBuilder: (context, state) => NoTransitionPage(
    key: state.pageKey,
    child: ChangeNotifierProvider(
      create: (_) => getIt<LearningPathProvider>(),
      child: const LearnPathListScreen(),
    ),
  ),
  routes: [
    // Detail route inherit provider dari parent
  ],
),

// Di learn_path_list.dart:
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<LearningPathProvider>().loadAllPaths();
  });
}

@override
Widget build(BuildContext context) {
  final provider = context.watch<LearningPathProvider>();
  final paths = provider.learningPaths;
  
  // Filter berdasarkan search query
  final filteredPaths = _searchQuery.isEmpty
    ? paths
    : paths.where((p) => p.title.toLowerCase().contains(_searchQuery)).toList();
  
  return ListView.builder(
    itemCount: filteredPaths.length,
    itemBuilder: (context, index) {
      final path = filteredPaths[index];
      return PathCard(
        title: path.title,
        subtitle: path.description,
        duration: '${path.totalDuration} jam',
        courses: '${path.courseCount} kelas',
        onTap: () => context.push('/learn-path/detail', extra: {'pathId': path.id.toString()}),
      );
    },
  );
}
```

---

# 🎯 TAHAP P5: QUIZ SCREENS (Prioritas 5)

## Files yang perlu diupdate:
| No | File | Provider | Endpoint |
|----|------|----------|----------|
| 1 | `quiz.dart` | `QuizProvider` | `GET /quiz/:id`, `POST /quiz/:id/submit` |
| 2 | `quiz_result.dart` | `QuizProvider` | `GET /quiz/:id/result` |

---

### P5.1: Update `quiz.dart`

**Kondisi Saat Ini:**
```dart
// ❌ SEKARANG - HARDCODE
final List<QuizQuestion> questions = const [
  QuizQuestion(id: 1, question: '...', options: [...], correctAnswerIndex: 2),
  // ... data hardcode
];
```

**Yang Harus Diubah:**
```dart
// Di app_router.dart:
GoRoute(
  path: '/quiz/:quizId',
  builder: (context, state) {
    final quizId = state.pathParameters['quizId']!;
    return ChangeNotifierProvider(
      create: (_) => getIt<QuizProvider>(),
      child: QuizScreen(quizId: quizId),
    );
  },
),

// Di quiz.dart:
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<QuizProvider>().startQuiz(int.parse(widget.quizId));
  });
}

void _submitQuiz() async {
  final provider = context.read<QuizProvider>();
  
  final result = await provider.submitQuiz();
  
  if (mounted && result != null) {
    context.pushReplacement(
      '/quiz/${widget.quizId}/result',
      extra: result,
    );
  }
}

@override
Widget build(BuildContext context) {
  final provider = context.watch<QuizProvider>();
  
  if (provider.isLoading) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
  
  final quiz = provider.currentQuiz;
  final questions = quiz?.questions ?? [];
  
  // Render questions dari provider
}
```

---

# 🎯 TAHAP P6: SPLASH SCREENS (Prioritas 6)

## Kenapa Prioritas Terakhir?
- **Optional**: Splash & onboarding sudah bekerja
- **Enhancement**: Bisa ditambah logic check token untuk auto-login

## Files yang perlu diupdate:
| No | File | Provider | Logic |
|----|------|----------|-------|
| 1 | `splash_screen.dart` | `AuthProvider` | Check existing token → auto login |
| 2 | `onboarding.dart` | - | Tidak perlu provider |

---

### P6.1: Update `splash_screen.dart` (OPTIONAL ENHANCEMENT)

**Enhancement: Auto-login jika ada saved token**
```dart
@override
void initState() {
  super.initState();
  _checkAuthAndNavigate();
}

Future<void> _checkAuthAndNavigate() async {
  // Delay untuk animasi splash
  await Future.delayed(const Duration(milliseconds: 2000));
  
  if (!mounted) return;
  
  final authProvider = context.read<AuthProvider>();
  
  // Coba load user dari saved token
  final hasValidToken = await authProvider.checkSavedToken();
  
  if (mounted) {
    if (hasValidToken) {
      // Token valid → langsung ke home
      context.go('/home');
    } else {
      // Tidak ada token → ke onboarding/login
      context.go('/onboarding');
    }
  }
}
```

---

# ✅ CHECKLIST IMPLEMENTASI

## Tahap P0 (WAJIB PERTAMA)
- [ ] Update `main.dart` dengan setupServiceLocator & MultiProvider
- [ ] Update `app_router.dart` dengan import providers

## Tahap P1 (Auth)
- [ ] Update `login_screen.dart`
- [ ] Update `register_screen.dart`
- [ ] Update `reset_password_input_email.dart`
- [ ] Update `reset_password.dart`

## Tahap P2 (Home, Explore, Profile)
- [ ] Update `home.dart`
- [ ] Update `home_search.dart`
- [ ] Update `quick_kelas.dart`
- [ ] Update `quick_ebook.dart`
- [ ] Update `quick_sertif.dart`
- [ ] Update `explore.dart`
- [ ] Update `profile.dart`
- [ ] Update `setting.dart`

## Tahap P3 (Kelas)
- [ ] Update `detail_kelas.dart`
- [ ] Update `beli_kelas.dart`
- [ ] Update `payment.dart`
- [ ] Update `mulai_kelas.dart`

## Tahap P4 (Learning Path)
- [ ] Update `learn_path_list.dart`
- [ ] Update `learn_path_detail.dart`
- [ ] Update `learn_path_detail_dialogs.dart`

## Tahap P5 (Quiz)
- [ ] Update `quiz.dart`
- [ ] Update `quiz_result.dart`

## Tahap P6 (Splash - Optional)
- [ ] Update `splash_screen.dart` untuk auto-login

---

# 📚 QUICK REFERENCE

## Provider Usage Patterns

### Pattern 1: Read untuk Action
```dart
// Untuk trigger action (login, load data, submit)
onPressed: () => context.read<AuthProvider>().login(email, password);
```

### Pattern 2: Watch untuk UI
```dart
// Untuk rebuild UI saat state berubah
@override
Widget build(BuildContext context) {
  final isLoading = context.watch<AuthProvider>().isLoading;
  final user = context.watch<AuthProvider>().currentUser;
}
```

### Pattern 3: Load di initState
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<SomeProvider>().loadData();
  });
}
```

### Pattern 4: Loading & Error Handling
```dart
@override
Widget build(BuildContext context) {
  final provider = context.watch<SomeProvider>();
  
  if (provider.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  
  if (provider.errorMessage != null) {
    return Center(child: Text(provider.errorMessage!));
  }
  
  // Render data
}
```

---

## 🔗 Dokumen Terkait
- **[API_DOCUMENTATION.md](./API_DOCUMENTATION.md)**: Request/response API lengkap
- **[ARCHITECTURE_PLAN.md](./ARCHITECTURE_PLAN.md)**: Mapping screen ke endpoint
- **[ENDPOINT_VERIFICATION.md](./ENDPOINT_VERIFICATION.md)**: Status backend (36/36 ✅)

---

**Dokumen ini dibuat:** 12 Januari 2026  
**Last Updated:** 12 Januari 2026  
**Status:** Siap untuk implementasi
