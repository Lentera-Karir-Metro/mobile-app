// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/service_locator.dart';

import 'package:lentera_karir/screens/splash/splash_screen.dart';
import 'package:lentera_karir/screens/splash/onboarding.dart';
import 'package:lentera_karir/screens/auth/login_screen.dart';
import 'package:lentera_karir/screens/auth/register_screen.dart';
import 'package:lentera_karir/screens/auth/reset_password_input_email.dart';
import 'package:lentera_karir/screens/auth/reset_password.dart';
import 'package:lentera_karir/screens/home/home.dart';
import 'package:lentera_karir/screens/home/home_search.dart';
import 'package:lentera_karir/screens/explore/explore.dart';
import 'package:lentera_karir/screens/learning-path/learn_path_list.dart';
import 'package:lentera_karir/screens/learning-path/learn_path_detail.dart';
import 'package:lentera_karir/screens/profile/profile.dart';
import 'package:lentera_karir/screens/home/quick_ebook.dart';
import 'package:lentera_karir/screens/home/quick_kelas.dart';
import 'package:lentera_karir/screens/home/quick_sertif.dart';
import 'package:lentera_karir/screens/kelas/detail_kelas.dart';
import 'package:lentera_karir/screens/kelas/belum_beli/beli_kelas.dart';
import 'package:lentera_karir/screens/kelas/belum_beli/payment.dart';
import 'package:lentera_karir/screens/kelas/belum_beli/midtrans_webview.dart';
import 'package:lentera_karir/screens/payment/payment_success_screen.dart';
import 'package:lentera_karir/screens/payment/payment_pending_screen.dart';
import 'package:lentera_karir/screens/kelas/sudah_beli/mulai_kelas.dart';
import 'package:lentera_karir/screens/quiz/quiz.dart';
import 'package:lentera_karir/screens/quiz/quiz_result.dart';
import 'package:lentera_karir/screens/ebook/ebook_viewer.dart';

