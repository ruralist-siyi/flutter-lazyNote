// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo()
    ..userId = json['userId'] as num
    ..userName = json['userName'] as String
    ..userPassword = json['userPassword'] as String
    ..phone = json['phone'] as String
    ..email = json['email'] as String
    ..createTime = json['createTime'] as String
    ..updateTime = json['updateTime'] as String;
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userPassword': instance.userPassword,
      'phone': instance.phone,
      'email': instance.email,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime
    };
