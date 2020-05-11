class UserModel {
  String id;
  String hn;
  String username;
  String password;
  String status;
  String prename;
  String name;
  String lastname;
  String sex;
  String dob;
  String tel;
  String email;
  String img;
  String flag;
  String lat;
  String lng;

  UserModel(
      {this.id,
      this.hn,
      this.username,
      this.password,
      this.status,
      this.prename,
      this.name,
      this.lastname,
      this.sex,
      this.dob,
      this.tel,
      this.email,
      this.img,
      this.flag,
      this.lat,
      this.lng});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hn = json['hn'];
    username = json['username'];
    password = json['password'];
    status = json['status'];
    prename = json['prename'];
    name = json['name'];
    lastname = json['lastname'];
    sex = json['sex'];
    dob = json['dob'];
    tel = json['tel'];
    email = json['email'];
    img = json['img'];
    flag = json['flag'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hn'] = this.hn;
    data['username'] = this.username;
    data['password'] = this.password;
    data['status'] = this.status;
    data['prename'] = this.prename;
    data['name'] = this.name;
    data['lastname'] = this.lastname;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['tel'] = this.tel;
    data['email'] = this.email;
    data['img'] = this.img;
    data['flag'] = this.flag;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}

