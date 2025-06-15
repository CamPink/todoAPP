// ✅ Trang thêm Task theo pastel UI giống EditTaskPage với gradient
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tolist_model.dart';

class AddWorkPage extends StatefulWidget {
  final bool isDarkMode;
  final String userEmail;

  const AddWorkPage({
    super.key,
    required this.userEmail,
    this.isDarkMode = false,
  });

  @override
  State<AddWorkPage> createState() => _AddWorkPageState();
}

class _AddWorkPageState extends State<AddWorkPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  TimeOfDay? _selectedTime;
  DateTime _selectedDeadline = DateTime.now();
  String _priority = 'Trung bình';
  String _category = 'Cá nhân';
  bool _reminder = false;
  bool _isPinned = false;

  late Realm realm;

  @override
  void initState() {
    super.initState();
    realm = Realm(Configuration.local([Task.schema]));
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : const Color(0xFF5C5470);
    final inputFillColor = widget.isDarkMode ? const Color(0xFF3A2D63) : const Color(0xFFECECF9);
    final buttonColor = widget.isDarkMode ? const Color(0xFF6A1B9A) : const Color(0xFF8E24AA);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: widget.isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF1B1A2F), Color(0xFF40336B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFFFFBFE), Color(0xFFFFEAF4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: textColor,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Thêm Công Việc",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField("Tiêu đề", _titleController, textColor, inputFillColor),
                const SizedBox(height: 16),
                _buildTextField("Mô tả", _descController, textColor, inputFillColor, maxLines: 3),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    _selectedTime != null
                        ? 'Thời gian: ${_selectedTime!.format(context)}'
                        : 'Chọn thời gian',
                    style: GoogleFonts.poppins(color: textColor),
                  ),
                  trailing: Icon(Icons.access_time, color: buttonColor),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedTime = picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    'Deadline: ${DateFormat('dd/MM/yyyy').format(_selectedDeadline)}',
                    style: GoogleFonts.poppins(color: textColor),
                  ),
                  trailing: Icon(Icons.calendar_today, color: buttonColor),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDeadline,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDeadline = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          23,
                          59,
                          59,
                        );
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown("Mức độ ưu tiên", _priority, ['Cao', 'Trung bình', 'Thấp'],
                    (val) => setState(() => _priority = val!), textColor, inputFillColor),
                const SizedBox(height: 16),
                _buildDropdown("Danh mục", _category,
                    ['Cá nhân', 'Công việc', 'Gia đình', 'Học tập', 'Việc làm', 'Trò chơi', 'Khác'],
                    (val) => setState(() => _category = val!), textColor, inputFillColor),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text("Nhắc nhở", style: GoogleFonts.poppins(color: textColor)),
                  value: _reminder,
                  activeColor: buttonColor,
                  onChanged: (val) => setState(() => _reminder = val),
                ),
                CheckboxListTile(
                  value: _isPinned,
                  onChanged: (val) => setState(() => _isPinned = val!),
                  activeColor: buttonColor,
                  title: Text("Ghim công việc", style: GoogleFonts.poppins(color: textColor)),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _saveTask,
                    icon: const Icon(Icons.save),
                    label: Text("Lưu Công Việc", style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Color textColor,
    Color fillColor, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(color: textColor),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: textColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: fillColor,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
    Color textColor,
    Color fillColor,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      style: GoogleFonts.poppins(color: textColor),
      dropdownColor: fillColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: textColor),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: options
          .map((opt) => DropdownMenuItem(
                value: opt,
                child: Text(opt, style: GoogleFonts.poppins(color: textColor)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập tiêu đề')));
      return;
    }

    final reminderTimeStr = (_reminder && _selectedTime != null)
        ? _selectedTime!.format(context)
        : null;

    realm.write(() {
      final task = Task(
        ObjectId(),
        title,
        desc,
        _selectedDeadline,
        _priority,
        _category,
        false,
        _isPinned,
        widget.userEmail,
        false,
        DateTime.now().toUtc().add(const Duration(hours: 7)),
        reminderTime: reminderTimeStr,
        updatedAt: null,
        repeat: null,
      );
      realm.add(task);
    });

    Navigator.pop(context, true);
  }
}
