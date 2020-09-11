import 'package:flutter/material.dart';
import 'user.dart';
import 'course.dart';

class Announcement {
  final int id;
  final String title;
  final User author;
  final String message;

  Announcement({
    this.id,
    this.title,
    this.author,
    this.message,
  });
}

/*
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
  Widget _buildRow(String announcementTitle) {
    return new ListTile(
        title: new Text(announcementTitle),
    );
  }
  Widget _buildAnnouncementBoard() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final int index = i ~/ 2;
          return _buildRow(_course.announcementList[index].title);
        },
        itemCount: _course.announcementList.length * 2,
    );
  }
  @override
  void initState() {
    super.initState();
    _course = widget.course;
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
  Announcement announcement;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: Text(announcement.title),
        ),
        body: _buildAnnouncementDetail(),
    );
  }
}

class AnnouncementDetailState extends StatelessWidget {
}
*/
