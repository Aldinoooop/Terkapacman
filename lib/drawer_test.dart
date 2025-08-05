import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui'; // diperlukan untuk ImageFilter
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'dart:io';
// import 'package:csv/csv.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'Test/calenderHistory.dart';

final logger = Logger();

class mainScreen extends StatelessWidget {
  final String username;
  final bool isAdmin;
  const mainScreen({super.key, required this.username, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Demo',
      home: HomePage(
        username: username,
        isAdmin: isAdmin,
      ),
    );
  }
}

class secondScreen extends StatelessWidget {
  const secondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Demo',
      home: GuestPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;
  final bool isAdmin;
  const HomePage({Key? key, required this.username, required this.isAdmin})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class GuestPage extends StatefulWidget {
  @override
  State<GuestPage> createState() => _GuestPageState();
}

DateTime parseCustomTimestamp(String timestamp) {
  // Format: "2025-05-04_18-01"
  try {
    final parts = timestamp.split('_');
    final datePart = parts[0]; // 2025-05-04
    final timePart = parts[1]; // 18-01

    final formatted = "$datePart ${timePart.replaceAll('-', ':')}";
    return DateTime.parse(formatted);
  } catch (e) {
    return DateTime.now(); // fallback
  }
}

class _GuestPageState extends State<GuestPage> {
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              "Hi Guest",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Monitoring Katak Pacman",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'lib/Assets/1x/Background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Mjpeg(
                stream: 'https://stream.terrium.my.id/stream',
                isLive: true,
              ),
              // PiTunnelVideoPlayer(
              //   streamUrl:
              //       // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
              //       'https://stream.terrium.my.id/stream'
              //       ,
              // ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => logout(context),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FrogProfilePage extends StatelessWidget {
  const FrogProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'lib/Assets/1x/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Konten dengan blur semi-transparan
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "🐸 Katak Pacman",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'lib/Assets/1x/Logo.png', // ganti sesuai path fotomu
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Katak Pacman, yang secara ilmiah disebut *Ceratophrys cranwelli*, adalah jenis amfibi yang berasal dari kawasan Amerika Selatan. Pacman dikenal cenderung malas karena mereka lebih suka berada di tempat dan tidak banyak bergerak. Jadi, mereka tidak akan melarikan diri. Mereka lebih aktif pada malam hari dan suka bersembunyi di tempat yang lembap. Ketika berburu, Pacman akan tetap diam dan menunggu makanan datang. Mereka merupakan predator yang menunggu dan biasanya menghabiskan waktu lama untuk menantikan mangsanya.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "📚 Referensi:\n• da Silva Jorge et al. (2015)\n  Judul: *On the natural history of the Catinga horned frog, Ceratophrys joazeirensis...*\n  Sumber: Phyllomedusa: Journal of Herpetology",
                          style: TextStyle(
                              fontSize: 13, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  String _title = "Dashboard";

  Widget _getPageContent(String title) {
    switch (title) {
      case 'Profile':
        return TimedWidget(
          key: ValueKey(title),
          label: 'Profile Page',
          child: FrogProfilePage(),
        );
      case 'Live Data':
        return TimedWidget(
          label: 'Live Data Page',
          child: LiveData(admin: widget.isAdmin),
        );
      case 'Grafik':
        return TimedWidget(
          label: 'Grafik Page',
          child: SensorCharts(),
        );
      case 'Livestream':
        return TimedWidget(
          key: ValueKey(title),
          label: 'Livestream Page',
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Mjpeg(
                stream: 'https://stream.terrium.my.id/stream',
                isLive: true,
              ),
            ),
          ),
        );
      case 'History':
        return TimedWidget(
          label: 'History Page',
          child: CalendarPage(),
        );
      default:
        return TimedWidget(
          label: 'Default (Live Data)',
          child: LiveData(admin: widget.isAdmin),
        );
    }
  }

  void _selectDrawerItem(String title) {
    setState(() {
      _title = title;
    });
    Navigator.pop(context); // Menutup drawer setelah memilih
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          // automaticallyImplyLeading: false,
          title: Column(
            children: [
              Text(
                "Hi ${widget.username}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Monitoring Terrarium Katak Pacman",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        drawer: Drawer(
          backgroundColor: Colors.transparent, // transparan dulu
          child: BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: 10, sigmaY: 10), // nilai blur X & Y
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.2), // semi transparan agar blur terlihat
              ),
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color:
                          Colors.transparent, // biar header-nya juga ikut blur
                    ),
                    child: Text(
                      'Menu Navigasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_box, color: Colors.white),
                    title:
                        Text('Profile', style: TextStyle(color: Colors.white)),
                    onTap: () => _selectDrawerItem('Profile'),
                  ),
                  ListTile(
                    leading: Icon(Icons.data_usage, color: Colors.white),
                    title: Text('Live Data',
                        style: TextStyle(color: Colors.white)),
                    onTap: () => _selectDrawerItem('Live Data'),
                  ),
                  ListTile(
                    leading: Icon(Icons.show_chart, color: Colors.white),
                    title:
                        Text('Grafik', style: TextStyle(color: Colors.white)),
                    onTap: () => _selectDrawerItem('Grafik'),
                  ),
                  ListTile(
                    leading: Icon(Icons.videocam, color: Colors.white),
                    title: Text('Livestream',
                        style: TextStyle(color: Colors.white)),
                    onTap: () => _selectDrawerItem('Livestream'),
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: Colors.white),
                    title:
                        Text('History', style: TextStyle(color: Colors.white)),
                    onTap: () => _selectDrawerItem('History'),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.white),
                    title:
                        Text('Logout', style: TextStyle(color: Colors.white)),
                    onTap: () => logout(context),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(children: [
          SizedBox.expand(
            child: Image.asset(
              'lib/Assets/1x/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          _getPageContent(_title),
        ]));
  }
}

