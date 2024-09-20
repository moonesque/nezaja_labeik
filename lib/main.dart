import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'splash_screen.dart'; // Import the splash screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لبیک یا امام خامنه ای (مدظله العالی)',
      locale: const Locale('fa'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'),
        Locale('en'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6b8e23)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

String formatNumber(int number) {
  final NumberFormat formatter = NumberFormat.decimalPattern('fa_IR');
  return formatter.format(number);
}

Future<String> loadJsonData(String jsonPath) async {
  String jsonData = await rootBundle.loadString(jsonPath);
  return jsonData;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _labeiksFuture;

  @override
  void initState() {
    super.initState();
    _labeiksFuture = loadLabeiksJsonData();
  }

  Future<Map<String, dynamic>> loadLabeiksJsonData() async {
    String jsonString =
        await rootBundle.loadString('assets/text_content/labeiks.json');
    return jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Column(
            children: [
              SizedBox(height: statusBarHeight), // Reserve space for status bar
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30.0)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/cropped_supreme.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 0), // No offset needed
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .black54, // Semi-transparent background
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded corners
                                ),
                                child: Text(
                                  'لبیک یا امام خامنه ای (مدظله العالی)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontFamily: "Zar",
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.black.withOpacity(0),
                          width: double.infinity,
                          child: Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Nazanin"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _labeiksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  }
                  Map<String, dynamic> labeiks = snapshot.data!;
                  return ListView.builder(
                    itemCount: 31,
                    itemBuilder: (context, index) {
                      int entryNumber = index + 1;
                      String shortInfo =
                          labeiks["$entryNumber"]["short_text"] ?? '';
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200]!.withOpacity(
                              0.7), // Slightly gray background color
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                          border:
                              Border.all(color: Colors.grey), // Border outline
                        ),
                        margin: EdgeInsets.all(6), // Margin around the tile
                        child: ListTile(
                          title: Row(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'لبیک ${formatNumber(entryNumber)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Entezar",
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          200), // Set max width for center alignment
                                  child: Center(
                                    child: Text(
                                      shortInfo,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        fontFamily: "Nazanin",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(entryNumber: entryNumber),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Error loading data'));
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.black.withOpacity(0.3),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Flexible(
                //   child: Image.asset(
                //     'assets/images/bazresi.png',
                //     height: 10,
                //     fit: BoxFit.contain,
                //   ),
                // ),
                // SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'تهیه شده در مد بازرسی و ایمنی ف آما و پش مرکز نزاجا (دبیرخانه طرح های لبیک)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Nazanin",
                    ),
                  ),
                ),
                // SizedBox(width: 8),
                // Flexible(
                //   child: Image.asset(
                //     'assets/images/famaposh.png',
                //     height: 10,
                //     fit: BoxFit.contain,
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final int entryNumber;

  DetailPage({required this.entryNumber});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<int> _countdownNotifier;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _countdownNotifier = ValueNotifier<int>(10);
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownNotifier.value > 0) {
        _countdownNotifier.value--;
      } else {
        timer.cancel();
        _navigate();
      }
    });
  }

  void _navigate() {
    _timer?.cancel(); // Cancel any ongoing timer
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FullDetailPage(entryNumber: widget.entryNumber),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(-1.0, 0.0); // Slide in from the left
          var end = Offset.zero;
          var curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    ).then((value) {
      _resetCountdown(); // Reset countdown when coming back
    });
  }

  void _resetCountdown() {
    _timer?.cancel();
    _countdownNotifier.value = 10; // Reset countdown
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdownNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedNumber = formatNumber(widget.entryNumber);
    String imageUrl = 'assets/images/full_detailed_pages/labeik_1/overview.jpg';

    return FutureBuilder(
      future: loadJsonData('assets/text_content/labeiks.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> shortInfo = jsonDecode(snapshot.data.toString());
          return Scaffold(
            appBar: AppBar(
              title: Text('لبیک $formattedNumber',
                  style: TextStyle(fontFamily: "Entezar")),
              backgroundColor:
                  const Color(0xFF6b8e23), // Set the background color here
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(imageUrl),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(
                                0.7), // Semi-transparent gray background
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Text(
                            '«${shortInfo["${widget.entryNumber}"]["name"]}»',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Entezar"),
                          ),
                        ),
                        SizedBox(
                            height: 10), // Add some space between the texts
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(
                                0.7), // Semi-transparent gray background
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Text(
                            '${shortInfo["${widget.entryNumber}"]["short_text"]}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: "Nazanin"),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _navigate,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 24.0),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(
                                    0xFF6b8e23)), // Changed to greenAccent
                            elevation: MaterialStateProperty.all<double>(10.0),
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.black54),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: 20),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF6b8e23),
                                  Colors.white24
                                ], // Changed to green gradient
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: ValueListenableBuilder<int>(
                                valueListenable: _countdownNotifier,
                                builder: (context, countdownValue, child) {
                                  return Text(
                                    'مطالعه (${formatNumber(countdownValue)})',
                                    style: TextStyle(color: Colors.black),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.3),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Commented out images to focus on text, uncomment if needed
                      // Flexible(
                      //   child: Image.asset(
                      //     'assets/images/bazresi.png',
                      //     height: 10,
                      //     fit: BoxFit.contain,
                      //   ),
                      // ),
                      // SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'تهیه شده در مد بازرسی و ایمنی ف آما و پش مرکز نزاجا (دبیرخانه طرح های لبیک)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Nazanin",
                          ),
                        ),
                      ),
                      // SizedBox(width: 8),
                      // Flexible(
                      //   child: Image.asset(
                      //     'assets/images/famaposh.png',
                      //     height: 10,
                      //     fit: BoxFit.contain,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: Text('Error loading data')),
          );
        }
      },
    );
  }
}

