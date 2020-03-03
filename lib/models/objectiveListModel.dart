import 'package:json_annotation/json_annotation.dart';

part 'objectiveListModel.g.dart';

@JsonSerializable()
class ObjectiveListModel {
    ObjectiveListModel();

    num count;
    List rows;
    
    factory ObjectiveListModel.fromJson(Map<String,dynamic> json) => _$ObjectiveListModelFromJson(json);
    Map<String, dynamic> toJson() => _$ObjectiveListModelToJson(this);
}
