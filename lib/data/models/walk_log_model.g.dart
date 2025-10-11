// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_log_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWalkLogModelCollection on Isar {
  IsarCollection<WalkLogModel> get walkLogModels => this.collection();
}

const WalkLogModelSchema = CollectionSchema(
  name: r'WalkLogModel',
  id: 1692015118699303525,
  properties: {
    r'airQuality': PropertySchema(
      id: 0,
      name: r'airQuality',
      type: IsarType.double,
    ),
    r'avgSpeed': PropertySchema(
      id: 1,
      name: r'avgSpeed',
      type: IsarType.double,
    ),
    r'distance': PropertySchema(
      id: 2,
      name: r'distance',
      type: IsarType.double,
    ),
    r'duration': PropertySchema(
      id: 3,
      name: r'duration',
      type: IsarType.long,
    ),
    r'endTime': PropertySchema(
      id: 4,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'happinessGained': PropertySchema(
      id: 5,
      name: r'happinessGained',
      type: IsarType.long,
    ),
    r'isOutdoor': PropertySchema(
      id: 6,
      name: r'isOutdoor',
      type: IsarType.bool,
    ),
    r'locationSamples': PropertySchema(
      id: 7,
      name: r'locationSamples',
      type: IsarType.objectList,
      target: r'LocationSampleModel',
    ),
    r'missionsCompleted': PropertySchema(
      id: 8,
      name: r'missionsCompleted',
      type: IsarType.objectList,
      target: r'MissionCompletedModel',
    ),
    r'sessionId': PropertySchema(
      id: 9,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 10,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'totalSteps': PropertySchema(
      id: 11,
      name: r'totalSteps',
      type: IsarType.long,
    ),
    r'treatsEarned': PropertySchema(
      id: 12,
      name: r'treatsEarned',
      type: IsarType.long,
    ),
    r'validOutdoorSamples': PropertySchema(
      id: 13,
      name: r'validOutdoorSamples',
      type: IsarType.long,
    ),
    r'weatherCondition': PropertySchema(
      id: 14,
      name: r'weatherCondition',
      type: IsarType.string,
    )
  },
  estimateSize: _walkLogModelEstimateSize,
  serialize: _walkLogModelSerialize,
  deserialize: _walkLogModelDeserialize,
  deserializeProp: _walkLogModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'LocationSampleModel': LocationSampleModelSchema,
    r'MissionCompletedModel': MissionCompletedModelSchema
  },
  getId: _walkLogModelGetId,
  getLinks: _walkLogModelGetLinks,
  attach: _walkLogModelAttach,
  version: '3.1.0+1',
);

int _walkLogModelEstimateSize(
  WalkLogModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.locationSamples.length * 3;
  {
    final offsets = allOffsets[LocationSampleModel]!;
    for (var i = 0; i < object.locationSamples.length; i++) {
      final value = object.locationSamples[i];
      bytesCount +=
          LocationSampleModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.missionsCompleted.length * 3;
  {
    final offsets = allOffsets[MissionCompletedModel]!;
    for (var i = 0; i < object.missionsCompleted.length; i++) {
      final value = object.missionsCompleted[i];
      bytesCount +=
          MissionCompletedModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.sessionId.length * 3;
  {
    final value = object.weatherCondition;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _walkLogModelSerialize(
  WalkLogModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.airQuality);
  writer.writeDouble(offsets[1], object.avgSpeed);
  writer.writeDouble(offsets[2], object.distance);
  writer.writeLong(offsets[3], object.duration);
  writer.writeDateTime(offsets[4], object.endTime);
  writer.writeLong(offsets[5], object.happinessGained);
  writer.writeBool(offsets[6], object.isOutdoor);
  writer.writeObjectList<LocationSampleModel>(
    offsets[7],
    allOffsets,
    LocationSampleModelSchema.serialize,
    object.locationSamples,
  );
  writer.writeObjectList<MissionCompletedModel>(
    offsets[8],
    allOffsets,
    MissionCompletedModelSchema.serialize,
    object.missionsCompleted,
  );
  writer.writeString(offsets[9], object.sessionId);
  writer.writeDateTime(offsets[10], object.startTime);
  writer.writeLong(offsets[11], object.totalSteps);
  writer.writeLong(offsets[12], object.treatsEarned);
  writer.writeLong(offsets[13], object.validOutdoorSamples);
  writer.writeString(offsets[14], object.weatherCondition);
}

WalkLogModel _walkLogModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WalkLogModel();
  object.airQuality = reader.readDoubleOrNull(offsets[0]);
  object.avgSpeed = reader.readDouble(offsets[1]);
  object.distance = reader.readDouble(offsets[2]);
  object.duration = reader.readLong(offsets[3]);
  object.endTime = reader.readDateTime(offsets[4]);
  object.happinessGained = reader.readLong(offsets[5]);
  object.id = id;
  object.isOutdoor = reader.readBool(offsets[6]);
  object.locationSamples = reader.readObjectList<LocationSampleModel>(
        offsets[7],
        LocationSampleModelSchema.deserialize,
        allOffsets,
        LocationSampleModel(),
      ) ??
      [];
  object.missionsCompleted = reader.readObjectList<MissionCompletedModel>(
        offsets[8],
        MissionCompletedModelSchema.deserialize,
        allOffsets,
        MissionCompletedModel(),
      ) ??
      [];
  object.sessionId = reader.readString(offsets[9]);
  object.startTime = reader.readDateTime(offsets[10]);
  object.totalSteps = reader.readLong(offsets[11]);
  object.treatsEarned = reader.readLong(offsets[12]);
  object.validOutdoorSamples = reader.readLong(offsets[13]);
  object.weatherCondition = reader.readStringOrNull(offsets[14]);
  return object;
}

P _walkLogModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readObjectList<LocationSampleModel>(
            offset,
            LocationSampleModelSchema.deserialize,
            allOffsets,
            LocationSampleModel(),
          ) ??
          []) as P;
    case 8:
      return (reader.readObjectList<MissionCompletedModel>(
            offset,
            MissionCompletedModelSchema.deserialize,
            allOffsets,
            MissionCompletedModel(),
          ) ??
          []) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _walkLogModelGetId(WalkLogModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _walkLogModelGetLinks(WalkLogModel object) {
  return [];
}

void _walkLogModelAttach(
    IsarCollection<dynamic> col, Id id, WalkLogModel object) {
  object.id = id;
}

extension WalkLogModelQueryWhereSort
    on QueryBuilder<WalkLogModel, WalkLogModel, QWhere> {
  QueryBuilder<WalkLogModel, WalkLogModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WalkLogModelQueryWhere
    on QueryBuilder<WalkLogModel, WalkLogModel, QWhereClause> {
  QueryBuilder<WalkLogModel, WalkLogModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterWhereClause> idBetween(
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

extension WalkLogModelQueryFilter
    on QueryBuilder<WalkLogModel, WalkLogModel, QFilterCondition> {
  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      airQualityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'airQuality',
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      airQualityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'airQuality',
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      airQualityEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'airQuality',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      airQualityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'airQuality',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      airQualityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'airQuality',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      airQualityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'airQuality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      avgSpeedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      avgSpeedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      avgSpeedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      avgSpeedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgSpeed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      distanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      distanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      distanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      distanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      durationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      durationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      durationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      durationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      endTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      endTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      endTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      happinessGainedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'happinessGained',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      happinessGainedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'happinessGained',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      happinessGainedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'happinessGained',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      happinessGainedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'happinessGained',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      isOutdoorEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOutdoor',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      locationSamplesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'locationSamples',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      locationSamplesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'locationSamples',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      locationSamplesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'locationSamples',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      locationSamplesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'locationSamples',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      locationSamplesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'locationSamples',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      locationSamplesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'locationSamples',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      missionsCompletedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missionsCompleted',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      missionsCompletedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missionsCompleted',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      missionsCompletedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missionsCompleted',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      missionsCompletedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missionsCompleted',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      missionsCompletedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missionsCompleted',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      missionsCompletedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'missionsCompleted',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      totalStepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      totalStepsGreaterThan(
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

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      totalStepsLessThan(
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

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      totalStepsBetween(
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

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      treatsEarnedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'treatsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      treatsEarnedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'treatsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      treatsEarnedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'treatsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      treatsEarnedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'treatsEarned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      validOutdoorSamplesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'validOutdoorSamples',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      validOutdoorSamplesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'validOutdoorSamples',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      validOutdoorSamplesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'validOutdoorSamples',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      validOutdoorSamplesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'validOutdoorSamples',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weatherCondition',
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weatherCondition',
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weatherCondition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weatherCondition',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weatherCondition',
        value: '',
      ));
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      weatherConditionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weatherCondition',
        value: '',
      ));
    });
  }
}

extension WalkLogModelQueryObject
    on QueryBuilder<WalkLogModel, WalkLogModel, QFilterCondition> {
  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      locationSamplesElement(FilterQuery<LocationSampleModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'locationSamples');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterFilterCondition>
      missionsCompletedElement(FilterQuery<MissionCompletedModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'missionsCompleted');
    });
  }
}