class SensorCharts extends StatefulWidget {
  const SensorCharts({super.key});

  @override
  State<SensorCharts> createState() => _SensorChartsState();
}

class _SensorChartsState extends State<SensorCharts> {
  int _selectedDays = 1; // default 1 hari terakhir
  final Stopwatch _stopwatch = Stopwatch();
  Duration? _loadDuration;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<int>(
            value: _selectedDays,
            items: const [
              DropdownMenuItem(value: 1, child: Text("1 Hari Terakhir")),
              DropdownMenuItem(value: 2, child: Text("2 Hari Terakhir")),
              DropdownMenuItem(value: 7, child: Text("7 Hari Terakhir")),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedDays = val;
                });
              }
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Terrarium")
                .orderBy(FieldPath.documentId)
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

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Data Kosong"));
              } else {
                if (_stopwatch.isRunning) {
                  _stopwatch.stop();
                  _loadDuration = _stopwatch.elapsed;
                  debugPrint("Load time Grafik: ${_loadDuration!.inMilliseconds} ms");
                }
              }

              final allDocs = snapshot.data!.docs;
              final filtered = parseAndFilterData(allDocs, _selectedDays);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: _buildChart("Temperature (°C)", filtered,
                        'temperature', Colors.orange, 20, 30),
                      )),
                    const SizedBox(height: 16),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child:  _buildChart("Humidity (%)", filtered,
                        'humidityPercent', Colors.blue, 0, 100),
                      )),
                    const SizedBox(height: 16),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: _buildChart("Water Level (%)", filtered,
                        'waterLevelPercent', Colors.green, 0, 100),
                      )),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> parseAndFilterData(
      List<QueryDocumentSnapshot> docs, int days) {
    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: days));

    return docs.map((doc) {
      final rawTimestamp = doc.id;
      final date = parseCustomTimestamp(rawTimestamp);

      final sensor = doc['SensorValue'][0];
      return {
        'timestamp': date,
        'temperature': (sensor['Temperature'] as num).toDouble(),
        'humidityPercent': (sensor['HumidityPercent'] as num).toDouble(),
        'waterLevelPercent': (sensor['WaterLevelPercent'] as num).toDouble(),
      };
    }).where((data) {
      final ts = data['timestamp'];
      return ts is DateTime && ts.isAfter(cutoff);
    }).toList();
  }

  Widget _buildChart(String title, List<Map<String, dynamic>> data, String key,
      Color color, double min, double max) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Center(child: Text("Tidak ada data untuk $title")),
      );
    }

    final List<FlSpot> spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final value = entry.value[key] as double;
      final clampedValue = value.clamp(min, max); // 🔧 Clamp value
      return FlSpot(index, clampedValue);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 40,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= data.length)
                          return const Text('');
                        final date = data[index]['timestamp'] as DateTime;
                        return Text(
                          DateFormat('MM/dd\nHH:mm').format(date),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                      interval: data.length / 5,
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: data.length.toDouble() - 1,
                minY: min,
                maxY: max,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime parseCustomTimestamp(String timestamp) {
    try {
      final parts = timestamp.split('_'); // e.g., "2025-05-04_18-01"
      final datePart = parts[0];
      final timePart = parts[1];
      final formatted = "$datePart ${timePart.replaceAll('-', ':')}";
      return DateTime.parse(formatted);
    } catch (_) {
      return DateTime.now();
    }
  }
}


