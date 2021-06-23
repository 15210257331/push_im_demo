
class ContactData {
  int id;
  int adminId;
  int headmasterId;
  String foreignName;
  String foreignPhone;
  String foreignEmail;
  String createTime;
  String updateTime;
  String adminTalkId;
  String foreignTalkId;
  String adminName;
  String adminEnglishName;
  int unreadCount;

  ContactData(
      {this.id,
        this.adminId,
        this.headmasterId,
        this.foreignName,
        this.foreignPhone,
        this.foreignEmail,
        this.createTime,
        this.updateTime,
        this.adminTalkId,
        this.foreignTalkId,
        this.adminName,
        this.adminEnglishName,
        this.unreadCount
      });

  ContactData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adminId = json['adminId'];
    headmasterId = json['headmasterId'];
    foreignName = json['foreignName'];
    foreignPhone = json['foreignPhone'];
    foreignEmail = json['foreignEmail'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    adminTalkId = json['adminTalkId'];
    foreignTalkId = json['foreignTalkId'];
    adminName = json['adminName'];
    adminEnglishName = json['adminEnglishName'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['adminId'] = this.adminId;
    data['headmasterId'] = this.headmasterId;
    data['foreignName'] = this.foreignName;
    data['foreignPhone'] = this.foreignPhone;
    data['foreignEmail'] = this.foreignEmail;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['adminTalkId'] = this.adminTalkId;
    data['foreignTalkId'] = this.foreignTalkId;
    data['adminName'] = this.adminName;
    data['adminEnglishName'] = this.adminEnglishName;
    data['unreadCount'] = this.unreadCount;
    return data;
  }
}
