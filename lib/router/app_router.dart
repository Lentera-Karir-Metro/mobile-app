// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
import 'package:lentera_karir/screens/kelas/sudah_beli/mulai_kelas.dart';
import 'package:lentera_karir/screens/quiz/quiz.dart';
import 'package:lentera_karir/screens/quiz/quiz_result.dart';

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

      // Reset Password (Ganti Password) route
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),

      // Home route
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
        routes: [
          // Home Search route
          GoRoute(
            path: 'search',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const HomeSearchScreen(),
            ),
          ),
        ],
      ),

      // Explore route
      GoRoute(
        path: '/explore',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const ExploreScreen(),
        ),
      ),

      // Learn Path route
      GoRoute(
        path: '/learn-path',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const LearnPathListScreen(),
        ),
        routes: [
          // Learn Path Detail route
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final extra = state.extra as Map<String, String>;
              return LearnPathDetailScreen(
                pathId: extra['pathId']!,
                title: extra['title']!,
                description: extra['description']!,
                profileSection: extra['profileSection']!,
                profileDescription: extra['profileDescription']!,
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

      // Quick Ebook route
      GoRoute(
        path: '/quick-ebook',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const QuickEbookScreen(),
        ),
      ),

      // Quick Kelas route
      GoRoute(
        path: '/quick-kelas',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const QuickKelasScreen(),
        ),
      ),

      // Quick Sertifikat route
      GoRoute(
        path: '/quick-sertif',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const QuickSertifScreen(),
        ),
      ),

      // Kelas Detail route
      GoRoute(
        path: '/kelas/detail/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          final isPurchased = state.extra as bool? ?? false;
          return DetailKelasScreen(
            courseId: courseId,
            isPurchased: isPurchased,
          );
        },
      ),

      // Beli Kelas route
      GoRoute(
        path: '/kelas/beli/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          return BeliKelasScreen(courseId: courseId);
        },
      ),

      // Payment route
      GoRoute(
        path: '/kelas/payment/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          final extra = state.extra as Map<String, dynamic>? ?? {};
          
          return PaymentScreen(
            courseId: courseId,
            orderId: extra['orderId'] ?? '#LTR-000000',
            totalAmount: extra['totalAmount'] ?? 'Rp0',
            expiredAt: extra['expiredAt'] ?? DateTime.now().add(const Duration(hours: 24)),
            transactionToken: extra['transactionToken'],
            redirectUrl: extra['redirectUrl'],
          );
        },
      ),

      // Mulai Kelas route (kelas yang sudah dibeli)
      GoRoute(
        path: '/kelas/mulai/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          return MulaiKelasScreen(courseId: courseId);
        },
      ),

      // Quiz route
      GoRoute(
        path: '/quiz/:quizId',
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          return QuizScreen(quizId: quizId);
        },
      ),

      // Quiz Result route
      GoRoute(
        path: '/quiz/result/:quizId',
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          final extra = state.extra as Map<String, dynamic>? ?? {};
          
          return QuizResultScreen(
            quizId: quizId,
            score: extra['score'] ?? 0,
            kkm: extra['kkm'] ?? 60,
            isPassed: extra['isPassed'] ?? false,
            correctCount: extra['correctCount'] ?? 0,
            totalQuestions: extra['totalQuestions'] ?? 0,
            questions: extra['questions'] ?? [],
            selectedAnswers: extra['selectedAnswers'] ?? {},
            courseTitle: extra['courseTitle'] ?? '',
          );
        },
      ),
    ],
  );
}
