import 'package:json_annotation/json_annotation.dart';

part 'userInfoModel.g.dart';

@JsonSerializable()
class UserInfoModel {
    UserInfoModel();

    num userId;
    String userName;
    String userPassword;
    String phone;
    String email;
    String createTime;
    String updateTime;
    
    factory UserInfoModel.fromJson(Map<String,dynamic> json) => _$UserInfoModelFromJson(json);
    Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}
