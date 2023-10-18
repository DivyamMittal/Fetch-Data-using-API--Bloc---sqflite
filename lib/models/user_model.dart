class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });
  late final int id;
  late final String name;
  late final String username;
  late final String email;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['username'] = username;
    _data['email'] = email;
    return _data;
  }
}
