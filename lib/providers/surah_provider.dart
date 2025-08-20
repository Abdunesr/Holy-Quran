// providers/surah_provider.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quran/models.dart';

class SurahProvider with ChangeNotifier {
  List<Surah> _surahs = [];
  List<Edition> _editions = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _currentEdition = 'en.asad';

  List<Surah> get surahs => _surahs;
  List<Edition> get editions => _editions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get currentEdition => _currentEdition;

  Future<void> loadSurahList() async {
    setStateToLoading();

    try {
      final response = await http
          .get(Uri.parse('http://api.alquran.cloud/v1/surah'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          _surahs = (data['data'] as List)
              .map((surahJson) => Surah.fromListJson(surahJson))
              .toList();
          _errorMessage = '';
        } else {
          _errorMessage = 'Invalid data format received from server';
        }
      } else {
        _errorMessage =
            'Failed to load data. Server returned ${response.statusCode}';
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Error: $e');
      _errorMessage = 'Network error. Please check your connection.';
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      _errorMessage = 'Request timed out. Please try again.';
    } on FormatException catch (e) {
      print('Format Error: $e');
      _errorMessage = 'Data format error. Please try again later.';
    } catch (e) {
      print('Unexpected Error: $e');
      _errorMessage = 'An unexpected error occurred. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Surah> loadFullSurah(int surahNumber, String edition) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              'http://api.alquran.cloud/v1/surah/$surahNumber/$edition',
            ),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return Surah.fromJson(data['data']);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load surah: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading full surah: $e');
      rethrow;
    }
  }

  Future<void> loadEditions() async {
    try {
      final response = await http
          .get(Uri.parse('http://api.alquran.cloud/v1/edition'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _editions = (data['data'] as List)
            .map((editionJson) => Edition.fromJson(editionJson))
            .toList();
      }
    } catch (e) {
      print('Error loading editions: $e');
    } finally {
      notifyListeners();
    }
  }

  void setStateToLoading() {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
  }
}
