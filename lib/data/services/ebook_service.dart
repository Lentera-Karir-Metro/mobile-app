import 'package:lentera_karir/data/api/api_service.dart';
import 'package:lentera_karir/data/api/endpoints.dart';

class EbookService {
  final ApiService _apiService;

  EbookService(this._apiService);

  // Get all ebooks from user's enrolled courses
  Future<Map<String, dynamic>> getMyEbooks() async {
    return await _apiService.get(ApiEndpoints.myEbooks);
  }
}
