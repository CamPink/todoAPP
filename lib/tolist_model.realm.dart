// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tolist_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class UserProfile extends _UserProfile
    with RealmEntity, RealmObjectBase, RealmObject {
  UserProfile(
    String email,
    String name,
    String avatar,
    bool isDarkMode,
    String mood,
    DateTime createdAt, {
    DateTime? lastLogin,
    String? password,
  }) {
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'avatar', avatar);
    RealmObjectBase.set(this, 'isDarkMode', isDarkMode);
    RealmObjectBase.set(this, 'mood', mood);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'lastLogin', lastLogin);
    RealmObjectBase.set(this, 'password', password);
  }

  UserProfile._();

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get avatar => RealmObjectBase.get<String>(this, 'avatar') as String;
  @override
  set avatar(String value) => RealmObjectBase.set(this, 'avatar', value);

  @override
  bool get isDarkMode => RealmObjectBase.get<bool>(this, 'isDarkMode') as bool;
  @override
  set isDarkMode(bool value) => RealmObjectBase.set(this, 'isDarkMode', value);

  @override
  String get mood => RealmObjectBase.get<String>(this, 'mood') as String;
  @override
  set mood(String value) => RealmObjectBase.set(this, 'mood', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get lastLogin =>
      RealmObjectBase.get<DateTime>(this, 'lastLogin') as DateTime?;
  @override
  set lastLogin(DateTime? value) =>
      RealmObjectBase.set(this, 'lastLogin', value);

  @override
  String? get password =>
      RealmObjectBase.get<String>(this, 'password') as String?;
  @override
  set password(String? value) => RealmObjectBase.set(this, 'password', value);

  @override
  Stream<RealmObjectChanges<UserProfile>> get changes =>
      RealmObjectBase.getChanges<UserProfile>(this);

  @override
  Stream<RealmObjectChanges<UserProfile>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<UserProfile>(this, keyPaths);

  @override
  UserProfile freeze() => RealmObjectBase.freezeObject<UserProfile>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'email': email.toEJson(),
      'name': name.toEJson(),
      'avatar': avatar.toEJson(),
      'isDarkMode': isDarkMode.toEJson(),
      'mood': mood.toEJson(),
      'createdAt': createdAt.toEJson(),
      'lastLogin': lastLogin.toEJson(),
      'password': password.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserProfile value) => value.toEJson();
  static UserProfile _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'email': EJsonValue email,
        'name': EJsonValue name,
        'avatar': EJsonValue avatar,
        'isDarkMode': EJsonValue isDarkMode,
        'mood': EJsonValue mood,
        'createdAt': EJsonValue createdAt,
      } =>
        UserProfile(
          fromEJson(email),
          fromEJson(name),
          fromEJson(avatar),
          fromEJson(isDarkMode),
          fromEJson(mood),
          fromEJson(createdAt),
          lastLogin: fromEJson(ejson['lastLogin']),
          password: fromEJson(ejson['password']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserProfile._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      UserProfile,
      'UserProfile',
      [
        SchemaProperty('email', RealmPropertyType.string, primaryKey: true),
        SchemaProperty('name', RealmPropertyType.string),
        SchemaProperty('avatar', RealmPropertyType.string),
        SchemaProperty('isDarkMode', RealmPropertyType.bool),
        SchemaProperty('mood', RealmPropertyType.string),
        SchemaProperty('createdAt', RealmPropertyType.timestamp),
        SchemaProperty(
          'lastLogin',
          RealmPropertyType.timestamp,
          optional: true,
        ),
        SchemaProperty('password', RealmPropertyType.string, optional: true),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Task extends _Task with RealmEntity, RealmObjectBase, RealmObject {
  Task(
    ObjectId id,
    String title,
    String description,
    DateTime deadline,
    String priority,
    String category,
    bool isCompleted,
    bool isPinned,
    String userEmail,
    bool isDeleted,
    DateTime createdAt, {
    String? reminderTime,
    DateTime? updatedAt,
    String? repeat,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'deadline', deadline);
    RealmObjectBase.set(this, 'priority', priority);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'isCompleted', isCompleted);
    RealmObjectBase.set(this, 'isPinned', isPinned);
    RealmObjectBase.set(this, 'reminderTime', reminderTime);
    RealmObjectBase.set(this, 'userEmail', userEmail);
    RealmObjectBase.set(this, 'isDeleted', isDeleted);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'repeat', repeat);
  }

  Task._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  DateTime get deadline =>
      RealmObjectBase.get<DateTime>(this, 'deadline') as DateTime;
  @override
  set deadline(DateTime value) => RealmObjectBase.set(this, 'deadline', value);

  @override
  String get priority =>
      RealmObjectBase.get<String>(this, 'priority') as String;
  @override
  set priority(String value) => RealmObjectBase.set(this, 'priority', value);

  @override
  String get category =>
      RealmObjectBase.get<String>(this, 'category') as String;
  @override
  set category(String value) => RealmObjectBase.set(this, 'category', value);

  @override
  bool get isCompleted =>
      RealmObjectBase.get<bool>(this, 'isCompleted') as bool;
  @override
  set isCompleted(bool value) =>
      RealmObjectBase.set(this, 'isCompleted', value);

  @override
  bool get isPinned => RealmObjectBase.get<bool>(this, 'isPinned') as bool;
  @override
  set isPinned(bool value) => RealmObjectBase.set(this, 'isPinned', value);

  @override
  String? get reminderTime =>
      RealmObjectBase.get<String>(this, 'reminderTime') as String?;
  @override
  set reminderTime(String? value) =>
      RealmObjectBase.set(this, 'reminderTime', value);

  @override
  String get userEmail =>
      RealmObjectBase.get<String>(this, 'userEmail') as String;
  @override
  set userEmail(String value) => RealmObjectBase.set(this, 'userEmail', value);

  @override
  bool get isDeleted => RealmObjectBase.get<bool>(this, 'isDeleted') as bool;
  @override
  set isDeleted(bool value) => RealmObjectBase.set(this, 'isDeleted', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  String? get repeat => RealmObjectBase.get<String>(this, 'repeat') as String?;
  @override
  set repeat(String? value) => RealmObjectBase.set(this, 'repeat', value);

  @override
  Stream<RealmObjectChanges<Task>> get changes =>
      RealmObjectBase.getChanges<Task>(this);

  @override
  Stream<RealmObjectChanges<Task>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Task>(this, keyPaths);

  @override
  Task freeze() => RealmObjectBase.freezeObject<Task>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'description': description.toEJson(),
      'deadline': deadline.toEJson(),
      'priority': priority.toEJson(),
      'category': category.toEJson(),
      'isCompleted': isCompleted.toEJson(),
      'isPinned': isPinned.toEJson(),
      'reminderTime': reminderTime.toEJson(),
      'userEmail': userEmail.toEJson(),
      'isDeleted': isDeleted.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'repeat': repeat.toEJson(),
    };
  }

  static EJsonValue _toEJson(Task value) => value.toEJson();
  static Task _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'title': EJsonValue title,
        'description': EJsonValue description,
        'deadline': EJsonValue deadline,
        'priority': EJsonValue priority,
        'category': EJsonValue category,
        'isCompleted': EJsonValue isCompleted,
        'isPinned': EJsonValue isPinned,
        'userEmail': EJsonValue userEmail,
        'isDeleted': EJsonValue isDeleted,
        'createdAt': EJsonValue createdAt,
      } =>
        Task(
          fromEJson(id),
          fromEJson(title),
          fromEJson(description),
          fromEJson(deadline),
          fromEJson(priority),
          fromEJson(category),
          fromEJson(isCompleted),
          fromEJson(isPinned),
          fromEJson(userEmail),
          fromEJson(isDeleted),
          fromEJson(createdAt),
          reminderTime: fromEJson(ejson['reminderTime']),
          updatedAt: fromEJson(ejson['updatedAt']),
          repeat: fromEJson(ejson['repeat']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Task._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Task, 'Task', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('deadline', RealmPropertyType.timestamp),
      SchemaProperty('priority', RealmPropertyType.string),
      SchemaProperty('category', RealmPropertyType.string),
      SchemaProperty('isCompleted', RealmPropertyType.bool),
      SchemaProperty('isPinned', RealmPropertyType.bool),
      SchemaProperty('reminderTime', RealmPropertyType.string, optional: true),
      SchemaProperty('userEmail', RealmPropertyType.string),
      SchemaProperty('isDeleted', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('repeat', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Streak extends _Streak with RealmEntity, RealmObjectBase, RealmObject {
  Streak(
    ObjectId id,
    DateTime date,
    bool allTasksCompleted,
    String userEmail,
    int streakCount, {
    String? note,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'allTasksCompleted', allTasksCompleted);
    RealmObjectBase.set(this, 'userEmail', userEmail);
    RealmObjectBase.set(this, 'streakCount', streakCount);
    RealmObjectBase.set(this, 'note', note);
  }

  Streak._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  DateTime get date => RealmObjectBase.get<DateTime>(this, 'date') as DateTime;
  @override
  set date(DateTime value) => RealmObjectBase.set(this, 'date', value);

  @override
  bool get allTasksCompleted =>
      RealmObjectBase.get<bool>(this, 'allTasksCompleted') as bool;
  @override
  set allTasksCompleted(bool value) =>
      RealmObjectBase.set(this, 'allTasksCompleted', value);

  @override
  String get userEmail =>
      RealmObjectBase.get<String>(this, 'userEmail') as String;
  @override
  set userEmail(String value) => RealmObjectBase.set(this, 'userEmail', value);

  @override
  int get streakCount => RealmObjectBase.get<int>(this, 'streakCount') as int;
  @override
  set streakCount(int value) => RealmObjectBase.set(this, 'streakCount', value);

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => RealmObjectBase.set(this, 'note', value);

  @override
  Stream<RealmObjectChanges<Streak>> get changes =>
      RealmObjectBase.getChanges<Streak>(this);

  @override
  Stream<RealmObjectChanges<Streak>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Streak>(this, keyPaths);

  @override
  Streak freeze() => RealmObjectBase.freezeObject<Streak>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'date': date.toEJson(),
      'allTasksCompleted': allTasksCompleted.toEJson(),
      'userEmail': userEmail.toEJson(),
      'streakCount': streakCount.toEJson(),
      'note': note.toEJson(),
    };
  }

  static EJsonValue _toEJson(Streak value) => value.toEJson();
  static Streak _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'date': EJsonValue date,
        'allTasksCompleted': EJsonValue allTasksCompleted,
        'userEmail': EJsonValue userEmail,
        'streakCount': EJsonValue streakCount,
      } =>
        Streak(
          fromEJson(id),
          fromEJson(date),
          fromEJson(allTasksCompleted),
          fromEJson(userEmail),
          fromEJson(streakCount),
          note: fromEJson(ejson['note']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Streak._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Streak, 'Streak', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('date', RealmPropertyType.timestamp),
      SchemaProperty('allTasksCompleted', RealmPropertyType.bool),
      SchemaProperty('userEmail', RealmPropertyType.string),
      SchemaProperty('streakCount', RealmPropertyType.int),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Category extends _Category
    with RealmEntity, RealmObjectBase, RealmObject {
  Category(
    ObjectId id,
    String name,
    String iconName,
    String colorHex,
    String userEmail,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'iconName', iconName);
    RealmObjectBase.set(this, 'colorHex', colorHex);
    RealmObjectBase.set(this, 'userEmail', userEmail);
  }

  Category._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get iconName =>
      RealmObjectBase.get<String>(this, 'iconName') as String;
  @override
  set iconName(String value) => RealmObjectBase.set(this, 'iconName', value);

  @override
  String get colorHex =>
      RealmObjectBase.get<String>(this, 'colorHex') as String;
  @override
  set colorHex(String value) => RealmObjectBase.set(this, 'colorHex', value);

  @override
  String get userEmail =>
      RealmObjectBase.get<String>(this, 'userEmail') as String;
  @override
  set userEmail(String value) => RealmObjectBase.set(this, 'userEmail', value);

  @override
  Stream<RealmObjectChanges<Category>> get changes =>
      RealmObjectBase.getChanges<Category>(this);

  @override
  Stream<RealmObjectChanges<Category>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Category>(this, keyPaths);

  @override
  Category freeze() => RealmObjectBase.freezeObject<Category>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'iconName': iconName.toEJson(),
      'colorHex': colorHex.toEJson(),
      'userEmail': userEmail.toEJson(),
    };
  }

  static EJsonValue _toEJson(Category value) => value.toEJson();
  static Category _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'iconName': EJsonValue iconName,
        'colorHex': EJsonValue colorHex,
        'userEmail': EJsonValue userEmail,
      } =>
        Category(
          fromEJson(id),
          fromEJson(name),
          fromEJson(iconName),
          fromEJson(colorHex),
          fromEJson(userEmail),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Category._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Category, 'Category', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('iconName', RealmPropertyType.string),
      SchemaProperty('colorHex', RealmPropertyType.string),
      SchemaProperty('userEmail', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