class HistoryData extends StatefulWidget {
  const HistoryData({super.key});

  @override
  State<HistoryData> createState() => _HistoryDataState();
}

class _HistoryDataState extends State<HistoryData> {
  String _selectedFilter = "All";
  List<HistoryEntry> _allData = [];
  List<HistoryEntry> _filteredData = [];

  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _fetchData(); // initial fetch
  }

  void _fetchData() {
    DatabaseService.getTerrariumStream().listen((snapshot) {
      final docs = snapshot.docs;
      final dataList = docs
          .map((doc) {
            final data = doc['SensorValue'][0];
            return HistoryEntry(
              timestamp: doc.id,
              temperature: data['Temperature'].toString(),
              humidity: data['Humidity'].toString(),
              waterLevel: data['WaterLevel'].toString(),
            );
          })
          .toList()
          .reversed
          .toList();

      setState(() {
        _allData = dataList;
        _applyFilter();
      });
    });
  }

  void _applyFilter() {
    final now = DateTime.now();
    setState(() {
      if (_selectedFilter == "Today") {
        _filteredData = _allData.where((entry) {
          final date = DateTime.tryParse(entry.timestamp);
          return date != null &&
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        }).toList();
      } else if (_selectedFilter == "Last 2 Days") {
        _filteredData = _allData.where((entry) {
          final date = DateTime.tryParse(entry.timestamp);
          return date != null && now.difference(date).inDays <= 2;
        }).toList();
      } else if (_selectedFilter == "Last 7 Days") {
        _filteredData = _allData.where((entry) {
          final date = DateTime.tryParse(entry.timestamp);
          return date != null && now.difference(date).inDays <= 7;
        }).toList();
      } else {
        _filteredData = _allData;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Filter: "),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedFilter,
                items: const [
                  DropdownMenuItem(value: "All", child: Text("All")),
                  DropdownMenuItem(value: "Today", child: Text("Today")),
                  DropdownMenuItem(
                      value: "Last 2 Days", child: Text("Last 2 Days")),
                  DropdownMenuItem(
                      value: "Last 7 Days", child: Text("Last 7 Days")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                    _applyFilter();
                  });
                },
              ),
              const Spacer(),
              // Tombol export dihilangkan
            ],
          ),
        ),
        Expanded(
          child: _filteredData.isEmpty
              ? const Center(child: Text("No data available"))
              : PaginatedDataTable(
                  header: const Text("Sensor History"),
                  columns: const [
                    DataColumn(label: Text("Timestamp")),
                    DataColumn(label: Text("Temp (°C)")),
                    DataColumn(label: Text("Humidity")),
                    DataColumn(label: Text("Water Level")),
                  ],
                  source: HistoryDataSource(_filteredData),
                  rowsPerPage: 5,
                  columnSpacing: 20,
                  horizontalMargin: 10,
                  showCheckboxColumn: false,
                ),
        ),
      ],
    );
  }
}

class HistoryEntry {
  final String timestamp;
  final String temperature;
  final String humidity;
  final String waterLevel;

  HistoryEntry({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.waterLevel,
  });
}

class HistoryDataSource extends DataTableSource {
  final List<HistoryEntry> data;

  HistoryDataSource(this.data);

