import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'drawer_test.dart'

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext content) {
    final collection = FirebaseFirestore.instance.collection("Terrarium");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Column(
            children: [
              Text(
                "Hi USER",
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
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
  children: [
    Image.asset(
      'lib/Assets/1x/Background.png',
      fit: BoxFit.cover,
    ),
    Column(
      children: [
        SizedBox(height: 100),
        Expanded(
          child: Container(
            // color: Colors.amberAccent,
            child: StreamBuilder<QuerySnapshot>(
              stream: collection
                  .orderBy(FieldPath.documentId, descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Text("Error: ${snapshot.error}"));
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;

                final dataList = docs
                    .map((doc) {
                      final data = doc['SensorValue'][0];
                      return {
                        'timestamp': doc.id,
                        'temperature': data['Temperature'],
                        'humidity': data['Humidity'],
                        'water': data['WaterLevel'],
                      };
                    })
                    .toList()
                    .reversed
                    .toList();

                return Column(
                  children: [
                    // Chart dengan tinggi tetap
                    SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SensorChart(dataList: dataList),
                      ),
                    ),
                    // ListView harus dibungkus Expanded
                    Expanded(
                      child: ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final item = dataList[index];
                          return ListTile(
                            title: Text(item['timestamp']),
                            subtitle: Text(
                                "Temp: ${item['temperature']}°C | Humidity: ${item['humidity']} | Water: ${item['water']}"),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    ),
  ],
),

      // body: Stack(
      //   children: [
      //     Image.asset(
      //       'lib/Assets/1x/Background.png',
      //       fit: BoxFit.cover,
      //     ),
      //     Column(
      //       // color: Colors.black,
      //         children: [ 
      //         SizedBox(height: 50,),
      //         Container(
      //           color: Colors.amberAccent,
      //           child: 
      //         StreamBuilder<QuerySnapshot>(
      //           stream: collection
      //               .orderBy(FieldPath.documentId, descending: true)
      //               .snapshots(),
      //           builder: (context, snapshot) {
      //             if (snapshot.hasError)
      //               return Center(child: Text("Error: ${snapshot.error}"));
      //             if (!snapshot.hasData)
      //               return const Center(child: CircularProgressIndicator());

      //             final docs = snapshot.data!.docs;

      //             // Buat list dari data sensor + grafik
      //             final dataList = docs
      //                 .map((doc) {
      //                   final data = doc['SensorValue'][0];
      //                   return {
      //                     'timestamp': doc.id,
      //                     'temperature': data['Temperature'],
      //                     'humidity': data['Humidity'],
      //                     'water': data['WaterLevel'],
      //                   };
      //                 })
      //                 .toList()
      //                 .reversed
      //                 .toList(); // Biar urut dari lama ke baru

      //             return Column(
      //               children: [
      //                 SensorChart(dataList: dataList),
      //                 // Expanded(
      //                 //   flex: 2,
      //                 //   child: Padding(
      //                 //     padding: const EdgeInsets.all(8.0),
      //                 //     child: SensorChart(dataList: dataList),
      //                 //   ),
      //                 // ),
      //                 ListView.builder(
      //                     itemCount: dataList.length,
      //                     itemBuilder: (context, index) {
      //                       final item = dataList[index];
      //                       return ListTile(
      //                         title: Text(item['timestamp']),
      //                         subtitle: Text(
      //                             "Temp: ${item['temperature']}°C | Humidity: ${item['humidity']} | Water: ${item['water']}"),
      //                       );
      //                     },
      //                   ),

      //                 // Expanded(
      //                 //   flex: 3,
      //                 //   child: ListView.builder(
      //                 //     itemCount: dataList.length,
      //                 //     itemBuilder: (context, index) {
      //                 //       final item = dataList[index];
      //                 //       return ListTile(
      //                 //         title: Text(item['timestamp']),
      //                 //         subtitle: Text(
      //                 //             "Temp: ${item['temperature']}°C | Humidity: ${item['humidity']} | Water: ${item['water']}"),
      //                 //       );
      //                 //     },
      //                 //   ),
      //                 // )
      //               ],
      //             );
      //           },
      //         ),
      //     )])
      //   ],
      // ),
    );
  }

  // Widget build(BuildContext context) {
  //   final collection = FirebaseFirestore.instance.collection("Terrarium");

  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Monitoring Sensor")),
  //     body: StreamBuilder<QuerySnapshot>(
  //       stream: collection
  //           .orderBy(FieldPath.documentId, descending: true)
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError)
  //           return Center(child: Text("Error: ${snapshot.error}"));
  //         if (!snapshot.hasData)
  //           return const Center(child: CircularProgressIndicator());

  //         final docs = snapshot.data!.docs;

  //         // Buat list dari data sensor + grafik
  //         final dataList = docs
  //             .map((doc) {
  //               final data = doc['SensorValue'][0];
  //               return {
  //                 'timestamp': doc.id,
  //                 'temperature': data['Temperature'],
  //                 'humidity': data['Humidity'],
  //                 'water': data['WaterLevel'],
  //               };
  //             })
  //             .toList()
  //             .reversed
  //             .toList(); // Biar urut dari lama ke baru

  //         return Column(
  //           children: [
  //             Expanded(
  //               flex: 2,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: SensorChart(dataList: dataList),
  //               ),
  //             ),
  //             Expanded(
  //               flex: 3,
  //               child: ListView.builder(
  //                 itemCount: dataList.length,
  //                 itemBuilder: (context, index) {
  //                   final item = dataList[index];
  //                   return ListTile(
  //                     title: Text(item['timestamp']),
  //                     subtitle: Text(
  //                         "Temp: ${item['temperature']}°C | Humidity: ${item['humidity']} | Water: ${item['water']}"),
  //                   );
  //                 },
  //               ),
  //             )
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }
}

class SensorChart extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;

  const SensorChart({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= dataList.length)
                  return const SizedBox();
                return Text(dataList[index]['timestamp']
                    .toString()
                    .substring(11)); // jam
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
                dataList.length,
                (i) => FlSpot(i.toDouble(),
                    (dataList[i]['temperature'] as num).toDouble())),
            isCurved: true,
            color: Colors.red,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: List.generate(
                dataList.length,
                (i) => FlSpot(
                    i.toDouble(), (dataList[i]['humidity'] as num).toDouble())),
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
