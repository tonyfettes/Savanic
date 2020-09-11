import 'announcement.dart';
import 'api.dart';

class Course {
  final int id;
  final String name;
  final String courseCode;
  final int enrollmentTermId;
  List<Announcement> announcementList;

  Course({
    this.id,
    this.name,
    this.courseCode,
    this.enrollmentTermId,
  });

  Future<void> updateAnnouncementList(CanvasApi api) async {
    announcementList = await api.getAnnouncementByCourseId(this.id);
  }
}
