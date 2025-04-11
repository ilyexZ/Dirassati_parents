import '../datasources/students_remote_data_source.dart';
import '../models/student_model.dart';

class StudentsRepository {
  final StudentsRemoteDataSource remoteDataSource;

  StudentsRepository(this.remoteDataSource);

  Future<List<Student>> fetchStudents(String parentId) async {
    //await Future.delayed(Duration(seconds: 1));
  return await remoteDataSource.getStudents(parentId);
}
}
