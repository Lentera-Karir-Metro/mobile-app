import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:lentera_karir/data/api/api_service.dart';
// Services
import 'package:lentera_karir/data/services/auth_service.dart';
import 'package:lentera_karir/data/services/dashboard_service.dart';
import 'package:lentera_karir/data/services/course_service.dart';
import 'package:lentera_karir/data/services/catalog_service.dart';
import 'package:lentera_karir/data/services/learning_path_service.dart';
import 'package:lentera_karir/data/services/quiz_service.dart';
import 'package:lentera_karir/data/services/payment_service.dart';
import 'package:lentera_karir/data/services/certificate_service.dart';
import 'package:lentera_karir/data/services/ebook_service.dart';
// Repositories
import 'package:lentera_karir/data/repositories/auth_repository.dart';
import 'package:lentera_karir/data/repositories/dashboard_repository.dart';
import 'package:lentera_karir/data/repositories/course_repository.dart';
import 'package:lentera_karir/data/repositories/catalog_repository.dart';
import 'package:lentera_karir/data/repositories/learning_path_repository.dart';
import 'package:lentera_karir/data/repositories/quiz_repository.dart';
import 'package:lentera_karir/data/repositories/payment_repository.dart';
import 'package:lentera_karir/data/repositories/certificate_repository.dart';
import 'package:lentera_karir/data/repositories/ebook_repository.dart';
// Providers
import 'package:lentera_karir/providers/auth_provider.dart';
import 'package:lentera_karir/providers/dashboard_provider.dart';
import 'package:lentera_karir/providers/course_provider.dart';
import 'package:lentera_karir/providers/catalog_provider.dart';
import 'package:lentera_karir/providers/learning_path_provider.dart';
import 'package:lentera_karir/providers/quiz_provider.dart';
import 'package:lentera_karir/providers/payment_provider.dart';
import 'package:lentera_karir/providers/certificate_provider.dart';
import 'package:lentera_karir/providers/ebook_provider.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<Logger>(Logger());

  // Core
  getIt.registerSingleton<ApiService>(ApiService());

  // Services
  getIt.registerSingleton<AuthService>(AuthService(getIt<ApiService>()));
  getIt.registerSingleton<DashboardService>(
    DashboardService(getIt<ApiService>()),
  );
  getIt.registerSingleton<CourseService>(CourseService(getIt<ApiService>()));
  getIt.registerSingleton<CatalogService>(CatalogService(getIt<ApiService>()));
  getIt.registerSingleton<LearningPathService>(
    LearningPathService(getIt<ApiService>()),
  );
  getIt.registerSingleton<QuizService>(QuizService(getIt<ApiService>()));
  getIt.registerSingleton<PaymentService>(PaymentService(getIt<ApiService>()));
  getIt.registerSingleton<CertificateService>(
    CertificateService(getIt<ApiService>()),
  );
  getIt.registerSingleton<EbookService>(EbookService(getIt<ApiService>()));

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<AuthService>()),
  );
  getIt.registerSingleton<DashboardRepository>(
    DashboardRepositoryImpl(getIt<DashboardService>()),
  );
  getIt.registerSingleton<CourseRepository>(
    CourseRepositoryImpl(getIt<CourseService>()),
  );
  getIt.registerSingleton<CatalogRepository>(
    CatalogRepositoryImpl(getIt<CatalogService>()),
  );
  getIt.registerSingleton<LearningPathRepository>(
    LearningPathRepositoryImpl(getIt<LearningPathService>()),
  );
  getIt.registerSingleton<QuizRepository>(
    QuizRepositoryImpl(getIt<QuizService>()),
  );
  getIt.registerSingleton<PaymentRepository>(
    PaymentRepositoryImpl(getIt<PaymentService>()),
  );
  getIt.registerSingleton<CertificateRepository>(
    CertificateRepositoryImpl(getIt<CertificateService>()),
  );
  getIt.registerSingleton<EbookRepository>(
    EbookRepositoryImpl(getIt<EbookService>()),
  );

  // Providers - Use LazySingleton for global providers to maintain state
  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<DashboardProvider>(
    () => DashboardProvider(getIt<DashboardRepository>()),
  );
  // Changed to LazySingleton to avoid rebuild issues with GoRouter
  getIt.registerLazySingleton<CourseProvider>(
    () => CourseProvider(getIt<CourseRepository>()),
  );
  getIt.registerLazySingleton<CatalogProvider>(
    () => CatalogProvider(getIt<CatalogRepository>()),
  );
  getIt.registerFactory<LearningPathProvider>(
    () => LearningPathProvider(getIt<LearningPathRepository>()),
  );
  getIt.registerLazySingleton<QuizProvider>(
    () => QuizProvider(getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton<PaymentProvider>(
    () => PaymentProvider(getIt<PaymentRepository>()),
  );
  getIt.registerFactory<CertificateProvider>(
    () => CertificateProvider(getIt<CertificateRepository>()),
  );
  getIt.registerFactory<EbookProvider>(
    () => EbookProvider(getIt<EbookRepository>()),
  );

  getIt<Logger>().i('Service Locator setup complete');
}

Future<void> resetServiceLocator() async {
  await getIt.reset();
}
