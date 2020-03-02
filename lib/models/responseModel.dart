import 'package:json_annotation/json_annotation.dart';

part 'responseModel.g.dart';

@JsonSerializable()
class ResponseModel {
    ResponseModel();

    String code;
    String msg;
    String data;
    
    factory ResponseModel.fromJson(Map<String,dynamic> json) => _$ResponseModelFromJson(json);
    Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
