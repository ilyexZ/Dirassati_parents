import 'dart:ui';

import 'package:dirassati/core/core_providers.dart';
import 'package:dirassati/core/auth_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/absences_remote_data_source.dart';
import '../../data/repositories/absences_repository.dart';
import '../../data/models/absence_model.dart';

/// Provider for the remote data source - this follows your exact pattern
/// from the students provider, keeping consistency across your app
final absencesRemoteDataSourceProvider = Provider<AbsencesRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return AbsencesRemoteDataSource(dio: dio, storage: storage);
});

/// Provider for the repository - again following your established pattern
/// This makes it easy to inject dependencies and test your code
final absencesRepositoryProvider = Provider<AbsencesRepository>((ref) {
  final remoteDataSource = ref.watch(absencesRemoteDataSourceProvider);
  return AbsencesRepository(remoteDataSource);
});

/// Main provider to fetch absences for a specific trimester
/// This uses FutureProvider.family just like your notesProvider
/// The family parameter lets you pass the trimester as an argument
final absencesProvider = FutureProvider.family<List<Absence>, String>((ref, trimester) async {
  // We need to get the student ID somehow - this assumes you have a current student selected
  // You might want to modify this to get the student ID from your app state
  final parentId = await ref.watch(parentIdProvider.future);
  final repository = ref.watch(absencesRepositoryProvider);
  
  // For now, using a placeholder student ID
  // In your real app, you'd get this from your selected student state
  return repository.fetchAbsences("student_id_placeholder", trimester);
});

/// Provider to get all absences grouped by trimester
/// This is useful for displaying the tab counts and managing state
final groupedAbsencesProvider = FutureProvider<Map<String, List<Absence>>>((ref) async {
  final parentId = await ref.watch(parentIdProvider.future);
  final repository = ref.watch(absencesRepositoryProvider);
  
  // Again, using placeholder - you'd want to get the actual student ID
  return repository.fetchAbsencesGroupedByTrimester("student_id_placeholder");
});

/// Provider for tracking the currently selected trimester
/// This helps manage which tab is active in your UI
final selectedTrimesterProvider = StateProvider<String>((ref) => 'Trimestre 1');

/// Provider that combines the selected trimester with the absences data
/// This gives you a reactive way to get absences for the currently selected trimester
final currentTrimesterAbsencesProvider = Provider<AsyncValue<List<Absence>>>((ref) {
  final selectedTrimester = ref.watch(selectedTrimesterProvider);
  return ref.watch(absencesProvider(selectedTrimester));
});

/// Theme-related providers following your pattern
/// These help manage the visual appearance of your absence cards
final absenceThemeProvider = Provider<AbsenceTheme>((ref) {
  // You could make this dynamic based on user preferences or system theme
  return AbsenceTheme.defaultTheme();
});

class AbsenceTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color dateBackgroundColor;
  final double borderRadius;
  final double cardElevation;

  AbsenceTheme({
    required this.primaryColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    required this.dateBackgroundColor,
    required this.borderRadius,
    required this.cardElevation,
  });

  /// Default theme that matches your screenshot colors
  factory AbsenceTheme.defaultTheme() {
    return AbsenceTheme(
      primaryColor: const Color(0xFF6366F1), // Purple color from your screenshot
      backgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      textColor: const Color(0xFF1F2937),
      dateBackgroundColor: const Color(0xFF6366F1),
      borderRadius: 12.0,
      cardElevation: 2.0,
    );
  }
}