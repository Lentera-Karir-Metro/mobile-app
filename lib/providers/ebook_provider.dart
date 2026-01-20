import 'package:flutter/material.dart';
import 'package:lentera_karir/data/models/ebook_model.dart';
import 'package:lentera_karir/data/repositories/ebook_repository.dart';

enum EbookStatus { initial, loading, loaded, error }

class EbookProvider extends ChangeNotifier {
  final EbookRepository _ebookRepository;

  EbookProvider(this._ebookRepository);

  EbookStatus _status = EbookStatus.initial;
  List<EbookModel> _ebooks = [];
  String? _errorMessage;

  EbookStatus get status => _status;
  List<EbookModel> get ebooks => _ebooks;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == EbookStatus.loading;

  Future<void> loadMyEbooks() async {
    _status = EbookStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _ebooks = await _ebookRepository.getMyEbooks();
      _status = EbookStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat ebook: $e';
      _status = EbookStatus.error;
    }

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearEbooks() {
    _ebooks = [];
    _status = EbookStatus.initial;
    notifyListeners();
  }
}
