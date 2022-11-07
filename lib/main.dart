import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const myTitle = "Positive Pushes";
    return MaterialApp(
      title: myTitle,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const AffirmationList(title: myTitle),
    );
  }
}

class AffirmationList extends StatefulWidget {
  const AffirmationList({super.key, required this.title});

  final String title;

  @override
  State<AffirmationList> createState() => _AffirmationListState();
}

class _AffirmationListState extends State<AffirmationList> {
  List<String> _affirmations = <String>[];

  void _loadData() async {
    final _loadedData = await rootBundle.loadString('assets/affirmations.txt');
    setState(() {
      _affirmations = _loadedData.split('\n');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _affirmations.length,
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          final index = i ~/ 2;

          return ListTile(
            title: Text(_affirmations[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Random random = Random();
            int randomNumber = random.nextInt(_affirmations.length);
            showNotification(widget.title, _affirmations[randomNumber]);
          },
          child: const Icon(Icons.notifications_active)),
    );
  }

  showNotification(String _title, String _message) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'Positive Pushes',
      'Affirmation message',
      description: 'Affirmation message',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      _title,
      _message,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description),
      ),
    );
  }
}
