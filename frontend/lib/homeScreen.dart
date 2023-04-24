
import 'dart:convert';

import 'package:GTEvents/config.dart';
import 'package:GTEvents/component/sidebar.dart';
import 'package:GTEvents/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;


import 'event.dart';
import 'eventsPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  // Future<ads.InitializationStatus> _initGoogleMobileAds() {
  //   return
  //     ads.MobileAds.instance.initialize();
  // }

}

class _HomeScreenState extends State<HomeScreen> {

  //banner ads
  late ads.BannerAd _bannerAd;
  bool isBannerAdReady = false;

  int filterLen = 0;

  int calculateSelectedFilterNum(List<int> eventTypeTagSelectState,
      List<int> degreeTagSelectState) {
    return eventTypeTagSelectState.length + degreeTagSelectState.length;
  }

  @override
  void initState() {
    super.initState();
    _bannerAd = ads.BannerAd(size: ads.AdSize.banner , adUnitId:'ca-app-pub-3257656342161902/320266917',
        listener: ads.BannerAdListener(onAdLoaded: (_){setState(() { isBannerAdReady = true;

    });}, onAdFailedToLoad: (ad,error){print("Fail to load a banner ad${error.message}"); isBannerAdReady = false; ad.dispose();} ),
        request:  ads.AdRequest())..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GTEvents'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: calculateSelectedFilterNum(
            StoreProvider.of<AppState>(context).state.filterData.eventTypeTagSelectState,
            StoreProvider.of<AppState>(context).state.filterData.degreeTagSelectState)
            == 0 ? Colors.brown : const Color(0xff432818),
        onPressed: () {
          context.push("/events/filter");
        },
        label: calculateSelectedFilterNum(
            StoreProvider.of<AppState>(context).state.filterData.eventTypeTagSelectState,
            StoreProvider.of<AppState>(context).state.filterData.degreeTagSelectState) == 0
            ? const Text("filter", style: TextStyle(color: Color(0xfffcf3ea)),)
            : Text("filter (${calculateSelectedFilterNum(
            StoreProvider.of<AppState>(context).state.filterData.eventTypeTagSelectState,
            StoreProvider.of<AppState>(context).state.filterData.degreeTagSelectState)})",
          style: const TextStyle(color: Color(0xfffcf3ea)),),
        icon: const Icon(Icons.filter_list_alt, color: Color(0xfffcf3ea),),
      ),
      body:
    //       Column(
    //         // crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //       if(isBannerAdReady)
    //
    //     SizedBox(
    //       height: _bannerAd.size.height.toDouble(),
    //       width: _bannerAd.size.width.toDouble(),
    //       child: ads.AdWidget(ad: _bannerAd),
    // ),

       StoreConnector<AppState, AppState>(
        converter: (store) {
          return store.state;
        },
        builder: (context, appState) {
          return const EventsPage();
        },
      ),
// ],
//     ),
      drawer: const UserSideBar(),

    );
  }
}

class CustomSearchDelegate extends SearchDelegate {

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.navigate_before),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  Future<List<dynamic>> _searchEvents() async {
    List<dynamic> eventList = [];
    if (query.length >= 3) {
      var response = await http.get(
        Uri.parse('${Config.baseURL}/events/events/search?pageNumber=0&pageSize=15&keyword=${query.toLowerCase()}'),
        headers: {"Content-Type": "application/json"},
      );
      Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes))['data']);
      if (response.statusCode == 200) {
        eventList = map['content'];
      }
    }
    return eventList;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: _searchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => context.push("/events/${snapshot.data?[index]['id']}"),
                  title: Text(snapshot.data?[index]['title']),
                );
              },
              itemCount: snapshot.data?.length,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}

