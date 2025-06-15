// AccountPage with improved UI design, pastel gradient background, and Poppins font
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tolist_model.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  final String userEmail;
  final bool isDarkMode;

  const AccountPage({super.key, required this.userEmail, required this.isDarkMode});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Realm realm;
  UserProfile? user;

  @override
  void initState() {
    super.initState();
    realm = Realm(Configuration.local([UserProfile.schema]));
    user = realm.all<UserProfile>().query('email == \$0', [widget.userEmail]).firstOrNull;
  }

  void _editProfile() {
    if (user == null) return;
    final nameController = TextEditingController(text: user!.name);
    final emailController = TextEditingController(text: user!.email);
    final phoneController = TextEditingController(text: user!.avatar);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        title: Text('Cập nhật thông tin', style: GoogleFonts.poppins(color: widget.isDarkMode ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tên')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Số điện thoại')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.red))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              realm.write(() {
                user!.name = nameController.text;
                user!.email = emailController.text;
                user!.avatar = phoneController.text;
              });
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu thông tin')));
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        title: Text('Đổi mật khẩu', style: GoogleFonts.poppins(color: widget.isDarkMode ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldPass, obscureText: true, decoration: const InputDecoration(labelText: 'Mật khẩu cũ')),
            TextField(controller: newPass, obscureText: true, decoration: const InputDecoration(labelText: 'Mật khẩu mới')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.red))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              if (user != null && user!.password == oldPass.text) {
                if (newPass.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu mới ít nhất 6 ký tự')));
                  return;
                }
                realm.write(() => user!.password = newPass.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đổi mật khẩu thành công')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu cũ không đúng')));
              }
            },
            child: const Text('Đổi'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              realm.close();
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 100), () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              });
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const Center(child: CircularProgressIndicator());

    final gradientColors = widget.isDarkMode ? [Color(0xFF2E294E), Color(0xFF1B1B3A)] : [Color(0xFFD8B4FE), Color(0xFFFFC2D1)];
    final textColor = widget.isDarkMode ? Colors.white : Color(0xFF5C5470);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Tài khoản', style: GoogleFonts.poppins(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
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
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              children: [
                Column(
                  children: [
                    CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Icon(Icons.person, size: 50, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Text(user!.name, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 20),
                  ],
                ),
                Divider(color: textColor.withOpacity(0.5)),
                ListTile(
                  leading: Icon(Icons.email, color: textColor),
                  title: Text("Email", style: GoogleFonts.poppins(color: textColor)),
                  subtitle: Text(user!.email, style: GoogleFonts.poppins(color: textColor)),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: textColor),
                  title: Text("Số điện thoại", style: GoogleFonts.poppins(color: textColor)),
                  subtitle: Text(user!.avatar, style: GoogleFonts.poppins(color: textColor)),
                ),
                Divider(color: textColor.withOpacity(0.5)),
                ListTile(
                  leading: Icon(Icons.edit, color: textColor),
                  title: Text("Cập nhật thông tin", style: GoogleFonts.poppins(color: textColor)),
                  onTap: _editProfile,
                ),
                ListTile(
                  leading: Icon(Icons.lock, color: textColor),
                  title: Text("Đổi mật khẩu", style: GoogleFonts.poppins(color: textColor)),
                  onTap: _changePassword,
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.redAccent),
                  title: Text("Đăng xuất", style: GoogleFonts.poppins(color: Colors.redAccent)),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
