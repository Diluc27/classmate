// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#4A90D9'),
  );
  static const VerificationMeta _targetPercentMeta = const VerificationMeta(
    'targetPercent',
  );
  @override
  late final GeneratedColumn<int> targetPercent = GeneratedColumn<int>(
    'target_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(75),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorHex,
    targetPercent,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('target_percent')) {
      context.handle(
        _targetPercentMeta,
        targetPercent.isAcceptableOrUnknown(
          data['target_percent']!,
          _targetPercentMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      targetPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_percent'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final int id;
  final String name;
  final String colorHex;
  final int targetPercent;
  final DateTime createdAt;
  const Subject({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.targetPercent,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    map['target_percent'] = Variable<int>(targetPercent);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: Value(colorHex),
      targetPercent: Value(targetPercent),
      createdAt: Value(createdAt),
    );
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      targetPercent: serializer.fromJson<int>(json['targetPercent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
      'targetPercent': serializer.toJson<int>(targetPercent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Subject copyWith({
    int? id,
    String? name,
    String? colorHex,
    int? targetPercent,
    DateTime? createdAt,
  }) => Subject(
    id: id ?? this.id,
    name: name ?? this.name,
    colorHex: colorHex ?? this.colorHex,
    targetPercent: targetPercent ?? this.targetPercent,
    createdAt: createdAt ?? this.createdAt,
  );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      targetPercent: data.targetPercent.present
          ? data.targetPercent.value
          : this.targetPercent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('targetPercent: $targetPercent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHex, targetPercent, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.targetPercent == this.targetPercent &&
          other.createdAt == this.createdAt);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> colorHex;
  final Value<int> targetPercent;
  final Value<DateTime> createdAt;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.targetPercent = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SubjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorHex = const Value.absent(),
    this.targetPercent = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Subject> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<int>? targetPercent,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (targetPercent != null) 'target_percent': targetPercent,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SubjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? colorHex,
    Value<int>? targetPercent,
    Value<DateTime>? createdAt,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      targetPercent: targetPercent ?? this.targetPercent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (targetPercent.present) {
      map['target_percent'] = Variable<int>(targetPercent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('targetPercent: $targetPercent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TimetableSlotsTable extends TimetableSlots
    with TableInfo<$TimetableSlotsTable, TimetableSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimetableSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    weekday,
    startTime,
    endTime,
    room,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timetable_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimetableSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimetableSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimetableSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      )!,
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $TimetableSlotsTable createAlias(String alias) {
    return $TimetableSlotsTable(attachedDatabase, alias);
  }
}

class TimetableSlot extends DataClass implements Insertable<TimetableSlot> {
  final int id;
  final int subjectId;
  final int weekday;
  final String startTime;
  final String endTime;
  final String? room;
  final bool isActive;
  const TimetableSlot({
    required this.id,
    required this.subjectId,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    this.room,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject_id'] = Variable<int>(subjectId);
    map['weekday'] = Variable<int>(weekday);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    if (!nullToAbsent || room != null) {
      map['room'] = Variable<String>(room);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  TimetableSlotsCompanion toCompanion(bool nullToAbsent) {
    return TimetableSlotsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      weekday: Value(weekday),
      startTime: Value(startTime),
      endTime: Value(endTime),
      room: room == null && nullToAbsent ? const Value.absent() : Value(room),
      isActive: Value(isActive),
    );
  }

  factory TimetableSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimetableSlot(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      room: serializer.fromJson<String?>(json['room']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<int>(subjectId),
      'weekday': serializer.toJson<int>(weekday),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'room': serializer.toJson<String?>(room),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  TimetableSlot copyWith({
    int? id,
    int? subjectId,
    int? weekday,
    String? startTime,
    String? endTime,
    Value<String?> room = const Value.absent(),
    bool? isActive,
  }) => TimetableSlot(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    weekday: weekday ?? this.weekday,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    room: room.present ? room.value : this.room,
    isActive: isActive ?? this.isActive,
  );
  TimetableSlot copyWithCompanion(TimetableSlotsCompanion data) {
    return TimetableSlot(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      room: data.room.present ? data.room.value : this.room,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimetableSlot(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('weekday: $weekday, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('room: $room, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, subjectId, weekday, startTime, endTime, room, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimetableSlot &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.weekday == this.weekday &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.room == this.room &&
          other.isActive == this.isActive);
}

class TimetableSlotsCompanion extends UpdateCompanion<TimetableSlot> {
  final Value<int> id;
  final Value<int> subjectId;
  final Value<int> weekday;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<String?> room;
  final Value<bool> isActive;
  const TimetableSlotsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.room = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  TimetableSlotsCompanion.insert({
    this.id = const Value.absent(),
    required int subjectId,
    required int weekday,
    required String startTime,
    required String endTime,
    this.room = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : subjectId = Value(subjectId),
       weekday = Value(weekday),
       startTime = Value(startTime),
       endTime = Value(endTime);
  static Insertable<TimetableSlot> custom({
    Expression<int>? id,
    Expression<int>? subjectId,
    Expression<int>? weekday,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? room,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (weekday != null) 'weekday': weekday,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (room != null) 'room': room,
      if (isActive != null) 'is_active': isActive,
    });
  }

  TimetableSlotsCompanion copyWith({
    Value<int>? id,
    Value<int>? subjectId,
    Value<int>? weekday,
    Value<String>? startTime,
    Value<String>? endTime,
    Value<String?>? room,
    Value<bool>? isActive,
  }) {
    return TimetableSlotsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      weekday: weekday ?? this.weekday,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimetableSlotsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('weekday: $weekday, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('room: $room, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ClassSessionsTable extends ClassSessions
    with TableInfo<$ClassSessionsTable, ClassSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _slotIdMeta = const VerificationMeta('slotId');
  @override
  late final GeneratedColumn<int> slotId = GeneratedColumn<int>(
    'slot_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES timetable_slots (id)',
    ),
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('absent'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slotId,
    subjectId,
    date,
    startTime,
    endTime,
    status,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'class_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slot_id')) {
      context.handle(
        _slotIdMeta,
        slotId.isAcceptableOrUnknown(data['slot_id']!, _slotIdMeta),
      );
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {subjectId, date, startTime},
  ];
  @override
  ClassSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot_id'],
      ),
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ClassSessionsTable createAlias(String alias) {
    return $ClassSessionsTable(attachedDatabase, alias);
  }
}

class ClassSession extends DataClass implements Insertable<ClassSession> {
  final int id;
  final int? slotId;
  final int subjectId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String status;
  final String? note;
  const ClassSession({
    required this.id,
    this.slotId,
    required this.subjectId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || slotId != null) {
      map['slot_id'] = Variable<int>(slotId);
    }
    map['subject_id'] = Variable<int>(subjectId);
    map['date'] = Variable<DateTime>(date);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ClassSessionsCompanion toCompanion(bool nullToAbsent) {
    return ClassSessionsCompanion(
      id: Value(id),
      slotId: slotId == null && nullToAbsent
          ? const Value.absent()
          : Value(slotId),
      subjectId: Value(subjectId),
      date: Value(date),
      startTime: Value(startTime),
      endTime: Value(endTime),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory ClassSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassSession(
      id: serializer.fromJson<int>(json['id']),
      slotId: serializer.fromJson<int?>(json['slotId']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      date: serializer.fromJson<DateTime>(json['date']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slotId': serializer.toJson<int?>(slotId),
      'subjectId': serializer.toJson<int>(subjectId),
      'date': serializer.toJson<DateTime>(date),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
    };
  }

  ClassSession copyWith({
    int? id,
    Value<int?> slotId = const Value.absent(),
    int? subjectId,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? status,
    Value<String?> note = const Value.absent(),
  }) => ClassSession(
    id: id ?? this.id,
    slotId: slotId.present ? slotId.value : this.slotId,
    subjectId: subjectId ?? this.subjectId,
    date: date ?? this.date,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
  );
  ClassSession copyWithCompanion(ClassSessionsCompanion data) {
    return ClassSession(
      id: data.id.present ? data.id.value : this.id,
      slotId: data.slotId.present ? data.slotId.value : this.slotId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      date: data.date.present ? data.date.value : this.date,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassSession(')
          ..write('id: $id, ')
          ..write('slotId: $slotId, ')
          ..write('subjectId: $subjectId, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    slotId,
    subjectId,
    date,
    startTime,
    endTime,
    status,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassSession &&
          other.id == this.id &&
          other.slotId == this.slotId &&
          other.subjectId == this.subjectId &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.status == this.status &&
          other.note == this.note);
}

class ClassSessionsCompanion extends UpdateCompanion<ClassSession> {
  final Value<int> id;
  final Value<int?> slotId;
  final Value<int> subjectId;
  final Value<DateTime> date;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<String> status;
  final Value<String?> note;
  const ClassSessionsCompanion({
    this.id = const Value.absent(),
    this.slotId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
  });
  ClassSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.slotId = const Value.absent(),
    required int subjectId,
    required DateTime date,
    required String startTime,
    required String endTime,
    this.status = const Value.absent(),
    this.note = const Value.absent(),
  }) : subjectId = Value(subjectId),
       date = Value(date),
       startTime = Value(startTime),
       endTime = Value(endTime);
  static Insertable<ClassSession> custom({
    Expression<int>? id,
    Expression<int>? slotId,
    Expression<int>? subjectId,
    Expression<DateTime>? date,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? status,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slotId != null) 'slot_id': slotId,
      if (subjectId != null) 'subject_id': subjectId,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
    });
  }

  ClassSessionsCompanion copyWith({
    Value<int>? id,
    Value<int?>? slotId,
    Value<int>? subjectId,
    Value<DateTime>? date,
    Value<String>? startTime,
    Value<String>? endTime,
    Value<String>? status,
    Value<String?>? note,
  }) {
    return ClassSessionsCompanion(
      id: id ?? this.id,
      slotId: slotId ?? this.slotId,
      subjectId: subjectId ?? this.subjectId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slotId.present) {
      map['slot_id'] = Variable<int>(slotId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassSessionsCompanion(')
          ..write('id: $id, ')
          ..write('slotId: $slotId, ')
          ..write('subjectId: $subjectId, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $DeadlinesTable extends Deadlines
    with TableInfo<$DeadlinesTable, Deadline> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeadlinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('assignment'),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderDateMeta = const VerificationMeta(
    'reminderDate',
  );
  @override
  late final GeneratedColumn<DateTime> reminderDate = GeneratedColumn<DateTime>(
    'reminder_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
    'reminder_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderDaysMeta = const VerificationMeta(
    'reminderDays',
  );
  @override
  late final GeneratedColumn<String> reminderDays = GeneratedColumn<String>(
    'reminder_days',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _repeatUntilDueMeta = const VerificationMeta(
    'repeatUntilDue',
  );
  @override
  late final GeneratedColumn<bool> repeatUntilDue = GeneratedColumn<bool>(
    'repeat_until_due',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("repeat_until_due" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderFiredMeta = const VerificationMeta(
    'reminderFired',
  );
  @override
  late final GeneratedColumn<bool> reminderFired = GeneratedColumn<bool>(
    'reminder_fired',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_fired" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastReminderFiredDateMeta =
      const VerificationMeta('lastReminderFiredDate');
  @override
  late final GeneratedColumn<DateTime> lastReminderFiredDate =
      GeneratedColumn<DateTime>(
        'last_reminder_fired_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    title,
    type,
    dueDate,
    reminderDate,
    reminderTime,
    reminderDays,
    isDone,
    repeatUntilDue,
    reminderFired,
    lastReminderFiredDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deadlines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Deadline> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('reminder_date')) {
      context.handle(
        _reminderDateMeta,
        reminderDate.isAcceptableOrUnknown(
          data['reminder_date']!,
          _reminderDateMeta,
        ),
      );
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('reminder_days')) {
      context.handle(
        _reminderDaysMeta,
        reminderDays.isAcceptableOrUnknown(
          data['reminder_days']!,
          _reminderDaysMeta,
        ),
      );
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('repeat_until_due')) {
      context.handle(
        _repeatUntilDueMeta,
        repeatUntilDue.isAcceptableOrUnknown(
          data['repeat_until_due']!,
          _repeatUntilDueMeta,
        ),
      );
    }
    if (data.containsKey('reminder_fired')) {
      context.handle(
        _reminderFiredMeta,
        reminderFired.isAcceptableOrUnknown(
          data['reminder_fired']!,
          _reminderFiredMeta,
        ),
      );
    }
    if (data.containsKey('last_reminder_fired_date')) {
      context.handle(
        _lastReminderFiredDateMeta,
        lastReminderFiredDate.isAcceptableOrUnknown(
          data['last_reminder_fired_date']!,
          _lastReminderFiredDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deadline map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deadline(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      reminderDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_date'],
      ),
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_time'],
      ),
      reminderDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_days'],
      ),
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      repeatUntilDue: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}repeat_until_due'],
      )!,
      reminderFired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_fired'],
      )!,
      lastReminderFiredDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reminder_fired_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DeadlinesTable createAlias(String alias) {
    return $DeadlinesTable(attachedDatabase, alias);
  }
}

class Deadline extends DataClass implements Insertable<Deadline> {
  final int id;
  final int? subjectId;
  final String title;
  final String type;
  final DateTime dueDate;
  final DateTime? reminderDate;
  final String? reminderTime;
  final String? reminderDays;
  final bool isDone;
  final bool repeatUntilDue;
  final bool reminderFired;
  final DateTime? lastReminderFiredDate;
  final DateTime createdAt;
  const Deadline({
    required this.id,
    this.subjectId,
    required this.title,
    required this.type,
    required this.dueDate,
    this.reminderDate,
    this.reminderTime,
    this.reminderDays,
    required this.isDone,
    required this.repeatUntilDue,
    required this.reminderFired,
    this.lastReminderFiredDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<int>(subjectId);
    }
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['due_date'] = Variable<DateTime>(dueDate);
    if (!nullToAbsent || reminderDate != null) {
      map['reminder_date'] = Variable<DateTime>(reminderDate);
    }
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<String>(reminderTime);
    }
    if (!nullToAbsent || reminderDays != null) {
      map['reminder_days'] = Variable<String>(reminderDays);
    }
    map['is_done'] = Variable<bool>(isDone);
    map['repeat_until_due'] = Variable<bool>(repeatUntilDue);
    map['reminder_fired'] = Variable<bool>(reminderFired);
    if (!nullToAbsent || lastReminderFiredDate != null) {
      map['last_reminder_fired_date'] = Variable<DateTime>(
        lastReminderFiredDate,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DeadlinesCompanion toCompanion(bool nullToAbsent) {
    return DeadlinesCompanion(
      id: Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      title: Value(title),
      type: Value(type),
      dueDate: Value(dueDate),
      reminderDate: reminderDate == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderDate),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      reminderDays: reminderDays == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderDays),
      isDone: Value(isDone),
      repeatUntilDue: Value(repeatUntilDue),
      reminderFired: Value(reminderFired),
      lastReminderFiredDate: lastReminderFiredDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReminderFiredDate),
      createdAt: Value(createdAt),
    );
  }

  factory Deadline.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deadline(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<int?>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      reminderDate: serializer.fromJson<DateTime?>(json['reminderDate']),
      reminderTime: serializer.fromJson<String?>(json['reminderTime']),
      reminderDays: serializer.fromJson<String?>(json['reminderDays']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      repeatUntilDue: serializer.fromJson<bool>(json['repeatUntilDue']),
      reminderFired: serializer.fromJson<bool>(json['reminderFired']),
      lastReminderFiredDate: serializer.fromJson<DateTime?>(
        json['lastReminderFiredDate'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<int?>(subjectId),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'reminderDate': serializer.toJson<DateTime?>(reminderDate),
      'reminderTime': serializer.toJson<String?>(reminderTime),
      'reminderDays': serializer.toJson<String?>(reminderDays),
      'isDone': serializer.toJson<bool>(isDone),
      'repeatUntilDue': serializer.toJson<bool>(repeatUntilDue),
      'reminderFired': serializer.toJson<bool>(reminderFired),
      'lastReminderFiredDate': serializer.toJson<DateTime?>(
        lastReminderFiredDate,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Deadline copyWith({
    int? id,
    Value<int?> subjectId = const Value.absent(),
    String? title,
    String? type,
    DateTime? dueDate,
    Value<DateTime?> reminderDate = const Value.absent(),
    Value<String?> reminderTime = const Value.absent(),
    Value<String?> reminderDays = const Value.absent(),
    bool? isDone,
    bool? repeatUntilDue,
    bool? reminderFired,
    Value<DateTime?> lastReminderFiredDate = const Value.absent(),
    DateTime? createdAt,
  }) => Deadline(
    id: id ?? this.id,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    title: title ?? this.title,
    type: type ?? this.type,
    dueDate: dueDate ?? this.dueDate,
    reminderDate: reminderDate.present ? reminderDate.value : this.reminderDate,
    reminderTime: reminderTime.present ? reminderTime.value : this.reminderTime,
    reminderDays: reminderDays.present ? reminderDays.value : this.reminderDays,
    isDone: isDone ?? this.isDone,
    repeatUntilDue: repeatUntilDue ?? this.repeatUntilDue,
    reminderFired: reminderFired ?? this.reminderFired,
    lastReminderFiredDate: lastReminderFiredDate.present
        ? lastReminderFiredDate.value
        : this.lastReminderFiredDate,
    createdAt: createdAt ?? this.createdAt,
  );
  Deadline copyWithCompanion(DeadlinesCompanion data) {
    return Deadline(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      reminderDate: data.reminderDate.present
          ? data.reminderDate.value
          : this.reminderDate,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      reminderDays: data.reminderDays.present
          ? data.reminderDays.value
          : this.reminderDays,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      repeatUntilDue: data.repeatUntilDue.present
          ? data.repeatUntilDue.value
          : this.repeatUntilDue,
      reminderFired: data.reminderFired.present
          ? data.reminderFired.value
          : this.reminderFired,
      lastReminderFiredDate: data.lastReminderFiredDate.present
          ? data.lastReminderFiredDate.value
          : this.lastReminderFiredDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deadline(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('dueDate: $dueDate, ')
          ..write('reminderDate: $reminderDate, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('isDone: $isDone, ')
          ..write('repeatUntilDue: $repeatUntilDue, ')
          ..write('reminderFired: $reminderFired, ')
          ..write('lastReminderFiredDate: $lastReminderFiredDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    title,
    type,
    dueDate,
    reminderDate,
    reminderTime,
    reminderDays,
    isDone,
    repeatUntilDue,
    reminderFired,
    lastReminderFiredDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deadline &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.type == this.type &&
          other.dueDate == this.dueDate &&
          other.reminderDate == this.reminderDate &&
          other.reminderTime == this.reminderTime &&
          other.reminderDays == this.reminderDays &&
          other.isDone == this.isDone &&
          other.repeatUntilDue == this.repeatUntilDue &&
          other.reminderFired == this.reminderFired &&
          other.lastReminderFiredDate == this.lastReminderFiredDate &&
          other.createdAt == this.createdAt);
}

class DeadlinesCompanion extends UpdateCompanion<Deadline> {
  final Value<int> id;
  final Value<int?> subjectId;
  final Value<String> title;
  final Value<String> type;
  final Value<DateTime> dueDate;
  final Value<DateTime?> reminderDate;
  final Value<String?> reminderTime;
  final Value<String?> reminderDays;
  final Value<bool> isDone;
  final Value<bool> repeatUntilDue;
  final Value<bool> reminderFired;
  final Value<DateTime?> lastReminderFiredDate;
  final Value<DateTime> createdAt;
  const DeadlinesCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.reminderDate = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.isDone = const Value.absent(),
    this.repeatUntilDue = const Value.absent(),
    this.reminderFired = const Value.absent(),
    this.lastReminderFiredDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DeadlinesCompanion.insert({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    required String title,
    this.type = const Value.absent(),
    required DateTime dueDate,
    this.reminderDate = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.isDone = const Value.absent(),
    this.repeatUntilDue = const Value.absent(),
    this.reminderFired = const Value.absent(),
    this.lastReminderFiredDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       dueDate = Value(dueDate);
  static Insertable<Deadline> custom({
    Expression<int>? id,
    Expression<int>? subjectId,
    Expression<String>? title,
    Expression<String>? type,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? reminderDate,
    Expression<String>? reminderTime,
    Expression<String>? reminderDays,
    Expression<bool>? isDone,
    Expression<bool>? repeatUntilDue,
    Expression<bool>? reminderFired,
    Expression<DateTime>? lastReminderFiredDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (dueDate != null) 'due_date': dueDate,
      if (reminderDate != null) 'reminder_date': reminderDate,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (reminderDays != null) 'reminder_days': reminderDays,
      if (isDone != null) 'is_done': isDone,
      if (repeatUntilDue != null) 'repeat_until_due': repeatUntilDue,
      if (reminderFired != null) 'reminder_fired': reminderFired,
      if (lastReminderFiredDate != null)
        'last_reminder_fired_date': lastReminderFiredDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DeadlinesCompanion copyWith({
    Value<int>? id,
    Value<int?>? subjectId,
    Value<String>? title,
    Value<String>? type,
    Value<DateTime>? dueDate,
    Value<DateTime?>? reminderDate,
    Value<String?>? reminderTime,
    Value<String?>? reminderDays,
    Value<bool>? isDone,
    Value<bool>? repeatUntilDue,
    Value<bool>? reminderFired,
    Value<DateTime?>? lastReminderFiredDate,
    Value<DateTime>? createdAt,
  }) {
    return DeadlinesCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      type: type ?? this.type,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderDays: reminderDays ?? this.reminderDays,
      isDone: isDone ?? this.isDone,
      repeatUntilDue: repeatUntilDue ?? this.repeatUntilDue,
      reminderFired: reminderFired ?? this.reminderFired,
      lastReminderFiredDate:
          lastReminderFiredDate ?? this.lastReminderFiredDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (reminderDate.present) {
      map['reminder_date'] = Variable<DateTime>(reminderDate.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (reminderDays.present) {
      map['reminder_days'] = Variable<String>(reminderDays.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (repeatUntilDue.present) {
      map['repeat_until_due'] = Variable<bool>(repeatUntilDue.value);
    }
    if (reminderFired.present) {
      map['reminder_fired'] = Variable<bool>(reminderFired.value);
    }
    if (lastReminderFiredDate.present) {
      map['last_reminder_fired_date'] = Variable<DateTime>(
        lastReminderFiredDate.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeadlinesCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('dueDate: $dueDate, ')
          ..write('reminderDate: $reminderDate, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('isDone: $isDone, ')
          ..write('repeatUntilDue: $repeatUntilDue, ')
          ..write('reminderFired: $reminderFired, ')
          ..write('lastReminderFiredDate: $lastReminderFiredDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LectureScheduleConfigTable extends LectureScheduleConfig
    with TableInfo<$LectureScheduleConfigTable, LectureScheduleConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LectureScheduleConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _collegeNameMeta = const VerificationMeta(
    'collegeName',
  );
  @override
  late final GeneratedColumn<String> collegeName = GeneratedColumn<String>(
    'college_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lectureDurationMinsMeta =
      const VerificationMeta('lectureDurationMins');
  @override
  late final GeneratedColumn<int> lectureDurationMins = GeneratedColumn<int>(
    'lecture_duration_mins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _firstLectureStartMeta = const VerificationMeta(
    'firstLectureStart',
  );
  @override
  late final GeneratedColumn<String> firstLectureStart =
      GeneratedColumn<String>(
        'first_lecture_start',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant("10:00"),
      );
  static const VerificationMeta _breakStartMeta = const VerificationMeta(
    'breakStart',
  );
  @override
  late final GeneratedColumn<String> breakStart = GeneratedColumn<String>(
    'break_start',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant("12:30"),
  );
  static const VerificationMeta _breakEndMeta = const VerificationMeta(
    'breakEnd',
  );
  @override
  late final GeneratedColumn<String> breakEnd = GeneratedColumn<String>(
    'break_end',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant("13:00"),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    collegeName,
    lectureDurationMins,
    firstLectureStart,
    breakStart,
    breakEnd,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lecture_schedule_config';
  @override
  VerificationContext validateIntegrity(
    Insertable<LectureScheduleConfigData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('college_name')) {
      context.handle(
        _collegeNameMeta,
        collegeName.isAcceptableOrUnknown(
          data['college_name']!,
          _collegeNameMeta,
        ),
      );
    }
    if (data.containsKey('lecture_duration_mins')) {
      context.handle(
        _lectureDurationMinsMeta,
        lectureDurationMins.isAcceptableOrUnknown(
          data['lecture_duration_mins']!,
          _lectureDurationMinsMeta,
        ),
      );
    }
    if (data.containsKey('first_lecture_start')) {
      context.handle(
        _firstLectureStartMeta,
        firstLectureStart.isAcceptableOrUnknown(
          data['first_lecture_start']!,
          _firstLectureStartMeta,
        ),
      );
    }
    if (data.containsKey('break_start')) {
      context.handle(
        _breakStartMeta,
        breakStart.isAcceptableOrUnknown(data['break_start']!, _breakStartMeta),
      );
    }
    if (data.containsKey('break_end')) {
      context.handle(
        _breakEndMeta,
        breakEnd.isAcceptableOrUnknown(data['break_end']!, _breakEndMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LectureScheduleConfigData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LectureScheduleConfigData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      collegeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}college_name'],
      ),
      lectureDurationMins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lecture_duration_mins'],
      )!,
      firstLectureStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_lecture_start'],
      )!,
      breakStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}break_start'],
      )!,
      breakEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}break_end'],
      )!,
    );
  }

  @override
  $LectureScheduleConfigTable createAlias(String alias) {
    return $LectureScheduleConfigTable(attachedDatabase, alias);
  }
}

class LectureScheduleConfigData extends DataClass
    implements Insertable<LectureScheduleConfigData> {
  final int id;
  final String? collegeName;
  final int lectureDurationMins;
  final String firstLectureStart;
  final String breakStart;
  final String breakEnd;
  const LectureScheduleConfigData({
    required this.id,
    this.collegeName,
    required this.lectureDurationMins,
    required this.firstLectureStart,
    required this.breakStart,
    required this.breakEnd,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || collegeName != null) {
      map['college_name'] = Variable<String>(collegeName);
    }
    map['lecture_duration_mins'] = Variable<int>(lectureDurationMins);
    map['first_lecture_start'] = Variable<String>(firstLectureStart);
    map['break_start'] = Variable<String>(breakStart);
    map['break_end'] = Variable<String>(breakEnd);
    return map;
  }

  LectureScheduleConfigCompanion toCompanion(bool nullToAbsent) {
    return LectureScheduleConfigCompanion(
      id: Value(id),
      collegeName: collegeName == null && nullToAbsent
          ? const Value.absent()
          : Value(collegeName),
      lectureDurationMins: Value(lectureDurationMins),
      firstLectureStart: Value(firstLectureStart),
      breakStart: Value(breakStart),
      breakEnd: Value(breakEnd),
    );
  }

  factory LectureScheduleConfigData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LectureScheduleConfigData(
      id: serializer.fromJson<int>(json['id']),
      collegeName: serializer.fromJson<String?>(json['collegeName']),
      lectureDurationMins: serializer.fromJson<int>(
        json['lectureDurationMins'],
      ),
      firstLectureStart: serializer.fromJson<String>(json['firstLectureStart']),
      breakStart: serializer.fromJson<String>(json['breakStart']),
      breakEnd: serializer.fromJson<String>(json['breakEnd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'collegeName': serializer.toJson<String?>(collegeName),
      'lectureDurationMins': serializer.toJson<int>(lectureDurationMins),
      'firstLectureStart': serializer.toJson<String>(firstLectureStart),
      'breakStart': serializer.toJson<String>(breakStart),
      'breakEnd': serializer.toJson<String>(breakEnd),
    };
  }

  LectureScheduleConfigData copyWith({
    int? id,
    Value<String?> collegeName = const Value.absent(),
    int? lectureDurationMins,
    String? firstLectureStart,
    String? breakStart,
    String? breakEnd,
  }) => LectureScheduleConfigData(
    id: id ?? this.id,
    collegeName: collegeName.present ? collegeName.value : this.collegeName,
    lectureDurationMins: lectureDurationMins ?? this.lectureDurationMins,
    firstLectureStart: firstLectureStart ?? this.firstLectureStart,
    breakStart: breakStart ?? this.breakStart,
    breakEnd: breakEnd ?? this.breakEnd,
  );
  LectureScheduleConfigData copyWithCompanion(
    LectureScheduleConfigCompanion data,
  ) {
    return LectureScheduleConfigData(
      id: data.id.present ? data.id.value : this.id,
      collegeName: data.collegeName.present
          ? data.collegeName.value
          : this.collegeName,
      lectureDurationMins: data.lectureDurationMins.present
          ? data.lectureDurationMins.value
          : this.lectureDurationMins,
      firstLectureStart: data.firstLectureStart.present
          ? data.firstLectureStart.value
          : this.firstLectureStart,
      breakStart: data.breakStart.present
          ? data.breakStart.value
          : this.breakStart,
      breakEnd: data.breakEnd.present ? data.breakEnd.value : this.breakEnd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LectureScheduleConfigData(')
          ..write('id: $id, ')
          ..write('collegeName: $collegeName, ')
          ..write('lectureDurationMins: $lectureDurationMins, ')
          ..write('firstLectureStart: $firstLectureStart, ')
          ..write('breakStart: $breakStart, ')
          ..write('breakEnd: $breakEnd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    collegeName,
    lectureDurationMins,
    firstLectureStart,
    breakStart,
    breakEnd,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LectureScheduleConfigData &&
          other.id == this.id &&
          other.collegeName == this.collegeName &&
          other.lectureDurationMins == this.lectureDurationMins &&
          other.firstLectureStart == this.firstLectureStart &&
          other.breakStart == this.breakStart &&
          other.breakEnd == this.breakEnd);
}

class LectureScheduleConfigCompanion
    extends UpdateCompanion<LectureScheduleConfigData> {
  final Value<int> id;
  final Value<String?> collegeName;
  final Value<int> lectureDurationMins;
  final Value<String> firstLectureStart;
  final Value<String> breakStart;
  final Value<String> breakEnd;
  const LectureScheduleConfigCompanion({
    this.id = const Value.absent(),
    this.collegeName = const Value.absent(),
    this.lectureDurationMins = const Value.absent(),
    this.firstLectureStart = const Value.absent(),
    this.breakStart = const Value.absent(),
    this.breakEnd = const Value.absent(),
  });
  LectureScheduleConfigCompanion.insert({
    this.id = const Value.absent(),
    this.collegeName = const Value.absent(),
    this.lectureDurationMins = const Value.absent(),
    this.firstLectureStart = const Value.absent(),
    this.breakStart = const Value.absent(),
    this.breakEnd = const Value.absent(),
  });
  static Insertable<LectureScheduleConfigData> custom({
    Expression<int>? id,
    Expression<String>? collegeName,
    Expression<int>? lectureDurationMins,
    Expression<String>? firstLectureStart,
    Expression<String>? breakStart,
    Expression<String>? breakEnd,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collegeName != null) 'college_name': collegeName,
      if (lectureDurationMins != null)
        'lecture_duration_mins': lectureDurationMins,
      if (firstLectureStart != null) 'first_lecture_start': firstLectureStart,
      if (breakStart != null) 'break_start': breakStart,
      if (breakEnd != null) 'break_end': breakEnd,
    });
  }

  LectureScheduleConfigCompanion copyWith({
    Value<int>? id,
    Value<String?>? collegeName,
    Value<int>? lectureDurationMins,
    Value<String>? firstLectureStart,
    Value<String>? breakStart,
    Value<String>? breakEnd,
  }) {
    return LectureScheduleConfigCompanion(
      id: id ?? this.id,
      collegeName: collegeName ?? this.collegeName,
      lectureDurationMins: lectureDurationMins ?? this.lectureDurationMins,
      firstLectureStart: firstLectureStart ?? this.firstLectureStart,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (collegeName.present) {
      map['college_name'] = Variable<String>(collegeName.value);
    }
    if (lectureDurationMins.present) {
      map['lecture_duration_mins'] = Variable<int>(lectureDurationMins.value);
    }
    if (firstLectureStart.present) {
      map['first_lecture_start'] = Variable<String>(firstLectureStart.value);
    }
    if (breakStart.present) {
      map['break_start'] = Variable<String>(breakStart.value);
    }
    if (breakEnd.present) {
      map['break_end'] = Variable<String>(breakEnd.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LectureScheduleConfigCompanion(')
          ..write('id: $id, ')
          ..write('collegeName: $collegeName, ')
          ..write('lectureDurationMins: $lectureDurationMins, ')
          ..write('firstLectureStart: $firstLectureStart, ')
          ..write('breakStart: $breakStart, ')
          ..write('breakEnd: $breakEnd')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $TimetableSlotsTable timetableSlots = $TimetableSlotsTable(this);
  late final $ClassSessionsTable classSessions = $ClassSessionsTable(this);
  late final $DeadlinesTable deadlines = $DeadlinesTable(this);
  late final $LectureScheduleConfigTable lectureScheduleConfig =
      $LectureScheduleConfigTable(this);
  late final SubjectDao subjectDao = SubjectDao(this as AppDatabase);
  late final SlotDao slotDao = SlotDao(this as AppDatabase);
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  late final DeadlineDao deadlineDao = DeadlineDao(this as AppDatabase);
  late final LectureConfigDao lectureConfigDao = LectureConfigDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subjects,
    timetableSlots,
    classSessions,
    deadlines,
    lectureScheduleConfig,
  ];
}

typedef $$SubjectsTableCreateCompanionBuilder =
    SubjectsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> colorHex,
      Value<int> targetPercent,
      Value<DateTime> createdAt,
    });
typedef $$SubjectsTableUpdateCompanionBuilder =
    SubjectsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> colorHex,
      Value<int> targetPercent,
      Value<DateTime> createdAt,
    });

final class $$SubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTable, Subject> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TimetableSlotsTable, List<TimetableSlot>>
  _timetableSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timetableSlots,
    aliasName: $_aliasNameGenerator(
      db.subjects.id,
      db.timetableSlots.subjectId,
    ),
  );

  $$TimetableSlotsTableProcessedTableManager get timetableSlotsRefs {
    final manager = $$TimetableSlotsTableTableManager(
      $_db,
      $_db.timetableSlots,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timetableSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClassSessionsTable, List<ClassSession>>
  _classSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.classSessions,
    aliasName: $_aliasNameGenerator(db.subjects.id, db.classSessions.subjectId),
  );

  $$ClassSessionsTableProcessedTableManager get classSessionsRefs {
    final manager = $$ClassSessionsTableTableManager(
      $_db,
      $_db.classSessions,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_classSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeadlinesTable, List<Deadline>>
  _deadlinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deadlines,
    aliasName: $_aliasNameGenerator(db.subjects.id, db.deadlines.subjectId),
  );

  $$DeadlinesTableProcessedTableManager get deadlinesRefs {
    final manager = $$DeadlinesTableTableManager(
      $_db,
      $_db.deadlines,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_deadlinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPercent => $composableBuilder(
    column: $table.targetPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> timetableSlotsRefs(
    Expression<bool> Function($$TimetableSlotsTableFilterComposer f) f,
  ) {
    final $$TimetableSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableFilterComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> classSessionsRefs(
    Expression<bool> Function($$ClassSessionsTableFilterComposer f) f,
  ) {
    final $$ClassSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classSessions,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassSessionsTableFilterComposer(
            $db: $db,
            $table: $db.classSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deadlinesRefs(
    Expression<bool> Function($$DeadlinesTableFilterComposer f) f,
  ) {
    final $$DeadlinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deadlines,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeadlinesTableFilterComposer(
            $db: $db,
            $table: $db.deadlines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPercent => $composableBuilder(
    column: $table.targetPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get targetPercent => $composableBuilder(
    column: $table.targetPercent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> timetableSlotsRefs<T extends Object>(
    Expression<T> Function($$TimetableSlotsTableAnnotationComposer a) f,
  ) {
    final $$TimetableSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> classSessionsRefs<T extends Object>(
    Expression<T> Function($$ClassSessionsTableAnnotationComposer a) f,
  ) {
    final $$ClassSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classSessions,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.classSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deadlinesRefs<T extends Object>(
    Expression<T> Function($$DeadlinesTableAnnotationComposer a) f,
  ) {
    final $$DeadlinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deadlines,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeadlinesTableAnnotationComposer(
            $db: $db,
            $table: $db.deadlines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (Subject, $$SubjectsTableReferences),
          Subject,
          PrefetchHooks Function({
            bool timetableSlotsRefs,
            bool classSessionsRefs,
            bool deadlinesRefs,
          })
        > {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> targetPercent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                name: name,
                colorHex: colorHex,
                targetPercent: targetPercent,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> colorHex = const Value.absent(),
                Value<int> targetPercent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                name: name,
                colorHex: colorHex,
                targetPercent: targetPercent,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                timetableSlotsRefs = false,
                classSessionsRefs = false,
                deadlinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timetableSlotsRefs) db.timetableSlots,
                    if (classSessionsRefs) db.classSessions,
                    if (deadlinesRefs) db.deadlines,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timetableSlotsRefs)
                        await $_getPrefetchedData<
                          Subject,
                          $SubjectsTable,
                          TimetableSlot
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._timetableSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).timetableSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (classSessionsRefs)
                        await $_getPrefetchedData<
                          Subject,
                          $SubjectsTable,
                          ClassSession
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._classSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).classSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deadlinesRefs)
                        await $_getPrefetchedData<
                          Subject,
                          $SubjectsTable,
                          Deadline
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._deadlinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).deadlinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, $$SubjectsTableReferences),
      Subject,
      PrefetchHooks Function({
        bool timetableSlotsRefs,
        bool classSessionsRefs,
        bool deadlinesRefs,
      })
    >;
typedef $$TimetableSlotsTableCreateCompanionBuilder =
    TimetableSlotsCompanion Function({
      Value<int> id,
      required int subjectId,
      required int weekday,
      required String startTime,
      required String endTime,
      Value<String?> room,
      Value<bool> isActive,
    });
typedef $$TimetableSlotsTableUpdateCompanionBuilder =
    TimetableSlotsCompanion Function({
      Value<int> id,
      Value<int> subjectId,
      Value<int> weekday,
      Value<String> startTime,
      Value<String> endTime,
      Value<String?> room,
      Value<bool> isActive,
    });

final class $$TimetableSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $TimetableSlotsTable, TimetableSlot> {
  $$TimetableSlotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.timetableSlots.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<int>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ClassSessionsTable, List<ClassSession>>
  _classSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.classSessions,
    aliasName: $_aliasNameGenerator(
      db.timetableSlots.id,
      db.classSessions.slotId,
    ),
  );

  $$ClassSessionsTableProcessedTableManager get classSessionsRefs {
    final manager = $$ClassSessionsTableTableManager(
      $_db,
      $_db.classSessions,
    ).filter((f) => f.slotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_classSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TimetableSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $TimetableSlotsTable> {
  $$TimetableSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> classSessionsRefs(
    Expression<bool> Function($$ClassSessionsTableFilterComposer f) f,
  ) {
    final $$ClassSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classSessions,
      getReferencedColumn: (t) => t.slotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassSessionsTableFilterComposer(
            $db: $db,
            $table: $db.classSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimetableSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $TimetableSlotsTable> {
  $$TimetableSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimetableSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimetableSlotsTable> {
  $$TimetableSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> classSessionsRefs<T extends Object>(
    Expression<T> Function($$ClassSessionsTableAnnotationComposer a) f,
  ) {
    final $$ClassSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classSessions,
      getReferencedColumn: (t) => t.slotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.classSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimetableSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimetableSlotsTable,
          TimetableSlot,
          $$TimetableSlotsTableFilterComposer,
          $$TimetableSlotsTableOrderingComposer,
          $$TimetableSlotsTableAnnotationComposer,
          $$TimetableSlotsTableCreateCompanionBuilder,
          $$TimetableSlotsTableUpdateCompanionBuilder,
          (TimetableSlot, $$TimetableSlotsTableReferences),
          TimetableSlot,
          PrefetchHooks Function({bool subjectId, bool classSessionsRefs})
        > {
  $$TimetableSlotsTableTableManager(
    _$AppDatabase db,
    $TimetableSlotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimetableSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimetableSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimetableSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subjectId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<String?> room = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TimetableSlotsCompanion(
                id: id,
                subjectId: subjectId,
                weekday: weekday,
                startTime: startTime,
                endTime: endTime,
                room: room,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int subjectId,
                required int weekday,
                required String startTime,
                required String endTime,
                Value<String?> room = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TimetableSlotsCompanion.insert(
                id: id,
                subjectId: subjectId,
                weekday: weekday,
                startTime: startTime,
                endTime: endTime,
                room: room,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimetableSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({subjectId = false, classSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (classSessionsRefs) db.classSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectId,
                                    referencedTable:
                                        $$TimetableSlotsTableReferences
                                            ._subjectIdTable(db),
                                    referencedColumn:
                                        $$TimetableSlotsTableReferences
                                            ._subjectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (classSessionsRefs)
                        await $_getPrefetchedData<
                          TimetableSlot,
                          $TimetableSlotsTable,
                          ClassSession
                        >(
                          currentTable: table,
                          referencedTable: $$TimetableSlotsTableReferences
                              ._classSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TimetableSlotsTableReferences(
                                db,
                                table,
                                p0,
                              ).classSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.slotId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TimetableSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimetableSlotsTable,
      TimetableSlot,
      $$TimetableSlotsTableFilterComposer,
      $$TimetableSlotsTableOrderingComposer,
      $$TimetableSlotsTableAnnotationComposer,
      $$TimetableSlotsTableCreateCompanionBuilder,
      $$TimetableSlotsTableUpdateCompanionBuilder,
      (TimetableSlot, $$TimetableSlotsTableReferences),
      TimetableSlot,
      PrefetchHooks Function({bool subjectId, bool classSessionsRefs})
    >;
typedef $$ClassSessionsTableCreateCompanionBuilder =
    ClassSessionsCompanion Function({
      Value<int> id,
      Value<int?> slotId,
      required int subjectId,
      required DateTime date,
      required String startTime,
      required String endTime,
      Value<String> status,
      Value<String?> note,
    });
typedef $$ClassSessionsTableUpdateCompanionBuilder =
    ClassSessionsCompanion Function({
      Value<int> id,
      Value<int?> slotId,
      Value<int> subjectId,
      Value<DateTime> date,
      Value<String> startTime,
      Value<String> endTime,
      Value<String> status,
      Value<String?> note,
    });

final class $$ClassSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $ClassSessionsTable, ClassSession> {
  $$ClassSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TimetableSlotsTable _slotIdTable(_$AppDatabase db) =>
      db.timetableSlots.createAlias(
        $_aliasNameGenerator(db.classSessions.slotId, db.timetableSlots.id),
      );

  $$TimetableSlotsTableProcessedTableManager? get slotId {
    final $_column = $_itemColumn<int>('slot_id');
    if ($_column == null) return null;
    final manager = $$TimetableSlotsTableTableManager(
      $_db,
      $_db.timetableSlots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_slotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.classSessions.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<int>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClassSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ClassSessionsTable> {
  $$ClassSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$TimetableSlotsTableFilterComposer get slotId {
    final $$TimetableSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableFilterComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassSessionsTable> {
  $$ClassSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$TimetableSlotsTableOrderingComposer get slotId {
    final $$TimetableSlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableOrderingComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassSessionsTable> {
  $$ClassSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$TimetableSlotsTableAnnotationComposer get slotId {
    final $$TimetableSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimetableSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassSessionsTable,
          ClassSession,
          $$ClassSessionsTableFilterComposer,
          $$ClassSessionsTableOrderingComposer,
          $$ClassSessionsTableAnnotationComposer,
          $$ClassSessionsTableCreateCompanionBuilder,
          $$ClassSessionsTableUpdateCompanionBuilder,
          (ClassSession, $$ClassSessionsTableReferences),
          ClassSession,
          PrefetchHooks Function({bool slotId, bool subjectId})
        > {
  $$ClassSessionsTableTableManager(_$AppDatabase db, $ClassSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> slotId = const Value.absent(),
                Value<int> subjectId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => ClassSessionsCompanion(
                id: id,
                slotId: slotId,
                subjectId: subjectId,
                date: date,
                startTime: startTime,
                endTime: endTime,
                status: status,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> slotId = const Value.absent(),
                required int subjectId,
                required DateTime date,
                required String startTime,
                required String endTime,
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => ClassSessionsCompanion.insert(
                id: id,
                slotId: slotId,
                subjectId: subjectId,
                date: date,
                startTime: startTime,
                endTime: endTime,
                status: status,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClassSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({slotId = false, subjectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (slotId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.slotId,
                                referencedTable: $$ClassSessionsTableReferences
                                    ._slotIdTable(db),
                                referencedColumn: $$ClassSessionsTableReferences
                                    ._slotIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (subjectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subjectId,
                                referencedTable: $$ClassSessionsTableReferences
                                    ._subjectIdTable(db),
                                referencedColumn: $$ClassSessionsTableReferences
                                    ._subjectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClassSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassSessionsTable,
      ClassSession,
      $$ClassSessionsTableFilterComposer,
      $$ClassSessionsTableOrderingComposer,
      $$ClassSessionsTableAnnotationComposer,
      $$ClassSessionsTableCreateCompanionBuilder,
      $$ClassSessionsTableUpdateCompanionBuilder,
      (ClassSession, $$ClassSessionsTableReferences),
      ClassSession,
      PrefetchHooks Function({bool slotId, bool subjectId})
    >;
typedef $$DeadlinesTableCreateCompanionBuilder =
    DeadlinesCompanion Function({
      Value<int> id,
      Value<int?> subjectId,
      required String title,
      Value<String> type,
      required DateTime dueDate,
      Value<DateTime?> reminderDate,
      Value<String?> reminderTime,
      Value<String?> reminderDays,
      Value<bool> isDone,
      Value<bool> repeatUntilDue,
      Value<bool> reminderFired,
      Value<DateTime?> lastReminderFiredDate,
      Value<DateTime> createdAt,
    });
typedef $$DeadlinesTableUpdateCompanionBuilder =
    DeadlinesCompanion Function({
      Value<int> id,
      Value<int?> subjectId,
      Value<String> title,
      Value<String> type,
      Value<DateTime> dueDate,
      Value<DateTime?> reminderDate,
      Value<String?> reminderTime,
      Value<String?> reminderDays,
      Value<bool> isDone,
      Value<bool> repeatUntilDue,
      Value<bool> reminderFired,
      Value<DateTime?> lastReminderFiredDate,
      Value<DateTime> createdAt,
    });

final class $$DeadlinesTableReferences
    extends BaseReferences<_$AppDatabase, $DeadlinesTable, Deadline> {
  $$DeadlinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.deadlines.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager? get subjectId {
    final $_column = $_itemColumn<int>('subject_id');
    if ($_column == null) return null;
    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeadlinesTableFilterComposer
    extends Composer<_$AppDatabase, $DeadlinesTable> {
  $$DeadlinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get repeatUntilDue => $composableBuilder(
    column: $table.repeatUntilDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderFired => $composableBuilder(
    column: $table.reminderFired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReminderFiredDate => $composableBuilder(
    column: $table.lastReminderFiredDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeadlinesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeadlinesTable> {
  $$DeadlinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get repeatUntilDue => $composableBuilder(
    column: $table.repeatUntilDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderFired => $composableBuilder(
    column: $table.reminderFired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReminderFiredDate => $composableBuilder(
    column: $table.lastReminderFiredDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeadlinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeadlinesTable> {
  $$DeadlinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderDate => $composableBuilder(
    column: $table.reminderDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<bool> get repeatUntilDue => $composableBuilder(
    column: $table.repeatUntilDue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderFired => $composableBuilder(
    column: $table.reminderFired,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReminderFiredDate => $composableBuilder(
    column: $table.lastReminderFiredDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeadlinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeadlinesTable,
          Deadline,
          $$DeadlinesTableFilterComposer,
          $$DeadlinesTableOrderingComposer,
          $$DeadlinesTableAnnotationComposer,
          $$DeadlinesTableCreateCompanionBuilder,
          $$DeadlinesTableUpdateCompanionBuilder,
          (Deadline, $$DeadlinesTableReferences),
          Deadline,
          PrefetchHooks Function({bool subjectId})
        > {
  $$DeadlinesTableTableManager(_$AppDatabase db, $DeadlinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeadlinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeadlinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeadlinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> subjectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<DateTime?> reminderDate = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                Value<String?> reminderDays = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<bool> repeatUntilDue = const Value.absent(),
                Value<bool> reminderFired = const Value.absent(),
                Value<DateTime?> lastReminderFiredDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DeadlinesCompanion(
                id: id,
                subjectId: subjectId,
                title: title,
                type: type,
                dueDate: dueDate,
                reminderDate: reminderDate,
                reminderTime: reminderTime,
                reminderDays: reminderDays,
                isDone: isDone,
                repeatUntilDue: repeatUntilDue,
                reminderFired: reminderFired,
                lastReminderFiredDate: lastReminderFiredDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> subjectId = const Value.absent(),
                required String title,
                Value<String> type = const Value.absent(),
                required DateTime dueDate,
                Value<DateTime?> reminderDate = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                Value<String?> reminderDays = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<bool> repeatUntilDue = const Value.absent(),
                Value<bool> reminderFired = const Value.absent(),
                Value<DateTime?> lastReminderFiredDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DeadlinesCompanion.insert(
                id: id,
                subjectId: subjectId,
                title: title,
                type: type,
                dueDate: dueDate,
                reminderDate: reminderDate,
                reminderTime: reminderTime,
                reminderDays: reminderDays,
                isDone: isDone,
                repeatUntilDue: repeatUntilDue,
                reminderFired: reminderFired,
                lastReminderFiredDate: lastReminderFiredDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeadlinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subjectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subjectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subjectId,
                                referencedTable: $$DeadlinesTableReferences
                                    ._subjectIdTable(db),
                                referencedColumn: $$DeadlinesTableReferences
                                    ._subjectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeadlinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeadlinesTable,
      Deadline,
      $$DeadlinesTableFilterComposer,
      $$DeadlinesTableOrderingComposer,
      $$DeadlinesTableAnnotationComposer,
      $$DeadlinesTableCreateCompanionBuilder,
      $$DeadlinesTableUpdateCompanionBuilder,
      (Deadline, $$DeadlinesTableReferences),
      Deadline,
      PrefetchHooks Function({bool subjectId})
    >;
typedef $$LectureScheduleConfigTableCreateCompanionBuilder =
    LectureScheduleConfigCompanion Function({
      Value<int> id,
      Value<String?> collegeName,
      Value<int> lectureDurationMins,
      Value<String> firstLectureStart,
      Value<String> breakStart,
      Value<String> breakEnd,
    });
typedef $$LectureScheduleConfigTableUpdateCompanionBuilder =
    LectureScheduleConfigCompanion Function({
      Value<int> id,
      Value<String?> collegeName,
      Value<int> lectureDurationMins,
      Value<String> firstLectureStart,
      Value<String> breakStart,
      Value<String> breakEnd,
    });

class $$LectureScheduleConfigTableFilterComposer
    extends Composer<_$AppDatabase, $LectureScheduleConfigTable> {
  $$LectureScheduleConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collegeName => $composableBuilder(
    column: $table.collegeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lectureDurationMins => $composableBuilder(
    column: $table.lectureDurationMins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstLectureStart => $composableBuilder(
    column: $table.firstLectureStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breakStart => $composableBuilder(
    column: $table.breakStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breakEnd => $composableBuilder(
    column: $table.breakEnd,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LectureScheduleConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $LectureScheduleConfigTable> {
  $$LectureScheduleConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collegeName => $composableBuilder(
    column: $table.collegeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lectureDurationMins => $composableBuilder(
    column: $table.lectureDurationMins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstLectureStart => $composableBuilder(
    column: $table.firstLectureStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breakStart => $composableBuilder(
    column: $table.breakStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breakEnd => $composableBuilder(
    column: $table.breakEnd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LectureScheduleConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $LectureScheduleConfigTable> {
  $$LectureScheduleConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get collegeName => $composableBuilder(
    column: $table.collegeName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lectureDurationMins => $composableBuilder(
    column: $table.lectureDurationMins,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstLectureStart => $composableBuilder(
    column: $table.firstLectureStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get breakStart => $composableBuilder(
    column: $table.breakStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get breakEnd =>
      $composableBuilder(column: $table.breakEnd, builder: (column) => column);
}

class $$LectureScheduleConfigTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LectureScheduleConfigTable,
          LectureScheduleConfigData,
          $$LectureScheduleConfigTableFilterComposer,
          $$LectureScheduleConfigTableOrderingComposer,
          $$LectureScheduleConfigTableAnnotationComposer,
          $$LectureScheduleConfigTableCreateCompanionBuilder,
          $$LectureScheduleConfigTableUpdateCompanionBuilder,
          (
            LectureScheduleConfigData,
            BaseReferences<
              _$AppDatabase,
              $LectureScheduleConfigTable,
              LectureScheduleConfigData
            >,
          ),
          LectureScheduleConfigData,
          PrefetchHooks Function()
        > {
  $$LectureScheduleConfigTableTableManager(
    _$AppDatabase db,
    $LectureScheduleConfigTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LectureScheduleConfigTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LectureScheduleConfigTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LectureScheduleConfigTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> collegeName = const Value.absent(),
                Value<int> lectureDurationMins = const Value.absent(),
                Value<String> firstLectureStart = const Value.absent(),
                Value<String> breakStart = const Value.absent(),
                Value<String> breakEnd = const Value.absent(),
              }) => LectureScheduleConfigCompanion(
                id: id,
                collegeName: collegeName,
                lectureDurationMins: lectureDurationMins,
                firstLectureStart: firstLectureStart,
                breakStart: breakStart,
                breakEnd: breakEnd,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> collegeName = const Value.absent(),
                Value<int> lectureDurationMins = const Value.absent(),
                Value<String> firstLectureStart = const Value.absent(),
                Value<String> breakStart = const Value.absent(),
                Value<String> breakEnd = const Value.absent(),
              }) => LectureScheduleConfigCompanion.insert(
                id: id,
                collegeName: collegeName,
                lectureDurationMins: lectureDurationMins,
                firstLectureStart: firstLectureStart,
                breakStart: breakStart,
                breakEnd: breakEnd,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LectureScheduleConfigTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LectureScheduleConfigTable,
      LectureScheduleConfigData,
      $$LectureScheduleConfigTableFilterComposer,
      $$LectureScheduleConfigTableOrderingComposer,
      $$LectureScheduleConfigTableAnnotationComposer,
      $$LectureScheduleConfigTableCreateCompanionBuilder,
      $$LectureScheduleConfigTableUpdateCompanionBuilder,
      (
        LectureScheduleConfigData,
        BaseReferences<
          _$AppDatabase,
          $LectureScheduleConfigTable,
          LectureScheduleConfigData
        >,
      ),
      LectureScheduleConfigData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$TimetableSlotsTableTableManager get timetableSlots =>
      $$TimetableSlotsTableTableManager(_db, _db.timetableSlots);
  $$ClassSessionsTableTableManager get classSessions =>
      $$ClassSessionsTableTableManager(_db, _db.classSessions);
  $$DeadlinesTableTableManager get deadlines =>
      $$DeadlinesTableTableManager(_db, _db.deadlines);
  $$LectureScheduleConfigTableTableManager get lectureScheduleConfig =>
      $$LectureScheduleConfigTableTableManager(_db, _db.lectureScheduleConfig);
}
