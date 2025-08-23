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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF004D40), Color(0xFF00251A), Color(0xFF00110D)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(
              color: Colors.amber[100],
              fontWeight: FontWeight.bold,
              fontSize: 24,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.amber[100]),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF004D40).withOpacity(0.8),
                  Color(0xFF00251A).withOpacity(0.6),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // App Header
            _buildAppHeader(),
            SizedBox(height: 32),

            // Arabic Quran Toggle
            _buildArabicQuranCard(settings),
            SizedBox(height: 20),

            // Translation Settings (only show if Arabic Quran is disabled)
            if (!settings.useArabicQuran) ...[
              _buildTranslationCard(context, settings, surahProvider),
              SizedBox(height: 20),
            ],

            // Dark Mode
            _buildDarkModeCard(settings),
            SizedBox(height: 20),

            // Reset Settings
            _buildResetCard(context, settings),
            SizedBox(height: 20),

            // About
            _buildAboutCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF004D40).withOpacity(0.7),
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
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.amber.withOpacity(0.6), Colors.transparent],
              ),
              border: Border.all(
                color: Colors.amber.withOpacity(0.8),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(Icons.settings, color: Colors.amber[100], size: 30),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quran Settings',
                  style: TextStyle(
                    color: Colors.amber[100],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Customize your reading experience',
                  style: TextStyle(color: Colors.teal[200], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArabicQuranCard(SettingsProvider settings) {
    return Container(
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
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => settings.toggleUseArabicQuran(),
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.teal.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal[700]!.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.teal[500]!.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.language,
                    color: Colors.teal[200],
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arabic Quran',
                        style: TextStyle(
                          color: Colors.amber[100],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Read the original Arabic text',
                        style: TextStyle(color: Colors.teal[200], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Switch(
                    value: settings.useArabicQuran,
                    onChanged: (value) => settings.toggleUseArabicQuran(),
                    activeTrackColor: Colors.teal[300],
                    activeColor: Colors.amber,
                    thumbColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationCard(
    BuildContext context,
    SettingsProvider settings,
    SurahProvider surahProvider,
  ) {
    return Container(
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
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal[700]!.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.teal[500]!.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.translate,
                    color: Colors.teal[200],
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Translation Settings',
                  style: TextStyle(
                    color: Colors.amber[100],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.teal[900]!.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.teal[700]!.withOpacity(0.3)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: settings.edition,
                    dropdownColor: Color(0xFF00251A),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.teal[200]),
                    style: TextStyle(color: Colors.amber[100], fontSize: 16),
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
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                          120,
                                    ),
                                    child: Text(
                                      edition.englishName,
                                      style: TextStyle(
                                        color: Colors.amber[100],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              })
                              .toList()
                        : [
                            DropdownMenuItem<String>(
                              value: settings.edition,
                              child: Text(
                                'Loading translations...',
                                style: TextStyle(color: Colors.teal[200]),
                              ),
                            ),
                          ],
                    onChanged: (value) {
                      if (value != null) {
                        settings.setEdition(value);
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Choose your preferred translation',
              style: TextStyle(
                color: Colors.teal[200],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeCard(SettingsProvider settings) {
    return Container(
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
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => settings.toggleDarkMode(),
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.teal.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal[700]!.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.teal[500]!.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    settings.isDarkMode ? Icons.nightlight : Icons.wb_sunny,
                    color: Colors.teal[200],
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          color: Colors.amber[100],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        settings.isDarkMode
                            ? 'Enabled for comfortable reading'
                            : 'Disabled for brighter appearance',
                        style: TextStyle(color: Colors.teal[200], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Switch(
                    value: settings.isDarkMode,
                    onChanged: (value) => settings.toggleDarkMode(),
                    activeTrackColor: Colors.teal[300],
                    activeColor: Colors.amber,
                    thumbColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetCard(BuildContext context, SettingsProvider settings) {
    return Container(
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
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showResetConfirmationDialog(context, settings);
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.teal.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red[900]!.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.red[700]!.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.restart_alt,
                    color: Colors.red[200],
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reset Settings',
                        style: TextStyle(
                          color: Colors.amber[100],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Restore all settings to default',
                        style: TextStyle(color: Colors.teal[200], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
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

  Widget _buildAboutCard(BuildContext context) {
    return Container(
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
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'Holy Quran',
              applicationVersion: '1.0.0',
              applicationIcon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.amber.withOpacity(0.6), Colors.transparent],
                  ),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.8),
                    width: 2,
                  ),
                ),
                child: Icon(Icons.book, color: Colors.amber[100]),
              ),
              children: [
                SizedBox(height: 16),
                Text(
                  'A beautiful application to read and understand the Holy Quran',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.teal[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.teal.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal[700]!.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.teal[500]!.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.teal[200],
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: TextStyle(
                          color: Colors.amber[100],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Holy Quran App v1.0.0',
                        style: TextStyle(
                          color: Colors.teal[200],
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        style: TextStyle(
                          color: Colors.teal[200],
                          fontSize: 12,
                          fontFamily: 'Scheherazade New',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
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

  void _showResetConfirmationDialog(
    BuildContext context,
    SettingsProvider settings,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF004D40), Color(0xFF00251A)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 50,
                ),
                SizedBox(height: 16),
                Text(
                  'Reset Settings?',
                  style: TextStyle(
                    color: Colors.amber[100],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Are you sure you want to restore all settings to their default values?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.teal[200], fontSize: 16),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.teal[200], fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Settings reset to default'),
                            backgroundColor: Colors.teal,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
