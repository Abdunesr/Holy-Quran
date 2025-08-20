// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/providers/surah_provider.dart';
import 'package:quran/screen/bookmarks_screen.dart';
import 'package:quran/screen/settings_screen.dart';
import 'package:quran/screen/surah_list_screen.dart';
import 'package:quran/components/fancy_drawer.dart';

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

  void _handleDrawerItemSelected(int index) {
    Navigator.pop(context); // Close drawer
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: FancyDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: _handleDrawerItemSelected,
      ),
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
