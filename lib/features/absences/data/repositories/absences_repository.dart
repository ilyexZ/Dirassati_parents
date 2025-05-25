import '../datasources/absences_remote_data_source.dart';
import '../models/absence_model.dart';

class AbsencesRepository {
  final AbsencesRemoteDataSource remoteDataSource;

  AbsencesRepository(this.remoteDataSource);

  /// Repository method to fetch absences - this adds a layer of abstraction
  /// between your UI and data source, making it easier to change data sources later
  Future<List<Absence>> fetchAbsences(String studentId, String trimester) async {
    return await remoteDataSource.fetchAbsences(studentId, trimester);
  }

  /// Get all absences for a student across all trimesters
  Future<List<Absence>> fetchAllAbsences(String studentId) async {
    return await remoteDataSource.fetchAllAbsences(studentId);
  }

  /// Get absences grouped by trimester - useful for the UI tabs
  Future<Map<String, List<Absence>>> fetchAbsencesGroupedByTrimester(String studentId) async {
    final allAbsences = await fetchAllAbsences(studentId);
    
    // Group absences by trimester using a map
    final Map<String, List<Absence>> grouped = {};
    
    for (final absence in allAbsences) {
      final trimester = absence.trimester;
      if (!grouped.containsKey(trimester)) {
        grouped[trimester] = [];
      }
      grouped[trimester]!.add(absence);
    }
    
    return grouped;
  }
}