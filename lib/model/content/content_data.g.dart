// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentData _$ContentDataFromJson(Map<String, dynamic> json) {
  return ContentData(
    limit: json['limit'] as int?,
    page: json['page'] as int?,
    sort: json['sort'] as String?,
    totalRows: json['total_rows'] as int?,
    totalPages: json['total_pages'] as int?,
    size: json['size'] as int?,
    rows: (json['rows'] as List<dynamic>?)
        ?.map((e) => ContentRows.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ContentDataToJson(ContentData instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'page': instance.page,
      'sort': instance.sort,
      'total_rows': instance.totalRows,
      'total_pages': instance.totalPages,
      'size': instance.size,
      'rows': instance.rows,
    };
