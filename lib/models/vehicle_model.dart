class VehicleModel {
  String? brandName;
  List<String>? modelList;

  VehicleModel({this.brandName, this.modelList});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    brandName = json['brandName'];
    modelList = json['modelList'].cast<String>();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brandName'] = brandName;
    data['modelList'] = modelList;
    return data;
  }
}
