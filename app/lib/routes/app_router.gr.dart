// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:cabquiz/features/home/views/pages/home_page.dart' as _i1;
import 'package:cabquiz/features/leaderboard/views/pages/leader_board_page.dart'
    as _i2;
import 'package:cabquiz/features/quiz/views/pages/quiz_name_prompt_page.dart'
    as _i3;
import 'package:cabquiz/features/quiz/views/pages/quiz_page.dart' as _i4;
import 'package:flutter/material.dart' as _i6;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return _i5.WrappedRoute(child: const _i1.HomePage());
    },
  );
}

/// generated route for
/// [_i2.LeaderBoardPage]
class LeaderBoardRoute extends _i5.PageRouteInfo<LeaderBoardRouteArgs> {
  LeaderBoardRoute({
    _i6.Key? key,
    required String roomId,
    required String username,
    List<_i5.PageRouteInfo>? children,
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

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LeaderBoardRouteArgs>();
      return _i5.WrappedRoute(
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

  final _i6.Key? key;

  final String roomId;

  final String username;

  @override
  String toString() {
    return 'LeaderBoardRouteArgs{key: $key, roomId: $roomId, username: $username}';
  }
}

/// generated route for
/// [_i3.QuizNamePromptPage]
class QuizNamePromptRoute extends _i5.PageRouteInfo<QuizNamePromptRouteArgs> {
  QuizNamePromptRoute({
    _i6.Key? key,
    required String roomId,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          QuizNamePromptRoute.name,
          args: QuizNamePromptRouteArgs(
            key: key,
            roomId: roomId,
          ),
          rawPathParams: {'roomId': roomId},
          initialChildren: children,
        );

  static const String name = 'QuizNamePromptRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<QuizNamePromptRouteArgs>(
          orElse: () =>
              QuizNamePromptRouteArgs(roomId: pathParams.getString('roomId')));
      return _i3.QuizNamePromptPage(
        key: args.key,
        roomId: args.roomId,
      );
    },
  );
}

class QuizNamePromptRouteArgs {
  const QuizNamePromptRouteArgs({
    this.key,
    required this.roomId,
  });

  final _i6.Key? key;

  final String roomId;

  @override
  String toString() {
    return 'QuizNamePromptRouteArgs{key: $key, roomId: $roomId}';
  }
}

/// generated route for
/// [_i4.QuizPage]
class QuizRoute extends _i5.PageRouteInfo<QuizRouteArgs> {
  QuizRoute({
    _i6.Key? key,
    required String roomId,
    required String username,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          QuizRoute.name,
          args: QuizRouteArgs(
            key: key,
            roomId: roomId,
            username: username,
          ),
          rawPathParams: {
            'roomId': roomId,
            'username': username,
          },
          initialChildren: children,
        );

  static const String name = 'QuizRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<QuizRouteArgs>(
          orElse: () => QuizRouteArgs(
                roomId: pathParams.getString('roomId'),
                username: pathParams.getString('username'),
              ));
      return _i5.WrappedRoute(
          child: _i4.QuizPage(
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

  final _i6.Key? key;

  final String roomId;

  final String username;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, roomId: $roomId, username: $username}';
  }
}
