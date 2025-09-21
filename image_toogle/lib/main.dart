import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  // Toggle theme method
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Toggle App',
      theme: _isDarkMode 
          ? ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.purple,
              scaffoldBackgroundColor: Colors.grey[900],
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            )
          : ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
      home: ImageToggleScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImageToggleScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  ImageToggleScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _ImageToggleScreenState createState() => _ImageToggleScreenState();
}

class _ImageToggleScreenState extends State<ImageToggleScreen>
    with SingleTickerProviderStateMixin {
  
  // Boolean variable to track current image state
  bool _isFirstImage = true;
  
  // Animation variables
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Local asset image paths
  final String _firstImagePath = 'assets/images/darwizzy.jpg';
  final String _secondImagePath = 'assets/images/plane.jpg';

  @override
  void initState() {
    super.initState();
    
    // Initialize AnimationController
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Create CurvedAnimation for smoother transition
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Start with animation at full opacity
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method to toggle image with animation
  void _toggleImage() {
    // Fade out current image
    _animationController.reverse().then((_) {
      // Change the image state
      setState(() {
        _isFirstImage = !_isFirstImage;
      });
      // Fade in new image
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Toggle App'),
        actions: [
          // Theme toggle button in app bar
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.toggleTheme,
            tooltip: widget.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Title text
            Text(
              'Toggle Between Images',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            
            // Image display area with border
            Container(
              width: 320,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.isDarkMode ? Colors.purple : Colors.blue,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    _isFirstImage ? _firstImagePath : _secondImagePath,
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 300,
                        height: 200,
                        color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 50,
                              color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                            ),
                            Text(
                              'Image ${_isFirstImage ? '1' : '2'} not found',
                              style: TextStyle(
                                fontSize: 16,
                                color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                              ),
                            ),
                            Text(
                              'Check assets folder',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.isDarkMode ? Colors.white38 : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 30),
            
            // Current image indicator
            Text(
              'Current: Image ${_isFirstImage ? '1' : '2'}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: widget.isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            
            SizedBox(height: 30),
            
            // Toggle Image button
            ElevatedButton(
              onPressed: _toggleImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isDarkMode ? Colors.purple : Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 6,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swap_horiz, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Toggle Image',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            
            // Theme toggle button
            OutlinedButton(
              onPressed: widget.toggleTheme,
              style: OutlinedButton.styleFrom(
                foregroundColor: widget.isDarkMode ? Colors.purple : Colors.blue,
                side: BorderSide(
                  color: widget.isDarkMode ? Colors.purple : Colors.blue,
                  width: 2,
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.isDarkMode ? 'Light Mode' : 'Dark Mode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
}