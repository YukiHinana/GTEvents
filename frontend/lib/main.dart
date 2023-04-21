
import 'package:GTEvents/eventDetailPage.dart';
import 'package:GTEvents/createEvent.dart';
import 'package:GTEvents/createdEventsPage.dart';
import 'package:GTEvents/eventPreview.dart';
import 'package:GTEvents/component/filter.dart';
import 'package:GTEvents/homeScreen.dart';
import 'package:GTEvents/profilePage.dart';
import 'package:GTEvents/savedEventsPage.dart';
import 'package:GTEvents/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:GTEvents/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login.dart';
import 'config.dart';
import 'package:redux/redux.dart';

import 'event.dart';

// run main.dart to start the program
void main() {
  DateTime curTime = DateTime.now();
  final store = Store<AppState>(appReducer,
      initialState: AppState(filterData: FilterData([], [],
          null, null
          // DateTime(curTime.year, curTime.month, curTime.day),
          // DateTime(curTime.year, curTime.month, curTime.day + 1),
      )));
  runApp(
      MyApp(
        store: store,
      )
  );
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  Future<void> appInit(Store<AppState> store) async {
    SharedPreferences.getInstance().then((value) {
      var result = value.getString('token');
      var tokenVal = result == "" || result == null ? null : result;
      store.dispatch(SetTokenAction(tokenVal));
      if (tokenVal != null) {
        handleFindUsernameByTokenRequest(tokenVal).then((usernameVal) {
          if (usernameVal == null) {
            store.dispatch(SetTokenAction(null));
            store.dispatch(SetUsernameAction(null));
            value.setString("token", "");
          } else {
            store.dispatch(SetUsernameAction(usernameVal));
          }
        });
      }
    });
  }

  //Main interface
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: FutureBuilder(
          future: appInit(store),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return MaterialApp.router(
                title: 'hello',
                routerConfig: _router,
                theme: ThemeData(
                    colorScheme: ColorScheme.fromSwatch().copyWith(
                      primary: const Color(0xffADC178),
                      // secondary: Color(0xff606c38),
                      secondary: const Color(0xff432818),
                    ),
                  scaffoldBackgroundColor: const Color(0xfffffbf3),
                  fontFamily: 'San Francisco',
                  textTheme: const TextTheme(
                    displayLarge: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
                    titleLarge: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic, fontFamily: 'Georgia'),
                    bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'San Francisco'),
                  ),
                )
            );
          }
      ),
    );
  }
}

//Route to different pages
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
        name: "userProfile",
        path: '/user/profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfilePage();
        }
    ),
    GoRoute(
        name: "search",
        path: '/search',
        builder: (BuildContext context, GoRouterState state) {
          return const SearchPage();
        }
    ),
    GoRoute(
      path: '/events',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
            name: "createEvent",
            path: 'create',
            builder: (BuildContext context, GoRouterState state) {
              return const CreateEvent();
            }
        ),
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
          name: "eventDetails",
          path: 'view',
          builder: (context, state) {
            Map<String, dynamic> map = state.extra as Map<String, dynamic>;
            return EventDetailPage(event: map["event"], tagList: map["tagList"]);
          },
        ),
        GoRoute(
          name: "filter",
          path: 'filter',
          builder: (context, state) {
            return const Filter();
          },
        ),
        // TODO: add event preview
        // GoRoute(
        //   name: "eventPreview",
        //   path: 'preview',
        //   builder: (context, state) {
        //     return EventPreview(
        //       eventTitle: state.queryParams["eventTitle"]??"",
        //       eventLocation: state.queryParams["eventLocation"]??"",
        //       eventDescription: state.queryParams["eventDescription"]??"",
        //       eventDate: state.queryParams["eventDate"]??"0",
        //       eventCreationDate: state.queryParams["eventCreationDate"]??"0",
        //       tagName: state.queryParams["tagName"]??"",
        //     );
        //   } ,
        // ),
      ],
    ),
  ],
);