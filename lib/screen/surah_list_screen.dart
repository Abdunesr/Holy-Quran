// screens/surah_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/providers/settings_provider.dart';
import 'package:quran/screen/surah_detail_screen.dart';
import 'package:quran/models.dart';

class SurahListScreen extends StatefulWidget {
  @override
  _SurahListScreenState createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final surahProvider = Provider.of<SurahProvider>(context, listen: false);
      surahProvider.loadSurahList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final surahProvider = Provider.of<SurahProvider>(context);

    if (surahProvider.isLoading) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004D40), Color(0xFF00251A), Color(0xFF00110D)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                strokeWidth: 3,
              ),
              SizedBox(height: 20),
              Text(
                'Loading Holy Quran...',
                style: TextStyle(
                  color: Colors.amber[100],
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: TextStyle(
                  color: Colors.teal[200],
                  fontSize: 14,
                  fontFamily: 'Scheherazade New',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (surahProvider.errorMessage.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004D40), Color(0xFF00251A)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.amber[100]),
                SizedBox(height: 20),
                Text(
                  surahProvider.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () => surahProvider.loadSurahList(),
                  icon: Icon(Icons.refresh, color: Colors.white),
                  label: Text('Retry', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (surahProvider.surahs.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004D40), Color(0xFF00251A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book_rounded, size: 80, color: Colors.teal[200]),
              SizedBox(height: 20),
              Text(
                'No Surahs Available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Begin your journey with the Holy Quran',
                style: TextStyle(color: Colors.teal[200], fontSize: 14),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => surahProvider.loadSurahList(),
                child: Text(
                  'Load Quran',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF004D40), Color(0xFF00251A), Color(0xFF00110D)],
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        itemCount: surahProvider.surahs.length,
        itemBuilder: (context, index) {
          final surah = surahProvider.surahs[index];
          return SurahListItem(
            surah: surah,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(surah: surah),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SurahListItem extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  SurahListItem({required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        border: Border.all(color: Colors.teal[700]!.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.teal.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Surah number with decorative design
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
                // Surah details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Arabic name
                      Text(
                        surah.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Scheherazade New',
                          color: Colors.white,
                          height: 1.4,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 8),
                      // English name and translation
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
                          Expanded(
                            child: Text(
                              '• ${surah.englishNameTranslation}',
                              style: TextStyle(
                                color: Colors.teal[200],
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      // Revelation type and verse count
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
                              surah.revelationType.toUpperCase(),
                              style: TextStyle(
                                color: Colors.teal[100],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${surah.numberOfAyahs} verses',
                            style: TextStyle(
                              color: Colors.teal[300],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
    );
  }
}
