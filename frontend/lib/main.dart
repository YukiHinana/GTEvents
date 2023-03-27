import 'package:GTEvents/createdEventsPage.dart';
import 'package:GTEvents/homePage.dart';
import 'package:GTEvents/savedEventsPage.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:GTEvents/allPostPage.dart';
import 'package:GTEvents/signup.dart';
import 'package:GTEvents/singlePostPage.dart';
import './login.dart';
import 'config.dart';
import 'createPostPage.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(appReducer, initialState: const AppState());
  runApp(
      MyApp(
        store: store,
      )
  );
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp.router(
        title: 'hello',
        // home: HomePage(),
        routerConfig: _router,
      ),
    );
  }
}


final GoRouter _router = GoRouter(
  initialLocation: '/events',
  routes: <RouteBase>[
    GoRoute(
      name: "login",
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const MyLoginPage();
      }
    ),
    // GoRoute(
    //   path: '/signup',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const MySignupPage();
    //   }
    // ),
    GoRoute(
        name: "search",
        path: '/search',
        builder: (BuildContext context, GoRouterState state) {
          return const MyLoginPage();
        }
    ),
    GoRoute(
      path: '/events',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
            name: "createdEvents",
            path: 'created',
            builder: (BuildContext context, GoRouterState state) {
              return const CreatedEventsPage();
            }
        ),
        GoRoute(
            name: "savedEvents",
            path: 'saved',
            builder: (BuildContext context, GoRouterState state) {
              return const SavedEventsPage();
            }
        ),
        // GoRoute(
        //     name: "createEvent",
        //     path: '/create',
        //     builder: (BuildContext context, GoRouterState state) {
        //       return const NewPostPage();
        //     }
        // ),
        // GoRoute(
        //   path: 'view/:id',
        //   builder: (context, state) => SinglePostPage(postId: int.parse(state.params['id']!)),
        // ),
      ],
    ),
  ],
);
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       theme: ThemeData(
//         primarySwatch: Colors.yellow,
//         inputDecorationTheme: const InputDecorationTheme(
//             labelStyle: TextStyle(color: Colors.deepPurpleAccent),
//         )
//       ),
//       // home: const MyLoginPage(),
//       routerConfig: _router,
//     );
//   }
// }
//
