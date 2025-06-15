import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:todoapp/tolist_model.dart';
import 'package:todoapp/edit_task.dart';

class AllTaskPage extends StatefulWidget {
  final List<Task> tasks;
  final bool isDarkMode;
  final void Function(Task) onDelete;
  final Realm realm;

  const AllTaskPage({
    super.key,
    required this.tasks,
    required this.isDarkMode,
    required this.onDelete,
    required this.realm,
  });

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  String searchQuery = '';
  String? selectedCategory;
  DateTime? selectedDate;
  final Map<String, bool> _expandedTiles = {};
  final Map<String, int> priorityOrder = {'Cao': 1, 'Trung bình': 2, 'Thấp': 3};

  Map<String, List<Task>> get groupedTasksByDate {
    List<Task> filtered = List.from(widget.tasks);
    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (task) => task.title.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }
    if (selectedCategory != null && selectedCategory != 'Tất cả') {
      filtered =
          filtered.where((task) => task.category == selectedCategory).toList();
    }
    if (selectedDate != null) {
      filtered =
          filtered
              .where(
                (task) =>
                    task.deadline.year == selectedDate!.year &&
                    task.deadline.month == selectedDate!.month &&
                    task.deadline.day == selectedDate!.day,
              )
              .toList();
    }
    filtered.sort(
      (a, b) => (priorityOrder[a.priority] ?? 999).compareTo(
        priorityOrder[b.priority] ?? 999,
      ),
    );

    Map<String, List<Task>> grouped = {};
    for (var task in filtered) {
      String dateKey = DateFormat('dd/MM/yyyy').format(task.deadline);
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(task);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final bgGradient =
        widget.isDarkMode
            ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2E294E), Color(0xFF3B3355), Color(0xFF1B1B3A)],
            )
            : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFD8B4FE), Color(0xFFFFC2D1)],
            );

    final textColor =
        widget.isDarkMode ? Colors.white : const Color(0xFF5C5470);
    final sortedEntries =
        groupedTasksByDate.entries.toList()..sort(
          (a, b) => DateFormat(
            'dd/MM/yyyy',
          ).parse(a.key).compareTo(DateFormat('dd/MM/yyyy').parse(b.key)),
        );

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: bgGradient)),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(textColor),
                _buildFilters(textColor),
                Expanded(
                  child:
                      groupedTasksByDate.isEmpty
                          ? Center(
                            child: Text(
                              "Không có công việc phù hợp.",
                              style: TextStyle(color: textColor),
                            ),
                          )
                          : ListView(
                            padding: const EdgeInsets.all(16),
                            children:
                                sortedEntries.map((entry) {
                                  final date = entry.key;
                                  final tasks = entry.value;
                                  _expandedTiles.putIfAbsent(date, () => false);
                                  return _buildDateGroup(
                                    date,
                                    tasks,
                                    textColor,
                                  );
                                }).toList(),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Color textColor) => Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.west_rounded, color: Color(0xFFE91E63)),
          onPressed: () => Navigator.pop(context, true),
        ),
        Expanded(
          child: Text(
            'Tất Cả Công Việc',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    ),
  );

  Widget _buildFilters(Color textColor) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Tìm công việc...',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFFFF80AB),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(color: Colors.pinkAccent, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide(color: Colors.pink, width: 2),
            ),
          ),
          onChanged: (value) => setState(() => searchQuery = value),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.local_florist, size: 18, color: Color(0xFFF48FB1)),
            const SizedBox(width: 8),
            const Text(
              "Danh mục:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.pinkAccent, width: 1),
              ),
              child: Center(
                child: DropdownButton<String>(
                  isDense: true,
                  alignment: Alignment.center,
                  iconSize: 18,
                  underline: const SizedBox(),
                  dropdownColor: Colors.white,
                  iconEnabledColor: Colors.pinkAccent,
                  value: selectedCategory ?? 'Tất cả',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  items:
                      [
                            'Tất cả',
                            'Cá nhân',
                            'Công việc',
                            'Gia đình',
                            'Học tập',
                            'Việc làm',
                            'Trò chơi',
                            'Khác',
                          ]
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(
                        () =>
                            selectedCategory = value == 'Tất cả' ? null : value,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month,
              size: 18,
              color: Color(0xFFF06292),
            ),
            const SizedBox(width: 8),
            Text(
              selectedDate == null
                  ? 'Lọc theo ngày: Tất cả'
                  : 'Ngày: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: const Icon(
              Icons.date_range,
              color: Colors.white,
              size: 24,
            ),
            ),
            if (selectedDate != null)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: () => setState(() => selectedDate = null),
              ),
          ],
        ),
      ),
    ],
  );

  Widget _buildDateGroup(String date, List<Task> tasks, Color textColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 4,
      color: Color(0xFFF06292),
      child: ExpansionTile(
        initiallyExpanded: _expandedTiles[date]!,
        onExpansionChanged:
            (expanded) => setState(() => _expandedTiles[date] = expanded),
        title: Text(
          '🗓 $date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        children: tasks.map((task) => _buildTaskCard(task, textColor)).toList(),
      ),
    );
  }

  Widget _buildTaskCard(Task task, Color textColor) {
    return GestureDetector(
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => EditTaskPage(
                  task: task,
                  isDarkMode: widget.isDarkMode,
                  realm: widget.realm,
                ),
          ),
        );
        if (updated == true) setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              task.isCompleted
                  ? const Color(0xFFFFE4EC)
                  : (widget.isDarkMode
                      ? const Color(0xFF3A2D63)
                      : const Color(0xFFFFFBFE)),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.pink.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite_border, color: Color(0xFFF06292)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      decoration:
                          task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  onChanged:
                      (value) => setState(
                        () => widget.realm.write(() {
                          task.isCompleted = value!;
                          task.updatedAt = DateTime.now();
                        }),
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("Xác nhận xoá"),
                            content: const Text(
                              "Bạn có chắc chắn muốn xoá công việc này không?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Huỷ"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Xoá",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) widget.onDelete(task);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (task.description.isNotEmpty)
              Text(task.description, style: TextStyle(color: textColor)),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Color(0xFFBA68C8),
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('HH:mm').format(task.deadline),
                  style: TextStyle(color: textColor),
                ),
                const Spacer(),
                const Icon(Icons.local_florist, size: 16),
                const SizedBox(width: 4),
                Text(task.category, style: TextStyle(color: textColor)),
              ],
            ),
            if (task.reminderTime != null && task.reminderTime!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: const [
                    Icon(
                      Icons.notifications_rounded,
                      size: 16,
                      color: Color(0xFFE57373),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Đã bật nhắc nhở",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
