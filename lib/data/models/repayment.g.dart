// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repayment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRepaymentCollection on Isar {
  IsarCollection<Repayment> get repayments => this.collection();
}

const RepaymentSchema = CollectionSchema(
  name: r'Repayment',
  id: -5087213708932537260,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.long),
    r'amountInMainUnit': PropertySchema(
      id: 1,
      name: r'amountInMainUnit',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'transactionId': PropertySchema(
      id: 3,
      name: r'transactionId',
      type: IsarType.long,
    ),
    r'when': PropertySchema(id: 4, name: r'when', type: IsarType.dateTime),
  },

  estimateSize: _repaymentEstimateSize,
  serialize: _repaymentSerialize,
  deserialize: _repaymentDeserialize,
  deserializeProp: _repaymentDeserializeProp,
  idName: r'id',
  indexes: {
    r'transactionId': IndexSchema(
      id: 8561542235958051982,
      name: r'transactionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'transactionId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'when_transactionId': IndexSchema(
      id: 6302117046981007544,
      name: r'when_transactionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'when',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'transactionId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _repaymentGetId,
  getLinks: _repaymentGetLinks,
  attach: _repaymentAttach,
  version: '3.3.0',
);

int _repaymentEstimateSize(
  Repayment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _repaymentSerialize(
  Repayment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeDouble(offsets[1], object.amountInMainUnit);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.transactionId);
  writer.writeDateTime(offsets[4], object.when);
}

Repayment _repaymentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Repayment();
  object.amount = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.transactionId = reader.readLong(offsets[3]);
  object.when = reader.readDateTime(offsets[4]);
  return object;
}

P _repaymentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _repaymentGetId(Repayment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _repaymentGetLinks(Repayment object) {
  return [];
}

void _repaymentAttach(IsarCollection<dynamic> col, Id id, Repayment object) {
  object.id = id;
}

extension RepaymentQueryWhereSort
    on QueryBuilder<Repayment, Repayment, QWhere> {
  QueryBuilder<Repayment, Repayment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhere> anyTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'transactionId'),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhere> anyWhenTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'when_transactionId'),
      );
    });
  }
}

