import 'package:core_tune/auth/login.dart';
import 'package:core_tune/auth/login_w_google.dart';
import 'package:core_tune/json/json_song.dart';
import 'package:core_tune/models/user.dart';
import 'package:core_tune/page/About.dart';
import 'package:core_tune/screen/playeraudio.dart';
import 'package:core_tune/services/auth.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:core_tune/user/profile.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final MUser user;

  final AuthService authService = AuthService();

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final _user = FirebaseAuth.instance.currentUser;

  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  final List<String> letters = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
  ];
  bool _isPlaying = false;

  late CarouselSliderController _sliderController;
  int currentPage = 5;
  int index = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
  int activeMenu1 = 0;
  @override
  void initState() {
    super.initState();
    _sliderController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser!;
    return MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(left: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Core - Tune",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Container(
                child: _getPage(currentPage),
              ),
            ),
          ),
          bottomNavigationBar: FancyBottomNavigation(
            tabs: [
              TabData(
                  iconData: Icons.home,
                  title: "Home",
                  onclick: () {
                    final FancyBottomNavigationState fState =
                        bottomNavigationKey.currentState
                            as FancyBottomNavigationState;
                    fState.setPage(2);
                  }),
              TabData(iconData: Icons.person, title: "Artist"),
              TabData(iconData: Icons.album_sharp, title: "Album"),
              TabData(iconData: Icons.trending_up, title: 'Top-Trending'),
            ],
            initialSelection: 1,
            key: bottomNavigationKey,
            onTabChangedListener: (position) {
              setState(() {
                currentPage = position;
              });
            },
          ),
          drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(_user.photoURL!),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  '' + _user.displayName!,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'BalsamiqSans'),
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProfilePage();
                          }));
                        }),
                    Text(
                      'My Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'BalsamiqSans'),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    IconButton(
                        icon: Icon(Icons.audiotrack),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PlayerAudio();
                          }));
                        }),
                    Text(
                      'Track',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'BalsamiqSans'),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          final provider = Provider.of<SignInGoogleProvider>(
                              context,
                              listen: false);
                          provider.logout();
                          //await authService.signOut();
                          //FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }
                        //await authService.signOut();
                        //await authService.signOut();
                        ),
                    Text(
                      'Sign - Out',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'BalsamiqSans'),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    IconButton(
                        icon: Icon(Icons.apps),
                        onPressed: () {
                          //await authService.signOut();
                          //FirebaseAuth.instance.signOut();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AboutPage()));
                        }
                        //await authService.signOut();
                        //await authService.signOut();
                        ),
                    Text(
                      'About',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'BalsamiqSans'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget sliderItem(String title, IconData icons) => ListTile(
      title: Text(
        title,
        style:
            TextStyle(color: Colors.white, fontFamily: 'BalsamiqSans_Regular'),
      ),
      leading: Icon(
        icons,
        color: Colors.white,
      ),
      onTap: () {
        ProfilePage();
      });

  _getPage(int page) {
    switch (page) {
      case 0:
        return SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 50.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: Row(
                          children: List.generate(type_1_song.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                activeMenu1 = index;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  type_1_song[index],
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 3,
                                )
                              ],
                            ),
                          ),
                        );
                      }))),
                ),
                SizedBox(height: 40),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                        children: List.generate(10, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PlayerAudio();
                                  }));
                                },
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage(songs[index = 1]['img']),
                                        fit: BoxFit.cover),
                                    color: Colors.grey.shade600,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                songs[index = 1]['title'],
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Container(
                                width: 180,
                                child: Text(
                                  songs[currentPage]['description'],
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: Row(
                          children: List.generate(type_1_song.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                activeMenu1 = index;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  type_1_song[index],
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 3,
                                )
                              ],
                            ),
                          ),
                        );
                      }))),
                ),
                SizedBox(height: 40),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                        children: List.generate(10, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PlayerAudio();
                                  }));
                                },
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage(songs[index = 1]['img']),
                                        fit: BoxFit.cover),
                                    color: Colors.grey.shade600,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                songs[currentPage]['title'],
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Container(
                                width: 180,
                                child: Text(
                                  songs[currentPage]['description'],
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
                  ),
                )
              ],
            )
          ]),
        );
      case 1:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the search page"),
            RaisedButton(
              child: Text(
                "Start new page",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            )
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("This is the basket page"),
            RaisedButton(
              child: Text(
                "Start new page",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            )
          ],
        );
    }
  }
}

class Builder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasData) {
                return Home();
              }
              return LoginPage();
            }),
      );
}