// Providers
import 'package:lentera_karir/providers/catalog_provider.dart';
import 'package:lentera_karir/providers/course_provider.dart';
import 'package:lentera_karir/providers/learning_path_provider.dart';
import 'package:lentera_karir/providers/quiz_provider.dart';
import 'package:lentera_karir/providers/payment_provider.dart';
import 'package:lentera_karir/providers/certificate_provider.dart';
import 'package:lentera_karir/providers/ebook_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash screen route
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding route
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Login route
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Register route
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Reset Password Input Email route
      GoRoute(
        path: '/reset-password-input',
        builder: (context, state) => const ResetPasswordInputEmailScreen(),
      ),

      // Reset Password (Ganti Password) route - dengan token dari email
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return ResetPasswordScreen(token: token);
        },
      ),

      // Home route
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
        routes: [
          // Home Search route with CatalogProvider (singleton)
          GoRoute(
            path: 'search',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: ChangeNotifierProvider<CatalogProvider>.value(
                value: getIt<CatalogProvider>(),
                child: const HomeSearchScreen(),
              ),
            ),
          ),
        ],
      ),

      // Explore route with CatalogProvider (singleton)
      GoRoute(
        path: '/explore',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider<CatalogProvider>.value(
            value: getIt<CatalogProvider>(),
            child: const ExploreScreen(),
          ),
        ),
      ),

      // Learn Path route with LearningPathProvider
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
          // Learn Path Detail route with dynamic pathId
          GoRoute(
            path: ':pathId',
            builder: (context, state) {
              final pathId = state.pathParameters['pathId']!;
              return ChangeNotifierProvider(
                create: (_) => getIt<LearningPathProvider>(),
                child: LearnPathDetailScreen(
                  pathId: pathId,
                ),
              );
            },
          ),
        ],
      ),

      // Profile route
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),

      // Quick Ebook route with EbookProvider
      GoRoute(
        path: '/quick-ebook',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            create: (_) => getIt<EbookProvider>(),
            child: const QuickEbookScreen(),
          ),
        ),
      ),

      // Quick Kelas route with CourseProvider (singleton)
      GoRoute(
        path: '/quick-kelas',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider<CourseProvider>.value(
            value: getIt<CourseProvider>(),
            child: const QuickKelasScreen(),
          ),
        ),
      ),

      // Quick Sertifikat route with CertificateProvider
      GoRoute(
        path: '/quick-sertif',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            create: (_) => getIt<CertificateProvider>(),
            child: const QuickSertifScreen(),
          ),
        ),
      ),

      // Kelas Detail route with CourseProvider & CatalogProvider (singletons)
      GoRoute(
        path: '/kelas/detail/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          final isPurchased = state.extra as bool? ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: getIt<CourseProvider>()),
              ChangeNotifierProvider.value(value: getIt<CatalogProvider>()),
            ],
            child: DetailKelasScreen(
              courseId: courseId,
              isPurchased: isPurchased,
            ),
          );
        },
      ),

      // Beli Kelas route with CatalogProvider and PaymentProvider (singletons)
      GoRoute(
        path: '/kelas/beli/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: getIt<CatalogProvider>()),
              ChangeNotifierProvider.value(value: getIt<PaymentProvider>()),
            ],
            child: BeliKelasScreen(courseId: courseId),
          );
        },
      ),

      // Payment route with PaymentProvider (singleton)
      GoRoute(
        path: '/kelas/payment/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          final extra = state.extra as Map<String, dynamic>? ?? {};
          
          return ChangeNotifierProvider.value(
            value: getIt<PaymentProvider>(),
            child: PaymentScreen(
              courseId: courseId,
              orderId: extra['orderId'] ?? '#LTR-000000',
              totalAmount: extra['totalAmount'] ?? 'Rp0',
              expiredAt: extra['expiredAt'] ?? DateTime.now().add(const Duration(hours: 24)),
              transactionToken: extra['transactionToken'],
              redirectUrl: extra['redirectUrl'],
            ),
          );
        },
      ),

      // Midtrans WebView payment route (singleton)
      GoRoute(
        path: '/payment/webview/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          final extra = state.extra as Map<String, dynamic>? ?? {};
          
          return ChangeNotifierProvider<PaymentProvider>.value(
            value: getIt<PaymentProvider>(),
            child: MidtransWebViewScreen(
              courseId: courseId,
              orderId: extra['orderId'] ?? '',
              redirectUrl: extra['redirectUrl'] ?? '',
              totalAmount: (extra['totalAmount'] as num?)?.toDouble() ?? 0.0,
            ),
          );
        },
      ),

      // Payment success route
      GoRoute(
        path: '/payment/success',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return PaymentSuccessScreen(
            orderId: extra['orderId'] ?? '',
            courseId: extra['courseId'],
          );
        },
      ),

      // Payment pending route (singleton)
      GoRoute(
        path: '/payment/pending',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ChangeNotifierProvider<PaymentProvider>.value(
            value: getIt<PaymentProvider>(),
            child: PaymentPendingScreen(
              orderId: extra['orderId'] ?? '',
              courseId: extra['courseId'],
            ),
          );
        },
      ),

      // Mulai Kelas route with CourseProvider and CertificateProvider
      GoRoute(
        path: '/kelas/mulai/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: getIt<CourseProvider>()),
              ChangeNotifierProvider(create: (_) => getIt<CertificateProvider>()),
            ],
            child: MulaiKelasScreen(courseId: courseId),
          );
        },
      ),

      // Quiz route with QuizProvider (singleton)
      GoRoute(
        path: '/quiz/:quizId',
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          return ChangeNotifierProvider.value(
            value: getIt<QuizProvider>(),
            child: QuizScreen(quizId: quizId),
          );
        },
      ),

      // Quiz Result route with QuizProvider (singleton)
      GoRoute(
        path: '/quiz/result/:quizId',
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          final extra = state.extra as Map<String, dynamic>? ?? {};
          
          return ChangeNotifierProvider<QuizProvider>.value(
            value: getIt<QuizProvider>(),
            child: QuizResultScreen(
              quizId: quizId,
              score: extra['score'] ?? 0,
              kkm: extra['kkm'] ?? 60,
              isPassed: extra['isPassed'] ?? false,
              correctCount: extra['correctCount'] ?? 0,
              totalQuestions: extra['totalQuestions'] ?? 0,
              courseTitle: extra['courseTitle'] ?? '',
              courseId: extra['courseId']?.toString(),
            ),
          );
        },
      ),

      // Ebook Viewer route
      GoRoute(
        path: '/ebook/view',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return EbookViewerScreen(
            title: extra['title'] ?? 'E-Book',
            url: extra['url'] ?? '',
          );
        },
      ),
    ],
  );
}
