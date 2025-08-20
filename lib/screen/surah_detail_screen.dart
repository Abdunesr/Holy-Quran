// screens/surah_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/providers/bookmark_provider.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/providers/settings_provider.dart';
import 'package:quran/models.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;

  SurahDetailScreen({required this.surah});

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  Surah? _fullSurah;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // If the surah doesn't have ayahs, load the full surah
    if (widget.surah.ayahs.isEmpty) {
      _loadFullSurah();
    } else {
      _fullSurah = widget.surah;
    }
  }

  Future<void> _loadFullSurah() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final surahProvider = Provider.of<SurahProvider>(context, listen: false);

      Surah fullSurah;

      if (settings.useArabicQuran) {
        fullSurah = await surahProvider.loadFullSurah(
          widget.surah.number,
          'ar', // Use the Arabic edition code, e.g., 'ar'
        );
      } else {
        // Load translation using the selected edition (original logic)
        fullSurah = await surahProvider.loadFullSurah(
          widget.surah.number,
          settings.edition,
        );
      }

      setState(() {
        _fullSurah = fullSurah;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load surah: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF004D40),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
              SizedBox(height: 20),
              Text(
                'Loading Holy Verses...',
                style: TextStyle(
                  color: Colors.amber[100],
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFF004D40),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.amber[100]),
              SizedBox(height: 20),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadFullSurah,
                child: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_fullSurah == null || _fullSurah!.ayahs.isEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFF004D40),
        body: Center(
          child: Text(
            'No verses available for this surah.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF00251A),
      appBar: AppBar(
        backgroundColor: Color(0xFF004D40),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _fullSurah!.englishName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _fullSurah!.name,
              style: TextStyle(
                color: Colors.amber[100],
                fontSize: 14,
                fontFamily: 'Scheherazade New',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.amber[100]),
            onPressed: () {
              // Share functionality would go here
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.amber[100]),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004D40), Color(0xFF00251A), Color(0xFF00110D)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background pattern
            Opacity(
              opacity: 0.03,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://www.transparenttextures.com/patterns/arabesque.png',
                    ),
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            ),
            ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _fullSurah!.ayahs.length,
              itemBuilder: (context, index) {
                final ayah = _fullSurah!.ayahs[index];
                final bookmarkKey =
                    '${_fullSurah!.number}-${ayah.numberInSurah}';
                final isBookmarked = bookmarkProvider.isBookmarked(bookmarkKey);

                return VerseCard(
                  ayah: ayah,
                  isBookmarked: isBookmarked,
                  onBookmarkToggle: () {
                    if (isBookmarked) {
                      bookmarkProvider.removeBookmark(bookmarkKey);
                    } else {
                      bookmarkProvider.addBookmark(bookmarkKey);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOutQuart,
          );
        },
        child: Icon(Icons.arrow_upward, color: Colors.white),
        backgroundColor: Colors.amber[700],
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

class VerseCard extends StatelessWidget {
  final Ayah ayah;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  VerseCard({
    required this.ayah,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF004D40).withOpacity(0.8),
            Color(0xFF00251A).withOpacity(0.9),
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
        border: Border.all(color: Colors.teal[700]!.withOpacity(0.3), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            splashColor: Colors.teal.withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Header with verse number and bookmark
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Verse number with decorative design
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.amber.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          ayah.numberInSurah.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[100],
                          ),
                        ),
                      ),
                      // Bookmark button with animation
                      IconButton(
                        icon: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            key: ValueKey<bool>(isBookmarked),
                            color: isBookmarked
                                ? Colors.amber
                                : Colors.teal[100],
                            size: 28,
                          ),
                        ),
                        onPressed: onBookmarkToggle,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Arabic text with beautiful styling
                  Text(
                    ayah.text,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Scheherazade New',
                      color: Colors.white,
                      height: 1.8,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Decorative divider
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.amber.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Meta information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetaItem(
                        'Juz',
                        '${ayah.juz}',
                        Icons.bookmark_border,
                      ),
                      _buildMetaItem(
                        'Page',
                        '${ayah.page}',
                        Icons.library_books,
                      ),
                      _buildMetaItem(
                        'Ruku',
                        '${ayah.ruku}',
                        Icons.format_list_numbered,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal[200], size: 16),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.amber[100],
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.teal[300], fontSize: 10)),
      ],
    );
  }
}
