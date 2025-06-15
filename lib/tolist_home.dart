// ✅ Giao diện pastel dễ thương + Giữ nguyên logic gốc của Chiến sĩ Cam
// ✅ Khôi phục: navigation, pinned, chọn ngày, tất cả task, xoá/sửa/darkmode... đầy đủ!
// ✅ Áp dụng: pastel sáng/tối, gradient nền, font Poppins, thẻ task bo tròn
// 👉 Tự tin chạy tốt và đẹp!

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/tolist_statistical.dart';
import 'dart:math';

import 'tolist_model.dart';
import 'add_work.dart';
import 'edit_task.dart';
import 'all_task.dart';
import 'tolist_calender.dart';
import 'tolist_account.dart';

class HomePage extends StatefulWidget {
  final UserProfile userProfile;
  const HomePage({super.key, required this.userProfile});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  late AnimationController _meteorController;
  late Realm realm;
  late List<Task> allTasks;
  DateTime selectedDate = DateTime.now();

  final Color highlightColor = const Color(0xFFFFA726);

  @override
  void initState() {
    super.initState();
    _meteorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    realm = Realm(Configuration.local([Task.schema]));
    _loadTasks();
  }

  void _loadTasks() {
    allTasks =
        realm
            .all<Task>()
            .where(
              (t) => t.userEmail == widget.userProfile.email && !t.isDeleted,
            )
            .toList();
  }

  void _deleteTask(Task task) {
    realm.write(() => realm.delete(task));
    setState(() => _loadTasks());
  }

