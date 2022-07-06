import 'package:get/get.dart';
import 'package:medkit_app/screens/massage/chat_room/bindings/chat_room_binding.dart';
import 'package:medkit_app/screens/massage/chat_room/views/chat_room_view.dart';
import 'package:medkit_app/screens/massage/home/bindings/home_binding.dart';
import 'package:medkit_app/screens/massage/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.CHAT_HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: _Paths.INTRODUCTION,
    //   page: () => IntroductionView(),
    //   binding: IntroductionBinding(),
    // ),
    // GetPage(
    //   name: _Paths.LOGIN,
    //   page: () => LoginView(),
    //   binding: LoginBinding(),
    // ),
    // GetPage(
    //   name: _Paths.PROFILE,
    //   page: () => ProfileView(),
    //   binding: ProfileBinding(),
    // ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    // GetPage(
    //   name: _Paths.SEARCH,
    //   page: () => SearchView(),
    //   binding: SearchBinding(),
    // ),
    // GetPage(
    //   name: _Paths.UPDATE_STATUS,
    //   page: () => UpdateStatusView(),
    //   binding: UpdateStatusBinding(),
    // ),
    // GetPage(
    //   name: _Paths.CHANGE_PROFILE,
    //   page: () => ChangeProfileView(),
    //   binding: ChangeProfileBinding(),
    // ),
  ];
}
