// components/fancy_drawer.dart
import 'package:flutter/material.dart';

class FancyDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const FancyDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: Color(0xFF00251A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004D40), Color(0xFF00251A), Color(0xFF00110D)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(child: _buildDrawerContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00695C), Color(0xFF004D40)],
        ),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
        image: DecorationImage(
          image: NetworkImage(
            'https://tse4.mm.bing.net/th/id/OIP.OKGouvoEbKEjel3TM0C2HQHaEK?r=0&w=1366&h=768&rs=1&pid=ImgDetMain&o=7&rm=3',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xFF004D40).withOpacity(0.8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Quran icon with glow
                SizedBox(height: 16),
                Text(
                  'القرآن الكريم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Scheherazade New',
                    shadows: [
                      Shadow(
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.7),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerContent() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      children: [
        // Navigation Items
        _buildDrawerItem(
          0,
          Icons.home_rounded,
          'Home',
          'الرئيسية',
          isSelected: selectedIndex == 0,
        ),
        _buildDrawerItem(
          1,
          Icons.bookmark_rounded,
          'Bookmarks',
          'المفضلة',
          isSelected: selectedIndex == 1,
        ),
        _buildDrawerItem(
          2,
          Icons.settings_rounded,
          'Settings',
          'الإعدادات',
          isSelected: selectedIndex == 2,
        ),

        SizedBox(height: 30),

        // Additional Features
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'FEATURES',
            style: TextStyle(
              color: Colors.amber[100],
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(height: 15),

        _buildFeatureItem(Icons.nightlight_round, 'Night Mode', 'الوضع الليلي'),
        _buildFeatureItem(Icons.translate_rounded, 'Translations', 'الترجمات'),
        _buildFeatureItem(Icons.volume_up_rounded, 'Recitations', 'التلاوات'),

        SizedBox(height: 30),

        // App Info
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Version 1.0.0',
                style: TextStyle(
                  color: Colors.teal[300],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '© 2025 Quran App',
                style: TextStyle(color: Colors.teal[200], fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem(
    int index,
    IconData icon,
    String title,
    String arabicTitle, {
    bool isSelected = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.amber.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: isSelected
            ? Border.all(color: Colors.amber.withOpacity(0.5), width: 1)
            : null,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? Colors.amber.withOpacity(0.2)
                : Colors.teal.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.amber : Colors.teal[100],
            size: 22,
          ),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.amber : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            SizedBox(width: 8),
            Text(
              arabicTitle,
              style: TextStyle(
                color: isSelected ? Colors.amber : Colors.teal[100],
                fontFamily: 'Scheherazade New',
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: isSelected
            ? Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.amber,
                size: 16,
              )
            : null,
        onTap: () => onItemSelected(index),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String arabicTitle) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal.withOpacity(0.2),
          border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: Colors.teal[100], size: 18),
      ),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Text(
            arabicTitle,
            style: TextStyle(
              color: Colors.teal[100],
              fontFamily: 'Scheherazade New',
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.teal[300],
        size: 20,
      ),
      onTap: () {},
    );
  }
}
