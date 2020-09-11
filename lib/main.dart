import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api.dart';
import 'course.dart';
import 'announcement.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

var courseList = <Course>[];

final presetCourseIdList = [1897, 1807, 1800, 1801, 1804, 1795];

final CanvasApi canvasApi = new CanvasApi(
    hostname: "<YOUR_CANVAS_URL_HERE>",
    apiPath: "/api/v1",
    token: "<YOUR_TOKEN_HERE>",
);

Future<void> main() async {
  print("Getting course list from ${canvasApi.hostname}...");
  courseList = await canvasApi.getCourseByIdList(presetCourseIdList);
  print("Got course list from ${canvasApi.hostname}.");
  for (var course in courseList) {
    print("Getting announcement list for course ${course.id}...");
    course.announcementList = await canvasApi.getAnnouncementByCourseId(course.id);
    print("Got announcement list for course ${course.id} with length ${course.announcementList.length}...");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /*
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Canvas'),
    );
  }
  */
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Canvas',
        home: new DashBoard(courseList: courseList),
        theme: ThemeData(
            textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
            ),
        ),
    );
  }
}

class DashBoard extends StatefulWidget {
  final List<Course> courseList;
  DashBoard({
    this.courseList,
  });
  @override
  createState() => new DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  List<Course> _courseList;
  @override
  void initState() {
    super.initState();
    _courseList = widget.courseList;
  }
  Widget _buildRow(int courseIndex) {
    return new ListTile(
        title: new Text(_courseList[courseIndex].name),
        subtitle: new Text(_courseList[courseIndex].courseCode),
        onTap: () {
          print(_courseList[courseIndex].name + " pressed.");
          print("Announcement list with length " + _courseList[courseIndex].announcementList.length.toString() + " is to be shown");
          Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (context) {
                    return new AnnouncementBoard(course: _courseList[courseIndex]);
                  }
              )
          );
        }
    );
  }
  Widget _buildDashBoard() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final int index = i ~/ 2;
          return _buildRow(index);
        },
        itemCount: _courseList.length * 2,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Course List'),
        ),
        body: _buildDashBoard(),
    );
  }
}

class AnnouncementBoard extends StatefulWidget {
  final Course course;
  AnnouncementBoard({
    this.course,
  });
  @override
  createState() => new AnnouncementBoardState();
}

class AnnouncementBoardState extends State<AnnouncementBoard> {
  Course _course;
  @override
  void initState() {
    super.initState();
    _course = widget.course;
  }
  Widget _buildRow(int announcementId) {
    return new ListTile(
        title: new Text(_course.announcementList[announcementId].title),
        onTap: () {
          Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (context) {
                    return new AnnouncementDetail(announcement: _course.announcementList[announcementId]);
                  },
              )
          );
        }
    );
  }
  Widget _buildAnnouncementBoard() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final int index = i ~/ 2;
          return _buildRow(index);
        },
        itemCount: _course.announcementList.length * 2,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: Text('${(_course.name ?? '')}'),
        ),
        body: _buildAnnouncementBoard(),
    );
  }
}

class AnnouncementDetail extends StatefulWidget {
  final Announcement announcement;
  AnnouncementDetail({
    this.announcement,
  });
  @override
  createState() => new AnnouncementDetailState();
}

class AnnouncementDetailState extends State<AnnouncementDetail> {
  Announcement _announcement;
  Widget _buildAnnouncementDetail() {
    return new Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: HtmlWidget(
                _announcement.message,
                textStyle: TextStyle(fontSize: 16),
                webView: true,
            ),
        ),
    );
  }
  @override
  void initState() {
    super.initState();
    this._announcement = widget.announcement;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: Text(_announcement.title),
        ),
        body: _buildAnnouncementDetail(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
