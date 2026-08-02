// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPetModelCollection on Isar {
  IsarCollection<PetModel> get petModels => this.collection();
}

const PetModelSchema = CollectionSchema(
  name: r'PetModel',
  id: -6025191587648539153,
  properties: {
    r'accessory': PropertySchema(
      id: 0,
      name: r'accessory',
      type: IsarType.string,
      enumMap: _PetModelaccessoryEnumValueMap,
    ),
    r'avgDailySteps': PropertySchema(
      id: 1,
      name: r'avgDailySteps',
      type: IsarType.double,
    ),
    r'bestStreak': PropertySchema(
      id: 2,
      name: r'bestStreak',
      type: IsarType.long,
    ),
    r'breed': PropertySchema(
      id: 3,
      name: r'breed',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 4,
      name: r'color',
      type: IsarType.string,
    ),
    r'consecutiveDays': PropertySchema(
      id: 5,
      name: r'consecutiveDays',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 6,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'experience': PropertySchema(
      id: 7,
      name: r'experience',
      type: IsarType.long,
    ),
    r'happiness': PropertySchema(
      id: 8,
      name: r'happiness',
      type: IsarType.long,
    ),
    r'isActive': PropertySchema(
      id: 9,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'lastDecayDate': PropertySchema(
      id: 10,
      name: r'lastDecayDate',
      type: IsarType.dateTime,
    ),
    r'lastUpdate': PropertySchema(
      id: 11,
      name: r'lastUpdate',
      type: IsarType.dateTime,
    ),
    r'level': PropertySchema(
      id: 12,
      name: r'level',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 13,
      name: r'name',
      type: IsarType.string,
    ),
    r'personality': PropertySchema(
      id: 14,
      name: r'personality',
      type: IsarType.string,
      enumMap: _PetModelpersonalityEnumValueMap,
    ),
    r'petId': PropertySchema(
      id: 15,
      name: r'petId',
      type: IsarType.string,
    ),
    r'stepsToday': PropertySchema(
      id: 16,
      name: r'stepsToday',
      type: IsarType.long,
    ),
    r'stickerGeneratedAt': PropertySchema(
      id: 17,
      name: r'stickerGeneratedAt',
      type: IsarType.dateTime,
    ),
    r'stickerPath': PropertySchema(
      id: 18,
      name: r'stickerPath',
      type: IsarType.string,
    ),
    r'stickerUrl': PropertySchema(
      id: 19,
      name: r'stickerUrl',
      type: IsarType.string,
    ),
    r'totalSteps': PropertySchema(
      id: 20,
      name: r'totalSteps',
      type: IsarType.long,
    ),
    r'treats': PropertySchema(
      id: 21,
      name: r'treats',
      type: IsarType.long,
    )
  },
  estimateSize: _petModelEstimateSize,
  serialize: _petModelSerialize,
  deserialize: _petModelDeserialize,
  deserializeProp: _petModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'petId': IndexSchema(
      id: -7951607706841349632,
      name: r'petId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'petId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _petModelGetId,
  getLinks: _petModelGetLinks,
  attach: _petModelAttach,
  version: '3.1.0+1',
);

int _petModelEstimateSize(
  PetModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accessory.name.length * 3;
  bytesCount += 3 + object.breed.length * 3;
  bytesCount += 3 + object.color.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.personality.name.length * 3;
  bytesCount += 3 + object.petId.length * 3;
  {
    final value = object.stickerPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.stickerUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _petModelSerialize(
  PetModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accessory.name);
  writer.writeDouble(offsets[1], object.avgDailySteps);
  writer.writeLong(offsets[2], object.bestStreak);
  writer.writeString(offsets[3], object.breed);
  writer.writeString(offsets[4], object.color);
  writer.writeLong(offsets[5], object.consecutiveDays);
  writer.writeDateTime(offsets[6], object.createdAt);
  writer.writeLong(offsets[7], object.experience);
  writer.writeLong(offsets[8], object.happiness);
  writer.writeBool(offsets[9], object.isActive);
  writer.writeDateTime(offsets[10], object.lastDecayDate);
  writer.writeDateTime(offsets[11], object.lastUpdate);
  writer.writeLong(offsets[12], object.level);
  writer.writeString(offsets[13], object.name);
  writer.writeString(offsets[14], object.personality.name);
  writer.writeString(offsets[15], object.petId);
  writer.writeLong(offsets[16], object.stepsToday);
  writer.writeDateTime(offsets[17], object.stickerGeneratedAt);
  writer.writeString(offsets[18], object.stickerPath);
  writer.writeString(offsets[19], object.stickerUrl);
  writer.writeLong(offsets[20], object.totalSteps);
  writer.writeLong(offsets[21], object.treats);
}

PetModel _petModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PetModel();
  object.accessory =
      _PetModelaccessoryValueEnumMap[reader.readStringOrNull(offsets[0])] ??
          PetAccessory.none;
  object.avgDailySteps = reader.readDouble(offsets[1]);
  object.bestStreak = reader.readLong(offsets[2]);
  object.breed = reader.readString(offsets[3]);
  object.color = reader.readString(offsets[4]);
  object.consecutiveDays = reader.readLong(offsets[5]);
  object.createdAt = reader.readDateTime(offsets[6]);
  object.experience = reader.readLong(offsets[7]);
  object.happiness = reader.readLong(offsets[8]);
  object.id = id;
  object.isActive = reader.readBool(offsets[9]);
  object.lastDecayDate = reader.readDateTimeOrNull(offsets[10]);
  object.lastUpdate = reader.readDateTime(offsets[11]);
  object.level = reader.readLong(offsets[12]);
  object.name = reader.readString(offsets[13]);
  object.personality =
      _PetModelpersonalityValueEnumMap[reader.readStringOrNull(offsets[14])] ??
          PetPersonality.cheerful;
  object.petId = reader.readString(offsets[15]);
  object.stepsToday = reader.readLong(offsets[16]);
  object.stickerGeneratedAt = reader.readDateTimeOrNull(offsets[17]);
  object.stickerPath = reader.readStringOrNull(offsets[18]);
  object.stickerUrl = reader.readStringOrNull(offsets[19]);
  object.totalSteps = reader.readLong(offsets[20]);
  object.treats = reader.readLong(offsets[21]);
  return object;
}

P _petModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_PetModelaccessoryValueEnumMap[reader.readStringOrNull(offset)] ??
          PetAccessory.none) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (_PetModelpersonalityValueEnumMap[
              reader.readStringOrNull(offset)] ??
          PetPersonality.cheerful) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PetModelaccessoryEnumValueMap = {
  r'none': r'none',
  r'bandana': r'bandana',
  r'glasses': r'glasses',
  r'bowtie': r'bowtie',
  r'hat': r'hat',
  r'collar': r'collar',
  r'scarf': r'scarf',
  r'crown': r'crown',
  r'cap': r'cap',
  r'flowerCrown': r'flowerCrown',
  r'backpack': r'backpack',
  r'headphones': r'headphones',
  r'necktie': r'necktie',
  r'medal': r'medal',
};
const _PetModelaccessoryValueEnumMap = {
  r'none': PetAccessory.none,
  r'bandana': PetAccessory.bandana,
  r'glasses': PetAccessory.glasses,
  r'bowtie': PetAccessory.bowtie,
  r'hat': PetAccessory.hat,
  r'collar': PetAccessory.collar,
  r'scarf': PetAccessory.scarf,
  r'crown': PetAccessory.crown,
  r'cap': PetAccessory.cap,
  r'flowerCrown': PetAccessory.flowerCrown,
  r'backpack': PetAccessory.backpack,
  r'headphones': PetAccessory.headphones,
  r'necktie': PetAccessory.necktie,
  r'medal': PetAccessory.medal,
};
const _PetModelpersonalityEnumValueMap = {
  r'cheerful': r'cheerful',
  r'calm': r'calm',
  r'energetic': r'energetic',
  r'shy': r'shy',
  r'playful': r'playful',
};
const _PetModelpersonalityValueEnumMap = {
  r'cheerful': PetPersonality.cheerful,
  r'calm': PetPersonality.calm,
  r'energetic': PetPersonality.energetic,
  r'shy': PetPersonality.shy,
  r'playful': PetPersonality.playful,
};

Id _petModelGetId(PetModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _petModelGetLinks(PetModel object) {
  return [];
}

void _petModelAttach(IsarCollection<dynamic> col, Id id, PetModel object) {
  object.id = id;
}

extension PetModelByIndex on IsarCollection<PetModel> {
  Future<PetModel?> getByPetId(String petId) {
    return getByIndex(r'petId', [petId]);
  }

  PetModel? getByPetIdSync(String petId) {
    return getByIndexSync(r'petId', [petId]);
  }

  Future<bool> deleteByPetId(String petId) {
    return deleteByIndex(r'petId', [petId]);
  }

  bool deleteByPetIdSync(String petId) {
    return deleteByIndexSync(r'petId', [petId]);
  }

  Future<List<PetModel?>> getAllByPetId(List<String> petIdValues) {
    final values = petIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'petId', values);
  }

  List<PetModel?> getAllByPetIdSync(List<String> petIdValues) {
    final values = petIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'petId', values);
  }

  Future<int> deleteAllByPetId(List<String> petIdValues) {
    final values = petIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'petId', values);
  }

  int deleteAllByPetIdSync(List<String> petIdValues) {
    final values = petIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'petId', values);
  }

  Future<Id> putByPetId(PetModel object) {
    return putByIndex(r'petId', object);
  }

  Id putByPetIdSync(PetModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'petId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPetId(List<PetModel> objects) {
    return putAllByIndex(r'petId', objects);
  }

  List<Id> putAllByPetIdSync(List<PetModel> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'petId', objects, saveLinks: saveLinks);
  }
}

