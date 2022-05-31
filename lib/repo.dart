import 'package:dio/dio.dart';
import 'model.dart';

class Repo {
  Future getBackground() async {
    var dio = Dio();
    final response = await dio.get(
        'https://api.nasa.gov/planetary/apod?api_key=bndUokxT49HM1JvFu91s3PegBUtXGJ0swmfVXQU4');
    // print(response.data);

    return response;
  }

  Future searchUser(String str) async {
    var dio = Dio();
    try {
      final response = await dio.get('https://api.github.com/users/$str');

      // print(response.data);

      return response;
    } catch (e) {
      return 0;
    }
  }

  Future getFollowers(String str) async {
    var dio = Dio();
    final response = await dio.get(str);
    // for (var usr in response.data) {
    //   print(usr["login"]);
    // }
    return response.data;
  }

  Future getRepos(String str) async {
    var dio = Dio();
    final response = await dio.get(str);
    return response.data;
  }
}
