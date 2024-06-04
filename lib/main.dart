import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
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

Future<String> loadJsonData() async {
  String jsonData =
      await rootBundle.loadString('assets/text_content/labeiks.json');
  return jsonData;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/ic_launcher_foreground.png', // Replace with your image asset path
              fit: BoxFit.scaleDown,
            ),
          ),
          ListView.builder(
            itemCount: 31,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200]!
                      .withOpacity(0.7), // Slightly gray background color
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  border: Border.all(color: Colors.grey), // Border outline
                ),
                margin: EdgeInsets.all(6), // Margin around the tile
                child: ListTile(
                  title: Text('لبیک ${formatNumber(index + 1)}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(entryNumber: index + 1),
                      ),
                    );
                  },
                ),
              );
            },
          ),
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
    String imageUrl = 'assets/images/salute_supreme_air.jpg';
    // 'assets/images/full_detailed_pages/labeik_${widget.entryNumber}.jpg';

    return FutureBuilder(
      future: loadJsonData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> shortInfo = jsonDecode(snapshot.data.toString());
          return Scaffold(
            appBar: AppBar(
              title: Text('لبیک $formattedNumber'),
              backgroundColor:
                  Colors.greenAccent, // Set the background color here
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(imageUrl),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey
                          .withOpacity(0.7), // Semi-transparent gray background
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    child: Text(
                      '«${shortInfo["${widget.entryNumber}"]["name"]}»',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Add some space between the texts
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey
                          .withOpacity(0.7), // Semi-transparent gray background
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    child: Text(
                      '${shortInfo["${widget.entryNumber}"]["short_text"]}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _navigate,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.greenAccent), // Changed to greenAccent
                      elevation: MaterialStateProperty.all<double>(10.0),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.black54),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(fontSize: 20),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.greenAccent,
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

class FullDetailPage extends StatelessWidget {
  final int entryNumber;

  FullDetailPage({required this.entryNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('لبیک ${formatNumber(entryNumber)}'),
          backgroundColor: Colors.greenAccent),
      body: Center(
        child: Text('محتوای کامل لبیک ${formatNumber(entryNumber)}'),
      ),
    );
  }
}
