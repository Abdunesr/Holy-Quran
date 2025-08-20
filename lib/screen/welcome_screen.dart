import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quran/screen/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00695C), Color(0xFF004D40), Color(0xFF00251A)],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 60.0, 0, 0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'ٱقْرَأْ بِٱسْمِ رَبِّكَ ٱلَّذِى خَلَقَ',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.amber[100],
                        fontFamily: 'Scheherazade New',
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '"Read in the name of your Lord who created"',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Surah Al-Alaq (96:1)',
                      style: TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
            // Background decorative elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal[700]!.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal[600]!.withOpacity(0.1),
                ),
              ),
            ),

            // Islamic pattern overlay
            Opacity(
              opacity: 0.05,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/islamic_pattern.png',
                    ), // You'd need to add this asset
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 2),

                // Animated Quran icon with glow effect
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer ring
                            Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                            ),

                            // Middle ring
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                            ),

                            // Quran image
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://c8.alamy.com/comp/2X6FC1F/holy-quran-islamic-book-calligraphy-arabic-book-arabesque-the-koran-icon-quran-logo-vector-with-elegant-shiny-gradient-background-2X6FC1F.jpg',
                                placeholder: (context, url) => Container(
                                  width: 140,
                                  height: 140,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.amber,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.menu_book_rounded,
                                  size: 80,
                                  color: Colors.amber[200],
                                ),
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // App title with animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'The Holy Quran',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontFamily: 'Playfair Display',
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Subtitle with animation
                SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'Guidance for Mankind',
                    style: TextStyle(
                      color: Colors.amber[100],
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                Spacer(),

                // Get Started button with animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 5),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.green[700]!, Colors.green[200]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      HomeScreen(),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    var begin = Offset(1.0, 0.0);
                                    var end = Offset.zero;
                                    var curve = Curves.easeInOutQuart;
                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(CurveTween(curve: curve));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                              transitionDuration: Duration(milliseconds: 800),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Read the Quran',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Additional decorative text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'بسم الله الرحمن الرحيم',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      fontFamily: 'Scheherazade New',
                    ),
                  ),
                ),

                Spacer(flex: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
