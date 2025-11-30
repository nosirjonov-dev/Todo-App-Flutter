import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/todo_item.dart';
import 'home_page.dart';

class MediaQueryOverride extends StatelessWidget {
  final Widget child;

  const MediaQueryOverride({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // Web xatosi uchun boldText override ni bloklaymiz
    return MediaQuery(
      data: mq.copyWith(boldText: false),
      child: child,
    );
  }
}

class StatsPage extends StatelessWidget {
  final List<TodoItem> tasks;

  const StatsPage({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.isDone).length;
    final pending = total - completed;

    final workCount = tasks.where((t) => t.category == "Work").length;
    final studyCount = tasks.where((t) => t.category == "Study").length;
    final homeCount = tasks.where((t) => t.category == "Home").length;

    return MediaQueryOverride(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Statistics"),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSummaryCard(total, completed, pending),
            const SizedBox(height: 20),
            _buildPieChart(completed, pending),
            const SizedBox(height: 30),
            _buildCategoryBarChart(workCount, studyCount, homeCount),
          ],
        ),
      ),
    );
  }

  // Summary Card
  Widget _buildSummaryCard(int total, int complete, int pending) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem("Total", total, Colors.blue),
            _statItem("Done", complete, Colors.green),
            _statItem("Pending", pending, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }

  // Pie Chart
  Widget _buildPieChart(int done, int pending) {
    return Column(
      children: [
        const Text(
          "Completion Chart",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 40,
              sectionsSpace: 3,
              sections: [
                PieChartSectionData(
                  value: done.toDouble(),
                  title: done == 0 ? "" : "$done",
                  color: Colors.green,
                  radius: 60,
                ),
                PieChartSectionData(
                  value: pending.toDouble(),
                  title: pending == 0 ? "" : "$pending",
                  color: Colors.orange,
                  radius: 60,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Categories Bar Chart
  Widget _buildCategoryBarChart(int w, int s, int h) {
    return Column(
      children: [
        const Text(
          "Tasks by Category",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text("Work");
                        case 1:
                          return const Text("Study");
                        case 2:
                          return const Text("Home");
                      }
                      return const Text("");
                    },
                  ),
                ),
              ),
              barGroups: [
                _barGroup(0, w, Colors.blue),
                _barGroup(1, s, Colors.green),
                _barGroup(2, h, Colors.orange),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _barGroup(int x, int value, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value.toDouble(),
          color: color,
          width: 26,
          borderRadius: BorderRadius.circular(6),
        )
      ],
    );
  }
}
