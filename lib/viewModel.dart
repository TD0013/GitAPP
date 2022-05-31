import 'main.dart';
import 'model.dart';
import 'repo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Repo repoObj = Repo();
BackgroundImg? bgImg;
User? currUser;

final notProvider = StateNotifierProvider<Count, CustomNotifier>(
  (ref) => Count(ref),
);

class Count extends StateNotifier<CustomNotifier> {
  Count(Ref ref) : super(LoadingState()) {}

  getBgData() async {
    state = LoadingState();

    var bgImgResp = await repoObj.getBackground();

    bgImg = BackgroundImg(
        url: bgImgResp.data["url"],
        explanation: bgImgResp.data["explanation"],
        title: bgImgResp.data["title"]);

    state = HomeNoDataState();
  }

  searchUser(String str) async {
    state = LoadingState();

    var srcResp = await repoObj.searchUser(str);

    if (srcResp != 0) {
      currUser = User(
          login: srcResp.data["login"],
          followersUrl: srcResp.data["followers_url"],
          reposUrl: srcResp.data["repos_url"],
          avatarUrl: srcResp.data["avatar_url"]);

      var follResp = await repoObj.getFollowers(currUser!.followersUrl);

      if (follResp != 0) {}

      for (var usr in follResp) {
        currUser?.followers.add(User(
            login: usr["login"],
            followersUrl: usr["followers_url"],
            reposUrl: usr["repos_url"],
            avatarUrl: usr["avatar_url"]));
      }

      // for (var usr in currUser!.followers) {
      //   print(usr.login);
      // }

      var repoResp = await repoObj.getRepos(currUser!.reposUrl);

      for (var rep in repoResp) {
        currUser?.repos.add(Repos(name: rep["name"], private: (rep["fork"])));
      }

      // for (var rep in currUser!.repos) {
      //   print(rep.name + "    " + rep.private.toString());
      // }

      state = HomeWithUser();
    } else {
      print("error");
      state = ErrorState();
    }
  }
}
