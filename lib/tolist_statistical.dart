// 🎨 StatisticalPage - kế thừa chế độ sáng/tối từ HomePage, không đổi theme nội bộ
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import 'package:todoapp/tolist_model.dart';

class StatisticalPage extends StatefulWidget {
  final List<Task> allTasks;
  final bool isDarkMode;
  final String userEmail;

  const StatisticalPage({
    super.key,
    required this.allTasks,
    required this.isDarkMode,
    required this.userEmail,
  });

  @override
  State<StatisticalPage> createState() => _StatisticalPageState();
}

class _StatisticalPageState extends State<StatisticalPage>
    with SingleTickerProviderStateMixin {
  int selectedMonth = DateTime.now().month;
  late AnimationController _meteorController;

  @override
  void initState() {
    super.initState();
    _meteorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _meteorController.dispose();
    super.dispose();
  }

  final pastelColors = [
    Color(0xFFB5EAEA),
    Color(0xFFFFD6E0),
    Color(0xFFFFF5BA),
    Color(0xFFD5AAFF),
    Color(0xFFFFB5B5),
    Color(0xFFC1FFD7),
  ];

  List<PieChartSectionData> _getPieSections() {
    final tasksInMonth =
        widget.allTasks
            .where(
              (task) =>
                  task.deadline.month == selectedMonth &&
                  task.deadline.year == DateTime.now().year,
            )
            .toList();

    final completedTasks =
        tasksInMonth.where((task) => task.isCompleted).toList();
    final uncompletedCount = tasksInMonth.length - completedTasks.length;

    final categoryCounts = <String, int>{};
    for (var task in completedTasks) {
      categoryCounts[task.category] = (categoryCounts[task.category] ?? 0) + 1;
    }

    final total = tasksInMonth.length;
    final List<PieChartSectionData> sections = [];
    int index = 0;
    categoryCounts.forEach((category, count) {
      final percent = (count / total) * 100;
      sections.add(
        PieChartSectionData(
          value: percent,
          title: "$category\n${percent.toStringAsFixed(1)}%",
          color: pastelColors[index++ % pastelColors.length],
          radius: 70,
          titleStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      );
    });

    if (uncompletedCount > 0) {
      final percent = (uncompletedCount / total) * 100;
      sections.add(
        PieChartSectionData(
          value: percent,
          title: "Chưa hoàn thành\n${percent.toStringAsFixed(1)}%",
          color: Colors.grey.shade300,
          radius: 70,
          titleStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return sections;
  }

  List<BarChartGroupData> _getMonthlyBarData({required bool completed}) {
    return List.generate(12, (i) {
      final count =
          widget.allTasks
              .where(
                (task) =>
                    task.deadline.month == (i + 1) &&
                    task.deadline.year == DateTime.now().year &&
                    task.isCompleted == completed,
              )
              .length;

      return BarChartGroupData(
        x: i + 1,
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            color: completed ? pastelColors[0] : pastelColors[1],
            width: 14,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });
  }

  List<FlSpot> _getLineSpots({required bool completed}) {
    return List.generate(12, (i) {
      final count =
          widget.allTasks
              .where(
                (task) =>
                    task.deadline.month == (i + 1) &&
                    task.deadline.year == DateTime.now().year &&
                    task.isCompleted == completed,
              )
              .length;
      return FlSpot(i + 1.0, count.toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors =
        widget.isDarkMode
            ? [Color(0xFF2E294E), Color(0xFF1B1B3A)]
            : [Color(0xFFD8B4FE), Color(0xFFFFC2D1)];
    final textColor = widget.isDarkMode ? Colors.white : Color(0xFF5C5470);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Thống kê', style: GoogleFonts.poppins(color: textColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
          ),
          if (!widget.isDarkMode) Positioned.fill(child: CloudBackground()),
          if (widget.isDarkMode) Positioned.fill(child: StarBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "📊 Thống kê công việc",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.date_range, color: textColor),
                      const SizedBox(width: 8),
                      Text(
                        "Chọn tháng:",
                        style: GoogleFonts.poppins(color: textColor),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: selectedMonth,
                        dropdownColor:
                            widget.isDarkMode ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        style: GoogleFonts.poppins(color: textColor),
                        items: List.generate(12, (index) {
                          final isFirstMonth = index == 0;
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text(
                              "Tháng ${index + 1}",
                              style: GoogleFonts.poppins(
                                color: isFirstMonth ? Colors.black : textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                        onChanged: (value) {
                          setState(() => selectedMonth = value!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...[
                    "Tỷ lệ hoàn thành theo danh mục",
                    "Tổng công việc hoàn thành theo tháng",
                    "Tổng công việc chưa hoàn thành theo tháng",
                    "So sánh theo tháng (Đường biểu diễn)",
                  ].asMap().entries.map((entry) {
                    final index = entry.key;
                    final title = entry.value;
                    final Widget chart;
                    switch (index) {
                      case 0:
                        chart = SizedBox(
                          height: 250,
                          child: PieChart(
                            PieChartData(
                              sections: _getPieSections(),
                              centerSpaceRadius: 40,
                            ),
                          ),
                        );
                        break;
                      case 1:
                        chart = SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              barGroups: _getMonthlyBarData(completed: true),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget:
                                        (value, _) => Text(
                                          '${value.toInt()}',
                                          style: GoogleFonts.poppins(
                                            color: textColor,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        break;
                      case 2:
                        chart = SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              barGroups: _getMonthlyBarData(completed: false),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget:
                                        (value, _) => Text(
                                          '${value.toInt()}',
                                          style: GoogleFonts.poppins(
                                            color: textColor,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        break;
                      default:
                        chart = SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _getLineSpots(completed: true),
                                  color: pastelColors[0],
                                  isCurved: true,
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                ),
                                LineChartBarData(
                                  spots: _getLineSpots(completed: false),
                                  color: pastelColors[1],
                                  isCurved: true,
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                ),
                              ],
                              borderData: FlBorderData(show: true),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget:
                                        (value, _) => Text(
                                          '${value.toInt()}',
                                          style: GoogleFonts.poppins(
                                            color: textColor,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        chart,
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CloudBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: CloudPainter());
  }
}

class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);
    final cloudPath =
        Path()
          ..addOval(Rect.fromCircle(center: Offset(100, 100), radius: 30))
          ..addOval(Rect.fromCircle(center: Offset(140, 100), radius: 40))
          ..addOval(Rect.fromCircle(center: Offset(180, 100), radius: 30));
    canvas.drawPath(cloudPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class StarBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: StarPainter());
  }
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);
    final rand = Random(42);
    for (int i = 0; i < 50; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height * 0.4;
      final radius = rand.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
