// screens/bookmarks_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quran/providers/bookmark_provider.dart';
import 'package:quran/providers/settings_provider.dart';
import 'package:quran/models.dart';
import 'package:quran/screen/surah_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final bookmarks = bookmarkProvider.bookmarks;

    return bookmarks.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_remove, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No bookmarks yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Bookmark verses by tapping the bookmark icon',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bookmarks (${bookmarks.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => bookmarkProvider.clearAllBookmarks(),
                      child: Text(
                        'Clear All',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarks[index];
                    final parts = bookmark.split('-');
                    if (parts.length != 2) return SizedBox();

                    final surahNumber = parts[0];
                    final verseNumber = int.parse(parts[1]);

                    return FutureBuilder<Surah>(
                      future: _loadSurah(surahNumber, context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text('Loading...'),
                          );
                        }

                        if (snapshot.hasError) {
                          return ListTile(
                            leading: Icon(Icons.error),
                            title: Text('Error loading verse'),
                          );
                        }

                        final surah = snapshot.data!;
                        final ayah = surah.ayahs.firstWhere(
                          (a) => a.numberInSurah == verseNumber,
                          orElse: () => surah.ayahs[0],
                        );

                        return Dismissible(
                          key: Key(bookmark),
                          background: Container(color: Colors.red),
                          onDismissed: (direction) =>
                              bookmarkProvider.removeBookmark(bookmark),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal[700],
                              child: Text(
                                surahNumber,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            title: Text('${surah.englishName} : $verseNumber'),
                            subtitle: Text(
                              ayah.text.length > 50
                                  ? '${ayah.text.substring(0, 50)}...'
                                  : ayah.text,
                              style: TextStyle(fontFamily: 'Scheherazade'),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SurahDetailScreen(surah: surah),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }

  Future<Surah> _loadSurah(String surahNumber, BuildContext context) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    try {
      final response = await http.get(
        Uri.parse(
          'http://api.alquran.cloud/v1/surah/$surahNumber/${settings.edition}',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Surah.fromJson(data['data']);
      }
    } catch (e) {
      print('Error loading surah: $e');
    }

    throw Exception('Failed to load surah');
  }
}
