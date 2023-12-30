// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadCollection on Isar {
  IsarCollection<Download> get downloads => this.collection();
}

const DownloadSchema = CollectionSchema(
  name: r'Download',
  id: 5905484153212786579,
  properties: {
    r'bookId': PropertySchema(
      id: 0,
      name: r'bookId',
      type: IsarType.long,
    ),
    r'bookImage': PropertySchema(
      id: 1,
      name: r'bookImage',
      type: IsarType.string,
    ),
    r'bookName': PropertySchema(
      id: 2,
      name: r'bookName',
      type: IsarType.string,
    ),
    r'dateTime': PropertySchema(
      id: 3,
      name: r'dateTime',
      type: IsarType.dateTime,
    ),
    r'hashCode': PropertySchema(
      id: 4,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 5,
      name: r'status',
      type: IsarType.byte,
      enumMap: _DownloadstatusEnumValueMap,
    ),
    r'totalChaptersDownloaded': PropertySchema(
      id: 6,
      name: r'totalChaptersDownloaded',
      type: IsarType.long,
    ),
    r'totalChaptersToDownload': PropertySchema(
      id: 7,
      name: r'totalChaptersToDownload',
      type: IsarType.long,
    )
  },
  estimateSize: _downloadEstimateSize,
  serialize: _downloadSerialize,
  deserialize: _downloadDeserialize,
  deserializeProp: _downloadDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _downloadGetId,
  getLinks: _downloadGetLinks,
  attach: _downloadAttach,
  version: '3.1.0+1',
);

int _downloadEstimateSize(
  Download object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookImage.length * 3;
  bytesCount += 3 + object.bookName.length * 3;
  return bytesCount;
}

void _downloadSerialize(
  Download object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bookId);
  writer.writeString(offsets[1], object.bookImage);
  writer.writeString(offsets[2], object.bookName);
  writer.writeDateTime(offsets[3], object.dateTime);
  writer.writeLong(offsets[4], object.hashCode);
  writer.writeByte(offsets[5], object.status.index);
  writer.writeLong(offsets[6], object.totalChaptersDownloaded);
  writer.writeLong(offsets[7], object.totalChaptersToDownload);
}

Download _downloadDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Download(
    bookId: reader.readLong(offsets[0]),
    bookImage: reader.readString(offsets[1]),
    bookName: reader.readString(offsets[2]),
    dateTime: reader.readDateTime(offsets[3]),
    id: id,
    status: _DownloadstatusValueEnumMap[reader.readByteOrNull(offsets[5])] ??
        DownloadStatus.waiting,
    totalChaptersDownloaded: reader.readLong(offsets[6]),
    totalChaptersToDownload: reader.readLong(offsets[7]),
  );
  return object;
}

P _downloadDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (_DownloadstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          DownloadStatus.waiting) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DownloadstatusEnumValueMap = {
  'waiting': 0,
  'downloading': 1,
  'downloaded': 2,
  'downloadedCancel': 3,
  'downloadErr': 4,
};
const _DownloadstatusValueEnumMap = {
  0: DownloadStatus.waiting,
  1: DownloadStatus.downloading,
  2: DownloadStatus.downloaded,
  3: DownloadStatus.downloadedCancel,
  4: DownloadStatus.downloadErr,
};

Id _downloadGetId(Download object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _downloadGetLinks(Download object) {
  return [];
}

void _downloadAttach(IsarCollection<dynamic> col, Id id, Download object) {}

extension DownloadQueryWhereSort on QueryBuilder<Download, Download, QWhere> {
  QueryBuilder<Download, Download, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadQueryWhere on QueryBuilder<Download, Download, QWhereClause> {
  QueryBuilder<Download, Download, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Download, Download, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterWhereClause> idBetween(
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

extension DownloadQueryFilter
    on QueryBuilder<Download, Download, QFilterCondition> {
  QueryBuilder<Download, Download, QAfterFilterCondition> bookIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookId',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookId',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookId',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookImageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookImageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookImageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookImageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookImage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookImageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookImageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookImage',
        value: '',
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
      bookImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookImage',
        value: '',
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookName',
        value: '',
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> bookNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookName',
        value: '',
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> dateTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> dateTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> dateTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> dateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<Download, Download, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<Download, Download, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<Download, Download, QAfterFilterCondition> statusEqualTo(
      DownloadStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> statusGreaterThan(
    DownloadStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> statusLessThan(
    DownloadStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> statusBetween(
    DownloadStatus lower,
    DownloadStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
      totalChaptersDownloadedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalChaptersDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
      totalChaptersDownloadedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalChaptersDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
      totalChaptersDownloadedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalChaptersDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
      totalChaptersDownloadedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalChaptersDownloaded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
      totalChaptersToDownloadEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalChaptersToDownload',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
      totalChaptersToDownloadGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalChaptersToDownload',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
      totalChaptersToDownloadLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalChaptersToDownload',
        value: value,
      ));
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
      totalChaptersToDownloadBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalChaptersToDownload',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DownloadQueryObject
    on QueryBuilder<Download, Download, QFilterCondition> {}

extension DownloadQueryLinks
    on QueryBuilder<Download, Download, QFilterCondition> {}

extension DownloadQuerySortBy on QueryBuilder<Download, Download, QSortBy> {
  QueryBuilder<Download, Download, QAfterSortBy> sortByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByBookImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookImage', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByBookImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookImage', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByBookName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByBookNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy>
      sortByTotalChaptersDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersDownloaded', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy>
      sortByTotalChaptersDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersDownloaded', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy>
      sortByTotalChaptersToDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersToDownload', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy>
      sortByTotalChaptersToDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersToDownload', Sort.desc);
    });
  }
}

extension DownloadQuerySortThenBy
    on QueryBuilder<Download, Download, QSortThenBy> {
  QueryBuilder<Download, Download, QAfterSortBy> thenByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByBookImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookImage', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByBookImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookImage', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByBookName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByBookNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy>
      thenByTotalChaptersDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersDownloaded', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy>
      thenByTotalChaptersDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersDownloaded', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy>
      thenByTotalChaptersToDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersToDownload', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy>
      thenByTotalChaptersToDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersToDownload', Sort.desc);
    });
  }
}

extension DownloadQueryWhereDistinct
    on QueryBuilder<Download, Download, QDistinct> {
  QueryBuilder<Download, Download, QDistinct> distinctByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookId');
    });
  }

  QueryBuilder<Download, Download, QDistinct> distinctByBookImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Download, Download, QDistinct> distinctByBookName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Download, Download, QDistinct> distinctByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateTime');
    });
  }

  QueryBuilder<Download, Download, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<Download, Download, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<Download, Download, QDistinct>
      distinctByTotalChaptersDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalChaptersDownloaded');
    });
  }

  QueryBuilder<Download, Download, QDistinct>
      distinctByTotalChaptersToDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalChaptersToDownload');
    });
  }
}

extension DownloadQueryProperty
    on QueryBuilder<Download, Download, QQueryProperty> {
  QueryBuilder<Download, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Download, int, QQueryOperations> bookIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookId');
    });
  }

  QueryBuilder<Download, String, QQueryOperations> bookImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookImage');
    });
  }

  QueryBuilder<Download, String, QQueryOperations> bookNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookName');
    });
  }

  QueryBuilder<Download, DateTime, QQueryOperations> dateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateTime');
    });
  }

  QueryBuilder<Download, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<Download, DownloadStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Download, int, QQueryOperations>
      totalChaptersDownloadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalChaptersDownloaded');
    });
  }

  QueryBuilder<Download, int, QQueryOperations>
      totalChaptersToDownloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalChaptersToDownload');
    });
  }
}
