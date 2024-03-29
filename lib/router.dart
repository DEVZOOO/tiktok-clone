import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

/// router + redirect
final routerProvider = Provider((ref) {
  // ref.watch(authState); // stream 변화되면 dependency에 의해 리빌드되서 redirect됨
  return GoRouter(
    initialLocation: "/home", // TEST
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        // subloc : sub location
        if (state.subloc != SignUpScreen.routeUrl &&
            state.subloc != LoginScreen.routeUrl) {
          return SignUpScreen.routeUrl;
        }
      }
      return null;
    },
    routes: [
      // signup
      GoRoute(
        path: SignUpScreen.routeUrl,
        name: SignUpScreen.routeName,
        builder: (context, state) => const SignUpScreen(),
      ),
      // login
      GoRoute(
        path: LoginScreen.routeUrl,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      // interests
      GoRoute(
        path: InterestsScreen.routeUrl,
        name: InterestsScreen.routeName,
        builder: (context, state) => const InterestsScreen(),
      ),

      // path variable
      GoRoute(
        path: "/:tab(home|discover|inbox|profile)",
        name: MainNavigationScreen.routeName,
        builder: (context, state) {
          final tab = state.params['tab']!;
          return MainNavigationScreen(
            tab: tab,
          );
        },
      ),

      // Video
      GoRoute(
        path: VideoRecordingScreen.routeUrl,
        name: VideoRecordingScreen.routeName,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const VideoRecordingScreen(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final position = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation);

            return SlideTransition(
              position: position,
              child: child,
            );
          },
        ),
      ),

      // Inbox
      GoRoute(
        path: ActivityScreen.routeUrl,
        name: ActivityScreen.routeName,
        builder: (context, state) => const ActivityScreen(),
      ),
      // chats
      GoRoute(
        path: ChatsScreen.routeUrl,
        name: ChatsScreen.routeName,
        builder: (context, state) => const ChatsScreen(),
        routes: [
          GoRoute(
            path: ChatDetailScreen.routeUrl,
            name: ChatDetailScreen.routeName,
            builder: (context, state) {
              final chatId = state.params['chatId']!;
              return ChatDetailScreen(
                chatId: chatId,
              );
            },
          ),
        ],
      ),

      /*
    GoRoute(
      path: SignUpScreen.routeUrl,
      name: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
      routes: [
        GoRoute(
          path: UsernameScreen.routeUrl,
          name: UsernameScreen.routeName,
          builder: (context, state) => const UsernameScreen(),
          routes: [
            GoRoute(
              path: EmailScreen.routeUrl,
              name: EmailScreen.routeName,
              builder: (context, state) {
                final args = state.extra as EmailScreenArgs;
                return EmailScreen(username: args.username);
              },
            ),
          ],
        ),
      ],
    ),
    /*
    GoRoute(
      path: UsernameScreen.routeUrl,
      name: "username_screen",
      // builder: (context, state) => const UsernameScreen(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const UsernameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
        );
      },
    ),
    GoRoute(
      path: EmailScreen.routeName,
      builder: (context, state) {
        final args = state.extra as EmailScreenArgs;
        return EmailScreen(username: args.username);
      },
    ),
    */
    GoRoute(
      // path variable
      path: "/users/:username",
      builder: (context, state) {
        final username = state.params['username'];
        final tab = state.queryParams['show'];
        return UserProfileScreen(
          username: username!,
          tab: tab!,
        );
      },
    )
    */
    ],
  );
});


/*
final router = GoRouter(
  initialLocation: "/home", // TEST
  routes: [
    // signup
    GoRoute(
      path: SignUpScreen.routeUrl,
      name: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    // login
    GoRoute(
      path: LoginScreen.routeUrl,
      name: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    // interests
    GoRoute(
      path: InterestsScreen.routeUrl,
      name: InterestsScreen.routeName,
      builder: (context, state) => const InterestsScreen(),
    ),

    // path variable
    GoRoute(
      path: "/:tab(home|discover|inbox|profile)",
      name: MainNavigationScreen.routeName,
      builder: (context, state) {
        final tab = state.params['tab']!;
        return MainNavigationScreen(
          tab: tab,
        );
      },
    ),

    // Video
    GoRoute(
      path: VideoRecordingScreen.routeUrl,
      name: VideoRecordingScreen.routeName,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const VideoRecordingScreen(),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final position = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(
            position: position,
            child: child,
          );
        },
      ),
    ),

    // Inbox
    GoRoute(
      path: ActivityScreen.routeUrl,
      name: ActivityScreen.routeName,
      builder: (context, state) => const ActivityScreen(),
    ),
    // chats
    GoRoute(
      path: ChatsScreen.routeUrl,
      name: ChatsScreen.routeName,
      builder: (context, state) => const ChatsScreen(),
      routes: [
        GoRoute(
          path: ChatDetailScreen.routeUrl,
          name: ChatDetailScreen.routeName,
          builder: (context, state) {
            final chatId = state.params['chatId']!;
            return ChatDetailScreen(
              chatId: chatId,
            );
          },
        ),
      ],
    ),

    /*
    GoRoute(
      path: SignUpScreen.routeUrl,
      name: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
      routes: [
        GoRoute(
          path: UsernameScreen.routeUrl,
          name: UsernameScreen.routeName,
          builder: (context, state) => const UsernameScreen(),
          routes: [
            GoRoute(
              path: EmailScreen.routeUrl,
              name: EmailScreen.routeName,
              builder: (context, state) {
                final args = state.extra as EmailScreenArgs;
                return EmailScreen(username: args.username);
              },
            ),
          ],
        ),
      ],
    ),
    /*
    GoRoute(
      path: UsernameScreen.routeUrl,
      name: "username_screen",
      // builder: (context, state) => const UsernameScreen(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const UsernameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
        );
      },
    ),
    GoRoute(
      path: EmailScreen.routeName,
      builder: (context, state) {
        final args = state.extra as EmailScreenArgs;
        return EmailScreen(username: args.username);
      },
    ),
    */
    GoRoute(
      // path variable
      path: "/users/:username",
      builder: (context, state) {
        final username = state.params['username'];
        final tab = state.queryParams['show'];
        return UserProfileScreen(
          username: username!,
          tab: tab!,
        );
      },
    )
    */
  ],
);
*/