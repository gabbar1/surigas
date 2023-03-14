class StockModel {
  int? pendingCylinder;
  int? emptyCylinder;
  String? key;

  StockModel({this.pendingCylinder, this.emptyCylinder, this.key});

  StockModel.fromJson(Map<String, dynamic> json) {
    pendingCylinder = json['pending_cylinder'];
    emptyCylinder = json['empty_cylinder'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending_cylinder'] = this.pendingCylinder;
    data['empty_cylinder'] = this.emptyCylinder;
    data['key'] = this.key;
    return data;
  }
}
