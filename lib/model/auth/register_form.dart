
class RegisterFormModel {
  String? name;
  int? mobileNumber;
  String? email;
  String? address;
  int? pincode;
  int? orgId;
  int? refId;
  bool? isDealder;

  RegisterFormModel(
      {this.name,
        this.mobileNumber,
        this.email,
        this.address,
        this.pincode,
        this.orgId,
        this.refId,
        this.isDealder
      });

  RegisterFormModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    address = json['address'];
    pincode = json['pincode'];
    orgId = json['org_id'];
    refId = json['ref_id'];
    isDealder = json['isDealder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['org_id'] = this.orgId;
    data['ref_id'] = this.refId;
    data['isDealder'] = this.isDealder;
    return data;
  }
}
