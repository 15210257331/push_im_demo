class UserInfo {
  int id;
  String name;
  String englishName;
  int sex;
  String email;
  int birthday;
  String phone;
  String avatar;
  // 用户用于声网通讯的ID
  String foreignTalkId;
  String token;
  int jobStatus;
  int teacherStatus;

  UserInfo(
      {this.id,
        this.name,
        this.englishName,
        this.sex,
        this.email,
        this.birthday,
        this.phone,
        this.avatar,
        this.foreignTalkId,
        this.token,
        this.jobStatus,
        this.teacherStatus});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    englishName = json['englishName'];
    sex = json['sex'];
    email = json['email'];
    birthday = json['birthday'];
    phone = json['phone'];
    avatar = json['avatar'];
    foreignTalkId = json['foreignTalkId'];
    token = json['token'];
    jobStatus = json['jobStatus'];
    teacherStatus = json['teacherStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['englishName'] = this.englishName;
    data['sex'] = this.sex;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['foreignTalkId'] = this.foreignTalkId;
    data['token'] = this.token;
    data['jobStatus'] = this.jobStatus;
    data['teacherStatus'] = this.teacherStatus;
    return data;
  }
}