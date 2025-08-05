import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   // Setup background handler
//   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   // Setup local notifications
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   runApp(MaterialApp(
//     home: CalendarPage(),
//   ));
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender Data',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalendarPage(), // ← ini penting
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
    final Stopwatch _stopwatch = Stopwatch();
  Duration? _loadDuration;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    String selectedDateFormatted =
        DateFormat('yyyy-MM-dd').format(_selectedDay);

    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Card(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
          ),
        )),
        const SizedBox(height: 16),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Terrarium")
                .where(FieldPath.documentId,
                    isGreaterThanOrEqualTo: "$selectedDateFormatted")
                .where(FieldPath.documentId,
                    isLessThan: "$selectedDateFormatted" + "_23-59")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/Assets/giphy.gif',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 16),
                      const Text("Kodok lagi mikir..."),
                    ],
                  ),
                );
              }

              // if (!snapshot.hasData) {
              //   return const Center(child: CircularProgressIndicator());
              // }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return const Center(
                    child: Text('Tidak ada data di tanggal ini'));
              } else {
                if (_stopwatch.isRunning) {
                  _stopwatch.stop();
                  _loadDuration = _stopwatch.elapsed;
                  debugPrint(
                      "Load time History: ${_loadDuration!.inMilliseconds} ms");
                }
              }

              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("Waktu: ${docs[index].id}"),
                      subtitle: Text(
                          "Kelembapan: ${data['SensorValue'][0]['Humidity']}\n"
                          "Persentase: ${data['SensorValue'][0]['HumidityPercent']}%\n"
                          "Suhu: ${data['SensorValue'][0]['Temperature']}°C\n"
                          "WaktuLengkap: ${data['SensorValue'][0]['WaktuLengkap']}\n"
                          "WaktuTerima: ${data['SensorValue'][0]['WaktuTerima']}\n"
                          "Tinggi Air: ${data['SensorValue'][0]['WaterLevel']}cm\n"
                          "Persentase Tinggi AIr: ${data['SensorValue'][0]['WaterLevelPercent']}%\n"),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