  @override
  DataRow getRow(int index) {
    final item = data[index];
    return DataRow(
      cells: [
        DataCell(Text(item.timestamp)),
        DataCell(Text(item.temperature)),
        DataCell(Text(item.humidity)),
        DataCell(Text(item.waterLevel)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class DatabaseService {
  static final CollectionReference terrariumCollection =
      FirebaseFirestore.instance.collection("Terrarium");

  static Stream<QuerySnapshot> getTerrariumStream() {
    return terrariumCollection
        .orderBy(FieldPath.documentId, descending: true)
        .snapshots();
  }
}

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'baru saja';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} menit yang lalu';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} jam yang lalu';
  } else {
    return '${difference.inDays} hari yang lalu';
  }
}

class LiveData extends StatefulWidget {
  const LiveData({super.key, required this.admin});
  final bool admin;

  @override
  State<LiveData> createState() => _LiveDataState();
}

class _LiveDataState extends State<LiveData> {
  final Stopwatch _stopwatch = Stopwatch();
  Duration? _loadDuration;

  @override
  void initState() {
    super.initState();
    _stopwatch.start(); // mulai hitung waktu saat widget muncul
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Terrarium")
          .orderBy(FieldPath.documentId, descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        print(
            "StreamBuilder snapshot: hasData=${snapshot.hasData}, hasError=${snapshot.hasError}");
        if (snapshot.hasError) {
          print("Error snapshot: ${snapshot.error}");
          return const Text("Terjadi kesalahan saat mengambil data.");
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print("Snapshot data kosong atau docs kosong");
          return const Center(
            child: Text(
              "Belum ada data sensor tersedia.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        } else {
          if (_stopwatch.isRunning) {
            _stopwatch.stop();
            _loadDuration = _stopwatch.elapsed;
            debugPrint(
                "Load time Live Data: ${_loadDuration!.inMilliseconds} ms");
          }
        }

        final doc = snapshot.data!.docs.first;
        print("Dokumen pertama id: ${doc.id}");

        final dataList = doc['SensorValue'];
        print("dataList: $dataList");

        if (dataList == null || !(dataList is List) || dataList.isEmpty) {
          print("dataList null/empty atau bukan List");
          return const Center(child: Text("Data tidak tersedia."));
        }

        final data = dataList[0];
        print("data pertama dari dataList: $data");
        if (data == null || !(data is Map)) {
          print("data bukan Map atau null");
          return const Center(child: Text("Data sensor invalid."));
        }

        // final timestamp = doc.id;
        final rawTimestamp = doc.id;
        final timestamp = parseCustomTimestamp(rawTimestamp);

        final temperature = data['Temperature'];
        final humidity = data['Humidity'];
        final humidityPercent = data['HumidityPercent'];
        final waterLevel = data['WaterLevel'];
        final waterLevelPercent = data['WaterLevelPercent'];

        logger.i(timestamp);

        // Kondisi kritis
        bool isHumidityCritical = humidityPercent < 30;
        bool isTempCritical = temperature > 26 || temperature < 24;
        bool isWaterCritical = waterLevelPercent < 20;

        return SafeArea(
            child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32),
          children: [
            // const SizedBox(height: 40),
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📅 Terakhir diperbarui: ${timeAgo(timestamp)}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildSensorTile("Humidity",
                        "$humidity ($humidityPercent%)", isHumidityCritical),
                    _buildSensorTile(
                        "Temperature", "$temperature °C", isTempCritical),
                    _buildSensorTile(
                        "Water Level",
                        "$waterLevel cm ($waterLevelPercent%)",
                        isWaterCritical),
                    if (isHumidityCritical || isTempCritical || isWaterCritical)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          "⚠️ Kondisi kritis terdeteksi!",
                          style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Gauge section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGauge("Temperatures", temperature.toDouble(), "°C",
                          isTempCritical, Colors.black, 20, 30),
                      SizedBox(
                        width: 20,
                      ),
                      _buildGauge("Humidity", humidity.toDouble(), "",
                          isTempCritical, Colors.black, 0, 1023),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGauge("Water Level", waterLevel.toDouble(), "CM",
                          isTempCritical, Colors.black, 0, 20),
                      SizedBox(
                        width: 20,
                      ),
                      _buildGauge(
                          "Humidity Percentage",
                          humidityPercent.toDouble(),
                          "%",
                          isTempCritical,
                          Colors.black,
                          0,
                          100),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGauge(
                          "Water Level Percantage",
                          waterLevelPercent.toDouble(),
                          "%",
                          isTempCritical,
                          Colors.black,
                          0,
                          100),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tombol hapus

            if (widget.admin)
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Konfirmasi"),
                        content:
                            const Text("Yakin ingin menghapus semua data?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Reset"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await _resetAndClearData(context);
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                ),
              ),

            // const SizedBox(height: 30),
          ],
        ));
      },
    );
  }

