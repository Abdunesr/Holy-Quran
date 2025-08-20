// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quran/models.dart';
import 'package:quran/screen/surah_detail_screen.dart';

class QuranSearchDelegate extends SearchDelegate {
  final String edition;

  QuranSearchDelegate({required this.edition});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Ayah>>(
      future: _searchVerses(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final results = snapshot.data ?? [];

        if (results.isEmpty) {
          return Center(child: Text('No results found'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final ayah = results[index];
            return ListTile(
              title: Text(ayah.text),
              subtitle: Text(
                'Surah ${ayah.numberInSurah}, Verse ${ayah.numberInSurah}',
              ),
              onTap: () {
                // Navigate to the specific verse
                _navigateToVerse(context, ayah);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show recent searches or popular suggestions
    return Container();
  }

  Future<List<Ayah>> _searchVerses(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/search/$query/all/$edition'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final matches = data['data']['matches'] as List;

        return matches.map((match) => Ayah.fromJson(match)).toList();
      }
    } catch (e) {
      print('Error searching: $e');
    }

    return [];
  }

  void _navigateToVerse(BuildContext context, Ayah ayah) async {
    try {
      final response = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/surah/${ayah.number}/$edition'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final surah = Surah.fromJson(data['data']);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahDetailScreen(surah: surah),
          ),
        );
      }
    } catch (e) {
      print('Error loading surah: $e');
    }
  }
}