extension WalkLogModelQueryLinks
    on QueryBuilder<WalkLogModel, WalkLogModel, QFilterCondition> {}

extension WalkLogModelQuerySortBy
    on QueryBuilder<WalkLogModel, WalkLogModel, QSortBy> {
  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByAirQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airQuality', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      sortByAirQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airQuality', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByAvgSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeed', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByAvgSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeed', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      sortByHappinessGained() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happinessGained', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      sortByHappinessGainedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happinessGained', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByIsOutdoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutdoor', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByIsOutdoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutdoor', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      sortByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> sortByTreatsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treatsEarned', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      sortByTreatsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treatsEarned', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      sortByValidOutdoorSamples() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validOutdoorSamples', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      sortByValidOutdoorSamplesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validOutdoorSamples', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      sortByWeatherCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherCondition', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      sortByWeatherConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherCondition', Sort.desc);
    });
  }
}

extension WalkLogModelQuerySortThenBy
    on QueryBuilder<WalkLogModel, WalkLogModel, QSortThenBy> {
  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByAirQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airQuality', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      thenByAirQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airQuality', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByAvgSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeed', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByAvgSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeed', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      thenByHappinessGained() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happinessGained', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      thenByHappinessGainedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'happinessGained', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByIsOutdoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutdoor', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByIsOutdoorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutdoor', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      thenByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy> thenByTreatsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treatsEarned', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      thenByTreatsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'treatsEarned', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      thenByValidOutdoorSamples() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validOutdoorSamples', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      thenByValidOutdoorSamplesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validOutdoorSamples', Sort.desc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      thenByWeatherCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherCondition', Sort.asc);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QAfterSortBy>
      thenByWeatherConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherCondition', Sort.desc);
    });
  }
}

