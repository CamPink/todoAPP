import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tolist_model.dart';

class CalendarPage extends StatefulWidget {
  final List<Task> tasks;
  final bool isDarkMode;

  const CalendarPage({
    super.key,
    required this.tasks,
    required this.isDarkMode,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  List<Task> getTasksForDay(DateTime day) {
    return widget.tasks.where((task) => isSameDay(task.deadline, day)).toList();
  }

  String getPriorityForDay(DateTime day) {
    final todayTasks = getTasksForDay(day);
    if (todayTasks.any((t) => t.priority == 'Cao')) return 'high';
    if (todayTasks.any((t) => t.priority == 'Trung bình')) return 'medium';
    if (todayTasks.any((t) => t.priority == 'Thấp')) return 'low';
    return '';
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return const Color.fromARGB(255, 61, 213, 53);
      case 'low':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    int year = selectedDate.year;
    int month = selectedDate.month;
    int daysInMonth = DateUtils.getDaysInMonth(year, month);
    int startWeekday = DateTime(year, month, 1).weekday;

    List<Widget> dayWidgets = [];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    dayWidgets.addAll(weekdays.map(
      (day) => Center(
        child: Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ));

    for (int i = 1; i < startWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(year, month, day);
      String priority = getPriorityForDay(date);

      bool isToday = isSameDay(date, DateTime.now());
      bool isSelected = isSameDay(date, selectedDate);

      dayWidgets.add(
        GestureDetector(
          onTap: () => setState(() => selectedDate = date),
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blueAccent
                  : Colors.white.withOpacity(0.85), // Nền trắng mờ dễ nhìn
              borderRadius: BorderRadius.circular(12),
              border: isToday
                ? Border.all(color: Colors.deepPurple, width: 2)
                : getTasksForDay(date).isNotEmpty
                    ? Border.all(color: const Color.fromARGB(255, 231, 46, 46), width: 1.5) // Ngày có task
                    : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87, // Chữ đen rõ ràng
                ),
              ),
            ),
          ),
        ),
      );
    }

    List<Task> selectedTasks = getTasksForDay(selectedDate);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDarkMode
                ? [Color(0xFF2E294E), Color(0xFF1B1B3A)]
                : [Color(0xFFD8B4FE),Color(0xFFFFC2D1) ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0,
                title: Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: dayWidgets,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "📅 ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: selectedTasks.isEmpty
                    ? const Center(
                        child: Text(
                          "Không có công việc",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: selectedTasks.length,
                        itemBuilder: (context, index) {
                          final task = selectedTasks[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.task_alt, color: getPriorityColor(task.priority)),
                              title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                DateFormat('HH:mm').format(task.deadline),
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