  @override
  void dispose() {
    _meteorController.dispose();
    realm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyTasks =
        allTasks.where((task) {
          final d = task.deadline;
          return d.year == selectedDate.year &&
              d.month == selectedDate.month &&
              d.day == selectedDate.day;
        }).toList();

    final gradientColors =
        isDarkMode
            ? [Color(0xFF2E294E), Color(0xFF1B1B3A)]
            : [Color(0xFFD8B4FE), Color(0xFFFFC2D1)];
    final taskCardColor = isDarkMode ? Color(0xFF3A2D63) : Color(0xFFFFFBFE);
    final taskTextColor = isDarkMode ? Colors.white : Color(0xFF5C5470);
    final fabColor = isDarkMode ? Color(0xFFF48FB1) : Color(0xFFFFB5C5);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: fabColor,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddWorkPage(
                    isDarkMode: isDarkMode,
                    userEmail: widget.userProfile.email,
                  ),
            ),
          );
          if (result == true) {
            await Future.delayed(const Duration(milliseconds: 100));
            setState(() {
              _loadTasks();
              selectedDate = DateTime.now();
            });
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: fabColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
        onTap: (index) async {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        CalendarPage(tasks: allTasks, isDarkMode: isDarkMode,),
              ),
            );
          }
          if (index == 2) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AllTaskPage(
                      tasks: allTasks,
                      isDarkMode: isDarkMode,
                      onDelete: (task) {
                        _deleteTask(task);
                        Navigator.pop(context, true);
                      },
                      realm: realm,
                    ),
              ),
            );
            if (result == true) {
              setState(() => _loadTasks());
            }
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => StatisticalPage(
                      isDarkMode: isDarkMode,
                      userEmail: widget.userProfile.email,
                      allTasks: allTasks,
                    ),
              ),
            );
          }

          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AccountPage(
                      userEmail: widget.userProfile.email,
                      isDarkMode: isDarkMode,
                    ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistical',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
      body: Stack(
        children: [
          Stack(
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
              if (!isDarkMode) Positioned.fill(child: CloudBackground()),
            ],
          ),
          if (isDarkMode) ...[
            Positioned(
              top: 20,
              right: 20,
              child: SizedBox(width: 60, height: 60),
            ),
            Positioned.fill(child: StarBackground()),
            AnimatedBuilder(
              animation: _meteorController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MeteorPainter(_meteorController.value),
                  child: Container(),
                );
              },
            ),
          ],
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        ),
                        color: taskTextColor,
                        onPressed:
                            () => setState(() => isDarkMode = !isDarkMode),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hello ${widget.userProfile.name} 👋',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: taskTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          allTasks.where((t) => t.isPinned).map((task) {
                            return Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: fabColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      realm.write(() {
                                        task.isPinned = !task.isPinned;
                                        task.updatedAt = DateTime.now();
                                      });
                                      setState(() => _loadTasks());
                                    },
                                    child: Icon(
                                      task.isPinned
                                          ? Icons.push_pin
                                          : Icons.push_pin_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    task.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    task.reminderTime ??
                                        DateFormat(
                                          'HH:mm',
                                        ).format(task.deadline),
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final current = DateTime.now().add(Duration(days: index));
                      final weekday =
                          DateFormat('EEE').format(current).toUpperCase();
                      final day = DateFormat('dd').format(current);
                      final hasTask = allTasks.any(
                        (task) =>
                            task.deadline.year == current.year &&
                            task.deadline.month == current.month &&
                            task.deadline.day == current.day,
                      );
                      return GestureDetector(
                        onTap: () => setState(() => selectedDate = current),
                        child: Container(
                          width: 55,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: hasTask ? highlightColor : fabColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                weekday,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                day,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Today's Tasks",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: taskTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...dailyTasks.map(
                    (task) => Dismissible(
                      key: Key(task.id.toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        _deleteTask(task);
                        return true;
                      },
                      child: GestureDetector(
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditTaskPage(
                                    task: task,
                                    isDarkMode: isDarkMode,
                                    realm: realm,
                                  ),
                            ),
                          );
                          if (updated == true) {
                            setState(() => _loadTasks());
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: taskCardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6),
                            ],
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    realm.write(() {
                                      task.isCompleted = value!;
                                      task.updatedAt = DateTime.now();
                                    });
                                    _loadTasks();
                                  });
                                },
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: GoogleFonts.poppins(
                                        color: taskTextColor,
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                            task.isCompleted
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      task.reminderTime ??
                                          DateFormat(
                                            'HH:mm',
                                          ).format(task.deadline),
                                      style: TextStyle(
                                        color: taskTextColor.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CloudBackground extends StatefulWidget {
  @override
  _CloudBackgroundState createState() => _CloudBackgroundState();
}

class _CloudBackgroundState extends State<CloudBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _cloudController;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cloudController,
      builder: (context, child) {
        return CustomPaint(painter: CloudPainter(_cloudController.value));
      },
    );
  }
}

class CloudPainter extends CustomPainter {
  final double progress;
  CloudPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);
    final cloudPath =
        Path()
          ..addOval(
            Rect.fromCircle(
              center: Offset(size.width * progress, 100),
              radius: 30,
            ),
          )
          ..addOval(
            Rect.fromCircle(
              center: Offset(size.width * progress + 40, 100),
              radius: 40,
            ),
          )
          ..addOval(
            Rect.fromCircle(
              center: Offset(size.width * progress + 80, 100),
              radius: 30,
            ),
          );
    canvas.drawPath(cloudPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StarBackground extends StatefulWidget {
  @override
  _StarBackgroundState createState() => _StarBackgroundState();
}

class _StarBackgroundState extends State<StarBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(painter: StarPainter(_controller.value));
      },
    );
  }
}

class StarPainter extends CustomPainter {
  final double progress;
  StarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..color = Colors.white.withOpacity(0.8);
    final rand = Random(123);
    for (int i = 0; i < 50; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height * 0.4;
      final radius = rand.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MeteorPainter extends CustomPainter {
  final double progress;
  MeteorPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Colors.white70, Colors.transparent],
          ).createShader(const Rect.fromLTWH(0, 0, 100, 100))
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    // Bay ngang trái -> phải
    final dx = size.width * (1 - progress); // di chuyển từ phải sang trái
    final dy = size.height * 0.2; // cao khoảng 20% màn

    canvas.drawLine(Offset(dx, dy), Offset(dx - 40, dy + 10), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