  Widget _buildSensorTile(String label, String value, bool isCritical) {
    return ListTile(
      leading: Icon(
        Icons.sensors,
        color: isCritical ? Colors.red : Colors.green,
      ),
      title: Text(label),
      subtitle: Text(value),
      trailing: isCritical
          ? const Icon(Icons.warning, color: Colors.red)
          : const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  Future<void> _resetAndClearData(BuildContext context) async {
    final collection = FirebaseFirestore.instance.collection('Terrarium');

    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final snapshot = await collection.get();
      final deleteFutures = snapshot.docs.map((doc) => doc.reference.delete());
      await Future.wait(deleteFutures);

      if (context.mounted) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil direset ke 0.")),
      );
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal reset data: $e")),
      );
    }
  }
}

Color getPointerColor(String title, double value) {
  switch (title) {
    case "Temperatures":
      if (value < 25)
        return Colors.green;
      else if (value < 26)
        return Colors.orange;
      else
        return Colors.red;

    case "Humidity":
      if (value < 100)
        return Colors.red;
      else if (value < 700)
        return Colors.orange;
      else
        return Colors.green;

    case "Water Level":
      if (value < 5)
        return Colors.red;
      else if (value < 15)
        return Colors.orange;
      else
        return Colors.green;

    case "Humidity Percentage":
      if (value < 40)
        return Colors.red;
      else if (value < 60)
        return Colors.orange;
      else
        return Colors.green;

    case "Water Level Percantage":
      if (value < 30)
        return Colors.red;
      else if (value < 70)
        return Colors.orange;
      else
        return Colors.green;

    default:
      return Colors.blueGrey;
  }
}

Widget _buildGauge(String title, double value, String unit, bool isCritical,
    Color color, double min, double max) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          SizedBox(
            width: 160,
            height: 140,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: min,
                  maximum: max,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.2,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Colors.grey.shade300,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: value.clamp(min, max),
                      width: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: getPointerColor(title, value),
                      // gradient: const SweepGradient(
                      //   colors: [Colors.green, Colors.yellow, Colors.red],
                      //   stops: [0.0, 0.5, 1.0],
                      // ),
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: true,
                      animationDuration: 800,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Text(
                        "$value $unit",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isCritical ? Colors.red : Colors.black,
                        ),
                      ),
                      angle: 90,
                      positionFactor: 0.1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Fungsi logout
Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  // Setelah logout, pindah ke halaman login
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const LoginPage()),
  );
}

class PiTunnelVideoPlayer extends StatefulWidget {
  final String streamUrl;

  const PiTunnelVideoPlayer({
    Key? key,
    required this.streamUrl,
  }) : super(key: key);

  @override
  State<PiTunnelVideoPlayer> createState() => _PiTunnelVideoPlayerState();
}

class _PiTunnelVideoPlayerState extends State<PiTunnelVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.streamUrl)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_controller.value.isInitialized)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Stream dari Pi Tunnel',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                IconButton(
                  onPressed: _togglePlay,
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimedWidget extends StatefulWidget {
  final String label;
  final Widget child;

  const TimedWidget({super.key, required this.label, required this.child});

  @override
  State<TimedWidget> createState() => _TimedWidgetState();
}

class _TimedWidgetState extends State<TimedWidget> {
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stopwatch.stop();
      debugPrint('⏱ Render time for "${widget.label}": ${_stopwatch.elapsedMilliseconds} ms');
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
