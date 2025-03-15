import '../datasources/students_remote_data_source.dart';
import '../models/student_model.dart';

class StudentsRepository {
  final StudentsRemoteDataSource remoteDataSource;

  StudentsRepository(this.remoteDataSource);

  Future<List<Student>> fetchStudents() async {
    return await remoteDataSource.getStudents();
  }
}
