// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responseModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) {
  return ResponseModel()
    ..code = json['code'] as String
    ..msg = json['msg'] as String
    ..data = json['data'] as String;
}

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
