import 'repo.dart';
import 'viewModel.dart';

class BackgroundImg {
  String url;
  String explanation;
  String title;

  BackgroundImg(
      {required this.url, required this.explanation, required this.title});
}

class User {
  String login;
  String followersUrl;
  List<User> followers = [];
  String reposUrl;
  List<Repos> repos = [];
  String avatarUrl;

  User(
      {required this.login,
      required this.followersUrl,
      required this.reposUrl,
      required this.avatarUrl});
}

class Repos {
  String name;
  bool private;

  Repos({required this.name, required this.private});
}

abstract class CustomNotifier {}

class LoadingState extends CustomNotifier {}

class HomeNoDataState extends CustomNotifier {}

class HomeWithUser extends CustomNotifier {}

class ErrorState extends CustomNotifier {}
