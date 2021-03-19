class AppUser {
  String uid;
  String email;
  String username;

  AppUser({
    this.uid,
    this.email,
    this.username,

  });

  Map toMap(AppUser user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['username'] = user.username;

    return data;
  }

  // Named constructor
  AppUser.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.username = mapData['username'];
  }
}
