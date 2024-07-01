
class User {
  int? id;
  String? name;
  String? image;
  String? imagepath;
  String? username;
  String? email;
  String? token;
  int? role;

  User({
    this.id,
    this.name,
    this.image,
    this.imagepath,
    this.username,
    this.email,
    this.token,
    this.role,
  });

// function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      image: json['user']['image'],
      imagepath: json['user']['imagepath'],
      username: json['user']['username'],
      email: json['user']['email'],
      token: json['token'],
      role: json['user']['role']
    );
  }

}

class AllUser{
  int? totalItems;
  dynamic currentPage;
  String? pageSize;
  int? totalPages;
  int? startPage;
  dynamic endPage;
  int? startIndex;
  int? endIndex;
  List? query;

  AllUser({
    this.totalItems,
    this.currentPage,
    this.pageSize,
    this.totalPages,
    this.startPage,
    this.endPage,
    this.startIndex,
    this.endIndex,
    this.query,
  });

  factory AllUser.fromJson(Map<String,dynamic> json){
    List<dynamic> arr = [];
    for(var item in json['query']){
      arr.add(
        User(
          id: item['id'],
          name: item['name'],
          image: item['image'],
          imagepath: item['imagepath'],
          username: item['username'],
          email: item['email'],
          role: item['role']
        )
      );
    }
    return AllUser(
      totalItems: json['totalItems'],
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
      startPage: json['startPage'],
      endPage: json['endPage'],
      startIndex: json['startIndex'],
      endIndex: json['endIndex'],
      query: arr
    );
  }
}