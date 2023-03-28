import 'package:GTEvents/EventDetailPage.dart';
import 'package:GTEvents/createdEventsPage.dart';
import 'package:GTEvents/homeScreen.dart';
import 'package:GTEvents/savedEventsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:GTEvents/signup.dart';
import './login.dart';
import 'config.dart';
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
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const MySignupPage();
      }
    ),
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
        return const HomeScreen();
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
        GoRoute(
          path: ':id',
          builder: (context, state) => EventDetailPage(eventId: int.parse(state.params['id']!)),
        ),
        // GoRoute(
        //     name: "createEvent",
        //     path: '/create',
        //     builder: (BuildContext context, GoRouterState state) {
        //       return const NewPostPage();
        //     }
        // ),
      ],
    ),
  ],
);