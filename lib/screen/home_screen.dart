// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/screen/bookmarks_screen.dart';
import 'package:quran/screen/settings_screen.dart';
import 'package:quran/screen/surah_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    SurahListScreen(),
    BookmarksScreen(),
    SettingsScreen(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Load editions when the app starts
    final surahProvider = Provider.of<SurahProvider>(context, listen: false);
    surahProvider.loadEditions();

    _scrollController.addListener(() {
      setState(() {
        _showAppBarTitle = _scrollController.offset > 100;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildFancyDrawer(),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              snap: false,
              elevation: 8.0,
              backgroundColor: Color(0xFF004D40),
              leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.amber[100]),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: _showAppBarTitle
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'القرآن الكريم',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Scheherazade New',
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black54,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background with gradient and pattern
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF00695C),
                            Color(0xFF004D40),
                            Color(0xFF00251A),
                          ],
                        ),
                      ),
                    ),
                    // Decorative elements
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal[700]!.withOpacity(0.15),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      left: -40,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal[600]!.withOpacity(0.15),
                        ),
                      ),
                    ),
                    // Main content
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Decorative icon
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.4),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: Colors.amber[100],
                              size: 40,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          // Arabic title
                          Text(
                            'القرآن الكريم',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Scheherazade New',
                              shadows: [
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.black54,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          // English subtitle
                          Text(
                            'The Holy Quran',
                            style: TextStyle(
                              color: Colors.amber[100],
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          // Decorative divider
                          Container(
                            height: 3.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.amber,
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (_selectedIndex == 0)
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.amber[100]),
                    onPressed: () {
                      // Search functionality would go here
                    },
                  ),
              ],
            ),
          ];
        },
        body: _screens[_selectedIndex],
      ),
      bottomNavigationBar: _buildFancyBottomNavigationBar(),
    );
  }

  Widget _buildFancyDrawer() {
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
            // Header with beautiful design
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00695C), Color(0xFF004D40)],
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  // Decorative pattern
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.mosque_rounded,
                        size: 150,
                        color: Colors.amber[100],
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
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.amber.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: Colors.amber[100],
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'القرآن الكريم',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Scheherazade New',
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Holy Quran App',
                          style: TextStyle(
                            color: Colors.amber[100],
                            fontSize: 16,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                children: [
                  // Navigation Items
                  _buildDrawerItem(
                    context,
                    0,
                    Icons.home_rounded,
                    'Home',
                    'الرئيسية',
                    isSelected: _selectedIndex == 0,
                  ),
                  _buildDrawerItem(
                    context,
                    1,
                    Icons.bookmark_rounded,
                    'Bookmarks',
                    'المفضلة',
                    isSelected: _selectedIndex == 1,
                  ),
                  _buildDrawerItem(
                    context,
                    2,
                    Icons.settings_rounded,
                    'Settings',
                    'الإعدادات',
                    isSelected: _selectedIndex == 2,
                  ),

                  SizedBox(height: 30),

                  // Additional Features
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Features',
                      style: TextStyle(
                        color: Colors.amber[100],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  _buildFeatureItem(
                    Icons.nightlight_round,
                    'Night Mode',
                    'الوضع الليلي',
                    onTap: () {},
                  ),
                  _buildFeatureItem(
                    Icons.translate_rounded,
                    'Translations',
                    'الترجمات',
                    onTap: () {},
                  ),
                  _buildFeatureItem(
                    Icons.volume_up_rounded,
                    'Recitations',
                    'التلاوات',
                    onTap: () {},
                  ),

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
                          '© 2024 Quran App',
                          style: TextStyle(
                            color: Colors.teal[200],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
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
        onTap: () {
          Navigator.pop(context);
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String arabicTitle, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal.withOpacity(0.2),
        ),
        child: Icon(icon, color: Colors.teal[100], size: 18),
      ),
      title: Row(
        children: [
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 14)),
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
      onTap: onTap,
    );
  }

  Widget _buildFancyBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
            offset: Offset(0, -5),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF004D40), Color(0xFF00251A)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 0
                      ? Colors.amber.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.book,
                  color: _selectedIndex == 0 ? Colors.amber : Colors.white70,
                  size: _selectedIndex == 0 ? 26 : 22,
                ),
              ),
              label: 'Quran',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 1
                      ? Colors.amber.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.bookmark,
                  color: _selectedIndex == 1 ? Colors.amber : Colors.white70,
                  size: _selectedIndex == 1 ? 26 : 22,
                ),
              ),
              label: 'Bookmarks',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 2
                      ? Colors.amber.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.settings,
                  color: _selectedIndex == 2 ? Colors.amber : Colors.white70,
                  size: _selectedIndex == 2 ? 26 : 22,
                ),
              ),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 11),
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
