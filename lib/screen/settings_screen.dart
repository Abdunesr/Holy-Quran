// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/providers/settings_provider.dart';
import 'package:quran/providers/surah_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final surahProvider = Provider.of<SurahProvider>(context);

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24),

        // Arabic Quran Toggle
        Card(
          child: ListTile(
            title: Text('Read Quran in Arabic'),
            subtitle: Text('Read the original Arabic text without translation'),
            trailing: Switch(
              value: settings.useArabicQuran,
              onChanged: (value) => settings.toggleUseArabicQuran(),
            ),
          ),
        ),
        SizedBox(height: 16),

        // Translation Settings (only show if Arabic Quran is disabled)
        if (!settings.useArabicQuran) ...[
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Translation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: settings.edition,
                    items: surahProvider.editions.isNotEmpty
                        ? surahProvider.editions
                              .where(
                                (edition) =>
                                    edition.format == 'text' &&
                                    edition.type == 'translation',
                              )
                              .map((edition) {
                                return DropdownMenuItem<String>(
                                  value: edition.identifier,
                                  child: Text(edition.englishName),
                                );
                              })
                              .toList()
                        : [
                            DropdownMenuItem<String>(
                              value: settings.edition,
                              child: Text('Loading translations...'),
                            ),
                          ],
                    onChanged: (value) {
                      if (value != null) {
                        settings.setEdition(value);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Select Translation',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
        ],

        // Dark Mode
        Card(
          child: ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: settings.isDarkMode,
              onChanged: (value) => settings.toggleDarkMode(),
            ),
          ),
        ),
        SizedBox(height: 16),

        // About
        Card(
          child: ListTile(
            title: Text('About'),
            subtitle: Text('Holy Quran App v1.0.0'),
            trailing: Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Holy Quran',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(Icons.book, color: Colors.teal),
              );
            },
          ),
        ),
      ],
    );
  }
}
