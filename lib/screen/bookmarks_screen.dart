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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF004D40), Color(0xFF00251A), Color(0xFF00110D)],
        ),
      ),
      child: bookmarks.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00695C).withOpacity(0.8),
                        Color(0xFF004D40).withOpacity(0.9),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bookmark_rounded,
                            color: Colors.amber[100],
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Bookmarks',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${bookmarks.length}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[100],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Clear All Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () =>
                          _showClearAllDialog(context, bookmarkProvider),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.red[200],
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Clear All',
                              style: TextStyle(
                                color: Colors.red[200],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Bookmarks List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            return _buildLoadingCard();
                          }

                          if (snapshot.hasError) {
                            return _buildErrorCard();
                          }

                          final surah = snapshot.data!;
                          final ayah = surah.ayahs.firstWhere(
                            (a) => a.numberInSurah == verseNumber,
                            orElse: () => surah.ayahs[0],
                          );

                          return _buildBookmarkCard(
                            context,
                            surah,
                            ayah,
                            verseNumber,
                            bookmark,
                            bookmarkProvider,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.teal.withOpacity(0.3), Colors.transparent],
              ),
              border: Border.all(color: Colors.teal.withOpacity(0.5), width: 2),
            ),
            child: Icon(
              Icons.bookmark_add_rounded,
              size: 50,
              color: Colors.teal[200],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Bookmarks Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Tap the bookmark icon on any verse\nto save it here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal[200],
              height: 1.5,
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.teal.withOpacity(0.3), width: 2),
            ),
            child: Icon(
              Icons.arrow_downward_rounded,
              color: Colors.teal[200],
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF004D40).withOpacity(0.7),
            Color(0xFF00251A).withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Colors.teal.withOpacity(0.3), Colors.transparent],
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[200]!),
              ),
            ),
          ),
        ),
        title: Container(
          height: 16,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        subtitle: Container(
          height: 14,
          width: 80,
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF004D40).withOpacity(0.7),
            Color(0xFF00251A).withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Colors.red.withOpacity(0.2), Colors.transparent],
            ),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Icon(Icons.error_outline, color: Colors.red[200], size: 24),
        ),
        title: Text(
          'Error Loading',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          'Could not load bookmark',
          style: TextStyle(color: Colors.teal[200], fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context,
    Surah surah,
    Ayah ayah,
    int verseNumber,
    String bookmarkKey,
    BookmarkProvider bookmarkProvider,
  ) {
    return Dismissible(
      key: Key(bookmarkKey),
      background: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red.withOpacity(0.3),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30),
        child: Icon(Icons.delete_forever, color: Colors.red[200], size: 30),
      ),
      onDismissed: (direction) => bookmarkProvider.removeBookmark(bookmarkKey),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF004D40).withOpacity(0.9),
              Color(0xFF00251A).withOpacity(0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Colors.teal[700]!.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(surah: surah),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.teal.withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Surah number
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.amber.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        surah.number.toString(),
                        style: TextStyle(
                          color: Colors.amber[100],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Surah name and verse number
                        Row(
                          children: [
                            Text(
                              surah.englishName,
                              style: TextStyle(
                                color: Colors.amber[100],
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '• Verse $verseNumber',
                              style: TextStyle(
                                color: Colors.teal[200],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Arabic verse
                        Text(
                          ayah.text,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Scheherazade New',
                            color: Colors.white,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12),
                        // Meta info
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal[700]!.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.teal[500]!.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                'Page ${ayah.page}',
                                style: TextStyle(
                                  color: Colors.teal[100],
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal[700]!.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.teal[500]!.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                'Juz ${ayah.juz}',
                                style: TextStyle(
                                  color: Colors.teal[100],
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow icon
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.teal[200],
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, BookmarkProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF004D40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber[100]),
              SizedBox(width: 12),
              Text(
                'Clear All Bookmarks?',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to remove all bookmarks? This action cannot be undone.',
            style: TextStyle(color: Colors.teal[200]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.teal[200])),
            ),
            TextButton(
              onPressed: () {
                provider.clearAllBookmarks();
                Navigator.pop(context);
              },
              child: Text(
                'Clear All',
                style: TextStyle(color: Colors.red[200]),
              ),
            ),
          ],
        );
      },
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
