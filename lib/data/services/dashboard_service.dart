import 'package:lentera_karir/data/api/api_service.dart';
import 'package:lentera_karir/data/api/endpoints.dart';

class DashboardService {
  final ApiService _apiService;

  DashboardService(this._apiService);

  // Get dashboard stats (total kelas, ebook, sertifikat)
  Future<Map<String, dynamic>> getStats() async {
    return await _apiService.get(ApiEndpoints.dashboardStats);
  }

  // Get continue learning (kelas yang sedang dipelajari)
  Future<Map<String, dynamic>> getContinueLearning() async {
    return await _apiService.get(ApiEndpoints.dashboardContinueLearning);
  }

  // Get recommended courses
  Future<Map<String, dynamic>> getRecommended() async {
    return await _apiService.get(ApiEndpoints.dashboardRecommended);
  }

  // Get learn dashboard (daftar LP yang dimiliki user dengan progress)
  Future<Map<String, dynamic>> getLearnDashboard() async {
    return await _apiService.get(ApiEndpoints.learnDashboard);
  }
}
