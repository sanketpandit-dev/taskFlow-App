import 'package:flutter/material.dart';
import 'dart:async';

import 'options_screen.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({Key? key, required this.nextScreen}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF9A70FF),
                  Color(0xFF7F3DFF),
                  Color(0xFF6425D0),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Abstract wave patterns
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 200),
                    painter: WavePainter(Color(0xFF8F55FF).withOpacity(0.2), true),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 200),
                    painter: WavePainter(Color(0xFF8F55FF).withOpacity(0.2), false),
                  ),
                ),


                Positioned(
                  top: 120,
                  left: 40,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  right: 40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),


                _buildDecorativeCircle(280, 180, 16, 0.6),
                _buildDecorativeCircle(80, 300, 12, 0.6),
                _buildDecorativeCircle(260, 500, 20, 0.4),

                // Centered content
                Center(
                  child: FadeTransition(
                    opacity: _fadeInAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          _buildAppLogo(),

                          const SizedBox(height: 40),


                          Text(
                            'TaskFlow',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Tagline
                          Text(
                            'Effortlessly manage your day',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),

                          const SizedBox(height: 50),

                          // Progress indicator
                          Container(
                            width: 120,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDecorativeCircle(double left, double top, double size, double opacity) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          // Task lines
          Positioned(
            left: 15,
            top: 25,
            child: Container(
              width: 50,
              height: 8,
              decoration: BoxDecoration(
                color: Color(0xFFEFEAFF),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 45,
            child: Container(
              width: 70,
              height: 8,
              decoration: BoxDecoration(
                color: Color(0xFFEFEAFF),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 65,
            child: Container(
              width: 40,
              height: 8,
              decoration: BoxDecoration(
                color: Color(0xFFEFEAFF),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Checkmarks
          Positioned(
            right: 20,
            top: 25,
            child: _buildCheckmark(),
          ),
          Positioned(
            right: 20,
            top: 65,
            child: _buildCheckmark(),
          ),

          // Accent circle with checkmark
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF8A00),
                    Color(0xFFFF5252),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckmark() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF7F3DFF),
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 10,
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  final bool isTop;

  WavePainter(this.color, this.isTop);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isTop) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height * 0.7);
      path.quadraticBezierTo(
          size.width * 0.25, size.height * 0.5,
          size.width * 0.5, size.height * 0.8
      );
      path.quadraticBezierTo(
          size.width * 0.75, size.height * 1.0,
          size.width, size.height * 0.6
      );
      path.lineTo(size.width, 0);
      path.close();
    }
    else {
      path.moveTo(0, size.height);
      path.lineTo(0, size.height * 0.3);
      path.quadraticBezierTo(
          size.width * 0.25, size.height * 0.5,
          size.width * 0.5, size.height * 0.2
      );
      path.quadraticBezierTo(
          size.width * 0.75, size.height * 0.0,
          size.width, size.height * 0.4
      );
      path.lineTo(size.width, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


