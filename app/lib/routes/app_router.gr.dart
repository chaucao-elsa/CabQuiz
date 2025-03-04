// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:cabquiz/features/home/views/pages/home_page.dart' as _i1;
import 'package:cabquiz/features/leaderboard/views/pages/leader_board_page.dart'
    as _i2;
import 'package:cabquiz/features/quiz/views/pages/quiz_page.dart' as _i3;
import 'package:flutter/material.dart' as _i5;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return _i4.WrappedRoute(child: const _i1.HomePage());
    },
  );
}

/// generated route for
/// [_i2.LeaderBoardPage]
class LeaderBoardRoute extends _i4.PageRouteInfo<LeaderBoardRouteArgs> {
  LeaderBoardRoute({
    _i5.Key? key,
    required int roomId,
    required String username,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          LeaderBoardRoute.name,
          args: LeaderBoardRouteArgs(
            key: key,
            roomId: roomId,
            username: username,
          ),
          initialChildren: children,
        );

  static const String name = 'LeaderBoardRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LeaderBoardRouteArgs>();
      return _i4.WrappedRoute(
          child: _i2.LeaderBoardPage(
        key: args.key,
        roomId: args.roomId,
        username: args.username,
      ));
    },
  );
}

class LeaderBoardRouteArgs {
  const LeaderBoardRouteArgs({
    this.key,
    required this.roomId,
    required this.username,
  });

  final _i5.Key? key;

  final int roomId;

  final String username;

  @override
  String toString() {
    return 'LeaderBoardRouteArgs{key: $key, roomId: $roomId, username: $username}';
  }
}

/// generated route for
/// [_i3.QuizPage]
class QuizRoute extends _i4.PageRouteInfo<QuizRouteArgs> {
  QuizRoute({
    _i5.Key? key,
    required int roomId,
    required String username,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          QuizRoute.name,
          args: QuizRouteArgs(
            key: key,
            roomId: roomId,
            username: username,
          ),
          initialChildren: children,
        );

  static const String name = 'QuizRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizRouteArgs>();
      return _i4.WrappedRoute(
          child: _i3.QuizPage(
        key: args.key,
        roomId: args.roomId,
        username: args.username,
      ));
    },
  );
}

class QuizRouteArgs {
  const QuizRouteArgs({
    this.key,
    required this.roomId,
    required this.username,
  });

  final _i5.Key? key;

  final int roomId;

  final String username;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, roomId: $roomId, username: $username}';
  }
}
