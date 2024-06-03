import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: HomePage(),
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
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
              title: Text(
                'لبیک یا امام خامنه ای (مدظله العالی)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              flexibleSpace: SafeArea(
                  child: Image(
                image: AssetImage('assets/images/cropped_supreme.jpg'),
                fit: BoxFit.cover,
              )))),
      body: Stack(children: [
        Center(
            child: Image.asset(
          'assets/images/ic_launcher_foreground.png', // Replace with your image asset path
          fit: BoxFit.scaleDown,
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
        )),
        ListView.builder(
          itemCount: 11,
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
                title: Text('لبیک ${formatNumber(index + 1)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(entryNumber: index + 1),
                    ),
                  );
                },
              ),
            );
          },
        )
      ]),
    );
  }
}

// This widget is the home page of your application. It is stateful, meaning
// that it has a State object (defined below) that contains fields that affect
// how it looks.

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

class DetailPage extends StatelessWidget {
  final int entryNumber;

  DetailPage({required this.entryNumber});

  @override
  Widget build(BuildContext context) {
    String formattedNumber = formatNumber(entryNumber);
    String textContent = 'لبیک $formattedNumber';
    String imageUrl = 'assets/images/salute_supreme_air.jpg';

    return FutureBuilder(
      future: loadJsonData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> shortInfo = jsonDecode(snapshot.data.toString());
          return Scaffold(
            appBar: AppBar(
              title: Text('لبیک $formattedNumber'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(imageUrl),
                  SizedBox(height: 20),
                  Text(
                    '«${shortInfo["$entryNumber"]["name"]}»',
                    style: TextStyle(fontSize: 22, decorationThickness: 6, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${shortInfo["$entryNumber"]["short_text"]}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        decorationThickness: 6,
                  )),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullDetailPage(entryNumber: entryNumber)),
                      );
                    },
                    child: Text('مطالعه', style: TextStyle(fontSize: 20),),
                  )
                ],
              ),
            ),
          );
        } else {
          return Text('Error loading data');
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
        title: Text('Full Detail Page'),
      ),
      body: Center(
        child: Text('Entry Number: $entryNumber'),
      ),
    );
  }
}