class FullDetailPage extends StatefulWidget {
  final int entryNumber;

  FullDetailPage({required this.entryNumber});

  @override
  _FullDetailPageState createState() => _FullDetailPageState();
}

class _FullDetailPageState extends State<FullDetailPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Future<List<Map<String, dynamic>>> _pagesFuture;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pagesFuture = _loadPages();

    // Initialize the fade animation controller and animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
  }

  @override
  void dispose() {
    // Dispose the fade animation controller
    _fadeController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadPages() async {
    String jsonString = await loadJsonData(
        'assets/text_content/full_detailed_pages/labeik_1.json');
    List<dynamic> jsonData = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonData);
  }

  Future<String> loadJsonData(String jsonPath) async {
    String jsonData = await rootBundle.loadString(jsonPath);
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _pagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final List<Map<String, dynamic>> pages = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'لبیک ${formatNumber(widget.entryNumber)}',
              style: TextStyle(fontFamily: "Entezar"),
            ),
            backgroundColor: const Color(0xFF6B8E23),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: KenBurnsEffect(
                  imagePath: pages[_currentPage]['image'],
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                          _fadeController.reset();
                          _fadeController.forward();
                        });
                      },
                      itemBuilder: (context, index) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: Text(
                                    pages[index]['title'],
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: "Zar"),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: Text(
                                    pages[index]['content'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: "Nazanin"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentPage > 0)
                          Container(
                            color: Colors.black.withOpacity(0.5),
                            child: TextButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text(
                                'صفحه قبل',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ),
                        SizedBox(width: 20),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            'صفحه ${formatNumber(_currentPage + 1)} از ${formatNumber(pages.length)}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 20),
                        if (_currentPage < pages.length - 1)
                          Container(
                            color: Colors.black.withOpacity(0.5),
                            child: TextButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text(
                                'صفحه بعد',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String formatNumber(int number) {
    final NumberFormat formatter = NumberFormat.decimalPattern('fa_IR');
    return formatter.format(number);
  }
}

class KenBurnsEffect extends StatefulWidget {
  final String imagePath;

  KenBurnsEffect({required this.imagePath});

  @override
  _KenBurnsEffectState createState() => _KenBurnsEffectState();
}

class _KenBurnsEffectState extends State<KenBurnsEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: Image.asset(widget.imagePath, fit: BoxFit.cover),
    );
  }
}
