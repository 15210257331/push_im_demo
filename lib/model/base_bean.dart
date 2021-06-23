class BaseBean {
  int code;
  String msg;
  dynamic data;

  BaseBean({this.code, this.msg, this.data});

  BaseBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? json['data'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}