extension RepaymentQueryWhere
    on QueryBuilder<Repayment, Repayment, QWhereClause> {
  QueryBuilder<Repayment, Repayment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Repayment, Repayment, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause> transactionIdEqualTo(
    int transactionId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'transactionId',
          value: [transactionId],
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause> transactionIdNotEqualTo(
    int transactionId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'transactionId',
                lower: [],
                upper: [transactionId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'transactionId',
                lower: [transactionId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'transactionId',
                lower: [transactionId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'transactionId',
                lower: [],
                upper: [transactionId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  transactionIdGreaterThan(int transactionId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'transactionId',
          lower: [transactionId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause> transactionIdLessThan(
    int transactionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'transactionId',
          lower: [],
          upper: [transactionId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause> transactionIdBetween(
    int lowerTransactionId,
    int upperTransactionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'transactionId',
          lower: [lowerTransactionId],
          includeLower: includeLower,
          upper: [upperTransactionId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenEqualToAnyTransactionId(DateTime when) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'when_transactionId',
          value: [when],
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenNotEqualToAnyTransactionId(DateTime when) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'when_transactionId',
                lower: [],
                upper: [when],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'when_transactionId',
                lower: [when],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'when_transactionId',
                lower: [when],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'when_transactionId',
                lower: [],
                upper: [when],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenGreaterThanAnyTransactionId(DateTime when, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'when_transactionId',
          lower: [when],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenLessThanAnyTransactionId(DateTime when, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'when_transactionId',
          lower: [],
          upper: [when],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenBetweenAnyTransactionId(
    DateTime lowerWhen,
    DateTime upperWhen, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'when_transactionId',
          lower: [lowerWhen],
          includeLower: includeLower,
          upper: [upperWhen],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenTransactionIdEqualTo(DateTime when, int transactionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'when_transactionId',
          value: [when, transactionId],
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenEqualToTransactionIdNotEqualTo(DateTime when, int transactionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'when_transactionId',
                lower: [when],
                upper: [when, transactionId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'when_transactionId',
                lower: [when, transactionId],
                includeLower: false,
                upper: [when],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'when_transactionId',
                lower: [when, transactionId],
                includeLower: false,
                upper: [when],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'when_transactionId',
                lower: [when],
                upper: [when, transactionId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenEqualToTransactionIdGreaterThan(
    DateTime when,
    int transactionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'when_transactionId',
          lower: [when, transactionId],
          includeLower: include,
          upper: [when],
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenEqualToTransactionIdLessThan(
    DateTime when,
    int transactionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'when_transactionId',
          lower: [when],
          upper: [when, transactionId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterWhereClause>
  whenEqualToTransactionIdBetween(
    DateTime when,
    int lowerTransactionId,
    int upperTransactionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'when_transactionId',
          lower: [when, lowerTransactionId],
          includeLower: includeLower,
          upper: [when, upperTransactionId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension RepaymentQueryFilter
    on QueryBuilder<Repayment, Repayment, QFilterCondition> {
  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> amountEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'amount', value: value),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> amountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> amountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> amountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition>
  amountInMainUnitEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amountInMainUnit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition>
  amountInMainUnitGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amountInMainUnit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition>
  amountInMainUnitLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amountInMainUnit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition>
  amountInMainUnitBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amountInMainUnit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition>
  transactionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'transactionId', value: value),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition>
  transactionIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'transactionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition>
  transactionIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'transactionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition>
  transactionIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'transactionId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> whenEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'when', value: value),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> whenGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'when',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> whenLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'when',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterFilterCondition> whenBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'when',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension RepaymentQueryObject
    on QueryBuilder<Repayment, Repayment, QFilterCondition> {}

extension RepaymentQueryLinks
    on QueryBuilder<Repayment, Repayment, QFilterCondition> {}

extension RepaymentQuerySortBy on QueryBuilder<Repayment, Repayment, QSortBy> {
  QueryBuilder<Repayment, Repayment, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> sortByAmountInMainUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountInMainUnit', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy>
  sortByAmountInMainUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountInMainUnit', Sort.desc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> sortByTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> sortByTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.desc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> sortByWhen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'when', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> sortByWhenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'when', Sort.desc);
    });
  }
}

extension RepaymentQuerySortThenBy
    on QueryBuilder<Repayment, Repayment, QSortThenBy> {
  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByAmountInMainUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountInMainUnit', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy>
  thenByAmountInMainUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountInMainUnit', Sort.desc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.desc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByWhen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'when', Sort.asc);
    });
  }

  QueryBuilder<Repayment, Repayment, QAfterSortBy> thenByWhenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'when', Sort.desc);
    });
  }
}

extension RepaymentQueryWhereDistinct
    on QueryBuilder<Repayment, Repayment, QDistinct> {
  QueryBuilder<Repayment, Repayment, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<Repayment, Repayment, QDistinct> distinctByAmountInMainUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountInMainUnit');
    });
  }

  QueryBuilder<Repayment, Repayment, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Repayment, Repayment, QDistinct> distinctByTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transactionId');
    });
  }

  QueryBuilder<Repayment, Repayment, QDistinct> distinctByWhen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'when');
    });
  }
}

extension RepaymentQueryProperty
    on QueryBuilder<Repayment, Repayment, QQueryProperty> {
  QueryBuilder<Repayment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Repayment, int, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<Repayment, double, QQueryOperations> amountInMainUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountInMainUnit');
    });
  }

  QueryBuilder<Repayment, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Repayment, int, QQueryOperations> transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transactionId');
    });
  }

  QueryBuilder<Repayment, DateTime, QQueryOperations> whenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'when');
    });
  }
}
