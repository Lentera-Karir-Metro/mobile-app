import 'package:lentera_karir/data/models/ebook_model.dart';
import 'package:lentera_karir/data/services/ebook_service.dart';

abstract class EbookRepository {
  Future<List<EbookModel>> getMyEbooks();
}

class EbookRepositoryImpl implements EbookRepository {
  final EbookService _ebookService;

  EbookRepositoryImpl(this._ebookService);

  @override
  Future<List<EbookModel>> getMyEbooks() async {
    final response = await _ebookService.getMyEbooks();
    if (response['success'] == true && response['data'] != null) {
      final List ebooks = response['data'] is List
          ? response['data']
          : response['data']['ebooks'] ?? [];
      return ebooks.map((e) => EbookModel.fromJson(e)).toList();
    }
    return [];
  }
}
