import 'dart:io';
import 'dart:convert';
import 'course.dart';
import 'announcement.dart';
import 'user.dart';

class CanvasApi {
  final String hostname;
  final String apiPath;
  final String token;
  final HttpClient httpClient = new HttpClient();

  CanvasApi({
    this.hostname,
    this.apiPath,
    this.token,
  });

  // ========
  //  Course
  // ========

  Future<List<Course>> getCourseList() async {
    return httpClient.getUrl(Uri.https(hostname, apiPath + "/courses"))
        .then((HttpClientRequest request) {
          request.headers.add("Authorization", "Bearer " + token);
          return request.close();
        })
    .then((HttpClientResponse response) async {
      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      List<Course> courseList = [];
      for (var course in data) {
        courseList.add(new Course(
                id: course["id"],
                name: course["name"],
                courseCode: course["course_code"],
                enrollmentTermId: course["enrollment_term_id"]
        ));
      }
      return courseList;
    });
  }
  Future<Course> getCourseById(int id) async {
    return httpClient.getUrl(Uri.https(hostname, apiPath + "/courses/$id"))
        .then((HttpClientRequest request) {
          request.headers.add("Authorization", "Bearer " + token);
          return request.close();
        })
    .then((HttpClientResponse response) async {
      var json = await response.transform(utf8.decoder).join();
      var course = jsonDecode(json);
      return new Course(
          id: course["id"],
          name: course["name"],
          courseCode: course["course_code"],
          enrollmentTermId: course["enrollment_term_id"]
      );
    });
  }
  Future<List<Course>> getCourseByIdList(List<int> idList) async {
    List<Course> courseList = [];
    for (int courseId in idList) {
      courseList.add(await getCourseById(courseId));
    }
    return courseList;
  }

  // ==============
  //  Announcement
  // ==============
  Future<List<Announcement>> getAnnouncementByCourseId(int courseId) async {
    return httpClient.getUrl(Uri.https(hostname, apiPath + "/announcements", { "context_codes[]": "course_$courseId" }))
        .then((HttpClientRequest request) {
          request.headers.add("Authorization", "Bearer " + token);
          return request.close();
        })
    .then((HttpClientResponse response) async {
      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      List<Announcement> announcementList = [];
      if (data.length == 0) return announcementList;
      for (var announcement in data) {
        var author = new User(
            id: announcement["author"]["id"],
            displayName: announcement["author"]["display_name"],
        );
        announcementList.add(new Announcement(
                id: announcement["id"],
                title: announcement["title"],
                author: author,
                message: announcement["message"],
        ));
      }
      return announcementList;
    });
  }
}
