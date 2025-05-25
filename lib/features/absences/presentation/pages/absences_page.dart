// lib/features/absences/presentation/pages/absences_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/providers/absences_provider.dart';
import '../../data/models/absence_model.dart';

class AbsencesPage extends ConsumerWidget {
  const AbsencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current theme to get consistent styling
    final theme = ref.watch(absenceThemeProvider);
    // Watch the currently selected trimester to highlight the active tab
    final selectedTrimester = ref.watch(selectedTrimesterProvider);
    
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Absences',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Trimester tabs - this creates the three tabs you see in your screenshot
          Container(
            color: Colors.white,
            child: _buildTrimesterTabs(context, ref, selectedTrimester, theme),
          ),
          // Content area showing the selected trimester's absences
          Expanded(
            child: _buildAbsencesContent(context, ref, theme),
          ),
        ],
      ),
    );
  }

  /// Builds the three trimester tabs at the top
  /// This creates the horizontal scrollable tabs you see in your design
  Widget _buildTrimesterTabs(BuildContext context, WidgetRef ref, String selectedTrimester, AbsenceTheme theme) {
    final trimesters = ['Trimestre 1', 'Trimestre 2', 'Trimestre 3'];
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: trimesters.map((trimester) {
          final isSelected = trimester == selectedTrimester;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                // Update the selected trimester when user taps a tab
                ref.read(selectedTrimesterProvider.notifier).state = trimester;
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? theme.primaryColor : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    trimester,
                    style: TextStyle(
                      color: isSelected ? theme.primaryColor : Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Builds the main content area showing absence cards
  /// This handles the loading state and displays the list of absences
  Widget _buildAbsencesContent(BuildContext context, WidgetRef ref, AbsenceTheme theme) {
    // Watch the absences for the currently selected trimester
    final absencesAsync = ref.watch(currentTrimesterAbsencesProvider);
    
    return absencesAsync.when(
      // Loading state - show a spinner while data is being fetched
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      // Error state - show an error message if something goes wrong
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur lors du chargement des absences',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Refresh the data when user taps retry
                ref.invalidate(currentTrimesterAbsencesProvider);
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
      // Success state - show the list of absences
      data: (absences) {
        if (absences.isEmpty) {
          // Show empty state when there are no absences
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Colors.green.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune absence pour ce trimestre',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }
        
        // Show the list of absence cards
        return RefreshIndicator(
          onRefresh: () async {
            // Allow user to refresh by pulling down
            ref.invalidate(currentTrimesterAbsencesProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: absences.length,
            itemBuilder: (context, index) {
              return _buildAbsenceCard(absences[index], theme);
            },
          ),
        );
      },
    );
  }

  /// Builds an individual absence card matching your screenshot design
  /// Each card shows the date, student name, and time in a clean layout
  Widget _buildAbsenceCard(Absence absence, AbsenceTheme theme) {
    // Format the date to match your screenshot format
    final formattedDate = DateFormat('dd MMMM yyyy', 'fr_FR').format(absence.date);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Left side - Purple date badge matching your design
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.dateBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Right side - Student info and time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student name
                  Text(
                    absence.studentName,
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Time with clock icon
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        absence.time,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 