extension PetModelQueryWhereSort on QueryBuilder<PetModel, PetModel, QWhere> {
  QueryBuilder<PetModel, PetModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PetModelQueryWhere on QueryBuilder<PetModel, PetModel, QWhereClause> {
  QueryBuilder<PetModel, PetModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterWhereClause> petIdEqualTo(
      String petId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'petId',
        value: [petId],
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterWhereClause> petIdNotEqualTo(
      String petId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petId',
              lower: [],
              upper: [petId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petId',
              lower: [petId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petId',
              lower: [petId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'petId',
              lower: [],
              upper: [petId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PetModelQueryFilter
    on QueryBuilder<PetModel, PetModel, QFilterCondition> {
  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> accessoryEqualTo(
    PetAccessory value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> accessoryGreaterThan(
    PetAccessory value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accessory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> accessoryLessThan(
    PetAccessory value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accessory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> accessoryBetween(
    PetAccessory lower,
    PetAccessory upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accessory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> accessoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accessory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> accessoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accessory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> accessoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accessory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> accessoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accessory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> accessoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessory',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      accessoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accessory',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> avgDailyStepsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgDailySteps',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      avgDailyStepsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgDailySteps',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> avgDailyStepsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgDailySteps',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> avgDailyStepsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgDailySteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> bestStreakEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> bestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> bestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> bestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'breed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'breed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'breed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'breed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'breed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'breed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'breed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breed',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> breedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'breed',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      consecutiveDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consecutiveDays',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      consecutiveDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consecutiveDays',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      consecutiveDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consecutiveDays',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      consecutiveDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consecutiveDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> experienceEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'experience',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> experienceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'experience',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> experienceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'experience',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> experienceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'experience',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> happinessEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'happiness',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> happinessGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'happiness',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> happinessLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'happiness',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> happinessBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'happiness',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> isActiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      lastDecayDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDecayDate',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      lastDecayDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastDecayDate',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> lastDecayDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDecayDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      lastDecayDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDecayDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> lastDecayDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDecayDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> lastDecayDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDecayDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> lastUpdateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> lastUpdateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> lastUpdateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdate',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> lastUpdateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> levelEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> levelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> personalityEqualTo(
    PetPersonality value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      personalityGreaterThan(
    PetPersonality value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'personality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> personalityLessThan(
    PetPersonality value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'personality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> personalityBetween(
    PetPersonality lower,
    PetPersonality upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'personality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> personalityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'personality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> personalityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'personality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> personalityContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'personality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> personalityMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'personality',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> personalityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personality',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      personalityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'personality',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'petId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'petId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'petId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'petId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> petIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'petId',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stepsTodayEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stepsToday',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stepsTodayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stepsToday',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stepsTodayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stepsToday',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stepsTodayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stepsToday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerGeneratedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stickerGeneratedAt',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerGeneratedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stickerGeneratedAt',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerGeneratedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stickerGeneratedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerGeneratedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stickerGeneratedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerGeneratedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stickerGeneratedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerGeneratedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stickerGeneratedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stickerPath',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stickerPath',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stickerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stickerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stickerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stickerPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stickerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stickerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stickerPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stickerPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stickerPath',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stickerPath',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stickerUrl',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stickerUrl',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stickerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stickerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stickerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stickerUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stickerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stickerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stickerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stickerUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> stickerUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stickerUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition>
      stickerUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stickerUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> totalStepsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> totalStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> totalStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> totalStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> treatsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'treats',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> treatsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'treats',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> treatsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'treats',
        value: value,
      ));
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterFilterCondition> treatsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'treats',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PetModelQueryObject
    on QueryBuilder<PetModel, PetModel, QFilterCondition> {}

extension PetModelQueryLinks
    on QueryBuilder<PetModel, PetModel, QFilterCondition> {}

extension PetModelQuerySortBy on QueryBuilder<PetModel, PetModel, QSortBy> {
  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByAccessory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessory', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByAccessoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessory', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByAvgDailySteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDailySteps', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByAvgDailyStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDailySteps', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByBreed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breed', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByBreedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breed', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByConsecutiveDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveDays', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByConsecutiveDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveDays', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByExperience() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experience', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByExperienceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experience', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByHappiness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happiness', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByHappinessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happiness', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByLastDecayDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDecayDate', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByLastDecayDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDecayDate', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByLastUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdate', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByLastUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdate', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByPersonality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personality', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByPersonalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personality', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByStepsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsToday', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByStepsTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsToday', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByStickerGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerGeneratedAt', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy>
      sortByStickerGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerGeneratedAt', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByStickerPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerPath', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByStickerPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerPath', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByStickerUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerUrl', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByStickerUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerUrl', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByTreats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treats', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> sortByTreatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treats', Sort.desc);
    });
  }
}

extension PetModelQuerySortThenBy
    on QueryBuilder<PetModel, PetModel, QSortThenBy> {
  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByAccessory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessory', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByAccessoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessory', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByAvgDailySteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDailySteps', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByAvgDailyStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDailySteps', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByBreed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breed', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByBreedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breed', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByConsecutiveDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveDays', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByConsecutiveDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveDays', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByExperience() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experience', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByExperienceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'experience', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByHappiness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happiness', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByHappinessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happiness', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByLastDecayDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDecayDate', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByLastDecayDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDecayDate', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByLastUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdate', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByLastUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdate', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByPersonality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personality', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByPersonalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personality', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByPetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByPetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petId', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByStepsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsToday', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByStepsTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsToday', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByStickerGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerGeneratedAt', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy>
      thenByStickerGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerGeneratedAt', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByStickerPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerPath', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByStickerPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerPath', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByStickerUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerUrl', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByStickerUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickerUrl', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByTreats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treats', Sort.asc);
    });
  }

  QueryBuilder<PetModel, PetModel, QAfterSortBy> thenByTreatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treats', Sort.desc);
    });
  }
}

extension PetModelQueryWhereDistinct
    on QueryBuilder<PetModel, PetModel, QDistinct> {
  QueryBuilder<PetModel, PetModel, QDistinct> distinctByAccessory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessory', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByAvgDailySteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgDailySteps');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestStreak');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByBreed(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breed', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByConsecutiveDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consecutiveDays');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByExperience() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'experience');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByHappiness() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'happiness');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByLastDecayDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDecayDate');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByLastUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdate');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByPersonality(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personality', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByPetId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByStepsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stepsToday');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByStickerGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stickerGeneratedAt');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByStickerPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stickerPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByStickerUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stickerUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSteps');
    });
  }

  QueryBuilder<PetModel, PetModel, QDistinct> distinctByTreats() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'treats');
    });
  }
}

