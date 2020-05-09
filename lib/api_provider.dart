import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
class ApiProvider{
  ApiProvider();
  String endPoint = 'http://10.10.105.105:3000';

  Future<http.Response> doLogin(String username, String password) async{
    String _url = '$endPoint/login';
    var body = {"username": username, "password":password};
    return http.post(_url, body: body);
  }
  Future<http.Response> saveUser(String username, String password, String fullname, String email, String token) async{
    String _url = '$endPoint/users';
    var body ={
      "username":username,
      "password":password,
      "fullname": fullname,
      "email": email
    };
    return http.post(_url,
        body: body,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
  }
 Future<http.Response> getUsers(String token) async {
    String _url ='$endPoint/users';
    return  http.get(_url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
 }
  Future<http.Response> getInfo(String token, String id) async {
    String _url = '$endPoint/users/$id';

    return http
        .get(_url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
  }

  Future<http.Response> removeUser(String token, String id) async {
    String _url = '$endPoint/users/$id';

    return http.delete(_url, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

  }
  Future<http.Response> updateUser(
      String id, String username, String password, String fullname,String email,String token) async {
    String _url = '$endPoint/users/$id';
    var body = {"username":username,"password":password, "fullname": fullname,"email":email };

    return http.put(_url,
        body: body,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
  }
}