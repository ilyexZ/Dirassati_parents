// lib/features/school_info/data/repositories/school_info_repository.dart
import 'package:dirassati/features/school_info/domain/models/school_info_model.dart';

import '../datasources/school_info_remote_data_source.dart';


class SchoolInfoRepository {
  final SchoolInfoRemoteDataSource remoteDataSource;

  SchoolInfoRepository(this.remoteDataSource);

  /// Repository method to fetch school info - this adds a layer of abstraction
  /// between your UI and data source, making it easier to change data sources later
  Future<SchoolInfo> fetchSchoolInfo(String studentId) async {
    return await remoteDataSource.fetchSchoolInfo(studentId);
  }
}