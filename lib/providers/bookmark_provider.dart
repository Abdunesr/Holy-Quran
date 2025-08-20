// providers/bookmark_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider with ChangeNotifier {
  List<String> _bookmarks = [];

  List<String> get bookmarks => _bookmarks;

  BookmarkProvider() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    _bookmarks = prefs.getStringList('bookmarks') ?? [];
    notifyListeners();
  }

  Future<void> addBookmark(String bookmark) async {
    if (!_bookmarks.contains(bookmark)) {
      _bookmarks.add(bookmark);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('bookmarks', _bookmarks);
      notifyListeners();
    }
  }

  Future<void> removeBookmark(String bookmark) async {
    _bookmarks.remove(bookmark);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', _bookmarks);
    notifyListeners();
  }

  Future<void> clearAllBookmarks() async {
    _bookmarks.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', _bookmarks);
    notifyListeners();
  }

  bool isBookmarked(String bookmark) {
    return _bookmarks.contains(bookmark);
  }
}
