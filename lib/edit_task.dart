// ✅ Trang sửa Task giống AddWorkPage, có lưu và quay lại Home
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import '../tolist_model.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  final bool isDarkMode;
  final Realm realm;

  const EditTaskPage({
    super.key,
    required this.task,
    required this.isDarkMode,
    required this.realm,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  Color getTextColor() {
    return widget.isDarkMode ? Colors.white : Colors.black;
  }

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDeadline;
  late TimeOfDay? _selectedTime;
  late String _priority;
  late String _category;
  late bool _reminder;
  late bool _isPinned;

  final Color pastelBlue = const Color.fromARGB(255, 153, 214, 255);
  final List<String> _categories = [
    'Cá nhân',
    'Công việc',
    'Gia đình',
    'Học tập',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _selectedDeadline = widget.task.deadline;
    _selectedTime = TimeOfDay.fromDateTime(widget.task.deadline);
    _priority = widget.task.priority;
    _category = widget.task.category;
    _reminder = false;
    _isPinned = widget.task.isPinned;
  }

  void _saveTask() {
    widget.realm.write(() {
      widget.task.title = _titleController.text;
      widget.task.description = _descController.text;
      widget.task.deadline = DateTime(
        _selectedDeadline.year,
        _selectedDeadline.month,
        _selectedDeadline.day,
        _selectedTime?.hour ?? 0,
        _selectedTime?.minute ?? 0,
      );
      widget.task.priority = _priority;
      widget.task.category = _category;
      widget.task.isPinned = _isPinned;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Sửa Công Việc', style: TextStyle(color: getTextColor())),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: getTextColor()),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isDarkMode
                    ? [Color(0xFF2E294E), Color(0xFF1B1B3A)]
                    : [Color(0xFFD8B4FE), Color(0xFFFFC2D1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề',
                    labelStyle: TextStyle(color: getTextColor()),
                  ),
                  style: TextStyle(color: getTextColor()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Mô tả',
                    labelStyle: TextStyle(color: getTextColor()),
                  ),
                  style: TextStyle(color: getTextColor()),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Ngày đến hạn:', style: TextStyle(color: getTextColor())),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDeadline,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDeadline = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.date_range,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Thời gian:', style: TextStyle(color: getTextColor())),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime ?? TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedTime = picked;
                          });
                        }
                      },
                      child: Text(
                        _selectedTime?.format(context) ?? 'Chọn giờ',
                        style: TextStyle(color: getTextColor()),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: InputDecoration(
                    labelText: 'Mức độ ưu tiên',
                    labelStyle: TextStyle(color: getTextColor()),
                  ),
                  dropdownColor: widget.isDarkMode ? Colors.grey[850] : null,
                  style: TextStyle(color: getTextColor()),
                  items: ['Cao', 'Trung bình', 'Thấp']
                      .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level, style: TextStyle(color: getTextColor()))))
                      .toList(),
                  onChanged: (value) => setState(() => _priority = value!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(
                    labelText: 'Danh mục',
                    labelStyle: TextStyle(color: getTextColor()),
                  ),
                  dropdownColor: widget.isDarkMode ? Colors.grey[850] : null,
                  style: TextStyle(color: getTextColor()),
                  items: _categories
                      .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat, style: TextStyle(color: getTextColor()))))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _reminder,
                  onChanged: (value) => setState(() => _reminder = value),
                  title: Text('Nhắc nhở', style: TextStyle(color: getTextColor())),
                ),
                SwitchListTile(
                  value: _isPinned,
                  onChanged: (value) => setState(() => _isPinned = value),
                  title: Text('Ghim công việc', style: TextStyle(color: getTextColor())),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                  'Lưu công việc',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, 
                  ),
                ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
