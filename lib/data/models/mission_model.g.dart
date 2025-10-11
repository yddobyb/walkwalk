// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMissionModelCollection on Isar {
  IsarCollection<MissionModel> get missionModels => this.collection();
}

const MissionModelSchema = CollectionSchema(
  name: r'MissionModel',
  id: 3976238352109843434,
  properties: {
    r'badgeCode': PropertySchema(
      id: 0,
      name: r'badgeCode',
      type: IsarType.string,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'currentProgress': PropertySchema(
      id: 2,
      name: r'currentProgress',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'expiresAt': PropertySchema(
      id: 4,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'happinessReward': PropertySchema(
      id: 5,
      name: r'happinessReward',
      type: IsarType.long,
    ),
    r'isActive': PropertySchema(
      id: 6,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isCompleted': PropertySchema(
      id: 7,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'missionId': PropertySchema(
      id: 8,
      name: r'missionId',
      type: IsarType.string,
    ),
    r'targetDistance': PropertySchema(
      id: 9,
      name: r'targetDistance',
      type: IsarType.double,
    ),
    r'targetDuration': PropertySchema(
      id: 10,
      name: r'targetDuration',
      type: IsarType.long,
    ),
    r'targetProgress': PropertySchema(
      id: 11,
      name: r'targetProgress',
      type: IsarType.long,
    ),
    r'targetSteps': PropertySchema(
      id: 12,
      name: r'targetSteps',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 13,
      name: r'title',
      type: IsarType.string,
    ),
    r'treatReward': PropertySchema(
      id: 14,
      name: r'treatReward',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 15,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _missionModelEstimateSize,
  serialize: _missionModelSerialize,
  deserialize: _missionModelDeserialize,
  deserializeProp: _missionModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _missionModelGetId,
  getLinks: _missionModelGetLinks,
  attach: _missionModelAttach,
  version: '3.1.0+1',
);

int _missionModelEstimateSize(
  MissionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.badgeCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.missionId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _missionModelSerialize(
  MissionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.badgeCode);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeLong(offsets[2], object.currentProgress);
  writer.writeString(offsets[3], object.description);
  writer.writeDateTime(offsets[4], object.expiresAt);
  writer.writeLong(offsets[5], object.happinessReward);
  writer.writeBool(offsets[6], object.isActive);
  writer.writeBool(offsets[7], object.isCompleted);
  writer.writeString(offsets[8], object.missionId);
  writer.writeDouble(offsets[9], object.targetDistance);
  writer.writeLong(offsets[10], object.targetDuration);
  writer.writeLong(offsets[11], object.targetProgress);
  writer.writeLong(offsets[12], object.targetSteps);
  writer.writeString(offsets[13], object.title);
  writer.writeLong(offsets[14], object.treatReward);
  writer.writeString(offsets[15], object.type);
}

MissionModel _missionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MissionModel();
  object.badgeCode = reader.readStringOrNull(offsets[0]);
  object.completedAt = reader.readDateTimeOrNull(offsets[1]);
  object.currentProgress = reader.readLong(offsets[2]);
  object.description = reader.readString(offsets[3]);
  object.expiresAt = reader.readDateTime(offsets[4]);
  object.happinessReward = reader.readLong(offsets[5]);
  object.id = id;
  object.isActive = reader.readBool(offsets[6]);
  object.isCompleted = reader.readBool(offsets[7]);
  object.missionId = reader.readString(offsets[8]);
  object.targetDistance = reader.readDouble(offsets[9]);
  object.targetDuration = reader.readLong(offsets[10]);
  object.targetSteps = reader.readLong(offsets[12]);
  object.title = reader.readString(offsets[13]);
  object.treatReward = reader.readLong(offsets[14]);
  object.type = reader.readString(offsets[15]);
  return object;
}

P _missionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _missionModelGetId(MissionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _missionModelGetLinks(MissionModel object) {
  return [];
}

void _missionModelAttach(
    IsarCollection<dynamic> col, Id id, MissionModel object) {
  object.id = id;
}

extension MissionModelQueryWhereSort
    on QueryBuilder<MissionModel, MissionModel, QWhere> {
  QueryBuilder<MissionModel, MissionModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MissionModelQueryWhere
    on QueryBuilder<MissionModel, MissionModel, QWhereClause> {
  QueryBuilder<MissionModel, MissionModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<MissionModel, MissionModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterWhereClause> idBetween(
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
}

extension MissionModelQueryFilter
    on QueryBuilder<MissionModel, MissionModel, QFilterCondition> {
  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'badgeCode',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'badgeCode',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badgeCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'badgeCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'badgeCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'badgeCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'badgeCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'badgeCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'badgeCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'badgeCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badgeCode',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      badgeCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'badgeCode',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      currentProgressEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentProgress',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      currentProgressGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentProgress',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      currentProgressLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentProgress',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      currentProgressBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentProgress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      expiresAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      expiresAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      expiresAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      expiresAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      happinessRewardEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'happinessReward',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      happinessRewardGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'happinessReward',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      happinessRewardLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'happinessReward',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      happinessRewardBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'happinessReward',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'missionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'missionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'missionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'missionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionId',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      missionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'missionId',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetDistanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetDistance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetDistanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetDistance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetDistanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetDistance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetDistanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetDistance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetProgressEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetProgress',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetProgressGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetProgress',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetProgressLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetProgress',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetProgressBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetProgress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetStepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      targetStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetSteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      treatRewardEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'treatReward',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      treatRewardGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'treatReward',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      treatRewardLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'treatReward',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      treatRewardBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'treatReward',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension MissionModelQueryObject
    on QueryBuilder<MissionModel, MissionModel, QFilterCondition> {}

extension MissionModelQueryLinks
    on QueryBuilder<MissionModel, MissionModel, QFilterCondition> {}

extension MissionModelQuerySortBy
    on QueryBuilder<MissionModel, MissionModel, QSortBy> {
  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByBadgeCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeCode', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByBadgeCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeCode', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByCurrentProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentProgress', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByCurrentProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentProgress', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByHappinessReward() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happinessReward', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByHappinessRewardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happinessReward', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByMissionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionId', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByMissionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionId', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByTargetDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDistance', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByTargetDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDistance', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByTargetDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDuration', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByTargetDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDuration', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByTargetProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetProgress', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByTargetProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetProgress', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByTargetSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSteps', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByTargetStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSteps', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByTreatReward() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treatReward', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      sortByTreatRewardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treatReward', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MissionModelQuerySortThenBy
    on QueryBuilder<MissionModel, MissionModel, QSortThenBy> {
  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByBadgeCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeCode', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByBadgeCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeCode', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByCurrentProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentProgress', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByCurrentProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentProgress', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByHappinessReward() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happinessReward', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByHappinessRewardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happinessReward', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByMissionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionId', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByMissionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionId', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByTargetDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDistance', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByTargetDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDistance', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByTargetDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDuration', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByTargetDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDuration', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByTargetProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetProgress', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByTargetProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetProgress', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByTargetSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSteps', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByTargetStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSteps', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByTreatReward() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treatReward', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy>
      thenByTreatRewardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treatReward', Sort.desc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MissionModelQueryWhereDistinct
    on QueryBuilder<MissionModel, MissionModel, QDistinct> {
  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByBadgeCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'badgeCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct>
      distinctByCurrentProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentProgress');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct>
      distinctByHappinessReward() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'happinessReward');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByMissionId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct>
      distinctByTargetDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDistance');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct>
      distinctByTargetDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDuration');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct>
      distinctByTargetProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetProgress');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByTargetSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetSteps');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByTreatReward() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'treatReward');
    });
  }

  QueryBuilder<MissionModel, MissionModel, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension MissionModelQueryProperty
    on QueryBuilder<MissionModel, MissionModel, QQueryProperty> {
  QueryBuilder<MissionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MissionModel, String?, QQueryOperations> badgeCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'badgeCode');
    });
  }

  QueryBuilder<MissionModel, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<MissionModel, int, QQueryOperations> currentProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentProgress');
    });
  }

  QueryBuilder<MissionModel, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<MissionModel, DateTime, QQueryOperations> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<MissionModel, int, QQueryOperations> happinessRewardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'happinessReward');
    });
  }

  QueryBuilder<MissionModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<MissionModel, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<MissionModel, String, QQueryOperations> missionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missionId');
    });
  }

  QueryBuilder<MissionModel, double, QQueryOperations>
      targetDistanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDistance');
    });
  }

  QueryBuilder<MissionModel, int, QQueryOperations> targetDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDuration');
    });
  }

  QueryBuilder<MissionModel, int, QQueryOperations> targetProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetProgress');
    });
  }

  QueryBuilder<MissionModel, int, QQueryOperations> targetStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetSteps');
    });
  }

  QueryBuilder<MissionModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<MissionModel, int, QQueryOperations> treatRewardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'treatReward');
    });
  }

  QueryBuilder<MissionModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
