import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quran/screen/surah_detail_screen.dart';
import 'dart:convert';

import 'models.dart';

class SurahSearchDelegate extends SearchDelegate {
  final String edition;

  SurahSearchDelegate({required this.edition});

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
    return FutureBuilder<List<Surah>>(
      future: _searchSurahs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error searching'));
        }

        final results = snapshot.data!;

        if (results.isEmpty) {
          return Center(child: Text('No results found for "$query"'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final surah = results[index];
            return ListTile(
              title: Text(surah.englishName),
              subtitle: Text(surah.englishNameTranslation),
              onTap: () {
                close(context, surah);
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
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Surah>>(
      future: _searchSurahs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error searching'));
        }

        final results = snapshot.data!;

        if (results.isEmpty) {
          return Center(child: Text('No results found for "$query"'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final surah = results[index];
            return ListTile(
              title: Text(surah.englishName),
              subtitle: Text(surah.englishNameTranslation),
              onTap: () {
                close(context, surah);
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
      },
    );
  }

  Future<List<Surah>> _searchSurahs() async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/quran/$edition'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final allSurahs = (data['data']['surahs'] as List)
            .map((surahJson) => Surah.fromJson(surahJson))
            .toList();

        return allSurahs.where((surah) {
          return surah.englishName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              surah.englishNameTranslation.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              surah.name.contains(query);
        }).toList();
      }
    } catch (e) {
      print('Error searching: $e');
    }

    return [];
  }
}
