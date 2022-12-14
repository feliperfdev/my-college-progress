import 'package:flutter/cupertino.dart';
import 'package:my_college_progress/modules/courses/domain/usecases/get_all_courses.dart';
import 'package:my_college_progress/modules/courses/domain/usecases/update_course_status.dart';
import 'package:my_college_progress/modules/courses/presenter/controllers/states/course_states.dart';

class CourseController extends ValueNotifier<CourseState> {
  CourseController(this._getAllCoursesUsecase, this._updateCourseStatusUsecase)
      : super(InitialCourseState());

  final GetAllCourses _getAllCoursesUsecase;

  /// [SQFlite Database]
  final UpdateCourseStatus _updateCourseStatusUsecase;

  Future<void> getAllCourses() async {
    final usecase = await _getAllCoursesUsecase();

    value = LoadingCourseState();

    usecase.fold((failure) {
      value = ErrorCourseState();
    }, (courses) {
      value = SucessGetAllCoursesState(courses);
    });
  }

  Future<void> updateCourseStatus(String name, String status) async {
    final usecase = await _updateCourseStatusUsecase(name, status);

    value = LoadingCourseState();

    usecase.fold((failure) {
      value = ErrorCourseState();
    }, (_) async {
      value = SuccessCourseUpdateState();
      await getAllCourses();
    });
  }
}
