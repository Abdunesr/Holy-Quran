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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading Quran...'),
          ],
        ),
      );
    }

    if (surahProvider.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                surahProvider.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => surahProvider.loadSurahList(),
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (surahProvider.surahs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No data available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => surahProvider.loadSurahList(),
              child: Text('Load Quran'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
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
    );
  }
}

// screens/surah_list_screen.dart - Update the SurahListItem class
class SurahListItem extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  SurahListItem({required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.teal[700],
          child: Text(
            surah.number.toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arabic name
            Text(
              surah.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 4),
            // English name and translation
            Row(
              children: [
                Text(
                  surah.englishName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '• ${surah.englishNameTranslation}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              '${surah.revelationType} • ${surah.numberOfAyahs} verses',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
