import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:word_learner/services/word_service.dart';
import 'package:word_learner/models/word.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wordService = WordService();

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: FutureBuilder<List<Word>>(
        future: wordService.getWords(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final words = snapshot.data!;
          final total = words.length;
          final newWords = words.where((w) => w.status == 'New').length;
          final inProgress = words.where((w) => w.status == 'In Progress').length;
          final learned = words.where((w) => w.status == 'Learned').length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: newWords.toDouble(),
                          color: Colors.yellow,
                          title: 'New: $newWords',
                          radius: 80,
                          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        PieChartSectionData(
                          value: inProgress.toDouble(),
                          color: Colors.orange,
                          title: 'In Progress: $inProgress',
                          radius: 80,
                          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        PieChartSectionData(
                          value: learned.toDouble(),
                          color: Colors.green,
                          title: 'Learned: $learned',
                          radius: 80,
                          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.numbers, color: Colors.blue),
                    title: Text('Total Words: $total', style: const TextStyle(fontSize: 18)),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.done_all, color: Colors.green),
                    title: Text('Learned: $learned', style: const TextStyle(fontSize: 18)),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.hourglass_bottom, color: Colors.orange),
                    title: Text('In Progress: $inProgress', style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}