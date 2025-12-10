// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransactionCollection on Isar {
  IsarCollection<Transaction> get transactions => this.collection();
}

const TransactionSchema = CollectionSchema(
  name: r'Transaction',
  id: 5320225499417954855,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.long),
    r'amountInMainUnit': PropertySchema(id: 1, name: r'amountInMainUnit', type: IsarType.double),
    r'createdAt': PropertySchema(id: 2, name: r'createdAt', type: IsarType.dateTime),
    r'currency': PropertySchema(id: 3, name: r'currency', type: IsarType.string, enumMap: _TransactioncurrencyEnumValueMap),
    r'description': PropertySchema(id: 4, name: r'description', type: IsarType.string),
    r'dueDate': PropertySchema(id: 5, name: r'dueDate', type: IsarType.dateTime),
    r'isActive': PropertySchema(id: 6, name: r'isActive', type: IsarType.bool),
    r'isCompleted': PropertySchema(id: 7, name: r'isCompleted', type: IsarType.bool),
    r'isOverdue': PropertySchema(id: 8, name: r'isOverdue', type: IsarType.bool),
    r'name': PropertySchema(id: 9, name: r'name', type: IsarType.string),
    r'status': PropertySchema(id: 10, name: r'status', type: IsarType.string, enumMap: _TransactionstatusEnumValueMap),
    r'transactionDate': PropertySchema(id: 11, name: r'transactionDate', type: IsarType.dateTime),
    r'type': PropertySchema(id: 12, name: r'type', type: IsarType.string, enumMap: _TransactiontypeEnumValueMap),
    r'updatedAt': PropertySchema(id: 13, name: r'updatedAt', type: IsarType.dateTime),
  },

  estimateSize: _transactionEstimateSize,
  serialize: _transactionSerialize,
  deserialize: _transactionDeserialize,
  deserializeProp: _transactionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _transactionGetId,
  getLinks: _transactionGetLinks,
  attach: _transactionAttach,
  version: '3.3.0',
);

int _transactionEstimateSize(Transaction object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currency.name.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.status.name.length * 3;
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _transactionSerialize(Transaction object, IsarWriter writer, List<int> offsets, Map<Type, List<int>> allOffsets) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeDouble(offsets[1], object.amountInMainUnit);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.currency.name);
  writer.writeString(offsets[4], object.description);
  writer.writeDateTime(offsets[5], object.dueDate);
  writer.writeBool(offsets[6], object.isActive);
  writer.writeBool(offsets[7], object.isCompleted);
  writer.writeBool(offsets[8], object.isOverdue);
  writer.writeString(offsets[9], object.name);
  writer.writeString(offsets[10], object.status.name);
  writer.writeDateTime(offsets[11], object.transactionDate);
  writer.writeString(offsets[12], object.type.name);
  writer.writeDateTime(offsets[13], object.updatedAt);
}

Transaction _transactionDeserialize(Id id, IsarReader reader, List<int> offsets, Map<Type, List<int>> allOffsets) {
  final object = Transaction();
  object.amount = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.currency = _TransactioncurrencyValueEnumMap[reader.readStringOrNull(offsets[3])] ?? Currency.pln;
  object.description = reader.readStringOrNull(offsets[4]);
  object.dueDate = reader.readDateTimeOrNull(offsets[5]);
  object.id = id;
  object.name = reader.readString(offsets[9]);
  object.status = _TransactionstatusValueEnumMap[reader.readStringOrNull(offsets[10])] ?? TransactionStatus.active;
  object.transactionDate = reader.readDateTime(offsets[11]);
  object.type = _TransactiontypeValueEnumMap[reader.readStringOrNull(offsets[12])] ?? TransactionType.debt;
  object.updatedAt = reader.readDateTime(offsets[13]);
  return object;
}

P _transactionDeserializeProp<P>(IsarReader reader, int propertyId, int offset, Map<Type, List<int>> allOffsets) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (_TransactioncurrencyValueEnumMap[reader.readStringOrNull(offset)] ?? Currency.pln) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (_TransactionstatusValueEnumMap[reader.readStringOrNull(offset)] ?? TransactionStatus.active) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (_TransactiontypeValueEnumMap[reader.readStringOrNull(offset)] ?? TransactionType.debt) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TransactioncurrencyEnumValueMap = {r'pln': r'pln', r'eur': r'eur', r'usd': r'usd', r'gbp': r'gbp'};
const _TransactioncurrencyValueEnumMap = {r'pln': Currency.pln, r'eur': Currency.eur, r'usd': Currency.usd, r'gbp': Currency.gbp};
const _TransactionstatusEnumValueMap = {r'active': r'active', r'completed': r'completed'};
const _TransactionstatusValueEnumMap = {r'active': TransactionStatus.active, r'completed': TransactionStatus.completed};
const _TransactiontypeEnumValueMap = {r'debt': r'debt', r'loan': r'loan'};
const _TransactiontypeValueEnumMap = {r'debt': TransactionType.debt, r'loan': TransactionType.loan};

Id _transactionGetId(Transaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transactionGetLinks(Transaction object) {
  return [];
}

void _transactionAttach(IsarCollection<dynamic> col, Id id, Transaction object) {
  object.id = id;
}

extension TransactionQueryWhereSort on QueryBuilder<Transaction, Transaction, QWhere> {
  QueryBuilder<Transaction, Transaction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TransactionQueryWhere on QueryBuilder<Transaction, Transaction, QWhereClause> {
  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: false)).addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: false));
      } else {
        return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: false)).addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: false));
      }
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idBetween(Id lowerId, Id upperId, {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: lowerId, includeLower: includeLower, upper: upperId, includeUpper: includeUpper));
    });
  }
}

