import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';

class StatsScreen extends StatelessWidget {
  Future<Map<String, double>> _getWeeklyData() async {
    final diaries = await DatabaseHelper.instance.getAllDiaries();
    Map<String, List<int>> weekGroups = {};

    for (var d in diaries) {
      DateTime dt = DateTime.parse(d.date);
      // Tìm ngày đầu tuần (Thứ 2)
      DateTime monday = dt.subtract(Duration(days: dt.weekday - 1));
      String label = "Tuần ${DateFormat('dd/MM').format(monday)}";
      weekGroups.putIfAbsent(label, () => []).add(d.score);
    }
    return weekGroups.map((k, v) => MapEntry(k, v.reduce((a, b) => a + b) / v.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phân Tích Cảm Xúc")),
      body: FutureBuilder<Map<String, double>>(
        future: _getWeeklyData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var data = snapshot.data!;
          var labels = data.keys.toList().reversed.toList(); // Đảo lại cho đúng thứ tự thời gian

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Biểu đồ mức độ tích cực theo tuần", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: BarChart(
                    BarChartData(
                      maxY: 10,
                      barGroups: List.generate(labels.length, (i) {
                        double avg = data[labels[i]]!;
                        return BarChartGroupData(x: i, barRods: [
                          BarChartRodData(toY: avg, color: avg >= 7 ? Colors.green : Colors.orange, width: 25)
                        ]);
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: labels.length,
                    itemBuilder: (context, i) {
                      double score = data[labels[i]]!;
                      bool isGood = score >= 7;
                      return Card(
                        child: ListTile(
                          leading: Icon(isGood ? Icons.sentiment_very_satisfied : Icons.sentiment_neutral, color: isGood ? Colors.green : Colors.orange),
                          title: Text(labels[i]),
                          subtitle: Text("Điểm trung bình: ${score.toStringAsFixed(1)}"),
                          trailing: Text(isGood ? "TÍCH CỰC" : "CẦN CỐ GẮNG", style: TextStyle(fontWeight: FontWeight.bold, color: isGood ? Colors.green : Colors.orange)),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}