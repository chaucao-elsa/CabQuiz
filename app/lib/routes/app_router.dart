import 'package:auto_route/auto_route.dart';
import 'package:cabquiz/routes/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: QuizRoute.page,
        ),
        AutoRoute(
          page: LeaderBoardRoute.page,
        ),
      ];
}