extension WalkLogModelQueryWhereDistinct
    on QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> {
  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctByAirQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'airQuality');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctByAvgSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgSpeed');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distance');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct>
      distinctByHappinessGained() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'happinessGained');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctByIsOutdoor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOutdoor');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctBySessionId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSteps');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct> distinctByTreatsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'treatsEarned');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct>
      distinctByValidOutdoorSamples() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'validOutdoorSamples');
    });
  }

  QueryBuilder<WalkLogModel, WalkLogModel, QDistinct>
      distinctByWeatherCondition({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weatherCondition',
          caseSensitive: caseSensitive);
    });
  }
}

extension WalkLogModelQueryProperty
    on QueryBuilder<WalkLogModel, WalkLogModel, QQueryProperty> {
  QueryBuilder<WalkLogModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WalkLogModel, double?, QQueryOperations> airQualityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'airQuality');
    });
  }

  QueryBuilder<WalkLogModel, double, QQueryOperations> avgSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgSpeed');
    });
  }

  QueryBuilder<WalkLogModel, double, QQueryOperations> distanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distance');
    });
  }

  QueryBuilder<WalkLogModel, int, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<WalkLogModel, DateTime, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<WalkLogModel, int, QQueryOperations> happinessGainedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'happinessGained');
    });
  }

  QueryBuilder<WalkLogModel, bool, QQueryOperations> isOutdoorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOutdoor');
    });
  }

  QueryBuilder<WalkLogModel, List<LocationSampleModel>, QQueryOperations>
      locationSamplesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationSamples');
    });
  }

  QueryBuilder<WalkLogModel, List<MissionCompletedModel>, QQueryOperations>
      missionsCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missionsCompleted');
    });
  }

  QueryBuilder<WalkLogModel, String, QQueryOperations> sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<WalkLogModel, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<WalkLogModel, int, QQueryOperations> totalStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSteps');
    });
  }

  QueryBuilder<WalkLogModel, int, QQueryOperations> treatsEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'treatsEarned');
    });
  }

  QueryBuilder<WalkLogModel, int, QQueryOperations>
      validOutdoorSamplesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'validOutdoorSamples');
    });
  }

  QueryBuilder<WalkLogModel, String?, QQueryOperations>
      weatherConditionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weatherCondition');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LocationSampleModelSchema = Schema(
  name: r'LocationSampleModel',
  id: 6357711736851669122,
  properties: {
    r'accuracy': PropertySchema(
      id: 0,
      name: r'accuracy',
      type: IsarType.double,
    ),
    r'latitude': PropertySchema(
      id: 1,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 2,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'speed': PropertySchema(
      id: 3,
      name: r'speed',
      type: IsarType.double,
    ),
    r'timestamp': PropertySchema(
      id: 4,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _locationSampleModelEstimateSize,
  serialize: _locationSampleModelSerialize,
  deserialize: _locationSampleModelDeserialize,
  deserializeProp: _locationSampleModelDeserializeProp,
);

int _locationSampleModelEstimateSize(
  LocationSampleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _locationSampleModelSerialize(
  LocationSampleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.accuracy);
  writer.writeDouble(offsets[1], object.latitude);
  writer.writeDouble(offsets[2], object.longitude);
  writer.writeDouble(offsets[3], object.speed);
  writer.writeDateTime(offsets[4], object.timestamp);
}

LocationSampleModel _locationSampleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocationSampleModel();
  object.accuracy = reader.readDouble(offsets[0]);
  object.latitude = reader.readDouble(offsets[1]);
  object.longitude = reader.readDouble(offsets[2]);
  object.speed = reader.readDouble(offsets[3]);
  object.timestamp = reader.readDateTime(offsets[4]);
  return object;
}

P _locationSampleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LocationSampleModelQueryFilter on QueryBuilder<LocationSampleModel,
    LocationSampleModel, QFilterCondition> {
  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      accuracyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      accuracyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      accuracyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      accuracyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      speedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      speedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      speedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      speedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<LocationSampleModel, LocationSampleModel, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocationSampleModelQueryObject on QueryBuilder<LocationSampleModel,
    LocationSampleModel, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MissionCompletedModelSchema = Schema(
  name: r'MissionCompletedModel',
  id: 6941721601953745677,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'missionId': PropertySchema(
      id: 1,
      name: r'missionId',
      type: IsarType.string,
    ),
    r'missionType': PropertySchema(
      id: 2,
      name: r'missionType',
      type: IsarType.string,
    ),
    r'rewardAmount': PropertySchema(
      id: 3,
      name: r'rewardAmount',
      type: IsarType.long,
    )
  },
  estimateSize: _missionCompletedModelEstimateSize,
  serialize: _missionCompletedModelSerialize,
  deserialize: _missionCompletedModelDeserialize,
  deserializeProp: _missionCompletedModelDeserializeProp,
);

int _missionCompletedModelEstimateSize(
  MissionCompletedModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.missionId.length * 3;
  bytesCount += 3 + object.missionType.length * 3;
  return bytesCount;
}

void _missionCompletedModelSerialize(
  MissionCompletedModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeString(offsets[1], object.missionId);
  writer.writeString(offsets[2], object.missionType);
  writer.writeLong(offsets[3], object.rewardAmount);
}

MissionCompletedModel _missionCompletedModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MissionCompletedModel();
  object.completedAt = reader.readDateTime(offsets[0]);
  object.missionId = reader.readString(offsets[1]);
  object.missionType = reader.readString(offsets[2]);
  object.rewardAmount = reader.readLong(offsets[3]);
  return object;
}

P _missionCompletedModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MissionCompletedModelQueryFilter on QueryBuilder<
    MissionCompletedModel, MissionCompletedModel, QFilterCondition> {
  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> completedAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> completedAtLessThan(
    DateTime value, {
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

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> completedAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionIdEqualTo(
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

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionIdGreaterThan(
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

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionIdLessThan(
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

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionIdBetween(
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

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionIdStartsWith(
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

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionIdEndsWith(
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

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
          QAfterFilterCondition>
      missionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'missionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
          QAfterFilterCondition>
      missionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'missionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionId',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'missionId',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
          QAfterFilterCondition>
      missionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
          QAfterFilterCondition>
      missionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'missionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionType',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> missionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'missionType',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> rewardAmountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> rewardAmountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rewardAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> rewardAmountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rewardAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletedModel, MissionCompletedModel,
      QAfterFilterCondition> rewardAmountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rewardAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MissionCompletedModelQueryObject on QueryBuilder<
    MissionCompletedModel, MissionCompletedModel, QFilterCondition> {}
