// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MeasurementUnit, String>
  defaultUnit = GeneratedColumn<String>(
    'default_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<MeasurementUnit>($IngredientsTable.$converterdefaultUnit);
  @override
  List<GeneratedColumn> get $columns => [id, name, category, defaultUnit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ingredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      defaultUnit: $IngredientsTable.$converterdefaultUnit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}default_unit'],
        )!,
      ),
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MeasurementUnit, String, String>
  $converterdefaultUnit = const EnumNameConverter<MeasurementUnit>(
    MeasurementUnit.values,
  );
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final String id;
  final String name;

  /// Loose grouping (e.g. "spice", "vegetable", "dal") — informational.
  final String? category;

  /// The unit this ingredient is normally measured in.
  final MeasurementUnit defaultUnit;
  const Ingredient({
    required this.id,
    required this.name,
    this.category,
    required this.defaultUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    {
      map['default_unit'] = Variable<String>(
        $IngredientsTable.$converterdefaultUnit.toSql(defaultUnit),
      );
    }
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      defaultUnit: Value(defaultUnit),
    );
  }

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      defaultUnit: $IngredientsTable.$converterdefaultUnit.fromJson(
        serializer.fromJson<String>(json['defaultUnit']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'defaultUnit': serializer.toJson<String>(
        $IngredientsTable.$converterdefaultUnit.toJson(defaultUnit),
      ),
    };
  }

  Ingredient copyWith({
    String? id,
    String? name,
    Value<String?> category = const Value.absent(),
    MeasurementUnit? defaultUnit,
  }) => Ingredient(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    defaultUnit: defaultUnit ?? this.defaultUnit,
  );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      defaultUnit: data.defaultUnit.present
          ? data.defaultUnit.value
          : this.defaultUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('defaultUnit: $defaultUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, defaultUnit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.defaultUnit == this.defaultUnit);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> category;
  final Value<MeasurementUnit> defaultUnit;
  final Value<int> rowid;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientsCompanion.insert({
    required String id,
    required String name,
    this.category = const Value.absent(),
    required MeasurementUnit defaultUnit,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       defaultUnit = Value(defaultUnit);
  static Insertable<Ingredient> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? defaultUnit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? category,
    Value<MeasurementUnit>? defaultUnit,
    Value<int>? rowid,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(
        $IngredientsTable.$converterdefaultUnit.toSql(defaultUnit.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquipmentTable extends Equipment
    with TableInfo<$EquipmentTable, EquipmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $EquipmentTable createAlias(String alias) {
    return $EquipmentTable(attachedDatabase, alias);
  }
}

class EquipmentData extends DataClass implements Insertable<EquipmentData> {
  final String id;
  final String name;
  const EquipmentData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  EquipmentCompanion toCompanion(bool nullToAbsent) {
    return EquipmentCompanion(id: Value(id), name: Value(name));
  }

  factory EquipmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  EquipmentData copyWith({String? id, String? name}) =>
      EquipmentData(id: id ?? this.id, name: name ?? this.name);
  EquipmentData copyWithCompanion(EquipmentCompanion data) {
    return EquipmentData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentData &&
          other.id == this.id &&
          other.name == this.name);
}

class EquipmentCompanion extends UpdateCompanion<EquipmentData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const EquipmentCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EquipmentCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<EquipmentData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EquipmentCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return EquipmentCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientSubstitutionsTable extends IngredientSubstitutions
    with TableInfo<$IngredientSubstitutionsTable, IngredientSubstitution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientSubstitutionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alternativeIngredientIdMeta =
      const VerificationMeta('alternativeIngredientId');
  @override
  late final GeneratedColumn<String> alternativeIngredientId =
      GeneratedColumn<String>(
        'alternative_ingredient_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _qualityRatioMeta = const VerificationMeta(
    'qualityRatio',
  );
  @override
  late final GeneratedColumn<double> qualityRatio = GeneratedColumn<double>(
    'quality_ratio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
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
    ingredientId,
    alternativeIngredientId,
    qualityRatio,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_substitutions';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientSubstitution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('alternative_ingredient_id')) {
      context.handle(
        _alternativeIngredientIdMeta,
        alternativeIngredientId.isAcceptableOrUnknown(
          data['alternative_ingredient_id']!,
          _alternativeIngredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_alternativeIngredientIdMeta);
    }
    if (data.containsKey('quality_ratio')) {
      context.handle(
        _qualityRatioMeta,
        qualityRatio.isAcceptableOrUnknown(
          data['quality_ratio']!,
          _qualityRatioMeta,
        ),
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
  IngredientSubstitution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientSubstitution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      alternativeIngredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alternative_ingredient_id'],
      )!,
      qualityRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quality_ratio'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $IngredientSubstitutionsTable createAlias(String alias) {
    return $IngredientSubstitutionsTable(attachedDatabase, alias);
  }
}

class IngredientSubstitution extends DataClass
    implements Insertable<IngredientSubstitution> {
  final String id;
  final String ingredientId;
  final String alternativeIngredientId;
  final double qualityRatio;
  final String? note;
  const IngredientSubstitution({
    required this.id,
    required this.ingredientId,
    required this.alternativeIngredientId,
    required this.qualityRatio,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['alternative_ingredient_id'] = Variable<String>(
      alternativeIngredientId,
    );
    map['quality_ratio'] = Variable<double>(qualityRatio);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  IngredientSubstitutionsCompanion toCompanion(bool nullToAbsent) {
    return IngredientSubstitutionsCompanion(
      id: Value(id),
      ingredientId: Value(ingredientId),
      alternativeIngredientId: Value(alternativeIngredientId),
      qualityRatio: Value(qualityRatio),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory IngredientSubstitution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientSubstitution(
      id: serializer.fromJson<String>(json['id']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      alternativeIngredientId: serializer.fromJson<String>(
        json['alternativeIngredientId'],
      ),
      qualityRatio: serializer.fromJson<double>(json['qualityRatio']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'alternativeIngredientId': serializer.toJson<String>(
        alternativeIngredientId,
      ),
      'qualityRatio': serializer.toJson<double>(qualityRatio),
      'note': serializer.toJson<String?>(note),
    };
  }

  IngredientSubstitution copyWith({
    String? id,
    String? ingredientId,
    String? alternativeIngredientId,
    double? qualityRatio,
    Value<String?> note = const Value.absent(),
  }) => IngredientSubstitution(
    id: id ?? this.id,
    ingredientId: ingredientId ?? this.ingredientId,
    alternativeIngredientId:
        alternativeIngredientId ?? this.alternativeIngredientId,
    qualityRatio: qualityRatio ?? this.qualityRatio,
    note: note.present ? note.value : this.note,
  );
  IngredientSubstitution copyWithCompanion(
    IngredientSubstitutionsCompanion data,
  ) {
    return IngredientSubstitution(
      id: data.id.present ? data.id.value : this.id,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      alternativeIngredientId: data.alternativeIngredientId.present
          ? data.alternativeIngredientId.value
          : this.alternativeIngredientId,
      qualityRatio: data.qualityRatio.present
          ? data.qualityRatio.value
          : this.qualityRatio,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientSubstitution(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('alternativeIngredientId: $alternativeIngredientId, ')
          ..write('qualityRatio: $qualityRatio, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ingredientId,
    alternativeIngredientId,
    qualityRatio,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientSubstitution &&
          other.id == this.id &&
          other.ingredientId == this.ingredientId &&
          other.alternativeIngredientId == this.alternativeIngredientId &&
          other.qualityRatio == this.qualityRatio &&
          other.note == this.note);
}

class IngredientSubstitutionsCompanion
    extends UpdateCompanion<IngredientSubstitution> {
  final Value<String> id;
  final Value<String> ingredientId;
  final Value<String> alternativeIngredientId;
  final Value<double> qualityRatio;
  final Value<String?> note;
  final Value<int> rowid;
  const IngredientSubstitutionsCompanion({
    this.id = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.alternativeIngredientId = const Value.absent(),
    this.qualityRatio = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientSubstitutionsCompanion.insert({
    required String id,
    required String ingredientId,
    required String alternativeIngredientId,
    this.qualityRatio = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ingredientId = Value(ingredientId),
       alternativeIngredientId = Value(alternativeIngredientId);
  static Insertable<IngredientSubstitution> custom({
    Expression<String>? id,
    Expression<String>? ingredientId,
    Expression<String>? alternativeIngredientId,
    Expression<double>? qualityRatio,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (alternativeIngredientId != null)
        'alternative_ingredient_id': alternativeIngredientId,
      if (qualityRatio != null) 'quality_ratio': qualityRatio,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientSubstitutionsCompanion copyWith({
    Value<String>? id,
    Value<String>? ingredientId,
    Value<String>? alternativeIngredientId,
    Value<double>? qualityRatio,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return IngredientSubstitutionsCompanion(
      id: id ?? this.id,
      ingredientId: ingredientId ?? this.ingredientId,
      alternativeIngredientId:
          alternativeIngredientId ?? this.alternativeIngredientId,
      qualityRatio: qualityRatio ?? this.qualityRatio,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (alternativeIngredientId.present) {
      map['alternative_ingredient_id'] = Variable<String>(
        alternativeIngredientId.value,
      );
    }
    if (qualityRatio.present) {
      map['quality_ratio'] = Variable<double>(qualityRatio.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientSubstitutionsCompanion(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('alternativeIngredientId: $alternativeIngredientId, ')
          ..write('qualityRatio: $qualityRatio, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquipmentSubstitutionsTable extends EquipmentSubstitutions
    with TableInfo<$EquipmentSubstitutionsTable, EquipmentSubstitution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentSubstitutionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<String> equipmentId = GeneratedColumn<String>(
    'equipment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alternativeEquipmentIdMeta =
      const VerificationMeta('alternativeEquipmentId');
  @override
  late final GeneratedColumn<String> alternativeEquipmentId =
      GeneratedColumn<String>(
        'alternative_equipment_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
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
    equipmentId,
    alternativeEquipmentId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_substitutions';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentSubstitution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    if (data.containsKey('alternative_equipment_id')) {
      context.handle(
        _alternativeEquipmentIdMeta,
        alternativeEquipmentId.isAcceptableOrUnknown(
          data['alternative_equipment_id']!,
          _alternativeEquipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_alternativeEquipmentIdMeta);
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
  EquipmentSubstitution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentSubstitution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_id'],
      )!,
      alternativeEquipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alternative_equipment_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $EquipmentSubstitutionsTable createAlias(String alias) {
    return $EquipmentSubstitutionsTable(attachedDatabase, alias);
  }
}

class EquipmentSubstitution extends DataClass
    implements Insertable<EquipmentSubstitution> {
  final String id;
  final String equipmentId;
  final String alternativeEquipmentId;
  final String? note;
  const EquipmentSubstitution({
    required this.id,
    required this.equipmentId,
    required this.alternativeEquipmentId,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['equipment_id'] = Variable<String>(equipmentId);
    map['alternative_equipment_id'] = Variable<String>(alternativeEquipmentId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  EquipmentSubstitutionsCompanion toCompanion(bool nullToAbsent) {
    return EquipmentSubstitutionsCompanion(
      id: Value(id),
      equipmentId: Value(equipmentId),
      alternativeEquipmentId: Value(alternativeEquipmentId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory EquipmentSubstitution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentSubstitution(
      id: serializer.fromJson<String>(json['id']),
      equipmentId: serializer.fromJson<String>(json['equipmentId']),
      alternativeEquipmentId: serializer.fromJson<String>(
        json['alternativeEquipmentId'],
      ),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'equipmentId': serializer.toJson<String>(equipmentId),
      'alternativeEquipmentId': serializer.toJson<String>(
        alternativeEquipmentId,
      ),
      'note': serializer.toJson<String?>(note),
    };
  }

  EquipmentSubstitution copyWith({
    String? id,
    String? equipmentId,
    String? alternativeEquipmentId,
    Value<String?> note = const Value.absent(),
  }) => EquipmentSubstitution(
    id: id ?? this.id,
    equipmentId: equipmentId ?? this.equipmentId,
    alternativeEquipmentId:
        alternativeEquipmentId ?? this.alternativeEquipmentId,
    note: note.present ? note.value : this.note,
  );
  EquipmentSubstitution copyWithCompanion(
    EquipmentSubstitutionsCompanion data,
  ) {
    return EquipmentSubstitution(
      id: data.id.present ? data.id.value : this.id,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
      alternativeEquipmentId: data.alternativeEquipmentId.present
          ? data.alternativeEquipmentId.value
          : this.alternativeEquipmentId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentSubstitution(')
          ..write('id: $id, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('alternativeEquipmentId: $alternativeEquipmentId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, equipmentId, alternativeEquipmentId, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentSubstitution &&
          other.id == this.id &&
          other.equipmentId == this.equipmentId &&
          other.alternativeEquipmentId == this.alternativeEquipmentId &&
          other.note == this.note);
}

class EquipmentSubstitutionsCompanion
    extends UpdateCompanion<EquipmentSubstitution> {
  final Value<String> id;
  final Value<String> equipmentId;
  final Value<String> alternativeEquipmentId;
  final Value<String?> note;
  final Value<int> rowid;
  const EquipmentSubstitutionsCompanion({
    this.id = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.alternativeEquipmentId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EquipmentSubstitutionsCompanion.insert({
    required String id,
    required String equipmentId,
    required String alternativeEquipmentId,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       equipmentId = Value(equipmentId),
       alternativeEquipmentId = Value(alternativeEquipmentId);
  static Insertable<EquipmentSubstitution> custom({
    Expression<String>? id,
    Expression<String>? equipmentId,
    Expression<String>? alternativeEquipmentId,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (alternativeEquipmentId != null)
        'alternative_equipment_id': alternativeEquipmentId,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EquipmentSubstitutionsCompanion copyWith({
    Value<String>? id,
    Value<String>? equipmentId,
    Value<String>? alternativeEquipmentId,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return EquipmentSubstitutionsCompanion(
      id: id ?? this.id,
      equipmentId: equipmentId ?? this.equipmentId,
      alternativeEquipmentId:
          alternativeEquipmentId ?? this.alternativeEquipmentId,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<String>(equipmentId.value);
    }
    if (alternativeEquipmentId.present) {
      map['alternative_equipment_id'] = Variable<String>(
        alternativeEquipmentId.value,
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentSubstitutionsCompanion(')
          ..write('id: $id, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('alternativeEquipmentId: $alternativeEquipmentId, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientStockPoliciesTable extends IngredientStockPolicies
    with TableInfo<$IngredientStockPoliciesTable, IngredientStockPolicy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientStockPoliciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parQuantityMeta = const VerificationMeta(
    'parQuantity',
  );
  @override
  late final GeneratedColumn<double> parQuantity = GeneratedColumn<double>(
    'par_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MeasurementUnit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MeasurementUnit>(
        $IngredientStockPoliciesTable.$converterunit,
      );
  static const VerificationMeta _thresholdPercentMeta = const VerificationMeta(
    'thresholdPercent',
  );
  @override
  late final GeneratedColumn<double> thresholdPercent = GeneratedColumn<double>(
    'threshold_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _isCoreMeta = const VerificationMeta('isCore');
  @override
  late final GeneratedColumn<bool> isCore = GeneratedColumn<bool>(
    'is_core',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_core" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    ingredientId,
    parQuantity,
    unit,
    thresholdPercent,
    isCore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_stock_policies';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientStockPolicy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('par_quantity')) {
      context.handle(
        _parQuantityMeta,
        parQuantity.isAcceptableOrUnknown(
          data['par_quantity']!,
          _parQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parQuantityMeta);
    }
    if (data.containsKey('threshold_percent')) {
      context.handle(
        _thresholdPercentMeta,
        thresholdPercent.isAcceptableOrUnknown(
          data['threshold_percent']!,
          _thresholdPercentMeta,
        ),
      );
    }
    if (data.containsKey('is_core')) {
      context.handle(
        _isCoreMeta,
        isCore.isAcceptableOrUnknown(data['is_core']!, _isCoreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ingredientId};
  @override
  IngredientStockPolicy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientStockPolicy(
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      parQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}par_quantity'],
      )!,
      unit: $IngredientStockPoliciesTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      thresholdPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold_percent'],
      )!,
      isCore: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_core'],
      )!,
    );
  }

  @override
  $IngredientStockPoliciesTable createAlias(String alias) {
    return $IngredientStockPoliciesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MeasurementUnit, String, String> $converterunit =
      const EnumNameConverter<MeasurementUnit>(MeasurementUnit.values);
}

class IngredientStockPolicy extends DataClass
    implements Insertable<IngredientStockPolicy> {
  final String ingredientId;

  /// Desired "full" stock level; restock triggers below
  /// [thresholdPercent]% of this.
  final double parQuantity;
  final MeasurementUnit unit;
  final double thresholdPercent;

  /// Core staples get proactive low-stock reminders.
  final bool isCore;
  const IngredientStockPolicy({
    required this.ingredientId,
    required this.parQuantity,
    required this.unit,
    required this.thresholdPercent,
    required this.isCore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['par_quantity'] = Variable<double>(parQuantity);
    {
      map['unit'] = Variable<String>(
        $IngredientStockPoliciesTable.$converterunit.toSql(unit),
      );
    }
    map['threshold_percent'] = Variable<double>(thresholdPercent);
    map['is_core'] = Variable<bool>(isCore);
    return map;
  }

  IngredientStockPoliciesCompanion toCompanion(bool nullToAbsent) {
    return IngredientStockPoliciesCompanion(
      ingredientId: Value(ingredientId),
      parQuantity: Value(parQuantity),
      unit: Value(unit),
      thresholdPercent: Value(thresholdPercent),
      isCore: Value(isCore),
    );
  }

  factory IngredientStockPolicy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientStockPolicy(
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      parQuantity: serializer.fromJson<double>(json['parQuantity']),
      unit: $IngredientStockPoliciesTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      thresholdPercent: serializer.fromJson<double>(json['thresholdPercent']),
      isCore: serializer.fromJson<bool>(json['isCore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ingredientId': serializer.toJson<String>(ingredientId),
      'parQuantity': serializer.toJson<double>(parQuantity),
      'unit': serializer.toJson<String>(
        $IngredientStockPoliciesTable.$converterunit.toJson(unit),
      ),
      'thresholdPercent': serializer.toJson<double>(thresholdPercent),
      'isCore': serializer.toJson<bool>(isCore),
    };
  }

  IngredientStockPolicy copyWith({
    String? ingredientId,
    double? parQuantity,
    MeasurementUnit? unit,
    double? thresholdPercent,
    bool? isCore,
  }) => IngredientStockPolicy(
    ingredientId: ingredientId ?? this.ingredientId,
    parQuantity: parQuantity ?? this.parQuantity,
    unit: unit ?? this.unit,
    thresholdPercent: thresholdPercent ?? this.thresholdPercent,
    isCore: isCore ?? this.isCore,
  );
  IngredientStockPolicy copyWithCompanion(
    IngredientStockPoliciesCompanion data,
  ) {
    return IngredientStockPolicy(
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      parQuantity: data.parQuantity.present
          ? data.parQuantity.value
          : this.parQuantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      thresholdPercent: data.thresholdPercent.present
          ? data.thresholdPercent.value
          : this.thresholdPercent,
      isCore: data.isCore.present ? data.isCore.value : this.isCore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientStockPolicy(')
          ..write('ingredientId: $ingredientId, ')
          ..write('parQuantity: $parQuantity, ')
          ..write('unit: $unit, ')
          ..write('thresholdPercent: $thresholdPercent, ')
          ..write('isCore: $isCore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(ingredientId, parQuantity, unit, thresholdPercent, isCore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientStockPolicy &&
          other.ingredientId == this.ingredientId &&
          other.parQuantity == this.parQuantity &&
          other.unit == this.unit &&
          other.thresholdPercent == this.thresholdPercent &&
          other.isCore == this.isCore);
}

class IngredientStockPoliciesCompanion
    extends UpdateCompanion<IngredientStockPolicy> {
  final Value<String> ingredientId;
  final Value<double> parQuantity;
  final Value<MeasurementUnit> unit;
  final Value<double> thresholdPercent;
  final Value<bool> isCore;
  final Value<int> rowid;
  const IngredientStockPoliciesCompanion({
    this.ingredientId = const Value.absent(),
    this.parQuantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.thresholdPercent = const Value.absent(),
    this.isCore = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientStockPoliciesCompanion.insert({
    required String ingredientId,
    required double parQuantity,
    required MeasurementUnit unit,
    this.thresholdPercent = const Value.absent(),
    this.isCore = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ingredientId = Value(ingredientId),
       parQuantity = Value(parQuantity),
       unit = Value(unit);
  static Insertable<IngredientStockPolicy> custom({
    Expression<String>? ingredientId,
    Expression<double>? parQuantity,
    Expression<String>? unit,
    Expression<double>? thresholdPercent,
    Expression<bool>? isCore,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (parQuantity != null) 'par_quantity': parQuantity,
      if (unit != null) 'unit': unit,
      if (thresholdPercent != null) 'threshold_percent': thresholdPercent,
      if (isCore != null) 'is_core': isCore,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientStockPoliciesCompanion copyWith({
    Value<String>? ingredientId,
    Value<double>? parQuantity,
    Value<MeasurementUnit>? unit,
    Value<double>? thresholdPercent,
    Value<bool>? isCore,
    Value<int>? rowid,
  }) {
    return IngredientStockPoliciesCompanion(
      ingredientId: ingredientId ?? this.ingredientId,
      parQuantity: parQuantity ?? this.parQuantity,
      unit: unit ?? this.unit,
      thresholdPercent: thresholdPercent ?? this.thresholdPercent,
      isCore: isCore ?? this.isCore,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (parQuantity.present) {
      map['par_quantity'] = Variable<double>(parQuantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $IngredientStockPoliciesTable.$converterunit.toSql(unit.value),
      );
    }
    if (thresholdPercent.present) {
      map['threshold_percent'] = Variable<double>(thresholdPercent.value);
    }
    if (isCore.present) {
      map['is_core'] = Variable<bool>(isCore.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientStockPoliciesCompanion(')
          ..write('ingredientId: $ingredientId, ')
          ..write('parQuantity: $parQuantity, ')
          ..write('unit: $unit, ')
          ..write('thresholdPercent: $thresholdPercent, ')
          ..write('isCore: $isCore, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CuisineRegion, String> cuisine =
      GeneratedColumn<String>(
        'cuisine',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CuisineRegion>($RecipesTable.$convertercuisine);
  @override
  late final GeneratedColumnWithTypeConverter<MealType, String> mealType =
      GeneratedColumn<String>(
        'meal_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MealType>($RecipesTable.$convertermealType);
  static const VerificationMeta _baseServingsMeta = const VerificationMeta(
    'baseServings',
  );
  @override
  late final GeneratedColumn<int> baseServings = GeneratedColumn<int>(
    'base_servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _prepTimeMinutesMeta = const VerificationMeta(
    'prepTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> prepTimeMinutes = GeneratedColumn<int>(
    'prep_time_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookTimeMinutesMeta = const VerificationMeta(
    'cookTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> cookTimeMinutes = GeneratedColumn<int>(
    'cook_time_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageAssetPathMeta = const VerificationMeta(
    'imageAssetPath',
  );
  @override
  late final GeneratedColumn<String> imageAssetPath = GeneratedColumn<String>(
    'image_asset_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesPerServingMeta =
      const VerificationMeta('caloriesPerServing');
  @override
  late final GeneratedColumn<double> caloriesPerServing =
      GeneratedColumn<double>(
        'calories_per_serving',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _proteinGramsMeta = const VerificationMeta(
    'proteinGrams',
  );
  @override
  late final GeneratedColumn<double> proteinGrams = GeneratedColumn<double>(
    'protein_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsGramsMeta = const VerificationMeta(
    'carbsGrams',
  );
  @override
  late final GeneratedColumn<double> carbsGrams = GeneratedColumn<double>(
    'carbs_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatGramsMeta = const VerificationMeta(
    'fatGrams',
  );
  @override
  late final GeneratedColumn<double> fatGrams = GeneratedColumn<double>(
    'fat_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fiberGramsMeta = const VerificationMeta(
    'fiberGrams',
  );
  @override
  late final GeneratedColumn<double> fiberGrams = GeneratedColumn<double>(
    'fiber_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVegetarianMeta = const VerificationMeta(
    'isVegetarian',
  );
  @override
  late final GeneratedColumn<bool> isVegetarian = GeneratedColumn<bool>(
    'is_vegetarian',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_vegetarian" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isUserCreatedMeta = const VerificationMeta(
    'isUserCreated',
  );
  @override
  late final GeneratedColumn<bool> isUserCreated = GeneratedColumn<bool>(
    'is_user_created',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_user_created" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    cuisine,
    mealType,
    baseServings,
    prepTimeMinutes,
    cookTimeMinutes,
    imageAssetPath,
    caloriesPerServing,
    proteinGrams,
    carbsGrams,
    fatGrams,
    fiberGrams,
    isVegetarian,
    isUserCreated,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('base_servings')) {
      context.handle(
        _baseServingsMeta,
        baseServings.isAcceptableOrUnknown(
          data['base_servings']!,
          _baseServingsMeta,
        ),
      );
    }
    if (data.containsKey('prep_time_minutes')) {
      context.handle(
        _prepTimeMinutesMeta,
        prepTimeMinutes.isAcceptableOrUnknown(
          data['prep_time_minutes']!,
          _prepTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('cook_time_minutes')) {
      context.handle(
        _cookTimeMinutesMeta,
        cookTimeMinutes.isAcceptableOrUnknown(
          data['cook_time_minutes']!,
          _cookTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('image_asset_path')) {
      context.handle(
        _imageAssetPathMeta,
        imageAssetPath.isAcceptableOrUnknown(
          data['image_asset_path']!,
          _imageAssetPathMeta,
        ),
      );
    }
    if (data.containsKey('calories_per_serving')) {
      context.handle(
        _caloriesPerServingMeta,
        caloriesPerServing.isAcceptableOrUnknown(
          data['calories_per_serving']!,
          _caloriesPerServingMeta,
        ),
      );
    }
    if (data.containsKey('protein_grams')) {
      context.handle(
        _proteinGramsMeta,
        proteinGrams.isAcceptableOrUnknown(
          data['protein_grams']!,
          _proteinGramsMeta,
        ),
      );
    }
    if (data.containsKey('carbs_grams')) {
      context.handle(
        _carbsGramsMeta,
        carbsGrams.isAcceptableOrUnknown(data['carbs_grams']!, _carbsGramsMeta),
      );
    }
    if (data.containsKey('fat_grams')) {
      context.handle(
        _fatGramsMeta,
        fatGrams.isAcceptableOrUnknown(data['fat_grams']!, _fatGramsMeta),
      );
    }
    if (data.containsKey('fiber_grams')) {
      context.handle(
        _fiberGramsMeta,
        fiberGrams.isAcceptableOrUnknown(data['fiber_grams']!, _fiberGramsMeta),
      );
    }
    if (data.containsKey('is_vegetarian')) {
      context.handle(
        _isVegetarianMeta,
        isVegetarian.isAcceptableOrUnknown(
          data['is_vegetarian']!,
          _isVegetarianMeta,
        ),
      );
    }
    if (data.containsKey('is_user_created')) {
      context.handle(
        _isUserCreatedMeta,
        isUserCreated.isAcceptableOrUnknown(
          data['is_user_created']!,
          _isUserCreatedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      cuisine: $RecipesTable.$convertercuisine.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cuisine'],
        )!,
      ),
      mealType: $RecipesTable.$convertermealType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}meal_type'],
        )!,
      ),
      baseServings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_servings'],
      )!,
      prepTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_time_minutes'],
      ),
      cookTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_time_minutes'],
      ),
      imageAssetPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset_path'],
      ),
      caloriesPerServing: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_per_serving'],
      ),
      proteinGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_grams'],
      ),
      carbsGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_grams'],
      ),
      fatGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_grams'],
      ),
      fiberGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_grams'],
      ),
      isVegetarian: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_vegetarian'],
      )!,
      isUserCreated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_user_created'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CuisineRegion, String, String> $convertercuisine =
      const EnumNameConverter<CuisineRegion>(CuisineRegion.values);
  static JsonTypeConverter2<MealType, String, String> $convertermealType =
      const EnumNameConverter<MealType>(MealType.values);
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final String name;
  final String? description;
  final CuisineRegion cuisine;
  final MealType mealType;

  /// Servings the stored quantities correspond to. Recipes are authored
  /// per-person, so this is 1 by default.
  final int baseServings;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final String? imageAssetPath;
  final double? caloriesPerServing;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
  final double? fiberGrams;
  final bool isVegetarian;
  final bool isUserCreated;
  final DateTime createdAt;
  const Recipe({
    required this.id,
    required this.name,
    this.description,
    required this.cuisine,
    required this.mealType,
    required this.baseServings,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.imageAssetPath,
    this.caloriesPerServing,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
    this.fiberGrams,
    required this.isVegetarian,
    required this.isUserCreated,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['cuisine'] = Variable<String>(
        $RecipesTable.$convertercuisine.toSql(cuisine),
      );
    }
    {
      map['meal_type'] = Variable<String>(
        $RecipesTable.$convertermealType.toSql(mealType),
      );
    }
    map['base_servings'] = Variable<int>(baseServings);
    if (!nullToAbsent || prepTimeMinutes != null) {
      map['prep_time_minutes'] = Variable<int>(prepTimeMinutes);
    }
    if (!nullToAbsent || cookTimeMinutes != null) {
      map['cook_time_minutes'] = Variable<int>(cookTimeMinutes);
    }
    if (!nullToAbsent || imageAssetPath != null) {
      map['image_asset_path'] = Variable<String>(imageAssetPath);
    }
    if (!nullToAbsent || caloriesPerServing != null) {
      map['calories_per_serving'] = Variable<double>(caloriesPerServing);
    }
    if (!nullToAbsent || proteinGrams != null) {
      map['protein_grams'] = Variable<double>(proteinGrams);
    }
    if (!nullToAbsent || carbsGrams != null) {
      map['carbs_grams'] = Variable<double>(carbsGrams);
    }
    if (!nullToAbsent || fatGrams != null) {
      map['fat_grams'] = Variable<double>(fatGrams);
    }
    if (!nullToAbsent || fiberGrams != null) {
      map['fiber_grams'] = Variable<double>(fiberGrams);
    }
    map['is_vegetarian'] = Variable<bool>(isVegetarian);
    map['is_user_created'] = Variable<bool>(isUserCreated);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      cuisine: Value(cuisine),
      mealType: Value(mealType),
      baseServings: Value(baseServings),
      prepTimeMinutes: prepTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(prepTimeMinutes),
      cookTimeMinutes: cookTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(cookTimeMinutes),
      imageAssetPath: imageAssetPath == null && nullToAbsent
          ? const Value.absent()
          : Value(imageAssetPath),
      caloriesPerServing: caloriesPerServing == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesPerServing),
      proteinGrams: proteinGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinGrams),
      carbsGrams: carbsGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsGrams),
      fatGrams: fatGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(fatGrams),
      fiberGrams: fiberGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(fiberGrams),
      isVegetarian: Value(isVegetarian),
      isUserCreated: Value(isUserCreated),
      createdAt: Value(createdAt),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      cuisine: $RecipesTable.$convertercuisine.fromJson(
        serializer.fromJson<String>(json['cuisine']),
      ),
      mealType: $RecipesTable.$convertermealType.fromJson(
        serializer.fromJson<String>(json['mealType']),
      ),
      baseServings: serializer.fromJson<int>(json['baseServings']),
      prepTimeMinutes: serializer.fromJson<int?>(json['prepTimeMinutes']),
      cookTimeMinutes: serializer.fromJson<int?>(json['cookTimeMinutes']),
      imageAssetPath: serializer.fromJson<String?>(json['imageAssetPath']),
      caloriesPerServing: serializer.fromJson<double?>(
        json['caloriesPerServing'],
      ),
      proteinGrams: serializer.fromJson<double?>(json['proteinGrams']),
      carbsGrams: serializer.fromJson<double?>(json['carbsGrams']),
      fatGrams: serializer.fromJson<double?>(json['fatGrams']),
      fiberGrams: serializer.fromJson<double?>(json['fiberGrams']),
      isVegetarian: serializer.fromJson<bool>(json['isVegetarian']),
      isUserCreated: serializer.fromJson<bool>(json['isUserCreated']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'cuisine': serializer.toJson<String>(
        $RecipesTable.$convertercuisine.toJson(cuisine),
      ),
      'mealType': serializer.toJson<String>(
        $RecipesTable.$convertermealType.toJson(mealType),
      ),
      'baseServings': serializer.toJson<int>(baseServings),
      'prepTimeMinutes': serializer.toJson<int?>(prepTimeMinutes),
      'cookTimeMinutes': serializer.toJson<int?>(cookTimeMinutes),
      'imageAssetPath': serializer.toJson<String?>(imageAssetPath),
      'caloriesPerServing': serializer.toJson<double?>(caloriesPerServing),
      'proteinGrams': serializer.toJson<double?>(proteinGrams),
      'carbsGrams': serializer.toJson<double?>(carbsGrams),
      'fatGrams': serializer.toJson<double?>(fatGrams),
      'fiberGrams': serializer.toJson<double?>(fiberGrams),
      'isVegetarian': serializer.toJson<bool>(isVegetarian),
      'isUserCreated': serializer.toJson<bool>(isUserCreated),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Recipe copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    CuisineRegion? cuisine,
    MealType? mealType,
    int? baseServings,
    Value<int?> prepTimeMinutes = const Value.absent(),
    Value<int?> cookTimeMinutes = const Value.absent(),
    Value<String?> imageAssetPath = const Value.absent(),
    Value<double?> caloriesPerServing = const Value.absent(),
    Value<double?> proteinGrams = const Value.absent(),
    Value<double?> carbsGrams = const Value.absent(),
    Value<double?> fatGrams = const Value.absent(),
    Value<double?> fiberGrams = const Value.absent(),
    bool? isVegetarian,
    bool? isUserCreated,
    DateTime? createdAt,
  }) => Recipe(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    cuisine: cuisine ?? this.cuisine,
    mealType: mealType ?? this.mealType,
    baseServings: baseServings ?? this.baseServings,
    prepTimeMinutes: prepTimeMinutes.present
        ? prepTimeMinutes.value
        : this.prepTimeMinutes,
    cookTimeMinutes: cookTimeMinutes.present
        ? cookTimeMinutes.value
        : this.cookTimeMinutes,
    imageAssetPath: imageAssetPath.present
        ? imageAssetPath.value
        : this.imageAssetPath,
    caloriesPerServing: caloriesPerServing.present
        ? caloriesPerServing.value
        : this.caloriesPerServing,
    proteinGrams: proteinGrams.present ? proteinGrams.value : this.proteinGrams,
    carbsGrams: carbsGrams.present ? carbsGrams.value : this.carbsGrams,
    fatGrams: fatGrams.present ? fatGrams.value : this.fatGrams,
    fiberGrams: fiberGrams.present ? fiberGrams.value : this.fiberGrams,
    isVegetarian: isVegetarian ?? this.isVegetarian,
    isUserCreated: isUserCreated ?? this.isUserCreated,
    createdAt: createdAt ?? this.createdAt,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      cuisine: data.cuisine.present ? data.cuisine.value : this.cuisine,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      baseServings: data.baseServings.present
          ? data.baseServings.value
          : this.baseServings,
      prepTimeMinutes: data.prepTimeMinutes.present
          ? data.prepTimeMinutes.value
          : this.prepTimeMinutes,
      cookTimeMinutes: data.cookTimeMinutes.present
          ? data.cookTimeMinutes.value
          : this.cookTimeMinutes,
      imageAssetPath: data.imageAssetPath.present
          ? data.imageAssetPath.value
          : this.imageAssetPath,
      caloriesPerServing: data.caloriesPerServing.present
          ? data.caloriesPerServing.value
          : this.caloriesPerServing,
      proteinGrams: data.proteinGrams.present
          ? data.proteinGrams.value
          : this.proteinGrams,
      carbsGrams: data.carbsGrams.present
          ? data.carbsGrams.value
          : this.carbsGrams,
      fatGrams: data.fatGrams.present ? data.fatGrams.value : this.fatGrams,
      fiberGrams: data.fiberGrams.present
          ? data.fiberGrams.value
          : this.fiberGrams,
      isVegetarian: data.isVegetarian.present
          ? data.isVegetarian.value
          : this.isVegetarian,
      isUserCreated: data.isUserCreated.present
          ? data.isUserCreated.value
          : this.isUserCreated,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('cuisine: $cuisine, ')
          ..write('mealType: $mealType, ')
          ..write('baseServings: $baseServings, ')
          ..write('prepTimeMinutes: $prepTimeMinutes, ')
          ..write('cookTimeMinutes: $cookTimeMinutes, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('caloriesPerServing: $caloriesPerServing, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('fiberGrams: $fiberGrams, ')
          ..write('isVegetarian: $isVegetarian, ')
          ..write('isUserCreated: $isUserCreated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    cuisine,
    mealType,
    baseServings,
    prepTimeMinutes,
    cookTimeMinutes,
    imageAssetPath,
    caloriesPerServing,
    proteinGrams,
    carbsGrams,
    fatGrams,
    fiberGrams,
    isVegetarian,
    isUserCreated,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.cuisine == this.cuisine &&
          other.mealType == this.mealType &&
          other.baseServings == this.baseServings &&
          other.prepTimeMinutes == this.prepTimeMinutes &&
          other.cookTimeMinutes == this.cookTimeMinutes &&
          other.imageAssetPath == this.imageAssetPath &&
          other.caloriesPerServing == this.caloriesPerServing &&
          other.proteinGrams == this.proteinGrams &&
          other.carbsGrams == this.carbsGrams &&
          other.fatGrams == this.fatGrams &&
          other.fiberGrams == this.fiberGrams &&
          other.isVegetarian == this.isVegetarian &&
          other.isUserCreated == this.isUserCreated &&
          other.createdAt == this.createdAt);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<CuisineRegion> cuisine;
  final Value<MealType> mealType;
  final Value<int> baseServings;
  final Value<int?> prepTimeMinutes;
  final Value<int?> cookTimeMinutes;
  final Value<String?> imageAssetPath;
  final Value<double?> caloriesPerServing;
  final Value<double?> proteinGrams;
  final Value<double?> carbsGrams;
  final Value<double?> fatGrams;
  final Value<double?> fiberGrams;
  final Value<bool> isVegetarian;
  final Value<bool> isUserCreated;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.cuisine = const Value.absent(),
    this.mealType = const Value.absent(),
    this.baseServings = const Value.absent(),
    this.prepTimeMinutes = const Value.absent(),
    this.cookTimeMinutes = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
    this.caloriesPerServing = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.fiberGrams = const Value.absent(),
    this.isVegetarian = const Value.absent(),
    this.isUserCreated = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required CuisineRegion cuisine,
    required MealType mealType,
    this.baseServings = const Value.absent(),
    this.prepTimeMinutes = const Value.absent(),
    this.cookTimeMinutes = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
    this.caloriesPerServing = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.fiberGrams = const Value.absent(),
    this.isVegetarian = const Value.absent(),
    this.isUserCreated = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       cuisine = Value(cuisine),
       mealType = Value(mealType),
       createdAt = Value(createdAt);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? cuisine,
    Expression<String>? mealType,
    Expression<int>? baseServings,
    Expression<int>? prepTimeMinutes,
    Expression<int>? cookTimeMinutes,
    Expression<String>? imageAssetPath,
    Expression<double>? caloriesPerServing,
    Expression<double>? proteinGrams,
    Expression<double>? carbsGrams,
    Expression<double>? fatGrams,
    Expression<double>? fiberGrams,
    Expression<bool>? isVegetarian,
    Expression<bool>? isUserCreated,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (cuisine != null) 'cuisine': cuisine,
      if (mealType != null) 'meal_type': mealType,
      if (baseServings != null) 'base_servings': baseServings,
      if (prepTimeMinutes != null) 'prep_time_minutes': prepTimeMinutes,
      if (cookTimeMinutes != null) 'cook_time_minutes': cookTimeMinutes,
      if (imageAssetPath != null) 'image_asset_path': imageAssetPath,
      if (caloriesPerServing != null)
        'calories_per_serving': caloriesPerServing,
      if (proteinGrams != null) 'protein_grams': proteinGrams,
      if (carbsGrams != null) 'carbs_grams': carbsGrams,
      if (fatGrams != null) 'fat_grams': fatGrams,
      if (fiberGrams != null) 'fiber_grams': fiberGrams,
      if (isVegetarian != null) 'is_vegetarian': isVegetarian,
      if (isUserCreated != null) 'is_user_created': isUserCreated,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<CuisineRegion>? cuisine,
    Value<MealType>? mealType,
    Value<int>? baseServings,
    Value<int?>? prepTimeMinutes,
    Value<int?>? cookTimeMinutes,
    Value<String?>? imageAssetPath,
    Value<double?>? caloriesPerServing,
    Value<double?>? proteinGrams,
    Value<double?>? carbsGrams,
    Value<double?>? fatGrams,
    Value<double?>? fiberGrams,
    Value<bool>? isVegetarian,
    Value<bool>? isUserCreated,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cuisine: cuisine ?? this.cuisine,
      mealType: mealType ?? this.mealType,
      baseServings: baseServings ?? this.baseServings,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      fiberGrams: fiberGrams ?? this.fiberGrams,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isUserCreated: isUserCreated ?? this.isUserCreated,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cuisine.present) {
      map['cuisine'] = Variable<String>(
        $RecipesTable.$convertercuisine.toSql(cuisine.value),
      );
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(
        $RecipesTable.$convertermealType.toSql(mealType.value),
      );
    }
    if (baseServings.present) {
      map['base_servings'] = Variable<int>(baseServings.value);
    }
    if (prepTimeMinutes.present) {
      map['prep_time_minutes'] = Variable<int>(prepTimeMinutes.value);
    }
    if (cookTimeMinutes.present) {
      map['cook_time_minutes'] = Variable<int>(cookTimeMinutes.value);
    }
    if (imageAssetPath.present) {
      map['image_asset_path'] = Variable<String>(imageAssetPath.value);
    }
    if (caloriesPerServing.present) {
      map['calories_per_serving'] = Variable<double>(caloriesPerServing.value);
    }
    if (proteinGrams.present) {
      map['protein_grams'] = Variable<double>(proteinGrams.value);
    }
    if (carbsGrams.present) {
      map['carbs_grams'] = Variable<double>(carbsGrams.value);
    }
    if (fatGrams.present) {
      map['fat_grams'] = Variable<double>(fatGrams.value);
    }
    if (fiberGrams.present) {
      map['fiber_grams'] = Variable<double>(fiberGrams.value);
    }
    if (isVegetarian.present) {
      map['is_vegetarian'] = Variable<bool>(isVegetarian.value);
    }
    if (isUserCreated.present) {
      map['is_user_created'] = Variable<bool>(isUserCreated.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('cuisine: $cuisine, ')
          ..write('mealType: $mealType, ')
          ..write('baseServings: $baseServings, ')
          ..write('prepTimeMinutes: $prepTimeMinutes, ')
          ..write('cookTimeMinutes: $cookTimeMinutes, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('caloriesPerServing: $caloriesPerServing, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('fiberGrams: $fiberGrams, ')
          ..write('isVegetarian: $isVegetarian, ')
          ..write('isUserCreated: $isUserCreated, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeIngredientsTable extends RecipeIngredients
    with TableInfo<$RecipeIngredientsTable, RecipeIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityPerServingMeta =
      const VerificationMeta('quantityPerServing');
  @override
  late final GeneratedColumn<double> quantityPerServing =
      GeneratedColumn<double>(
        'quantity_per_serving',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<MeasurementUnit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MeasurementUnit>($RecipeIngredientsTable.$converterunit);
  static const VerificationMeta _isOptionalMeta = const VerificationMeta(
    'isOptional',
  );
  @override
  late final GeneratedColumn<bool> isOptional = GeneratedColumn<bool>(
    'is_optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _preparationNoteMeta = const VerificationMeta(
    'preparationNote',
  );
  @override
  late final GeneratedColumn<String> preparationNote = GeneratedColumn<String>(
    'preparation_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    ingredientId,
    quantityPerServing,
    unit,
    isOptional,
    preparationNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeIngredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity_per_serving')) {
      context.handle(
        _quantityPerServingMeta,
        quantityPerServing.isAcceptableOrUnknown(
          data['quantity_per_serving']!,
          _quantityPerServingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityPerServingMeta);
    }
    if (data.containsKey('is_optional')) {
      context.handle(
        _isOptionalMeta,
        isOptional.isAcceptableOrUnknown(data['is_optional']!, _isOptionalMeta),
      );
    }
    if (data.containsKey('preparation_note')) {
      context.handle(
        _preparationNoteMeta,
        preparationNote.isAcceptableOrUnknown(
          data['preparation_note']!,
          _preparationNoteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeIngredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      quantityPerServing: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_per_serving'],
      )!,
      unit: $RecipeIngredientsTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      isOptional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_optional'],
      )!,
      preparationNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preparation_note'],
      ),
    );
  }

  @override
  $RecipeIngredientsTable createAlias(String alias) {
    return $RecipeIngredientsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MeasurementUnit, String, String> $converterunit =
      const EnumNameConverter<MeasurementUnit>(MeasurementUnit.values);
}

class RecipeIngredient extends DataClass
    implements Insertable<RecipeIngredient> {
  final String id;
  final String recipeId;
  final String ingredientId;

  /// Quantity for a single serving; scaled up by [PortionScaler].
  final double quantityPerServing;
  final MeasurementUnit unit;
  final bool isOptional;

  /// Free-text prep note, e.g. "finely chopped", "soaked 30 min".
  final String? preparationNote;
  const RecipeIngredient({
    required this.id,
    required this.recipeId,
    required this.ingredientId,
    required this.quantityPerServing,
    required this.unit,
    required this.isOptional,
    this.preparationNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['quantity_per_serving'] = Variable<double>(quantityPerServing);
    {
      map['unit'] = Variable<String>(
        $RecipeIngredientsTable.$converterunit.toSql(unit),
      );
    }
    map['is_optional'] = Variable<bool>(isOptional);
    if (!nullToAbsent || preparationNote != null) {
      map['preparation_note'] = Variable<String>(preparationNote);
    }
    return map;
  }

  RecipeIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      ingredientId: Value(ingredientId),
      quantityPerServing: Value(quantityPerServing),
      unit: Value(unit),
      isOptional: Value(isOptional),
      preparationNote: preparationNote == null && nullToAbsent
          ? const Value.absent()
          : Value(preparationNote),
    );
  }

  factory RecipeIngredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeIngredient(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      quantityPerServing: serializer.fromJson<double>(
        json['quantityPerServing'],
      ),
      unit: $RecipeIngredientsTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      isOptional: serializer.fromJson<bool>(json['isOptional']),
      preparationNote: serializer.fromJson<String?>(json['preparationNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'quantityPerServing': serializer.toJson<double>(quantityPerServing),
      'unit': serializer.toJson<String>(
        $RecipeIngredientsTable.$converterunit.toJson(unit),
      ),
      'isOptional': serializer.toJson<bool>(isOptional),
      'preparationNote': serializer.toJson<String?>(preparationNote),
    };
  }

  RecipeIngredient copyWith({
    String? id,
    String? recipeId,
    String? ingredientId,
    double? quantityPerServing,
    MeasurementUnit? unit,
    bool? isOptional,
    Value<String?> preparationNote = const Value.absent(),
  }) => RecipeIngredient(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    ingredientId: ingredientId ?? this.ingredientId,
    quantityPerServing: quantityPerServing ?? this.quantityPerServing,
    unit: unit ?? this.unit,
    isOptional: isOptional ?? this.isOptional,
    preparationNote: preparationNote.present
        ? preparationNote.value
        : this.preparationNote,
  );
  RecipeIngredient copyWithCompanion(RecipeIngredientsCompanion data) {
    return RecipeIngredient(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantityPerServing: data.quantityPerServing.present
          ? data.quantityPerServing.value
          : this.quantityPerServing,
      unit: data.unit.present ? data.unit.value : this.unit,
      isOptional: data.isOptional.present
          ? data.isOptional.value
          : this.isOptional,
      preparationNote: data.preparationNote.present
          ? data.preparationNote.value
          : this.preparationNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredient(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityPerServing: $quantityPerServing, ')
          ..write('unit: $unit, ')
          ..write('isOptional: $isOptional, ')
          ..write('preparationNote: $preparationNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    ingredientId,
    quantityPerServing,
    unit,
    isOptional,
    preparationNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeIngredient &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.ingredientId == this.ingredientId &&
          other.quantityPerServing == this.quantityPerServing &&
          other.unit == this.unit &&
          other.isOptional == this.isOptional &&
          other.preparationNote == this.preparationNote);
}

class RecipeIngredientsCompanion extends UpdateCompanion<RecipeIngredient> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<String> ingredientId;
  final Value<double> quantityPerServing;
  final Value<MeasurementUnit> unit;
  final Value<bool> isOptional;
  final Value<String?> preparationNote;
  final Value<int> rowid;
  const RecipeIngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantityPerServing = const Value.absent(),
    this.unit = const Value.absent(),
    this.isOptional = const Value.absent(),
    this.preparationNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeIngredientsCompanion.insert({
    required String id,
    required String recipeId,
    required String ingredientId,
    required double quantityPerServing,
    required MeasurementUnit unit,
    this.isOptional = const Value.absent(),
    this.preparationNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       ingredientId = Value(ingredientId),
       quantityPerServing = Value(quantityPerServing),
       unit = Value(unit);
  static Insertable<RecipeIngredient> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<String>? ingredientId,
    Expression<double>? quantityPerServing,
    Expression<String>? unit,
    Expression<bool>? isOptional,
    Expression<String>? preparationNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantityPerServing != null)
        'quantity_per_serving': quantityPerServing,
      if (unit != null) 'unit': unit,
      if (isOptional != null) 'is_optional': isOptional,
      if (preparationNote != null) 'preparation_note': preparationNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeIngredientsCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<String>? ingredientId,
    Value<double>? quantityPerServing,
    Value<MeasurementUnit>? unit,
    Value<bool>? isOptional,
    Value<String?>? preparationNote,
    Value<int>? rowid,
  }) {
    return RecipeIngredientsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantityPerServing: quantityPerServing ?? this.quantityPerServing,
      unit: unit ?? this.unit,
      isOptional: isOptional ?? this.isOptional,
      preparationNote: preparationNote ?? this.preparationNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (quantityPerServing.present) {
      map['quantity_per_serving'] = Variable<double>(quantityPerServing.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $RecipeIngredientsTable.$converterunit.toSql(unit.value),
      );
    }
    if (isOptional.present) {
      map['is_optional'] = Variable<bool>(isOptional.value);
    }
    if (preparationNote.present) {
      map['preparation_note'] = Variable<String>(preparationNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityPerServing: $quantityPerServing, ')
          ..write('unit: $unit, ')
          ..write('isOptional: $isOptional, ')
          ..write('preparationNote: $preparationNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeEquipmentsTable extends RecipeEquipments
    with TableInfo<$RecipeEquipmentsTable, RecipeEquipment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeEquipmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<String> equipmentId = GeneratedColumn<String>(
    'equipment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEssentialMeta = const VerificationMeta(
    'isEssential',
  );
  @override
  late final GeneratedColumn<bool> isEssential = GeneratedColumn<bool>(
    'is_essential',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_essential" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _commonlySubstitutedMeta =
      const VerificationMeta('commonlySubstituted');
  @override
  late final GeneratedColumn<bool> commonlySubstituted = GeneratedColumn<bool>(
    'commonly_substituted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("commonly_substituted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    equipmentId,
    isEssential,
    commonlySubstituted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_equipments';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeEquipment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    if (data.containsKey('is_essential')) {
      context.handle(
        _isEssentialMeta,
        isEssential.isAcceptableOrUnknown(
          data['is_essential']!,
          _isEssentialMeta,
        ),
      );
    }
    if (data.containsKey('commonly_substituted')) {
      context.handle(
        _commonlySubstitutedMeta,
        commonlySubstituted.isAcceptableOrUnknown(
          data['commonly_substituted']!,
          _commonlySubstitutedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeEquipment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeEquipment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_id'],
      )!,
      isEssential: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_essential'],
      )!,
      commonlySubstituted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}commonly_substituted'],
      )!,
    );
  }

  @override
  $RecipeEquipmentsTable createAlias(String alias) {
    return $RecipeEquipmentsTable(attachedDatabase, alias);
  }
}

class RecipeEquipment extends DataClass implements Insertable<RecipeEquipment> {
  final String id;
  final String recipeId;
  final String equipmentId;

  /// If false, the recipe can be made without it (nice-to-have).
  final bool isEssential;

  /// When true, always show substitute alternatives as a footnote even if the
  /// user isn't tracking equipment ownership.
  final bool commonlySubstituted;
  const RecipeEquipment({
    required this.id,
    required this.recipeId,
    required this.equipmentId,
    required this.isEssential,
    required this.commonlySubstituted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['equipment_id'] = Variable<String>(equipmentId);
    map['is_essential'] = Variable<bool>(isEssential);
    map['commonly_substituted'] = Variable<bool>(commonlySubstituted);
    return map;
  }

  RecipeEquipmentsCompanion toCompanion(bool nullToAbsent) {
    return RecipeEquipmentsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      equipmentId: Value(equipmentId),
      isEssential: Value(isEssential),
      commonlySubstituted: Value(commonlySubstituted),
    );
  }

  factory RecipeEquipment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeEquipment(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      equipmentId: serializer.fromJson<String>(json['equipmentId']),
      isEssential: serializer.fromJson<bool>(json['isEssential']),
      commonlySubstituted: serializer.fromJson<bool>(
        json['commonlySubstituted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'equipmentId': serializer.toJson<String>(equipmentId),
      'isEssential': serializer.toJson<bool>(isEssential),
      'commonlySubstituted': serializer.toJson<bool>(commonlySubstituted),
    };
  }

  RecipeEquipment copyWith({
    String? id,
    String? recipeId,
    String? equipmentId,
    bool? isEssential,
    bool? commonlySubstituted,
  }) => RecipeEquipment(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    equipmentId: equipmentId ?? this.equipmentId,
    isEssential: isEssential ?? this.isEssential,
    commonlySubstituted: commonlySubstituted ?? this.commonlySubstituted,
  );
  RecipeEquipment copyWithCompanion(RecipeEquipmentsCompanion data) {
    return RecipeEquipment(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
      isEssential: data.isEssential.present
          ? data.isEssential.value
          : this.isEssential,
      commonlySubstituted: data.commonlySubstituted.present
          ? data.commonlySubstituted.value
          : this.commonlySubstituted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeEquipment(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('isEssential: $isEssential, ')
          ..write('commonlySubstituted: $commonlySubstituted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, equipmentId, isEssential, commonlySubstituted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeEquipment &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.equipmentId == this.equipmentId &&
          other.isEssential == this.isEssential &&
          other.commonlySubstituted == this.commonlySubstituted);
}

class RecipeEquipmentsCompanion extends UpdateCompanion<RecipeEquipment> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<String> equipmentId;
  final Value<bool> isEssential;
  final Value<bool> commonlySubstituted;
  final Value<int> rowid;
  const RecipeEquipmentsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.isEssential = const Value.absent(),
    this.commonlySubstituted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeEquipmentsCompanion.insert({
    required String id,
    required String recipeId,
    required String equipmentId,
    this.isEssential = const Value.absent(),
    this.commonlySubstituted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       equipmentId = Value(equipmentId);
  static Insertable<RecipeEquipment> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<String>? equipmentId,
    Expression<bool>? isEssential,
    Expression<bool>? commonlySubstituted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (isEssential != null) 'is_essential': isEssential,
      if (commonlySubstituted != null)
        'commonly_substituted': commonlySubstituted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeEquipmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<String>? equipmentId,
    Value<bool>? isEssential,
    Value<bool>? commonlySubstituted,
    Value<int>? rowid,
  }) {
    return RecipeEquipmentsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      equipmentId: equipmentId ?? this.equipmentId,
      isEssential: isEssential ?? this.isEssential,
      commonlySubstituted: commonlySubstituted ?? this.commonlySubstituted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<String>(equipmentId.value);
    }
    if (isEssential.present) {
      map['is_essential'] = Variable<bool>(isEssential.value);
    }
    if (commonlySubstituted.present) {
      map['commonly_substituted'] = Variable<bool>(commonlySubstituted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeEquipmentsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('isEssential: $isEssential, ')
          ..write('commonlySubstituted: $commonlySubstituted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeStepsTable extends RecipeSteps
    with TableInfo<$RecipeStepsTable, RecipeStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionMeta = const VerificationMeta(
    'instruction',
  );
  @override
  late final GeneratedColumn<String> instruction = GeneratedColumn<String>(
    'instruction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepGroupIdMeta = const VerificationMeta(
    'stepGroupId',
  );
  @override
  late final GeneratedColumn<String> stepGroupId = GeneratedColumn<String>(
    'step_group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GasFlameLevel?, String>
  flameLevel = GeneratedColumn<String>(
    'flame_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<GasFlameLevel?>($RecipeStepsTable.$converterflameLeveln);
  static const VerificationMeta _estimatedDurationSecondsMeta =
      const VerificationMeta('estimatedDurationSeconds');
  @override
  late final GeneratedColumn<int> estimatedDurationSeconds =
      GeneratedColumn<int>(
        'estimated_duration_seconds',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    orderIndex,
    instruction,
    stepGroupId,
    flameLevel,
    estimatedDurationSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('instruction')) {
      context.handle(
        _instructionMeta,
        instruction.isAcceptableOrUnknown(
          data['instruction']!,
          _instructionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instructionMeta);
    }
    if (data.containsKey('step_group_id')) {
      context.handle(
        _stepGroupIdMeta,
        stepGroupId.isAcceptableOrUnknown(
          data['step_group_id']!,
          _stepGroupIdMeta,
        ),
      );
    }
    if (data.containsKey('estimated_duration_seconds')) {
      context.handle(
        _estimatedDurationSecondsMeta,
        estimatedDurationSeconds.isAcceptableOrUnknown(
          data['estimated_duration_seconds']!,
          _estimatedDurationSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeStep(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      instruction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instruction'],
      )!,
      stepGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}step_group_id'],
      ),
      flameLevel: $RecipeStepsTable.$converterflameLeveln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}flame_level'],
        ),
      ),
      estimatedDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_duration_seconds'],
      ),
    );
  }

  @override
  $RecipeStepsTable createAlias(String alias) {
    return $RecipeStepsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GasFlameLevel, String, String>
  $converterflameLevel = const EnumNameConverter<GasFlameLevel>(
    GasFlameLevel.values,
  );
  static JsonTypeConverter2<GasFlameLevel?, String?, String?>
  $converterflameLeveln = JsonTypeConverter2.asNullable($converterflameLevel);
}

class RecipeStep extends DataClass implements Insertable<RecipeStep> {
  final String id;
  final String recipeId;
  final int orderIndex;
  final String instruction;

  /// Steps with the same group id are parallelizable ("while X simmers, do Y").
  final String? stepGroupId;
  final GasFlameLevel? flameLevel;
  final int? estimatedDurationSeconds;
  const RecipeStep({
    required this.id,
    required this.recipeId,
    required this.orderIndex,
    required this.instruction,
    this.stepGroupId,
    this.flameLevel,
    this.estimatedDurationSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['order_index'] = Variable<int>(orderIndex);
    map['instruction'] = Variable<String>(instruction);
    if (!nullToAbsent || stepGroupId != null) {
      map['step_group_id'] = Variable<String>(stepGroupId);
    }
    if (!nullToAbsent || flameLevel != null) {
      map['flame_level'] = Variable<String>(
        $RecipeStepsTable.$converterflameLeveln.toSql(flameLevel),
      );
    }
    if (!nullToAbsent || estimatedDurationSeconds != null) {
      map['estimated_duration_seconds'] = Variable<int>(
        estimatedDurationSeconds,
      );
    }
    return map;
  }

  RecipeStepsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      orderIndex: Value(orderIndex),
      instruction: Value(instruction),
      stepGroupId: stepGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(stepGroupId),
      flameLevel: flameLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(flameLevel),
      estimatedDurationSeconds: estimatedDurationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedDurationSeconds),
    );
  }

  factory RecipeStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeStep(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      instruction: serializer.fromJson<String>(json['instruction']),
      stepGroupId: serializer.fromJson<String?>(json['stepGroupId']),
      flameLevel: $RecipeStepsTable.$converterflameLeveln.fromJson(
        serializer.fromJson<String?>(json['flameLevel']),
      ),
      estimatedDurationSeconds: serializer.fromJson<int?>(
        json['estimatedDurationSeconds'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'instruction': serializer.toJson<String>(instruction),
      'stepGroupId': serializer.toJson<String?>(stepGroupId),
      'flameLevel': serializer.toJson<String?>(
        $RecipeStepsTable.$converterflameLeveln.toJson(flameLevel),
      ),
      'estimatedDurationSeconds': serializer.toJson<int?>(
        estimatedDurationSeconds,
      ),
    };
  }

  RecipeStep copyWith({
    String? id,
    String? recipeId,
    int? orderIndex,
    String? instruction,
    Value<String?> stepGroupId = const Value.absent(),
    Value<GasFlameLevel?> flameLevel = const Value.absent(),
    Value<int?> estimatedDurationSeconds = const Value.absent(),
  }) => RecipeStep(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    orderIndex: orderIndex ?? this.orderIndex,
    instruction: instruction ?? this.instruction,
    stepGroupId: stepGroupId.present ? stepGroupId.value : this.stepGroupId,
    flameLevel: flameLevel.present ? flameLevel.value : this.flameLevel,
    estimatedDurationSeconds: estimatedDurationSeconds.present
        ? estimatedDurationSeconds.value
        : this.estimatedDurationSeconds,
  );
  RecipeStep copyWithCompanion(RecipeStepsCompanion data) {
    return RecipeStep(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      instruction: data.instruction.present
          ? data.instruction.value
          : this.instruction,
      stepGroupId: data.stepGroupId.present
          ? data.stepGroupId.value
          : this.stepGroupId,
      flameLevel: data.flameLevel.present
          ? data.flameLevel.value
          : this.flameLevel,
      estimatedDurationSeconds: data.estimatedDurationSeconds.present
          ? data.estimatedDurationSeconds.value
          : this.estimatedDurationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStep(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('instruction: $instruction, ')
          ..write('stepGroupId: $stepGroupId, ')
          ..write('flameLevel: $flameLevel, ')
          ..write('estimatedDurationSeconds: $estimatedDurationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    orderIndex,
    instruction,
    stepGroupId,
    flameLevel,
    estimatedDurationSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeStep &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.orderIndex == this.orderIndex &&
          other.instruction == this.instruction &&
          other.stepGroupId == this.stepGroupId &&
          other.flameLevel == this.flameLevel &&
          other.estimatedDurationSeconds == this.estimatedDurationSeconds);
}

class RecipeStepsCompanion extends UpdateCompanion<RecipeStep> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<int> orderIndex;
  final Value<String> instruction;
  final Value<String?> stepGroupId;
  final Value<GasFlameLevel?> flameLevel;
  final Value<int?> estimatedDurationSeconds;
  final Value<int> rowid;
  const RecipeStepsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.instruction = const Value.absent(),
    this.stepGroupId = const Value.absent(),
    this.flameLevel = const Value.absent(),
    this.estimatedDurationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeStepsCompanion.insert({
    required String id,
    required String recipeId,
    required int orderIndex,
    required String instruction,
    this.stepGroupId = const Value.absent(),
    this.flameLevel = const Value.absent(),
    this.estimatedDurationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       orderIndex = Value(orderIndex),
       instruction = Value(instruction);
  static Insertable<RecipeStep> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<int>? orderIndex,
    Expression<String>? instruction,
    Expression<String>? stepGroupId,
    Expression<String>? flameLevel,
    Expression<int>? estimatedDurationSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (instruction != null) 'instruction': instruction,
      if (stepGroupId != null) 'step_group_id': stepGroupId,
      if (flameLevel != null) 'flame_level': flameLevel,
      if (estimatedDurationSeconds != null)
        'estimated_duration_seconds': estimatedDurationSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeStepsCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<int>? orderIndex,
    Value<String>? instruction,
    Value<String?>? stepGroupId,
    Value<GasFlameLevel?>? flameLevel,
    Value<int?>? estimatedDurationSeconds,
    Value<int>? rowid,
  }) {
    return RecipeStepsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      orderIndex: orderIndex ?? this.orderIndex,
      instruction: instruction ?? this.instruction,
      stepGroupId: stepGroupId ?? this.stepGroupId,
      flameLevel: flameLevel ?? this.flameLevel,
      estimatedDurationSeconds:
          estimatedDurationSeconds ?? this.estimatedDurationSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (instruction.present) {
      map['instruction'] = Variable<String>(instruction.value);
    }
    if (stepGroupId.present) {
      map['step_group_id'] = Variable<String>(stepGroupId.value);
    }
    if (flameLevel.present) {
      map['flame_level'] = Variable<String>(
        $RecipeStepsTable.$converterflameLeveln.toSql(flameLevel.value),
      );
    }
    if (estimatedDurationSeconds.present) {
      map['estimated_duration_seconds'] = Variable<int>(
        estimatedDurationSeconds.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('instruction: $instruction, ')
          ..write('stepGroupId: $stepGroupId, ')
          ..write('flameLevel: $flameLevel, ')
          ..write('estimatedDurationSeconds: $estimatedDurationSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryItemsTable extends InventoryItems
    with TableInfo<$InventoryItemsTable, InventoryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<String> kitchenId = GeneratedColumn<String>(
    'kitchen_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('home'),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customNameMeta = const VerificationMeta(
    'customName',
  );
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
    'custom_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MeasurementUnit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MeasurementUnit>($InventoryItemsTable.$converterunit);
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shelfLifeDaysMeta = const VerificationMeta(
    'shelfLifeDays',
  );
  @override
  late final GeneratedColumn<int> shelfLifeDays = GeneratedColumn<int>(
    'shelf_life_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalQuantityMeta = const VerificationMeta(
    'originalQuantity',
  );
  @override
  late final GeneratedColumn<double> originalQuantity = GeneratedColumn<double>(
    'original_quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kitchenId,
    ingredientId,
    customName,
    quantity,
    unit,
    purchaseDate,
    shelfLifeDays,
    expiryDate,
    originalQuantity,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kitchen_id')) {
      context.handle(
        _kitchenIdMeta,
        kitchenId.isAcceptableOrUnknown(data['kitchen_id']!, _kitchenIdMeta),
      );
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    }
    if (data.containsKey('custom_name')) {
      context.handle(
        _customNameMeta,
        customName.isAcceptableOrUnknown(data['custom_name']!, _customNameMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('shelf_life_days')) {
      context.handle(
        _shelfLifeDaysMeta,
        shelfLifeDays.isAcceptableOrUnknown(
          data['shelf_life_days']!,
          _shelfLifeDaysMeta,
        ),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('original_quantity')) {
      context.handle(
        _originalQuantityMeta,
        originalQuantity.isAcceptableOrUnknown(
          data['original_quantity']!,
          _originalQuantityMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kitchen_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      ),
      customName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_name'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: $InventoryItemsTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      shelfLifeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shelf_life_days'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      )!,
      originalQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}original_quantity'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InventoryItemsTable createAlias(String alias) {
    return $InventoryItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MeasurementUnit, String, String> $converterunit =
      const EnumNameConverter<MeasurementUnit>(MeasurementUnit.values);
}

class InventoryItem extends DataClass implements Insertable<InventoryItem> {
  final String id;

  /// Which kitchen this batch belongs to (defaults to the permanent "home").
  final String kitchenId;

  /// Links to the canonical ingredient. Null for a free-text item the user
  /// typed that isn't in the dictionary (still tracked, just unmatched).
  final String? ingredientId;
  final String? customName;
  final double quantity;
  final MeasurementUnit unit;
  final DateTime purchaseDate;
  final int? shelfLifeDays;
  final DateTime expiryDate;

  /// How much this batch started at — informational only (restock uses par
  /// levels, not this).
  final double? originalQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  const InventoryItem({
    required this.id,
    required this.kitchenId,
    this.ingredientId,
    this.customName,
    required this.quantity,
    required this.unit,
    required this.purchaseDate,
    this.shelfLifeDays,
    required this.expiryDate,
    this.originalQuantity,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kitchen_id'] = Variable<String>(kitchenId);
    if (!nullToAbsent || ingredientId != null) {
      map['ingredient_id'] = Variable<String>(ingredientId);
    }
    if (!nullToAbsent || customName != null) {
      map['custom_name'] = Variable<String>(customName);
    }
    map['quantity'] = Variable<double>(quantity);
    {
      map['unit'] = Variable<String>(
        $InventoryItemsTable.$converterunit.toSql(unit),
      );
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    if (!nullToAbsent || shelfLifeDays != null) {
      map['shelf_life_days'] = Variable<int>(shelfLifeDays);
    }
    map['expiry_date'] = Variable<DateTime>(expiryDate);
    if (!nullToAbsent || originalQuantity != null) {
      map['original_quantity'] = Variable<double>(originalQuantity);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return InventoryItemsCompanion(
      id: Value(id),
      kitchenId: Value(kitchenId),
      ingredientId: ingredientId == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientId),
      customName: customName == null && nullToAbsent
          ? const Value.absent()
          : Value(customName),
      quantity: Value(quantity),
      unit: Value(unit),
      purchaseDate: Value(purchaseDate),
      shelfLifeDays: shelfLifeDays == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLifeDays),
      expiryDate: Value(expiryDate),
      originalQuantity: originalQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(originalQuantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InventoryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryItem(
      id: serializer.fromJson<String>(json['id']),
      kitchenId: serializer.fromJson<String>(json['kitchenId']),
      ingredientId: serializer.fromJson<String?>(json['ingredientId']),
      customName: serializer.fromJson<String?>(json['customName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: $InventoryItemsTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      shelfLifeDays: serializer.fromJson<int?>(json['shelfLifeDays']),
      expiryDate: serializer.fromJson<DateTime>(json['expiryDate']),
      originalQuantity: serializer.fromJson<double?>(json['originalQuantity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kitchenId': serializer.toJson<String>(kitchenId),
      'ingredientId': serializer.toJson<String?>(ingredientId),
      'customName': serializer.toJson<String?>(customName),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(
        $InventoryItemsTable.$converterunit.toJson(unit),
      ),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'shelfLifeDays': serializer.toJson<int?>(shelfLifeDays),
      'expiryDate': serializer.toJson<DateTime>(expiryDate),
      'originalQuantity': serializer.toJson<double?>(originalQuantity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InventoryItem copyWith({
    String? id,
    String? kitchenId,
    Value<String?> ingredientId = const Value.absent(),
    Value<String?> customName = const Value.absent(),
    double? quantity,
    MeasurementUnit? unit,
    DateTime? purchaseDate,
    Value<int?> shelfLifeDays = const Value.absent(),
    DateTime? expiryDate,
    Value<double?> originalQuantity = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => InventoryItem(
    id: id ?? this.id,
    kitchenId: kitchenId ?? this.kitchenId,
    ingredientId: ingredientId.present ? ingredientId.value : this.ingredientId,
    customName: customName.present ? customName.value : this.customName,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    shelfLifeDays: shelfLifeDays.present
        ? shelfLifeDays.value
        : this.shelfLifeDays,
    expiryDate: expiryDate ?? this.expiryDate,
    originalQuantity: originalQuantity.present
        ? originalQuantity.value
        : this.originalQuantity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InventoryItem copyWithCompanion(InventoryItemsCompanion data) {
    return InventoryItem(
      id: data.id.present ? data.id.value : this.id,
      kitchenId: data.kitchenId.present ? data.kitchenId.value : this.kitchenId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      customName: data.customName.present
          ? data.customName.value
          : this.customName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      shelfLifeDays: data.shelfLifeDays.present
          ? data.shelfLifeDays.value
          : this.shelfLifeDays,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      originalQuantity: data.originalQuantity.present
          ? data.originalQuantity.value
          : this.originalQuantity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItem(')
          ..write('id: $id, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('customName: $customName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('shelfLifeDays: $shelfLifeDays, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('originalQuantity: $originalQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kitchenId,
    ingredientId,
    customName,
    quantity,
    unit,
    purchaseDate,
    shelfLifeDays,
    expiryDate,
    originalQuantity,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryItem &&
          other.id == this.id &&
          other.kitchenId == this.kitchenId &&
          other.ingredientId == this.ingredientId &&
          other.customName == this.customName &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.purchaseDate == this.purchaseDate &&
          other.shelfLifeDays == this.shelfLifeDays &&
          other.expiryDate == this.expiryDate &&
          other.originalQuantity == this.originalQuantity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InventoryItemsCompanion extends UpdateCompanion<InventoryItem> {
  final Value<String> id;
  final Value<String> kitchenId;
  final Value<String?> ingredientId;
  final Value<String?> customName;
  final Value<double> quantity;
  final Value<MeasurementUnit> unit;
  final Value<DateTime> purchaseDate;
  final Value<int?> shelfLifeDays;
  final Value<DateTime> expiryDate;
  final Value<double?> originalQuantity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InventoryItemsCompanion({
    this.id = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.customName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.shelfLifeDays = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.originalQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryItemsCompanion.insert({
    required String id,
    this.kitchenId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.customName = const Value.absent(),
    required double quantity,
    required MeasurementUnit unit,
    required DateTime purchaseDate,
    this.shelfLifeDays = const Value.absent(),
    required DateTime expiryDate,
    this.originalQuantity = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quantity = Value(quantity),
       unit = Value(unit),
       purchaseDate = Value(purchaseDate),
       expiryDate = Value(expiryDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InventoryItem> custom({
    Expression<String>? id,
    Expression<String>? kitchenId,
    Expression<String>? ingredientId,
    Expression<String>? customName,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<DateTime>? purchaseDate,
    Expression<int>? shelfLifeDays,
    Expression<DateTime>? expiryDate,
    Expression<double>? originalQuantity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (customName != null) 'custom_name': customName,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (shelfLifeDays != null) 'shelf_life_days': shelfLifeDays,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (originalQuantity != null) 'original_quantity': originalQuantity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? kitchenId,
    Value<String?>? ingredientId,
    Value<String?>? customName,
    Value<double>? quantity,
    Value<MeasurementUnit>? unit,
    Value<DateTime>? purchaseDate,
    Value<int?>? shelfLifeDays,
    Value<DateTime>? expiryDate,
    Value<double?>? originalQuantity,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InventoryItemsCompanion(
      id: id ?? this.id,
      kitchenId: kitchenId ?? this.kitchenId,
      ingredientId: ingredientId ?? this.ingredientId,
      customName: customName ?? this.customName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      shelfLifeDays: shelfLifeDays ?? this.shelfLifeDays,
      expiryDate: expiryDate ?? this.expiryDate,
      originalQuantity: originalQuantity ?? this.originalQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<String>(kitchenId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $InventoryItemsTable.$converterunit.toSql(unit.value),
      );
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (shelfLifeDays.present) {
      map['shelf_life_days'] = Variable<int>(shelfLifeDays.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (originalQuantity.present) {
      map['original_quantity'] = Variable<double>(originalQuantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('customName: $customName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('shelfLifeDays: $shelfLifeDays, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('originalQuantity: $originalQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RestockListItemsTable extends RestockListItems
    with TableInfo<$RestockListItemsTable, RestockListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestockListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kitchenIdMeta = const VerificationMeta(
    'kitchenId',
  );
  @override
  late final GeneratedColumn<String> kitchenId = GeneratedColumn<String>(
    'kitchen_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('home'),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suggestedQuantityMeta = const VerificationMeta(
    'suggestedQuantity',
  );
  @override
  late final GeneratedColumn<double> suggestedQuantity =
      GeneratedColumn<double>(
        'suggested_quantity',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<MeasurementUnit?, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<MeasurementUnit?>($RestockListItemsTable.$converterunitn);
  @override
  late final GeneratedColumnWithTypeConverter<RestockReason, String> reason =
      GeneratedColumn<String>(
        'reason',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RestockReason>($RestockListItemsTable.$converterreason);
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isResolvedMeta = const VerificationMeta(
    'isResolved',
  );
  @override
  late final GeneratedColumn<bool> isResolved = GeneratedColumn<bool>(
    'is_resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kitchenId,
    ingredientId,
    itemName,
    suggestedQuantity,
    unit,
    reason,
    addedAt,
    isResolved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restock_list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestockListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kitchen_id')) {
      context.handle(
        _kitchenIdMeta,
        kitchenId.isAcceptableOrUnknown(data['kitchen_id']!, _kitchenIdMeta),
      );
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('suggested_quantity')) {
      context.handle(
        _suggestedQuantityMeta,
        suggestedQuantity.isAcceptableOrUnknown(
          data['suggested_quantity']!,
          _suggestedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('is_resolved')) {
      context.handle(
        _isResolvedMeta,
        isResolved.isAcceptableOrUnknown(data['is_resolved']!, _isResolvedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestockListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestockListItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kitchenId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kitchen_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      ),
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      suggestedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}suggested_quantity'],
      ),
      unit: $RestockListItemsTable.$converterunitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        ),
      ),
      reason: $RestockListItemsTable.$converterreason.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason'],
        )!,
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      isResolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_resolved'],
      )!,
    );
  }

  @override
  $RestockListItemsTable createAlias(String alias) {
    return $RestockListItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MeasurementUnit, String, String> $converterunit =
      const EnumNameConverter<MeasurementUnit>(MeasurementUnit.values);
  static JsonTypeConverter2<MeasurementUnit?, String?, String?>
  $converterunitn = JsonTypeConverter2.asNullable($converterunit);
  static JsonTypeConverter2<RestockReason, String, String> $converterreason =
      const EnumNameConverter<RestockReason>(RestockReason.values);
}

class RestockListItem extends DataClass implements Insertable<RestockListItem> {
  final String id;

  /// Which kitchen this restock entry belongs to.
  final String kitchenId;
  final String? ingredientId;
  final String itemName;
  final double? suggestedQuantity;
  final MeasurementUnit? unit;
  final RestockReason reason;
  final DateTime addedAt;
  final bool isResolved;
  const RestockListItem({
    required this.id,
    required this.kitchenId,
    this.ingredientId,
    required this.itemName,
    this.suggestedQuantity,
    this.unit,
    required this.reason,
    required this.addedAt,
    required this.isResolved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kitchen_id'] = Variable<String>(kitchenId);
    if (!nullToAbsent || ingredientId != null) {
      map['ingredient_id'] = Variable<String>(ingredientId);
    }
    map['item_name'] = Variable<String>(itemName);
    if (!nullToAbsent || suggestedQuantity != null) {
      map['suggested_quantity'] = Variable<double>(suggestedQuantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(
        $RestockListItemsTable.$converterunitn.toSql(unit),
      );
    }
    {
      map['reason'] = Variable<String>(
        $RestockListItemsTable.$converterreason.toSql(reason),
      );
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    map['is_resolved'] = Variable<bool>(isResolved);
    return map;
  }

  RestockListItemsCompanion toCompanion(bool nullToAbsent) {
    return RestockListItemsCompanion(
      id: Value(id),
      kitchenId: Value(kitchenId),
      ingredientId: ingredientId == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientId),
      itemName: Value(itemName),
      suggestedQuantity: suggestedQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedQuantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      reason: Value(reason),
      addedAt: Value(addedAt),
      isResolved: Value(isResolved),
    );
  }

  factory RestockListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestockListItem(
      id: serializer.fromJson<String>(json['id']),
      kitchenId: serializer.fromJson<String>(json['kitchenId']),
      ingredientId: serializer.fromJson<String?>(json['ingredientId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      suggestedQuantity: serializer.fromJson<double?>(
        json['suggestedQuantity'],
      ),
      unit: $RestockListItemsTable.$converterunitn.fromJson(
        serializer.fromJson<String?>(json['unit']),
      ),
      reason: $RestockListItemsTable.$converterreason.fromJson(
        serializer.fromJson<String>(json['reason']),
      ),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      isResolved: serializer.fromJson<bool>(json['isResolved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kitchenId': serializer.toJson<String>(kitchenId),
      'ingredientId': serializer.toJson<String?>(ingredientId),
      'itemName': serializer.toJson<String>(itemName),
      'suggestedQuantity': serializer.toJson<double?>(suggestedQuantity),
      'unit': serializer.toJson<String?>(
        $RestockListItemsTable.$converterunitn.toJson(unit),
      ),
      'reason': serializer.toJson<String>(
        $RestockListItemsTable.$converterreason.toJson(reason),
      ),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'isResolved': serializer.toJson<bool>(isResolved),
    };
  }

  RestockListItem copyWith({
    String? id,
    String? kitchenId,
    Value<String?> ingredientId = const Value.absent(),
    String? itemName,
    Value<double?> suggestedQuantity = const Value.absent(),
    Value<MeasurementUnit?> unit = const Value.absent(),
    RestockReason? reason,
    DateTime? addedAt,
    bool? isResolved,
  }) => RestockListItem(
    id: id ?? this.id,
    kitchenId: kitchenId ?? this.kitchenId,
    ingredientId: ingredientId.present ? ingredientId.value : this.ingredientId,
    itemName: itemName ?? this.itemName,
    suggestedQuantity: suggestedQuantity.present
        ? suggestedQuantity.value
        : this.suggestedQuantity,
    unit: unit.present ? unit.value : this.unit,
    reason: reason ?? this.reason,
    addedAt: addedAt ?? this.addedAt,
    isResolved: isResolved ?? this.isResolved,
  );
  RestockListItem copyWithCompanion(RestockListItemsCompanion data) {
    return RestockListItem(
      id: data.id.present ? data.id.value : this.id,
      kitchenId: data.kitchenId.present ? data.kitchenId.value : this.kitchenId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      suggestedQuantity: data.suggestedQuantity.present
          ? data.suggestedQuantity.value
          : this.suggestedQuantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      reason: data.reason.present ? data.reason.value : this.reason,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      isResolved: data.isResolved.present
          ? data.isResolved.value
          : this.isResolved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestockListItem(')
          ..write('id: $id, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('itemName: $itemName, ')
          ..write('suggestedQuantity: $suggestedQuantity, ')
          ..write('unit: $unit, ')
          ..write('reason: $reason, ')
          ..write('addedAt: $addedAt, ')
          ..write('isResolved: $isResolved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kitchenId,
    ingredientId,
    itemName,
    suggestedQuantity,
    unit,
    reason,
    addedAt,
    isResolved,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestockListItem &&
          other.id == this.id &&
          other.kitchenId == this.kitchenId &&
          other.ingredientId == this.ingredientId &&
          other.itemName == this.itemName &&
          other.suggestedQuantity == this.suggestedQuantity &&
          other.unit == this.unit &&
          other.reason == this.reason &&
          other.addedAt == this.addedAt &&
          other.isResolved == this.isResolved);
}

class RestockListItemsCompanion extends UpdateCompanion<RestockListItem> {
  final Value<String> id;
  final Value<String> kitchenId;
  final Value<String?> ingredientId;
  final Value<String> itemName;
  final Value<double?> suggestedQuantity;
  final Value<MeasurementUnit?> unit;
  final Value<RestockReason> reason;
  final Value<DateTime> addedAt;
  final Value<bool> isResolved;
  final Value<int> rowid;
  const RestockListItemsCompanion({
    this.id = const Value.absent(),
    this.kitchenId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.suggestedQuantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.reason = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RestockListItemsCompanion.insert({
    required String id,
    this.kitchenId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    required String itemName,
    this.suggestedQuantity = const Value.absent(),
    this.unit = const Value.absent(),
    required RestockReason reason,
    required DateTime addedAt,
    this.isResolved = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemName = Value(itemName),
       reason = Value(reason),
       addedAt = Value(addedAt);
  static Insertable<RestockListItem> custom({
    Expression<String>? id,
    Expression<String>? kitchenId,
    Expression<String>? ingredientId,
    Expression<String>? itemName,
    Expression<double>? suggestedQuantity,
    Expression<String>? unit,
    Expression<String>? reason,
    Expression<DateTime>? addedAt,
    Expression<bool>? isResolved,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (itemName != null) 'item_name': itemName,
      if (suggestedQuantity != null) 'suggested_quantity': suggestedQuantity,
      if (unit != null) 'unit': unit,
      if (reason != null) 'reason': reason,
      if (addedAt != null) 'added_at': addedAt,
      if (isResolved != null) 'is_resolved': isResolved,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RestockListItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? kitchenId,
    Value<String?>? ingredientId,
    Value<String>? itemName,
    Value<double?>? suggestedQuantity,
    Value<MeasurementUnit?>? unit,
    Value<RestockReason>? reason,
    Value<DateTime>? addedAt,
    Value<bool>? isResolved,
    Value<int>? rowid,
  }) {
    return RestockListItemsCompanion(
      id: id ?? this.id,
      kitchenId: kitchenId ?? this.kitchenId,
      ingredientId: ingredientId ?? this.ingredientId,
      itemName: itemName ?? this.itemName,
      suggestedQuantity: suggestedQuantity ?? this.suggestedQuantity,
      unit: unit ?? this.unit,
      reason: reason ?? this.reason,
      addedAt: addedAt ?? this.addedAt,
      isResolved: isResolved ?? this.isResolved,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kitchenId.present) {
      map['kitchen_id'] = Variable<String>(kitchenId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (suggestedQuantity.present) {
      map['suggested_quantity'] = Variable<double>(suggestedQuantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $RestockListItemsTable.$converterunitn.toSql(unit.value),
      );
    }
    if (reason.present) {
      map['reason'] = Variable<String>(
        $RestockListItemsTable.$converterreason.toSql(reason.value),
      );
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (isResolved.present) {
      map['is_resolved'] = Variable<bool>(isResolved.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestockListItemsCompanion(')
          ..write('id: $id, ')
          ..write('kitchenId: $kitchenId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('itemName: $itemName, ')
          ..write('suggestedQuantity: $suggestedQuantity, ')
          ..write('unit: $unit, ')
          ..write('reason: $reason, ')
          ..write('addedAt: $addedAt, ')
          ..write('isResolved: $isResolved, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CookEventsTable extends CookEvents
    with TableInfo<$CookEventsTable, CookEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CookEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookedAtMeta = const VerificationMeta(
    'cookedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cookedAt = GeneratedColumn<DateTime>(
    'cooked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdsCsvMeta = const VerificationMeta(
    'ingredientIdsCsv',
  );
  @override
  late final GeneratedColumn<String> ingredientIdsCsv = GeneratedColumn<String>(
    'ingredient_ids_csv',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    cookedAt,
    ingredientIdsCsv,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cook_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CookEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    }
    if (data.containsKey('cooked_at')) {
      context.handle(
        _cookedAtMeta,
        cookedAt.isAcceptableOrUnknown(data['cooked_at']!, _cookedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cookedAtMeta);
    }
    if (data.containsKey('ingredient_ids_csv')) {
      context.handle(
        _ingredientIdsCsvMeta,
        ingredientIdsCsv.isAcceptableOrUnknown(
          data['ingredient_ids_csv']!,
          _ingredientIdsCsvMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CookEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      ),
      cookedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cooked_at'],
      )!,
      ingredientIdsCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_ids_csv'],
      )!,
    );
  }

  @override
  $CookEventsTable createAlias(String alias) {
    return $CookEventsTable(attachedDatabase, alias);
  }
}

class CookEvent extends DataClass implements Insertable<CookEvent> {
  final String id;
  final String? recipeId;
  final DateTime cookedAt;
  final String ingredientIdsCsv;
  const CookEvent({
    required this.id,
    this.recipeId,
    required this.cookedAt,
    required this.ingredientIdsCsv,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<String>(recipeId);
    }
    map['cooked_at'] = Variable<DateTime>(cookedAt);
    map['ingredient_ids_csv'] = Variable<String>(ingredientIdsCsv);
    return map;
  }

  CookEventsCompanion toCompanion(bool nullToAbsent) {
    return CookEventsCompanion(
      id: Value(id),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      cookedAt: Value(cookedAt),
      ingredientIdsCsv: Value(ingredientIdsCsv),
    );
  }

  factory CookEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookEvent(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String?>(json['recipeId']),
      cookedAt: serializer.fromJson<DateTime>(json['cookedAt']),
      ingredientIdsCsv: serializer.fromJson<String>(json['ingredientIdsCsv']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String?>(recipeId),
      'cookedAt': serializer.toJson<DateTime>(cookedAt),
      'ingredientIdsCsv': serializer.toJson<String>(ingredientIdsCsv),
    };
  }

  CookEvent copyWith({
    String? id,
    Value<String?> recipeId = const Value.absent(),
    DateTime? cookedAt,
    String? ingredientIdsCsv,
  }) => CookEvent(
    id: id ?? this.id,
    recipeId: recipeId.present ? recipeId.value : this.recipeId,
    cookedAt: cookedAt ?? this.cookedAt,
    ingredientIdsCsv: ingredientIdsCsv ?? this.ingredientIdsCsv,
  );
  CookEvent copyWithCompanion(CookEventsCompanion data) {
    return CookEvent(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      cookedAt: data.cookedAt.present ? data.cookedAt.value : this.cookedAt,
      ingredientIdsCsv: data.ingredientIdsCsv.present
          ? data.ingredientIdsCsv.value
          : this.ingredientIdsCsv,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookEvent(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('cookedAt: $cookedAt, ')
          ..write('ingredientIdsCsv: $ingredientIdsCsv')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, cookedAt, ingredientIdsCsv);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookEvent &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.cookedAt == this.cookedAt &&
          other.ingredientIdsCsv == this.ingredientIdsCsv);
}

class CookEventsCompanion extends UpdateCompanion<CookEvent> {
  final Value<String> id;
  final Value<String?> recipeId;
  final Value<DateTime> cookedAt;
  final Value<String> ingredientIdsCsv;
  final Value<int> rowid;
  const CookEventsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.cookedAt = const Value.absent(),
    this.ingredientIdsCsv = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CookEventsCompanion.insert({
    required String id,
    this.recipeId = const Value.absent(),
    required DateTime cookedAt,
    this.ingredientIdsCsv = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cookedAt = Value(cookedAt);
  static Insertable<CookEvent> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<DateTime>? cookedAt,
    Expression<String>? ingredientIdsCsv,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (cookedAt != null) 'cooked_at': cookedAt,
      if (ingredientIdsCsv != null) 'ingredient_ids_csv': ingredientIdsCsv,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CookEventsCompanion copyWith({
    Value<String>? id,
    Value<String?>? recipeId,
    Value<DateTime>? cookedAt,
    Value<String>? ingredientIdsCsv,
    Value<int>? rowid,
  }) {
    return CookEventsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      cookedAt: cookedAt ?? this.cookedAt,
      ingredientIdsCsv: ingredientIdsCsv ?? this.ingredientIdsCsv,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (cookedAt.present) {
      map['cooked_at'] = Variable<DateTime>(cookedAt.value);
    }
    if (ingredientIdsCsv.present) {
      map['ingredient_ids_csv'] = Variable<String>(ingredientIdsCsv.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CookEventsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('cookedAt: $cookedAt, ')
          ..write('ingredientIdsCsv: $ingredientIdsCsv, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduledRemindersTable extends ScheduledReminders
    with TableInfo<$ScheduledRemindersTable, ScheduledReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inventoryItemIdMeta = const VerificationMeta(
    'inventoryItemId',
  );
  @override
  late final GeneratedColumn<String> inventoryItemId = GeneratedColumn<String>(
    'inventory_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReminderType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReminderType>($ScheduledRemindersTable.$convertertype);
  static const VerificationMeta _scheduledForMeta = const VerificationMeta(
    'scheduledFor',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledFor = GeneratedColumn<DateTime>(
    'scheduled_for',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inventoryItemId,
    notificationId,
    type,
    scheduledFor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduledReminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inventory_item_id')) {
      context.handle(
        _inventoryItemIdMeta,
        inventoryItemId.isAcceptableOrUnknown(
          data['inventory_item_id']!,
          _inventoryItemIdMeta,
        ),
      );
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
        _scheduledForMeta,
        scheduledFor.isAcceptableOrUnknown(
          data['scheduled_for']!,
          _scheduledForMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledForMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledReminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inventoryItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inventory_item_id'],
      ),
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
      type: $ScheduledRemindersTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      scheduledFor: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_for'],
      )!,
    );
  }

  @override
  $ScheduledRemindersTable createAlias(String alias) {
    return $ScheduledRemindersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReminderType, String, String> $convertertype =
      const EnumNameConverter<ReminderType>(ReminderType.values);
}

class ScheduledReminder extends DataClass
    implements Insertable<ScheduledReminder> {
  final String id;
  final String? inventoryItemId;

  /// The integer id passed to flutter_local_notifications (needed to cancel).
  final int notificationId;
  final ReminderType type;
  final DateTime scheduledFor;
  const ScheduledReminder({
    required this.id,
    this.inventoryItemId,
    required this.notificationId,
    required this.type,
    required this.scheduledFor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || inventoryItemId != null) {
      map['inventory_item_id'] = Variable<String>(inventoryItemId);
    }
    map['notification_id'] = Variable<int>(notificationId);
    {
      map['type'] = Variable<String>(
        $ScheduledRemindersTable.$convertertype.toSql(type),
      );
    }
    map['scheduled_for'] = Variable<DateTime>(scheduledFor);
    return map;
  }

  ScheduledRemindersCompanion toCompanion(bool nullToAbsent) {
    return ScheduledRemindersCompanion(
      id: Value(id),
      inventoryItemId: inventoryItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(inventoryItemId),
      notificationId: Value(notificationId),
      type: Value(type),
      scheduledFor: Value(scheduledFor),
    );
  }

  factory ScheduledReminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledReminder(
      id: serializer.fromJson<String>(json['id']),
      inventoryItemId: serializer.fromJson<String?>(json['inventoryItemId']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
      type: $ScheduledRemindersTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      scheduledFor: serializer.fromJson<DateTime>(json['scheduledFor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inventoryItemId': serializer.toJson<String?>(inventoryItemId),
      'notificationId': serializer.toJson<int>(notificationId),
      'type': serializer.toJson<String>(
        $ScheduledRemindersTable.$convertertype.toJson(type),
      ),
      'scheduledFor': serializer.toJson<DateTime>(scheduledFor),
    };
  }

  ScheduledReminder copyWith({
    String? id,
    Value<String?> inventoryItemId = const Value.absent(),
    int? notificationId,
    ReminderType? type,
    DateTime? scheduledFor,
  }) => ScheduledReminder(
    id: id ?? this.id,
    inventoryItemId: inventoryItemId.present
        ? inventoryItemId.value
        : this.inventoryItemId,
    notificationId: notificationId ?? this.notificationId,
    type: type ?? this.type,
    scheduledFor: scheduledFor ?? this.scheduledFor,
  );
  ScheduledReminder copyWithCompanion(ScheduledRemindersCompanion data) {
    return ScheduledReminder(
      id: data.id.present ? data.id.value : this.id,
      inventoryItemId: data.inventoryItemId.present
          ? data.inventoryItemId.value
          : this.inventoryItemId,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      type: data.type.present ? data.type.value : this.type,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledReminder(')
          ..write('id: $id, ')
          ..write('inventoryItemId: $inventoryItemId, ')
          ..write('notificationId: $notificationId, ')
          ..write('type: $type, ')
          ..write('scheduledFor: $scheduledFor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, inventoryItemId, notificationId, type, scheduledFor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledReminder &&
          other.id == this.id &&
          other.inventoryItemId == this.inventoryItemId &&
          other.notificationId == this.notificationId &&
          other.type == this.type &&
          other.scheduledFor == this.scheduledFor);
}

class ScheduledRemindersCompanion extends UpdateCompanion<ScheduledReminder> {
  final Value<String> id;
  final Value<String?> inventoryItemId;
  final Value<int> notificationId;
  final Value<ReminderType> type;
  final Value<DateTime> scheduledFor;
  final Value<int> rowid;
  const ScheduledRemindersCompanion({
    this.id = const Value.absent(),
    this.inventoryItemId = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.type = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduledRemindersCompanion.insert({
    required String id,
    this.inventoryItemId = const Value.absent(),
    required int notificationId,
    required ReminderType type,
    required DateTime scheduledFor,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       notificationId = Value(notificationId),
       type = Value(type),
       scheduledFor = Value(scheduledFor);
  static Insertable<ScheduledReminder> custom({
    Expression<String>? id,
    Expression<String>? inventoryItemId,
    Expression<int>? notificationId,
    Expression<String>? type,
    Expression<DateTime>? scheduledFor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inventoryItemId != null) 'inventory_item_id': inventoryItemId,
      if (notificationId != null) 'notification_id': notificationId,
      if (type != null) 'type': type,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduledRemindersCompanion copyWith({
    Value<String>? id,
    Value<String?>? inventoryItemId,
    Value<int>? notificationId,
    Value<ReminderType>? type,
    Value<DateTime>? scheduledFor,
    Value<int>? rowid,
  }) {
    return ScheduledRemindersCompanion(
      id: id ?? this.id,
      inventoryItemId: inventoryItemId ?? this.inventoryItemId,
      notificationId: notificationId ?? this.notificationId,
      type: type ?? this.type,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inventoryItemId.present) {
      map['inventory_item_id'] = Variable<String>(inventoryItemId.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ScheduledRemindersTable.$convertertype.toSql(type.value),
      );
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledRemindersCompanion(')
          ..write('id: $id, ')
          ..write('inventoryItemId: $inventoryItemId, ')
          ..write('notificationId: $notificationId, ')
          ..write('type: $type, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationDebouncesTable extends NotificationDebounces
    with TableInfo<$NotificationDebouncesTable, NotificationDebounce> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationDebouncesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNotifiedAtMeta = const VerificationMeta(
    'lastNotifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastNotifiedAt =
      GeneratedColumn<DateTime>(
        'last_notified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [ingredientId, lastNotifiedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_debounces';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationDebounce> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('last_notified_at')) {
      context.handle(
        _lastNotifiedAtMeta,
        lastNotifiedAt.isAcceptableOrUnknown(
          data['last_notified_at']!,
          _lastNotifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastNotifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ingredientId};
  @override
  NotificationDebounce map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationDebounce(
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      lastNotifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_notified_at'],
      )!,
    );
  }

  @override
  $NotificationDebouncesTable createAlias(String alias) {
    return $NotificationDebouncesTable(attachedDatabase, alias);
  }
}

class NotificationDebounce extends DataClass
    implements Insertable<NotificationDebounce> {
  final String ingredientId;
  final DateTime lastNotifiedAt;
  const NotificationDebounce({
    required this.ingredientId,
    required this.lastNotifiedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['last_notified_at'] = Variable<DateTime>(lastNotifiedAt);
    return map;
  }

  NotificationDebouncesCompanion toCompanion(bool nullToAbsent) {
    return NotificationDebouncesCompanion(
      ingredientId: Value(ingredientId),
      lastNotifiedAt: Value(lastNotifiedAt),
    );
  }

  factory NotificationDebounce.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationDebounce(
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      lastNotifiedAt: serializer.fromJson<DateTime>(json['lastNotifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ingredientId': serializer.toJson<String>(ingredientId),
      'lastNotifiedAt': serializer.toJson<DateTime>(lastNotifiedAt),
    };
  }

  NotificationDebounce copyWith({
    String? ingredientId,
    DateTime? lastNotifiedAt,
  }) => NotificationDebounce(
    ingredientId: ingredientId ?? this.ingredientId,
    lastNotifiedAt: lastNotifiedAt ?? this.lastNotifiedAt,
  );
  NotificationDebounce copyWithCompanion(NotificationDebouncesCompanion data) {
    return NotificationDebounce(
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      lastNotifiedAt: data.lastNotifiedAt.present
          ? data.lastNotifiedAt.value
          : this.lastNotifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationDebounce(')
          ..write('ingredientId: $ingredientId, ')
          ..write('lastNotifiedAt: $lastNotifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ingredientId, lastNotifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationDebounce &&
          other.ingredientId == this.ingredientId &&
          other.lastNotifiedAt == this.lastNotifiedAt);
}

class NotificationDebouncesCompanion
    extends UpdateCompanion<NotificationDebounce> {
  final Value<String> ingredientId;
  final Value<DateTime> lastNotifiedAt;
  final Value<int> rowid;
  const NotificationDebouncesCompanion({
    this.ingredientId = const Value.absent(),
    this.lastNotifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationDebouncesCompanion.insert({
    required String ingredientId,
    required DateTime lastNotifiedAt,
    this.rowid = const Value.absent(),
  }) : ingredientId = Value(ingredientId),
       lastNotifiedAt = Value(lastNotifiedAt);
  static Insertable<NotificationDebounce> custom({
    Expression<String>? ingredientId,
    Expression<DateTime>? lastNotifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (lastNotifiedAt != null) 'last_notified_at': lastNotifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationDebouncesCompanion copyWith({
    Value<String>? ingredientId,
    Value<DateTime>? lastNotifiedAt,
    Value<int>? rowid,
  }) {
    return NotificationDebouncesCompanion(
      ingredientId: ingredientId ?? this.ingredientId,
      lastNotifiedAt: lastNotifiedAt ?? this.lastNotifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (lastNotifiedAt.present) {
      map['last_notified_at'] = Variable<DateTime>(lastNotifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationDebouncesCompanion(')
          ..write('ingredientId: $ingredientId, ')
          ..write('lastNotifiedAt: $lastNotifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SeedMetadataTable extends SeedMetadata
    with TableInfo<$SeedMetadataTable, SeedMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeedMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seed_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeedMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SeedMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeedMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SeedMetadataTable createAlias(String alias) {
    return $SeedMetadataTable(attachedDatabase, alias);
  }
}

class SeedMetadataData extends DataClass
    implements Insertable<SeedMetadataData> {
  final String key;
  final String value;
  const SeedMetadataData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SeedMetadataCompanion toCompanion(bool nullToAbsent) {
    return SeedMetadataCompanion(key: Value(key), value: Value(value));
  }

  factory SeedMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeedMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SeedMetadataData copyWith({String? key, String? value}) =>
      SeedMetadataData(key: key ?? this.key, value: value ?? this.value);
  SeedMetadataData copyWithCompanion(SeedMetadataCompanion data) {
    return SeedMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeedMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeedMetadataData &&
          other.key == this.key &&
          other.value == this.value);
}

class SeedMetadataCompanion extends UpdateCompanion<SeedMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SeedMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeedMetadataCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SeedMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeedMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SeedMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeedMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KitchensTable extends Kitchens with TableInfo<$KitchensTable, Kitchen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KitchensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isGuestMeta = const VerificationMeta(
    'isGuest',
  );
  @override
  late final GeneratedColumn<bool> isGuest = GeneratedColumn<bool>(
    'is_guest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_guest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isGuest, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kitchens';
  @override
  VerificationContext validateIntegrity(
    Insertable<Kitchen> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_guest')) {
      context.handle(
        _isGuestMeta,
        isGuest.isAcceptableOrUnknown(data['is_guest']!, _isGuestMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Kitchen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Kitchen(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isGuest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_guest'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $KitchensTable createAlias(String alias) {
    return $KitchensTable(attachedDatabase, alias);
  }
}

class Kitchen extends DataClass implements Insertable<Kitchen> {
  final String id;
  final String name;
  final bool isGuest;
  final DateTime createdAt;
  const Kitchen({
    required this.id,
    required this.name,
    required this.isGuest,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_guest'] = Variable<bool>(isGuest);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  KitchensCompanion toCompanion(bool nullToAbsent) {
    return KitchensCompanion(
      id: Value(id),
      name: Value(name),
      isGuest: Value(isGuest),
      createdAt: Value(createdAt),
    );
  }

  factory Kitchen.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Kitchen(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isGuest: serializer.fromJson<bool>(json['isGuest']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isGuest': serializer.toJson<bool>(isGuest),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Kitchen copyWith({
    String? id,
    String? name,
    bool? isGuest,
    DateTime? createdAt,
  }) => Kitchen(
    id: id ?? this.id,
    name: name ?? this.name,
    isGuest: isGuest ?? this.isGuest,
    createdAt: createdAt ?? this.createdAt,
  );
  Kitchen copyWithCompanion(KitchensCompanion data) {
    return Kitchen(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isGuest: data.isGuest.present ? data.isGuest.value : this.isGuest,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Kitchen(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isGuest: $isGuest, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isGuest, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Kitchen &&
          other.id == this.id &&
          other.name == this.name &&
          other.isGuest == this.isGuest &&
          other.createdAt == this.createdAt);
}

class KitchensCompanion extends UpdateCompanion<Kitchen> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isGuest;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const KitchensCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isGuest = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KitchensCompanion.insert({
    required String id,
    required String name,
    this.isGuest = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Kitchen> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isGuest,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isGuest != null) 'is_guest': isGuest,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KitchensCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? isGuest,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return KitchensCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isGuest.present) {
      map['is_guest'] = Variable<bool>(isGuest.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KitchensCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isGuest: $isGuest, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $EquipmentTable equipment = $EquipmentTable(this);
  late final $IngredientSubstitutionsTable ingredientSubstitutions =
      $IngredientSubstitutionsTable(this);
  late final $EquipmentSubstitutionsTable equipmentSubstitutions =
      $EquipmentSubstitutionsTable(this);
  late final $IngredientStockPoliciesTable ingredientStockPolicies =
      $IngredientStockPoliciesTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeIngredientsTable recipeIngredients =
      $RecipeIngredientsTable(this);
  late final $RecipeEquipmentsTable recipeEquipments = $RecipeEquipmentsTable(
    this,
  );
  late final $RecipeStepsTable recipeSteps = $RecipeStepsTable(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  late final $RestockListItemsTable restockListItems = $RestockListItemsTable(
    this,
  );
  late final $CookEventsTable cookEvents = $CookEventsTable(this);
  late final $ScheduledRemindersTable scheduledReminders =
      $ScheduledRemindersTable(this);
  late final $NotificationDebouncesTable notificationDebounces =
      $NotificationDebouncesTable(this);
  late final $SeedMetadataTable seedMetadata = $SeedMetadataTable(this);
  late final $KitchensTable kitchens = $KitchensTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    ingredients,
    equipment,
    ingredientSubstitutions,
    equipmentSubstitutions,
    ingredientStockPolicies,
    recipes,
    recipeIngredients,
    recipeEquipments,
    recipeSteps,
    inventoryItems,
    restockListItems,
    cookEvents,
    scheduledReminders,
    notificationDebounces,
    seedMetadata,
    kitchens,
    appSettings,
  ];
}

typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      required String id,
      required String name,
      Value<String?> category,
      required MeasurementUnit defaultUnit,
      Value<int> rowid,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> category,
      Value<MeasurementUnit> defaultUnit,
      Value<int> rowid,
    });

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MeasurementUnit, MeasurementUnit, String>
  get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MeasurementUnit, String> get defaultUnit =>
      $composableBuilder(
        column: $table.defaultUnit,
        builder: (column) => column,
      );
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          Ingredient,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (
            Ingredient,
            BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient>,
          ),
          Ingredient,
          PrefetchHooks Function()
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<MeasurementUnit> defaultUnit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                name: name,
                category: category,
                defaultUnit: defaultUnit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> category = const Value.absent(),
                required MeasurementUnit defaultUnit,
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion.insert(
                id: id,
                name: name,
                category: category,
                defaultUnit: defaultUnit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      Ingredient,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (
        Ingredient,
        BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient>,
      ),
      Ingredient,
      PrefetchHooks Function()
    >;
typedef $$EquipmentTableCreateCompanionBuilder =
    EquipmentCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$EquipmentTableUpdateCompanionBuilder =
    EquipmentCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$EquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$EquipmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentTable,
          EquipmentData,
          $$EquipmentTableFilterComposer,
          $$EquipmentTableOrderingComposer,
          $$EquipmentTableAnnotationComposer,
          $$EquipmentTableCreateCompanionBuilder,
          $$EquipmentTableUpdateCompanionBuilder,
          (
            EquipmentData,
            BaseReferences<_$AppDatabase, $EquipmentTable, EquipmentData>,
          ),
          EquipmentData,
          PrefetchHooks Function()
        > {
  $$EquipmentTableTableManager(_$AppDatabase db, $EquipmentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => EquipmentCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquipmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentTable,
      EquipmentData,
      $$EquipmentTableFilterComposer,
      $$EquipmentTableOrderingComposer,
      $$EquipmentTableAnnotationComposer,
      $$EquipmentTableCreateCompanionBuilder,
      $$EquipmentTableUpdateCompanionBuilder,
      (
        EquipmentData,
        BaseReferences<_$AppDatabase, $EquipmentTable, EquipmentData>,
      ),
      EquipmentData,
      PrefetchHooks Function()
    >;
typedef $$IngredientSubstitutionsTableCreateCompanionBuilder =
    IngredientSubstitutionsCompanion Function({
      required String id,
      required String ingredientId,
      required String alternativeIngredientId,
      Value<double> qualityRatio,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$IngredientSubstitutionsTableUpdateCompanionBuilder =
    IngredientSubstitutionsCompanion Function({
      Value<String> id,
      Value<String> ingredientId,
      Value<String> alternativeIngredientId,
      Value<double> qualityRatio,
      Value<String?> note,
      Value<int> rowid,
    });

class $$IngredientSubstitutionsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientSubstitutionsTable> {
  $$IngredientSubstitutionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alternativeIngredientId => $composableBuilder(
    column: $table.alternativeIngredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qualityRatio => $composableBuilder(
    column: $table.qualityRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IngredientSubstitutionsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientSubstitutionsTable> {
  $$IngredientSubstitutionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alternativeIngredientId => $composableBuilder(
    column: $table.alternativeIngredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qualityRatio => $composableBuilder(
    column: $table.qualityRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientSubstitutionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientSubstitutionsTable> {
  $$IngredientSubstitutionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alternativeIngredientId => $composableBuilder(
    column: $table.alternativeIngredientId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get qualityRatio => $composableBuilder(
    column: $table.qualityRatio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$IngredientSubstitutionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientSubstitutionsTable,
          IngredientSubstitution,
          $$IngredientSubstitutionsTableFilterComposer,
          $$IngredientSubstitutionsTableOrderingComposer,
          $$IngredientSubstitutionsTableAnnotationComposer,
          $$IngredientSubstitutionsTableCreateCompanionBuilder,
          $$IngredientSubstitutionsTableUpdateCompanionBuilder,
          (
            IngredientSubstitution,
            BaseReferences<
              _$AppDatabase,
              $IngredientSubstitutionsTable,
              IngredientSubstitution
            >,
          ),
          IngredientSubstitution,
          PrefetchHooks Function()
        > {
  $$IngredientSubstitutionsTableTableManager(
    _$AppDatabase db,
    $IngredientSubstitutionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientSubstitutionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$IngredientSubstitutionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IngredientSubstitutionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<String> alternativeIngredientId = const Value.absent(),
                Value<double> qualityRatio = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientSubstitutionsCompanion(
                id: id,
                ingredientId: ingredientId,
                alternativeIngredientId: alternativeIngredientId,
                qualityRatio: qualityRatio,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ingredientId,
                required String alternativeIngredientId,
                Value<double> qualityRatio = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientSubstitutionsCompanion.insert(
                id: id,
                ingredientId: ingredientId,
                alternativeIngredientId: alternativeIngredientId,
                qualityRatio: qualityRatio,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IngredientSubstitutionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientSubstitutionsTable,
      IngredientSubstitution,
      $$IngredientSubstitutionsTableFilterComposer,
      $$IngredientSubstitutionsTableOrderingComposer,
      $$IngredientSubstitutionsTableAnnotationComposer,
      $$IngredientSubstitutionsTableCreateCompanionBuilder,
      $$IngredientSubstitutionsTableUpdateCompanionBuilder,
      (
        IngredientSubstitution,
        BaseReferences<
          _$AppDatabase,
          $IngredientSubstitutionsTable,
          IngredientSubstitution
        >,
      ),
      IngredientSubstitution,
      PrefetchHooks Function()
    >;
typedef $$EquipmentSubstitutionsTableCreateCompanionBuilder =
    EquipmentSubstitutionsCompanion Function({
      required String id,
      required String equipmentId,
      required String alternativeEquipmentId,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$EquipmentSubstitutionsTableUpdateCompanionBuilder =
    EquipmentSubstitutionsCompanion Function({
      Value<String> id,
      Value<String> equipmentId,
      Value<String> alternativeEquipmentId,
      Value<String?> note,
      Value<int> rowid,
    });

class $$EquipmentSubstitutionsTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentSubstitutionsTable> {
  $$EquipmentSubstitutionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentId => $composableBuilder(
    column: $table.equipmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alternativeEquipmentId => $composableBuilder(
    column: $table.alternativeEquipmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquipmentSubstitutionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentSubstitutionsTable> {
  $$EquipmentSubstitutionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentId => $composableBuilder(
    column: $table.equipmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alternativeEquipmentId => $composableBuilder(
    column: $table.alternativeEquipmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentSubstitutionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentSubstitutionsTable> {
  $$EquipmentSubstitutionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get equipmentId => $composableBuilder(
    column: $table.equipmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alternativeEquipmentId => $composableBuilder(
    column: $table.alternativeEquipmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$EquipmentSubstitutionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentSubstitutionsTable,
          EquipmentSubstitution,
          $$EquipmentSubstitutionsTableFilterComposer,
          $$EquipmentSubstitutionsTableOrderingComposer,
          $$EquipmentSubstitutionsTableAnnotationComposer,
          $$EquipmentSubstitutionsTableCreateCompanionBuilder,
          $$EquipmentSubstitutionsTableUpdateCompanionBuilder,
          (
            EquipmentSubstitution,
            BaseReferences<
              _$AppDatabase,
              $EquipmentSubstitutionsTable,
              EquipmentSubstitution
            >,
          ),
          EquipmentSubstitution,
          PrefetchHooks Function()
        > {
  $$EquipmentSubstitutionsTableTableManager(
    _$AppDatabase db,
    $EquipmentSubstitutionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentSubstitutionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EquipmentSubstitutionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EquipmentSubstitutionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> equipmentId = const Value.absent(),
                Value<String> alternativeEquipmentId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentSubstitutionsCompanion(
                id: id,
                equipmentId: equipmentId,
                alternativeEquipmentId: alternativeEquipmentId,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String equipmentId,
                required String alternativeEquipmentId,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentSubstitutionsCompanion.insert(
                id: id,
                equipmentId: equipmentId,
                alternativeEquipmentId: alternativeEquipmentId,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquipmentSubstitutionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentSubstitutionsTable,
      EquipmentSubstitution,
      $$EquipmentSubstitutionsTableFilterComposer,
      $$EquipmentSubstitutionsTableOrderingComposer,
      $$EquipmentSubstitutionsTableAnnotationComposer,
      $$EquipmentSubstitutionsTableCreateCompanionBuilder,
      $$EquipmentSubstitutionsTableUpdateCompanionBuilder,
      (
        EquipmentSubstitution,
        BaseReferences<
          _$AppDatabase,
          $EquipmentSubstitutionsTable,
          EquipmentSubstitution
        >,
      ),
      EquipmentSubstitution,
      PrefetchHooks Function()
    >;
typedef $$IngredientStockPoliciesTableCreateCompanionBuilder =
    IngredientStockPoliciesCompanion Function({
      required String ingredientId,
      required double parQuantity,
      required MeasurementUnit unit,
      Value<double> thresholdPercent,
      Value<bool> isCore,
      Value<int> rowid,
    });
typedef $$IngredientStockPoliciesTableUpdateCompanionBuilder =
    IngredientStockPoliciesCompanion Function({
      Value<String> ingredientId,
      Value<double> parQuantity,
      Value<MeasurementUnit> unit,
      Value<double> thresholdPercent,
      Value<bool> isCore,
      Value<int> rowid,
    });

class $$IngredientStockPoliciesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientStockPoliciesTable> {
  $$IngredientStockPoliciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get parQuantity => $composableBuilder(
    column: $table.parQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MeasurementUnit, MeasurementUnit, String>
  get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get thresholdPercent => $composableBuilder(
    column: $table.thresholdPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCore => $composableBuilder(
    column: $table.isCore,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IngredientStockPoliciesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientStockPoliciesTable> {
  $$IngredientStockPoliciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get parQuantity => $composableBuilder(
    column: $table.parQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thresholdPercent => $composableBuilder(
    column: $table.thresholdPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCore => $composableBuilder(
    column: $table.isCore,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientStockPoliciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientStockPoliciesTable> {
  $$IngredientStockPoliciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get parQuantity => $composableBuilder(
    column: $table.parQuantity,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MeasurementUnit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get thresholdPercent => $composableBuilder(
    column: $table.thresholdPercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCore =>
      $composableBuilder(column: $table.isCore, builder: (column) => column);
}

class $$IngredientStockPoliciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientStockPoliciesTable,
          IngredientStockPolicy,
          $$IngredientStockPoliciesTableFilterComposer,
          $$IngredientStockPoliciesTableOrderingComposer,
          $$IngredientStockPoliciesTableAnnotationComposer,
          $$IngredientStockPoliciesTableCreateCompanionBuilder,
          $$IngredientStockPoliciesTableUpdateCompanionBuilder,
          (
            IngredientStockPolicy,
            BaseReferences<
              _$AppDatabase,
              $IngredientStockPoliciesTable,
              IngredientStockPolicy
            >,
          ),
          IngredientStockPolicy,
          PrefetchHooks Function()
        > {
  $$IngredientStockPoliciesTableTableManager(
    _$AppDatabase db,
    $IngredientStockPoliciesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientStockPoliciesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$IngredientStockPoliciesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IngredientStockPoliciesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> ingredientId = const Value.absent(),
                Value<double> parQuantity = const Value.absent(),
                Value<MeasurementUnit> unit = const Value.absent(),
                Value<double> thresholdPercent = const Value.absent(),
                Value<bool> isCore = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientStockPoliciesCompanion(
                ingredientId: ingredientId,
                parQuantity: parQuantity,
                unit: unit,
                thresholdPercent: thresholdPercent,
                isCore: isCore,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ingredientId,
                required double parQuantity,
                required MeasurementUnit unit,
                Value<double> thresholdPercent = const Value.absent(),
                Value<bool> isCore = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientStockPoliciesCompanion.insert(
                ingredientId: ingredientId,
                parQuantity: parQuantity,
                unit: unit,
                thresholdPercent: thresholdPercent,
                isCore: isCore,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IngredientStockPoliciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientStockPoliciesTable,
      IngredientStockPolicy,
      $$IngredientStockPoliciesTableFilterComposer,
      $$IngredientStockPoliciesTableOrderingComposer,
      $$IngredientStockPoliciesTableAnnotationComposer,
      $$IngredientStockPoliciesTableCreateCompanionBuilder,
      $$IngredientStockPoliciesTableUpdateCompanionBuilder,
      (
        IngredientStockPolicy,
        BaseReferences<
          _$AppDatabase,
          $IngredientStockPoliciesTable,
          IngredientStockPolicy
        >,
      ),
      IngredientStockPolicy,
      PrefetchHooks Function()
    >;
typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required CuisineRegion cuisine,
      required MealType mealType,
      Value<int> baseServings,
      Value<int?> prepTimeMinutes,
      Value<int?> cookTimeMinutes,
      Value<String?> imageAssetPath,
      Value<double?> caloriesPerServing,
      Value<double?> proteinGrams,
      Value<double?> carbsGrams,
      Value<double?> fatGrams,
      Value<double?> fiberGrams,
      Value<bool> isVegetarian,
      Value<bool> isUserCreated,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<CuisineRegion> cuisine,
      Value<MealType> mealType,
      Value<int> baseServings,
      Value<int?> prepTimeMinutes,
      Value<int?> cookTimeMinutes,
      Value<String?> imageAssetPath,
      Value<double?> caloriesPerServing,
      Value<double?> proteinGrams,
      Value<double?> carbsGrams,
      Value<double?> fatGrams,
      Value<double?> fiberGrams,
      Value<bool> isVegetarian,
      Value<bool> isUserCreated,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CuisineRegion, CuisineRegion, String>
  get cuisine => $composableBuilder(
    column: $table.cuisine,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<MealType, MealType, String> get mealType =>
      $composableBuilder(
        column: $table.mealType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get baseServings => $composableBuilder(
    column: $table.baseServings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepTimeMinutes => $composableBuilder(
    column: $table.prepTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookTimeMinutes => $composableBuilder(
    column: $table.cookTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAssetPath => $composableBuilder(
    column: $table.imageAssetPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberGrams => $composableBuilder(
    column: $table.fiberGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVegetarian => $composableBuilder(
    column: $table.isVegetarian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUserCreated => $composableBuilder(
    column: $table.isUserCreated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuisine => $composableBuilder(
    column: $table.cuisine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseServings => $composableBuilder(
    column: $table.baseServings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepTimeMinutes => $composableBuilder(
    column: $table.prepTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookTimeMinutes => $composableBuilder(
    column: $table.cookTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAssetPath => $composableBuilder(
    column: $table.imageAssetPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberGrams => $composableBuilder(
    column: $table.fiberGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVegetarian => $composableBuilder(
    column: $table.isVegetarian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUserCreated => $composableBuilder(
    column: $table.isUserCreated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CuisineRegion, String> get cuisine =>
      $composableBuilder(column: $table.cuisine, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MealType, String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<int> get baseServings => $composableBuilder(
    column: $table.baseServings,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prepTimeMinutes => $composableBuilder(
    column: $table.prepTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cookTimeMinutes => $composableBuilder(
    column: $table.cookTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageAssetPath => $composableBuilder(
    column: $table.imageAssetPath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatGrams =>
      $composableBuilder(column: $table.fatGrams, builder: (column) => column);

  GeneratedColumn<double> get fiberGrams => $composableBuilder(
    column: $table.fiberGrams,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVegetarian => $composableBuilder(
    column: $table.isVegetarian,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUserCreated => $composableBuilder(
    column: $table.isUserCreated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
          Recipe,
          PrefetchHooks Function()
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<CuisineRegion> cuisine = const Value.absent(),
                Value<MealType> mealType = const Value.absent(),
                Value<int> baseServings = const Value.absent(),
                Value<int?> prepTimeMinutes = const Value.absent(),
                Value<int?> cookTimeMinutes = const Value.absent(),
                Value<String?> imageAssetPath = const Value.absent(),
                Value<double?> caloriesPerServing = const Value.absent(),
                Value<double?> proteinGrams = const Value.absent(),
                Value<double?> carbsGrams = const Value.absent(),
                Value<double?> fatGrams = const Value.absent(),
                Value<double?> fiberGrams = const Value.absent(),
                Value<bool> isVegetarian = const Value.absent(),
                Value<bool> isUserCreated = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                name: name,
                description: description,
                cuisine: cuisine,
                mealType: mealType,
                baseServings: baseServings,
                prepTimeMinutes: prepTimeMinutes,
                cookTimeMinutes: cookTimeMinutes,
                imageAssetPath: imageAssetPath,
                caloriesPerServing: caloriesPerServing,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                fiberGrams: fiberGrams,
                isVegetarian: isVegetarian,
                isUserCreated: isUserCreated,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required CuisineRegion cuisine,
                required MealType mealType,
                Value<int> baseServings = const Value.absent(),
                Value<int?> prepTimeMinutes = const Value.absent(),
                Value<int?> cookTimeMinutes = const Value.absent(),
                Value<String?> imageAssetPath = const Value.absent(),
                Value<double?> caloriesPerServing = const Value.absent(),
                Value<double?> proteinGrams = const Value.absent(),
                Value<double?> carbsGrams = const Value.absent(),
                Value<double?> fatGrams = const Value.absent(),
                Value<double?> fiberGrams = const Value.absent(),
                Value<bool> isVegetarian = const Value.absent(),
                Value<bool> isUserCreated = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                name: name,
                description: description,
                cuisine: cuisine,
                mealType: mealType,
                baseServings: baseServings,
                prepTimeMinutes: prepTimeMinutes,
                cookTimeMinutes: cookTimeMinutes,
                imageAssetPath: imageAssetPath,
                caloriesPerServing: caloriesPerServing,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                fiberGrams: fiberGrams,
                isVegetarian: isVegetarian,
                isUserCreated: isUserCreated,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
      Recipe,
      PrefetchHooks Function()
    >;
typedef $$RecipeIngredientsTableCreateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      required String id,
      required String recipeId,
      required String ingredientId,
      required double quantityPerServing,
      required MeasurementUnit unit,
      Value<bool> isOptional,
      Value<String?> preparationNote,
      Value<int> rowid,
    });
typedef $$RecipeIngredientsTableUpdateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<String> ingredientId,
      Value<double> quantityPerServing,
      Value<MeasurementUnit> unit,
      Value<bool> isOptional,
      Value<String?> preparationNote,
      Value<int> rowid,
    });

class $$RecipeIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityPerServing => $composableBuilder(
    column: $table.quantityPerServing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MeasurementUnit, MeasurementUnit, String>
  get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preparationNote => $composableBuilder(
    column: $table.preparationNote,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityPerServing => $composableBuilder(
    column: $table.quantityPerServing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preparationNote => $composableBuilder(
    column: $table.preparationNote,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantityPerServing => $composableBuilder(
    column: $table.quantityPerServing,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MeasurementUnit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preparationNote => $composableBuilder(
    column: $table.preparationNote,
    builder: (column) => column,
  );
}

class $$RecipeIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient,
          $$RecipeIngredientsTableFilterComposer,
          $$RecipeIngredientsTableOrderingComposer,
          $$RecipeIngredientsTableAnnotationComposer,
          $$RecipeIngredientsTableCreateCompanionBuilder,
          $$RecipeIngredientsTableUpdateCompanionBuilder,
          (
            RecipeIngredient,
            BaseReferences<
              _$AppDatabase,
              $RecipeIngredientsTable,
              RecipeIngredient
            >,
          ),
          RecipeIngredient,
          PrefetchHooks Function()
        > {
  $$RecipeIngredientsTableTableManager(
    _$AppDatabase db,
    $RecipeIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<double> quantityPerServing = const Value.absent(),
                Value<MeasurementUnit> unit = const Value.absent(),
                Value<bool> isOptional = const Value.absent(),
                Value<String?> preparationNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion(
                id: id,
                recipeId: recipeId,
                ingredientId: ingredientId,
                quantityPerServing: quantityPerServing,
                unit: unit,
                isOptional: isOptional,
                preparationNote: preparationNote,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                required String ingredientId,
                required double quantityPerServing,
                required MeasurementUnit unit,
                Value<bool> isOptional = const Value.absent(),
                Value<String?> preparationNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion.insert(
                id: id,
                recipeId: recipeId,
                ingredientId: ingredientId,
                quantityPerServing: quantityPerServing,
                unit: unit,
                isOptional: isOptional,
                preparationNote: preparationNote,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipeIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeIngredientsTable,
      RecipeIngredient,
      $$RecipeIngredientsTableFilterComposer,
      $$RecipeIngredientsTableOrderingComposer,
      $$RecipeIngredientsTableAnnotationComposer,
      $$RecipeIngredientsTableCreateCompanionBuilder,
      $$RecipeIngredientsTableUpdateCompanionBuilder,
      (
        RecipeIngredient,
        BaseReferences<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient
        >,
      ),
      RecipeIngredient,
      PrefetchHooks Function()
    >;
typedef $$RecipeEquipmentsTableCreateCompanionBuilder =
    RecipeEquipmentsCompanion Function({
      required String id,
      required String recipeId,
      required String equipmentId,
      Value<bool> isEssential,
      Value<bool> commonlySubstituted,
      Value<int> rowid,
    });
typedef $$RecipeEquipmentsTableUpdateCompanionBuilder =
    RecipeEquipmentsCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<String> equipmentId,
      Value<bool> isEssential,
      Value<bool> commonlySubstituted,
      Value<int> rowid,
    });

class $$RecipeEquipmentsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeEquipmentsTable> {
  $$RecipeEquipmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentId => $composableBuilder(
    column: $table.equipmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEssential => $composableBuilder(
    column: $table.isEssential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get commonlySubstituted => $composableBuilder(
    column: $table.commonlySubstituted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeEquipmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeEquipmentsTable> {
  $$RecipeEquipmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentId => $composableBuilder(
    column: $table.equipmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEssential => $composableBuilder(
    column: $table.isEssential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get commonlySubstituted => $composableBuilder(
    column: $table.commonlySubstituted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeEquipmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeEquipmentsTable> {
  $$RecipeEquipmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get equipmentId => $composableBuilder(
    column: $table.equipmentId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEssential => $composableBuilder(
    column: $table.isEssential,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get commonlySubstituted => $composableBuilder(
    column: $table.commonlySubstituted,
    builder: (column) => column,
  );
}

class $$RecipeEquipmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeEquipmentsTable,
          RecipeEquipment,
          $$RecipeEquipmentsTableFilterComposer,
          $$RecipeEquipmentsTableOrderingComposer,
          $$RecipeEquipmentsTableAnnotationComposer,
          $$RecipeEquipmentsTableCreateCompanionBuilder,
          $$RecipeEquipmentsTableUpdateCompanionBuilder,
          (
            RecipeEquipment,
            BaseReferences<
              _$AppDatabase,
              $RecipeEquipmentsTable,
              RecipeEquipment
            >,
          ),
          RecipeEquipment,
          PrefetchHooks Function()
        > {
  $$RecipeEquipmentsTableTableManager(
    _$AppDatabase db,
    $RecipeEquipmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeEquipmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeEquipmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeEquipmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String> equipmentId = const Value.absent(),
                Value<bool> isEssential = const Value.absent(),
                Value<bool> commonlySubstituted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeEquipmentsCompanion(
                id: id,
                recipeId: recipeId,
                equipmentId: equipmentId,
                isEssential: isEssential,
                commonlySubstituted: commonlySubstituted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                required String equipmentId,
                Value<bool> isEssential = const Value.absent(),
                Value<bool> commonlySubstituted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeEquipmentsCompanion.insert(
                id: id,
                recipeId: recipeId,
                equipmentId: equipmentId,
                isEssential: isEssential,
                commonlySubstituted: commonlySubstituted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipeEquipmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeEquipmentsTable,
      RecipeEquipment,
      $$RecipeEquipmentsTableFilterComposer,
      $$RecipeEquipmentsTableOrderingComposer,
      $$RecipeEquipmentsTableAnnotationComposer,
      $$RecipeEquipmentsTableCreateCompanionBuilder,
      $$RecipeEquipmentsTableUpdateCompanionBuilder,
      (
        RecipeEquipment,
        BaseReferences<_$AppDatabase, $RecipeEquipmentsTable, RecipeEquipment>,
      ),
      RecipeEquipment,
      PrefetchHooks Function()
    >;
typedef $$RecipeStepsTableCreateCompanionBuilder =
    RecipeStepsCompanion Function({
      required String id,
      required String recipeId,
      required int orderIndex,
      required String instruction,
      Value<String?> stepGroupId,
      Value<GasFlameLevel?> flameLevel,
      Value<int?> estimatedDurationSeconds,
      Value<int> rowid,
    });
typedef $$RecipeStepsTableUpdateCompanionBuilder =
    RecipeStepsCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<int> orderIndex,
      Value<String> instruction,
      Value<String?> stepGroupId,
      Value<GasFlameLevel?> flameLevel,
      Value<int?> estimatedDurationSeconds,
      Value<int> rowid,
    });

class $$RecipeStepsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instruction => $composableBuilder(
    column: $table.instruction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stepGroupId => $composableBuilder(
    column: $table.stepGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GasFlameLevel?, GasFlameLevel, String>
  get flameLevel => $composableBuilder(
    column: $table.flameLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get estimatedDurationSeconds => $composableBuilder(
    column: $table.estimatedDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instruction => $composableBuilder(
    column: $table.instruction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepGroupId => $composableBuilder(
    column: $table.stepGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flameLevel => $composableBuilder(
    column: $table.flameLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedDurationSeconds => $composableBuilder(
    column: $table.estimatedDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instruction => $composableBuilder(
    column: $table.instruction,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stepGroupId => $composableBuilder(
    column: $table.stepGroupId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<GasFlameLevel?, String> get flameLevel =>
      $composableBuilder(
        column: $table.flameLevel,
        builder: (column) => column,
      );

  GeneratedColumn<int> get estimatedDurationSeconds => $composableBuilder(
    column: $table.estimatedDurationSeconds,
    builder: (column) => column,
  );
}

class $$RecipeStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeStepsTable,
          RecipeStep,
          $$RecipeStepsTableFilterComposer,
          $$RecipeStepsTableOrderingComposer,
          $$RecipeStepsTableAnnotationComposer,
          $$RecipeStepsTableCreateCompanionBuilder,
          $$RecipeStepsTableUpdateCompanionBuilder,
          (
            RecipeStep,
            BaseReferences<_$AppDatabase, $RecipeStepsTable, RecipeStep>,
          ),
          RecipeStep,
          PrefetchHooks Function()
        > {
  $$RecipeStepsTableTableManager(_$AppDatabase db, $RecipeStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> instruction = const Value.absent(),
                Value<String?> stepGroupId = const Value.absent(),
                Value<GasFlameLevel?> flameLevel = const Value.absent(),
                Value<int?> estimatedDurationSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeStepsCompanion(
                id: id,
                recipeId: recipeId,
                orderIndex: orderIndex,
                instruction: instruction,
                stepGroupId: stepGroupId,
                flameLevel: flameLevel,
                estimatedDurationSeconds: estimatedDurationSeconds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                required int orderIndex,
                required String instruction,
                Value<String?> stepGroupId = const Value.absent(),
                Value<GasFlameLevel?> flameLevel = const Value.absent(),
                Value<int?> estimatedDurationSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeStepsCompanion.insert(
                id: id,
                recipeId: recipeId,
                orderIndex: orderIndex,
                instruction: instruction,
                stepGroupId: stepGroupId,
                flameLevel: flameLevel,
                estimatedDurationSeconds: estimatedDurationSeconds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipeStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeStepsTable,
      RecipeStep,
      $$RecipeStepsTableFilterComposer,
      $$RecipeStepsTableOrderingComposer,
      $$RecipeStepsTableAnnotationComposer,
      $$RecipeStepsTableCreateCompanionBuilder,
      $$RecipeStepsTableUpdateCompanionBuilder,
      (
        RecipeStep,
        BaseReferences<_$AppDatabase, $RecipeStepsTable, RecipeStep>,
      ),
      RecipeStep,
      PrefetchHooks Function()
    >;
typedef $$InventoryItemsTableCreateCompanionBuilder =
    InventoryItemsCompanion Function({
      required String id,
      Value<String> kitchenId,
      Value<String?> ingredientId,
      Value<String?> customName,
      required double quantity,
      required MeasurementUnit unit,
      required DateTime purchaseDate,
      Value<int?> shelfLifeDays,
      required DateTime expiryDate,
      Value<double?> originalQuantity,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$InventoryItemsTableUpdateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<String> id,
      Value<String> kitchenId,
      Value<String?> ingredientId,
      Value<String?> customName,
      Value<double> quantity,
      Value<MeasurementUnit> unit,
      Value<DateTime> purchaseDate,
      Value<int?> shelfLifeDays,
      Value<DateTime> expiryDate,
      Value<double?> originalQuantity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$InventoryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MeasurementUnit, MeasurementUnit, String>
  get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shelfLifeDays => $composableBuilder(
    column: $table.shelfLifeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get originalQuantity => $composableBuilder(
    column: $table.originalQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shelfLifeDays => $composableBuilder(
    column: $table.shelfLifeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get originalQuantity => $composableBuilder(
    column: $table.originalQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kitchenId =>
      $composableBuilder(column: $table.kitchenId, builder: (column) => column);

  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MeasurementUnit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shelfLifeDays => $composableBuilder(
    column: $table.shelfLifeDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get originalQuantity => $composableBuilder(
    column: $table.originalQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InventoryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryItemsTable,
          InventoryItem,
          $$InventoryItemsTableFilterComposer,
          $$InventoryItemsTableOrderingComposer,
          $$InventoryItemsTableAnnotationComposer,
          $$InventoryItemsTableCreateCompanionBuilder,
          $$InventoryItemsTableUpdateCompanionBuilder,
          (
            InventoryItem,
            BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItem>,
          ),
          InventoryItem,
          PrefetchHooks Function()
        > {
  $$InventoryItemsTableTableManager(
    _$AppDatabase db,
    $InventoryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kitchenId = const Value.absent(),
                Value<String?> ingredientId = const Value.absent(),
                Value<String?> customName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<MeasurementUnit> unit = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<int?> shelfLifeDays = const Value.absent(),
                Value<DateTime> expiryDate = const Value.absent(),
                Value<double?> originalQuantity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryItemsCompanion(
                id: id,
                kitchenId: kitchenId,
                ingredientId: ingredientId,
                customName: customName,
                quantity: quantity,
                unit: unit,
                purchaseDate: purchaseDate,
                shelfLifeDays: shelfLifeDays,
                expiryDate: expiryDate,
                originalQuantity: originalQuantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> kitchenId = const Value.absent(),
                Value<String?> ingredientId = const Value.absent(),
                Value<String?> customName = const Value.absent(),
                required double quantity,
                required MeasurementUnit unit,
                required DateTime purchaseDate,
                Value<int?> shelfLifeDays = const Value.absent(),
                required DateTime expiryDate,
                Value<double?> originalQuantity = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InventoryItemsCompanion.insert(
                id: id,
                kitchenId: kitchenId,
                ingredientId: ingredientId,
                customName: customName,
                quantity: quantity,
                unit: unit,
                purchaseDate: purchaseDate,
                shelfLifeDays: shelfLifeDays,
                expiryDate: expiryDate,
                originalQuantity: originalQuantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryItemsTable,
      InventoryItem,
      $$InventoryItemsTableFilterComposer,
      $$InventoryItemsTableOrderingComposer,
      $$InventoryItemsTableAnnotationComposer,
      $$InventoryItemsTableCreateCompanionBuilder,
      $$InventoryItemsTableUpdateCompanionBuilder,
      (
        InventoryItem,
        BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItem>,
      ),
      InventoryItem,
      PrefetchHooks Function()
    >;
typedef $$RestockListItemsTableCreateCompanionBuilder =
    RestockListItemsCompanion Function({
      required String id,
      Value<String> kitchenId,
      Value<String?> ingredientId,
      required String itemName,
      Value<double?> suggestedQuantity,
      Value<MeasurementUnit?> unit,
      required RestockReason reason,
      required DateTime addedAt,
      Value<bool> isResolved,
      Value<int> rowid,
    });
typedef $$RestockListItemsTableUpdateCompanionBuilder =
    RestockListItemsCompanion Function({
      Value<String> id,
      Value<String> kitchenId,
      Value<String?> ingredientId,
      Value<String> itemName,
      Value<double?> suggestedQuantity,
      Value<MeasurementUnit?> unit,
      Value<RestockReason> reason,
      Value<DateTime> addedAt,
      Value<bool> isResolved,
      Value<int> rowid,
    });

class $$RestockListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RestockListItemsTable> {
  $$RestockListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get suggestedQuantity => $composableBuilder(
    column: $table.suggestedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MeasurementUnit?, MeasurementUnit, String>
  get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<RestockReason, RestockReason, String>
  get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RestockListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RestockListItemsTable> {
  $$RestockListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kitchenId => $composableBuilder(
    column: $table.kitchenId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get suggestedQuantity => $composableBuilder(
    column: $table.suggestedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestockListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestockListItemsTable> {
  $$RestockListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kitchenId =>
      $composableBuilder(column: $table.kitchenId, builder: (column) => column);

  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<double> get suggestedQuantity => $composableBuilder(
    column: $table.suggestedQuantity,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MeasurementUnit?, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RestockReason, String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => column,
  );
}

class $$RestockListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestockListItemsTable,
          RestockListItem,
          $$RestockListItemsTableFilterComposer,
          $$RestockListItemsTableOrderingComposer,
          $$RestockListItemsTableAnnotationComposer,
          $$RestockListItemsTableCreateCompanionBuilder,
          $$RestockListItemsTableUpdateCompanionBuilder,
          (
            RestockListItem,
            BaseReferences<
              _$AppDatabase,
              $RestockListItemsTable,
              RestockListItem
            >,
          ),
          RestockListItem,
          PrefetchHooks Function()
        > {
  $$RestockListItemsTableTableManager(
    _$AppDatabase db,
    $RestockListItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestockListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestockListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestockListItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kitchenId = const Value.absent(),
                Value<String?> ingredientId = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<double?> suggestedQuantity = const Value.absent(),
                Value<MeasurementUnit?> unit = const Value.absent(),
                Value<RestockReason> reason = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<bool> isResolved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestockListItemsCompanion(
                id: id,
                kitchenId: kitchenId,
                ingredientId: ingredientId,
                itemName: itemName,
                suggestedQuantity: suggestedQuantity,
                unit: unit,
                reason: reason,
                addedAt: addedAt,
                isResolved: isResolved,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> kitchenId = const Value.absent(),
                Value<String?> ingredientId = const Value.absent(),
                required String itemName,
                Value<double?> suggestedQuantity = const Value.absent(),
                Value<MeasurementUnit?> unit = const Value.absent(),
                required RestockReason reason,
                required DateTime addedAt,
                Value<bool> isResolved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestockListItemsCompanion.insert(
                id: id,
                kitchenId: kitchenId,
                ingredientId: ingredientId,
                itemName: itemName,
                suggestedQuantity: suggestedQuantity,
                unit: unit,
                reason: reason,
                addedAt: addedAt,
                isResolved: isResolved,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RestockListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestockListItemsTable,
      RestockListItem,
      $$RestockListItemsTableFilterComposer,
      $$RestockListItemsTableOrderingComposer,
      $$RestockListItemsTableAnnotationComposer,
      $$RestockListItemsTableCreateCompanionBuilder,
      $$RestockListItemsTableUpdateCompanionBuilder,
      (
        RestockListItem,
        BaseReferences<_$AppDatabase, $RestockListItemsTable, RestockListItem>,
      ),
      RestockListItem,
      PrefetchHooks Function()
    >;
typedef $$CookEventsTableCreateCompanionBuilder =
    CookEventsCompanion Function({
      required String id,
      Value<String?> recipeId,
      required DateTime cookedAt,
      Value<String> ingredientIdsCsv,
      Value<int> rowid,
    });
typedef $$CookEventsTableUpdateCompanionBuilder =
    CookEventsCompanion Function({
      Value<String> id,
      Value<String?> recipeId,
      Value<DateTime> cookedAt,
      Value<String> ingredientIdsCsv,
      Value<int> rowid,
    });

class $$CookEventsTableFilterComposer
    extends Composer<_$AppDatabase, $CookEventsTable> {
  $$CookEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cookedAt => $composableBuilder(
    column: $table.cookedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientIdsCsv => $composableBuilder(
    column: $table.ingredientIdsCsv,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CookEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $CookEventsTable> {
  $$CookEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cookedAt => $composableBuilder(
    column: $table.cookedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientIdsCsv => $composableBuilder(
    column: $table.ingredientIdsCsv,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CookEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CookEventsTable> {
  $$CookEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get cookedAt =>
      $composableBuilder(column: $table.cookedAt, builder: (column) => column);

  GeneratedColumn<String> get ingredientIdsCsv => $composableBuilder(
    column: $table.ingredientIdsCsv,
    builder: (column) => column,
  );
}

class $$CookEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CookEventsTable,
          CookEvent,
          $$CookEventsTableFilterComposer,
          $$CookEventsTableOrderingComposer,
          $$CookEventsTableAnnotationComposer,
          $$CookEventsTableCreateCompanionBuilder,
          $$CookEventsTableUpdateCompanionBuilder,
          (
            CookEvent,
            BaseReferences<_$AppDatabase, $CookEventsTable, CookEvent>,
          ),
          CookEvent,
          PrefetchHooks Function()
        > {
  $$CookEventsTableTableManager(_$AppDatabase db, $CookEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CookEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CookEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CookEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> recipeId = const Value.absent(),
                Value<DateTime> cookedAt = const Value.absent(),
                Value<String> ingredientIdsCsv = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CookEventsCompanion(
                id: id,
                recipeId: recipeId,
                cookedAt: cookedAt,
                ingredientIdsCsv: ingredientIdsCsv,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> recipeId = const Value.absent(),
                required DateTime cookedAt,
                Value<String> ingredientIdsCsv = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CookEventsCompanion.insert(
                id: id,
                recipeId: recipeId,
                cookedAt: cookedAt,
                ingredientIdsCsv: ingredientIdsCsv,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CookEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CookEventsTable,
      CookEvent,
      $$CookEventsTableFilterComposer,
      $$CookEventsTableOrderingComposer,
      $$CookEventsTableAnnotationComposer,
      $$CookEventsTableCreateCompanionBuilder,
      $$CookEventsTableUpdateCompanionBuilder,
      (CookEvent, BaseReferences<_$AppDatabase, $CookEventsTable, CookEvent>),
      CookEvent,
      PrefetchHooks Function()
    >;
typedef $$ScheduledRemindersTableCreateCompanionBuilder =
    ScheduledRemindersCompanion Function({
      required String id,
      Value<String?> inventoryItemId,
      required int notificationId,
      required ReminderType type,
      required DateTime scheduledFor,
      Value<int> rowid,
    });
typedef $$ScheduledRemindersTableUpdateCompanionBuilder =
    ScheduledRemindersCompanion Function({
      Value<String> id,
      Value<String?> inventoryItemId,
      Value<int> notificationId,
      Value<ReminderType> type,
      Value<DateTime> scheduledFor,
      Value<int> rowid,
    });

class $$ScheduledRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledRemindersTable> {
  $$ScheduledRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inventoryItemId => $composableBuilder(
    column: $table.inventoryItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReminderType, ReminderType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScheduledRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledRemindersTable> {
  $$ScheduledRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inventoryItemId => $composableBuilder(
    column: $table.inventoryItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduledRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledRemindersTable> {
  $$ScheduledRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get inventoryItemId => $composableBuilder(
    column: $table.inventoryItemId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ReminderType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => column,
  );
}

class $$ScheduledRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduledRemindersTable,
          ScheduledReminder,
          $$ScheduledRemindersTableFilterComposer,
          $$ScheduledRemindersTableOrderingComposer,
          $$ScheduledRemindersTableAnnotationComposer,
          $$ScheduledRemindersTableCreateCompanionBuilder,
          $$ScheduledRemindersTableUpdateCompanionBuilder,
          (
            ScheduledReminder,
            BaseReferences<
              _$AppDatabase,
              $ScheduledRemindersTable,
              ScheduledReminder
            >,
          ),
          ScheduledReminder,
          PrefetchHooks Function()
        > {
  $$ScheduledRemindersTableTableManager(
    _$AppDatabase db,
    $ScheduledRemindersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduledRemindersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> inventoryItemId = const Value.absent(),
                Value<int> notificationId = const Value.absent(),
                Value<ReminderType> type = const Value.absent(),
                Value<DateTime> scheduledFor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduledRemindersCompanion(
                id: id,
                inventoryItemId: inventoryItemId,
                notificationId: notificationId,
                type: type,
                scheduledFor: scheduledFor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> inventoryItemId = const Value.absent(),
                required int notificationId,
                required ReminderType type,
                required DateTime scheduledFor,
                Value<int> rowid = const Value.absent(),
              }) => ScheduledRemindersCompanion.insert(
                id: id,
                inventoryItemId: inventoryItemId,
                notificationId: notificationId,
                type: type,
                scheduledFor: scheduledFor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScheduledRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduledRemindersTable,
      ScheduledReminder,
      $$ScheduledRemindersTableFilterComposer,
      $$ScheduledRemindersTableOrderingComposer,
      $$ScheduledRemindersTableAnnotationComposer,
      $$ScheduledRemindersTableCreateCompanionBuilder,
      $$ScheduledRemindersTableUpdateCompanionBuilder,
      (
        ScheduledReminder,
        BaseReferences<
          _$AppDatabase,
          $ScheduledRemindersTable,
          ScheduledReminder
        >,
      ),
      ScheduledReminder,
      PrefetchHooks Function()
    >;
typedef $$NotificationDebouncesTableCreateCompanionBuilder =
    NotificationDebouncesCompanion Function({
      required String ingredientId,
      required DateTime lastNotifiedAt,
      Value<int> rowid,
    });
typedef $$NotificationDebouncesTableUpdateCompanionBuilder =
    NotificationDebouncesCompanion Function({
      Value<String> ingredientId,
      Value<DateTime> lastNotifiedAt,
      Value<int> rowid,
    });

class $$NotificationDebouncesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationDebouncesTable> {
  $$NotificationDebouncesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationDebouncesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationDebouncesTable> {
  $$NotificationDebouncesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationDebouncesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationDebouncesTable> {
  $$NotificationDebouncesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => column,
  );
}

class $$NotificationDebouncesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationDebouncesTable,
          NotificationDebounce,
          $$NotificationDebouncesTableFilterComposer,
          $$NotificationDebouncesTableOrderingComposer,
          $$NotificationDebouncesTableAnnotationComposer,
          $$NotificationDebouncesTableCreateCompanionBuilder,
          $$NotificationDebouncesTableUpdateCompanionBuilder,
          (
            NotificationDebounce,
            BaseReferences<
              _$AppDatabase,
              $NotificationDebouncesTable,
              NotificationDebounce
            >,
          ),
          NotificationDebounce,
          PrefetchHooks Function()
        > {
  $$NotificationDebouncesTableTableManager(
    _$AppDatabase db,
    $NotificationDebouncesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationDebouncesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationDebouncesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationDebouncesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> ingredientId = const Value.absent(),
                Value<DateTime> lastNotifiedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationDebouncesCompanion(
                ingredientId: ingredientId,
                lastNotifiedAt: lastNotifiedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ingredientId,
                required DateTime lastNotifiedAt,
                Value<int> rowid = const Value.absent(),
              }) => NotificationDebouncesCompanion.insert(
                ingredientId: ingredientId,
                lastNotifiedAt: lastNotifiedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationDebouncesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationDebouncesTable,
      NotificationDebounce,
      $$NotificationDebouncesTableFilterComposer,
      $$NotificationDebouncesTableOrderingComposer,
      $$NotificationDebouncesTableAnnotationComposer,
      $$NotificationDebouncesTableCreateCompanionBuilder,
      $$NotificationDebouncesTableUpdateCompanionBuilder,
      (
        NotificationDebounce,
        BaseReferences<
          _$AppDatabase,
          $NotificationDebouncesTable,
          NotificationDebounce
        >,
      ),
      NotificationDebounce,
      PrefetchHooks Function()
    >;
typedef $$SeedMetadataTableCreateCompanionBuilder =
    SeedMetadataCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SeedMetadataTableUpdateCompanionBuilder =
    SeedMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SeedMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SeedMetadataTable> {
  $$SeedMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SeedMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SeedMetadataTable> {
  $$SeedMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SeedMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeedMetadataTable> {
  $$SeedMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SeedMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeedMetadataTable,
          SeedMetadataData,
          $$SeedMetadataTableFilterComposer,
          $$SeedMetadataTableOrderingComposer,
          $$SeedMetadataTableAnnotationComposer,
          $$SeedMetadataTableCreateCompanionBuilder,
          $$SeedMetadataTableUpdateCompanionBuilder,
          (
            SeedMetadataData,
            BaseReferences<_$AppDatabase, $SeedMetadataTable, SeedMetadataData>,
          ),
          SeedMetadataData,
          PrefetchHooks Function()
        > {
  $$SeedMetadataTableTableManager(_$AppDatabase db, $SeedMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeedMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeedMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeedMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeedMetadataCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SeedMetadataCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SeedMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeedMetadataTable,
      SeedMetadataData,
      $$SeedMetadataTableFilterComposer,
      $$SeedMetadataTableOrderingComposer,
      $$SeedMetadataTableAnnotationComposer,
      $$SeedMetadataTableCreateCompanionBuilder,
      $$SeedMetadataTableUpdateCompanionBuilder,
      (
        SeedMetadataData,
        BaseReferences<_$AppDatabase, $SeedMetadataTable, SeedMetadataData>,
      ),
      SeedMetadataData,
      PrefetchHooks Function()
    >;
typedef $$KitchensTableCreateCompanionBuilder =
    KitchensCompanion Function({
      required String id,
      required String name,
      Value<bool> isGuest,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$KitchensTableUpdateCompanionBuilder =
    KitchensCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<bool> isGuest,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$KitchensTableFilterComposer
    extends Composer<_$AppDatabase, $KitchensTable> {
  $$KitchensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGuest => $composableBuilder(
    column: $table.isGuest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KitchensTableOrderingComposer
    extends Composer<_$AppDatabase, $KitchensTable> {
  $$KitchensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGuest => $composableBuilder(
    column: $table.isGuest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KitchensTableAnnotationComposer
    extends Composer<_$AppDatabase, $KitchensTable> {
  $$KitchensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isGuest =>
      $composableBuilder(column: $table.isGuest, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$KitchensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KitchensTable,
          Kitchen,
          $$KitchensTableFilterComposer,
          $$KitchensTableOrderingComposer,
          $$KitchensTableAnnotationComposer,
          $$KitchensTableCreateCompanionBuilder,
          $$KitchensTableUpdateCompanionBuilder,
          (Kitchen, BaseReferences<_$AppDatabase, $KitchensTable, Kitchen>),
          Kitchen,
          PrefetchHooks Function()
        > {
  $$KitchensTableTableManager(_$AppDatabase db, $KitchensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KitchensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KitchensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KitchensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isGuest = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KitchensCompanion(
                id: id,
                name: name,
                isGuest: isGuest,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<bool> isGuest = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => KitchensCompanion.insert(
                id: id,
                name: name,
                isGuest: isGuest,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KitchensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KitchensTable,
      Kitchen,
      $$KitchensTableFilterComposer,
      $$KitchensTableOrderingComposer,
      $$KitchensTableAnnotationComposer,
      $$KitchensTableCreateCompanionBuilder,
      $$KitchensTableUpdateCompanionBuilder,
      (Kitchen, BaseReferences<_$AppDatabase, $KitchensTable, Kitchen>),
      Kitchen,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$EquipmentTableTableManager get equipment =>
      $$EquipmentTableTableManager(_db, _db.equipment);
  $$IngredientSubstitutionsTableTableManager get ingredientSubstitutions =>
      $$IngredientSubstitutionsTableTableManager(
        _db,
        _db.ingredientSubstitutions,
      );
  $$EquipmentSubstitutionsTableTableManager get equipmentSubstitutions =>
      $$EquipmentSubstitutionsTableTableManager(
        _db,
        _db.equipmentSubstitutions,
      );
  $$IngredientStockPoliciesTableTableManager get ingredientStockPolicies =>
      $$IngredientStockPoliciesTableTableManager(
        _db,
        _db.ingredientStockPolicies,
      );
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeIngredientsTableTableManager get recipeIngredients =>
      $$RecipeIngredientsTableTableManager(_db, _db.recipeIngredients);
  $$RecipeEquipmentsTableTableManager get recipeEquipments =>
      $$RecipeEquipmentsTableTableManager(_db, _db.recipeEquipments);
  $$RecipeStepsTableTableManager get recipeSteps =>
      $$RecipeStepsTableTableManager(_db, _db.recipeSteps);
  $$InventoryItemsTableTableManager get inventoryItems =>
      $$InventoryItemsTableTableManager(_db, _db.inventoryItems);
  $$RestockListItemsTableTableManager get restockListItems =>
      $$RestockListItemsTableTableManager(_db, _db.restockListItems);
  $$CookEventsTableTableManager get cookEvents =>
      $$CookEventsTableTableManager(_db, _db.cookEvents);
  $$ScheduledRemindersTableTableManager get scheduledReminders =>
      $$ScheduledRemindersTableTableManager(_db, _db.scheduledReminders);
  $$NotificationDebouncesTableTableManager get notificationDebounces =>
      $$NotificationDebouncesTableTableManager(_db, _db.notificationDebounces);
  $$SeedMetadataTableTableManager get seedMetadata =>
      $$SeedMetadataTableTableManager(_db, _db.seedMetadata);
  $$KitchensTableTableManager get kitchens =>
      $$KitchensTableTableManager(_db, _db.kitchens);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