extension TransactionQueryFilter on QueryBuilder<Transaction, Transaction, QFilterCondition> {
  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'amount', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'amount', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'amount', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountBetween(int lower, int upper, {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(property: r'amount', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountInMainUnitEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'amountInMainUnit', value: value, epsilon: epsilon));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountInMainUnitGreaterThan(double value, {bool include = false, double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'amountInMainUnit', value: value, epsilon: epsilon));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountInMainUnitLessThan(double value, {bool include = false, double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'amountInMainUnit', value: value, epsilon: epsilon));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountInMainUnitBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(property: r'amountInMainUnit', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'createdAt', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'createdAt', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'createdAt', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> createdAtBetween(DateTime lower, DateTime upper, {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(property: r'createdAt', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyEqualTo(Currency value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'currency', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyGreaterThan(Currency value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'currency', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyLessThan(Currency value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'currency', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyBetween(
    Currency lower,
    Currency upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(property: r'currency', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(property: r'currency', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(property: r'currency', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(property: r'currency', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(property: r'currency', wildcard: pattern, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'currency', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'currency', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'description'));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'description'));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'description', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionGreaterThan(String? value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'description', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionLessThan(String? value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'description', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(property: r'description', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(property: r'description', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(property: r'description', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(property: r'description', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(property: r'description', wildcard: pattern, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'description', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'description', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dueDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(property: r'dueDate'));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dueDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(property: r'dueDate'));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dueDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'dueDate', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dueDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'dueDate', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dueDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'dueDate', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dueDateBetween(DateTime? lower, DateTime? upper, {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(property: r'dueDate', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'id', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idBetween(Id lower, Id upper, {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(property: r'id', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'isActive', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'isCompleted', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> isOverdueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'isOverdue', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'name', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameGreaterThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'name', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'name', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(property: r'name', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(property: r'name', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(property: r'name', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(property: r'name', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(property: r'name', wildcard: pattern, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'name', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'name', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusEqualTo(TransactionStatus value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'status', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusGreaterThan(TransactionStatus value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'status', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusLessThan(TransactionStatus value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'status', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusBetween(
    TransactionStatus lower,
    TransactionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(property: r'status', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(property: r'status', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(property: r'status', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(property: r'status', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(property: r'status', wildcard: pattern, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'status', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'status', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> transactionDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'transactionDate', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> transactionDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'transactionDate', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> transactionDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'transactionDate', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> transactionDateBetween(DateTime lower, DateTime upper, {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(property: r'transactionDate', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeEqualTo(TransactionType value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'type', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeGreaterThan(TransactionType value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'type', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeLessThan(TransactionType value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'type', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeBetween(
    TransactionType lower,
    TransactionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(property: r'type', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(property: r'type', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(property: r'type', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(property: r'type', value: value, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(property: r'type', wildcard: pattern, caseSensitive: caseSensitive));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'type', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'type', value: ''));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'updatedAt', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(include: include, property: r'updatedAt', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(include: include, property: r'updatedAt', value: value));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> updatedAtBetween(DateTime lower, DateTime upper, {bool includeLower = true, bool includeUpper = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(property: r'updatedAt', lower: lower, includeLower: includeLower, upper: upper, includeUpper: includeUpper));
    });
  }
}

extension TransactionQueryObject on QueryBuilder<Transaction, Transaction, QFilterCondition> {}

extension TransactionQueryLinks on QueryBuilder<Transaction, Transaction, QFilterCondition> {}

extension TransactionQuerySortBy on QueryBuilder<Transaction, Transaction, QSortBy> {
  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByAmountInMainUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountInMainUnit', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByAmountInMainUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountInMainUnit', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTransactionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionDate', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTransactionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionDate', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TransactionQuerySortThenBy on QueryBuilder<Transaction, Transaction, QSortThenBy> {
  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByAmountInMainUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountInMainUnit', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByAmountInMainUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountInMainUnit', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTransactionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionDate', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTransactionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionDate', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TransactionQueryWhereDistinct on QueryBuilder<Transaction, Transaction, QDistinct> {
  QueryBuilder<Transaction, Transaction, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByAmountInMainUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountInMainUnit');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByCurrency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dueDate');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOverdue');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByTransactionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transactionDate');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TransactionQueryProperty on QueryBuilder<Transaction, Transaction, QQueryProperty> {
  QueryBuilder<Transaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Transaction, int, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<Transaction, double, QQueryOperations> amountInMainUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountInMainUnit');
    });
  }

  QueryBuilder<Transaction, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Transaction, Currency, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Transaction, DateTime?, QQueryOperations> dueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dueDate');
    });
  }

  QueryBuilder<Transaction, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<Transaction, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<Transaction, bool, QQueryOperations> isOverdueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOverdue');
    });
  }

  QueryBuilder<Transaction, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Transaction, TransactionStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Transaction, DateTime, QQueryOperations> transactionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transactionDate');
    });
  }

  QueryBuilder<Transaction, TransactionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Transaction, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
