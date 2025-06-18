import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'OpenStreetLocationPage.dart';

class RealHomePage extends StatefulWidget {
  const RealHomePage({super.key});

  @override
  State<RealHomePage> createState() => _RealHomePageState();
}

class _RealHomePageState extends State<RealHomePage>
    with TickerProviderStateMixin {
  final services = [
    {'label': 'Bike', 'image': 'assets/images/bike.png'},
    {'label': 'Auto', 'image': 'assets/images/auto.png'},
    {'label': 'Car', 'image': 'assets/images/car.png'},
    {'label': 'Parcel', 'image': 'assets/images/parcel.png'},
  ];

  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      services.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      ),
    );

    _animations = List.generate(
      services.length,
      (i) {
        final fromLeft = i % 2 == 0;
        return Tween<Offset>(
          begin: Offset(fromLeft ? -1.5 : 1.5, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controllers[i],
          curve: Curves.easeOut,
        ));
      },
    );

    Future.forEach<int>(List.generate(services.length, (i) => i), (i) async {
      await Future.delayed(Duration(milliseconds: i * 300));
      _controllers[i].forward();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final halfWidth = screenWidth / 2;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu + Search Bar with Mic
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.menu, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                hintText: "Where are you going?",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.mic, color: Colors.grey),
                            onPressed: () {
                              // TODO: Implement mic/speech-to-text
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            // Explore Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Explore",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                  Text("View all",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.yellow,
                      )),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Animated Cards
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      final dx = _animations[index].value.dx;
                      final fromLeft = index % 2 == 0;

                      return Transform.translate(
                        offset: Offset(dx * halfWidth, 0),
                        child: Align(
                          alignment: fromLeft
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: _buildHalfCard(
                            services[index]['label']!,
                            services[index]['image']!,
                            halfWidth,
                            fromLeft,
                            context,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

 
    Widget _buildHalfCard(String label, String imagePath, double width, bool fromLeft, BuildContext context) {
  const double cardHeight = 55;

  return GestureDetector(
    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const OpenStreetLocationPage()),
  );
},

    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Card with one curved side and drop shadow
        Container(
          width: width,
          height: cardHeight,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: fromLeft
                ? const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D1B2A).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 0.8,
            ),
          ),
        ),

        // Large image overflowing the button
        Positioned(
          top: -20,
          left: fromLeft ? width - 75 : null,
          right: fromLeft ? null : width - 45,
          child: Container(
            width: 130,
            height: 130,
            alignment: Alignment.center,
            child: Image.asset(
              imagePath,
              width: 130,
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    ),
  );
}
    }