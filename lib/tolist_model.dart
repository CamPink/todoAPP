import 'package:realm/realm.dart';
part 'tolist_model.realm.dart'; // ⚠️ Chạy: flutter pub run realm generate

// =========================
// 👤 UserProfile Model
// =========================
@RealmModel()
class _UserProfile {
  @PrimaryKey()
  late String email;

  late String name;
  late String avatar;
  late bool isDarkMode;
  late String mood; // ví dụ: happy, sad, neutral

  // ➕ Trường mở rộng
  late DateTime createdAt;
  late DateTime? lastLogin;
  late String? password; // nếu không dùng Firebase
}

// =========================
// ✅ Task Model
// =========================
@RealmModel()
class _Task {
  @PrimaryKey()
  late ObjectId id;

  // Nội dung task
  late String title;
  late String description;
  late DateTime deadline;
  late String priority; // High, Normal, Low
  late String category; // tên danh mục
  late bool isCompleted;
  late bool isPinned;
  late String? reminderTime; // định dạng: '2025-04-18T08:00:00'
  late DateTime? reminderDateTime;

  // ➕ Trường mở rộng
  late String userEmail; // Gắn với UserProfile
  late bool isDeleted;
  late DateTime createdAt;
  late DateTime? updatedAt;
  late String? repeat; // daily, weekly, none...
}

// =========================
// 🔥 Streak Model
// =========================
@RealmModel()
class _Streak {
  @PrimaryKey()
  late ObjectId id;

  late DateTime date;
  late bool allTasksCompleted;

  // ➕ Trường mở rộng
  late String userEmail;
  late int streakCount; // số ngày streak liên tục
  late String? note; // nhật ký/cảm xúc khi hoàn thành task
}

// =========================
// 🗂 Category Model
// =========================
@RealmModel()
class _Category {
  @PrimaryKey()
  late ObjectId id; // 🔑 Đảm bảo không bị trùng khi tên giống nhau

  late String name; // ví dụ: Design, Learning
  late String iconName; // ví dụ: brush, school
  late String colorHex; // ví dụ: #FF4081
  late String userEmail; // ➕ gắn với người dùng
}