extension PetModelQueryProperty
    on QueryBuilder<PetModel, PetModel, QQueryProperty> {
  QueryBuilder<PetModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PetModel, PetAccessory, QQueryOperations> accessoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessory');
    });
  }

  QueryBuilder<PetModel, double, QQueryOperations> avgDailyStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgDailySteps');
    });
  }

  QueryBuilder<PetModel, int, QQueryOperations> bestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestStreak');
    });
  }

  QueryBuilder<PetModel, String, QQueryOperations> breedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breed');
    });
  }

  QueryBuilder<PetModel, String, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<PetModel, int, QQueryOperations> consecutiveDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consecutiveDays');
    });
  }

  QueryBuilder<PetModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PetModel, int, QQueryOperations> experienceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'experience');
    });
  }

  QueryBuilder<PetModel, int, QQueryOperations> happinessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'happiness');
    });
  }

  QueryBuilder<PetModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<PetModel, DateTime?, QQueryOperations> lastDecayDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDecayDate');
    });
  }

  QueryBuilder<PetModel, DateTime, QQueryOperations> lastUpdateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdate');
    });
  }

  QueryBuilder<PetModel, int, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<PetModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PetModel, PetPersonality, QQueryOperations>
      personalityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personality');
    });
  }

  QueryBuilder<PetModel, String, QQueryOperations> petIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petId');
    });
  }

  QueryBuilder<PetModel, int, QQueryOperations> stepsTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stepsToday');
    });
  }

  QueryBuilder<PetModel, DateTime?, QQueryOperations>
      stickerGeneratedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stickerGeneratedAt');
    });
  }

  QueryBuilder<PetModel, String?, QQueryOperations> stickerPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stickerPath');
    });
  }

  QueryBuilder<PetModel, String?, QQueryOperations> stickerUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stickerUrl');
    });
  }

  QueryBuilder<PetModel, int, QQueryOperations> totalStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSteps');
    });
  }

  QueryBuilder<PetModel, int, QQueryOperations> treatsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'treats');
    });
  }
}
