import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/absence_model.dart';
import '../../domain/providers/absences_provider.dart';

/// Detailed view for a single absence - useful for showing more information
/// This page could be accessed by tapping on an absence card
class AbsenceDetailPage extends ConsumerWidget {
  final Absence absence;

  const AbsenceDetailPage({
    Key? key,
    required this.absence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(absenceThemeProvider);
    
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
          'Détail de l\'absence',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main info card
            _buildInfoCard(theme),
            const SizedBox(height: 16),
            // Additional details if available
            if (absence.reason != null) ...[
              _buildReasonCard(theme),
              const SizedBox(height: 16),
            ],
            // Actions card
            _buildActionsCard(context, theme),
          ],
        ),
      ),
    );
  }

  /// Main information card showing absence details
  Widget _buildInfoCard(AbsenceTheme theme) {
    final formattedDate = DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(absence.date);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: absence.type == 'justified' 
                  ? Colors.green.shade100 
                  : Colors.red.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              absence.type == 'justified' ? 'Justifiée' : 'Non justifiée',
              style: TextStyle(
                color: absence.type == 'justified' 
                    ? Colors.green.shade700 
                    : Colors.red.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Student name
          _buildDetailRow('Élève', absence.studentName, theme),
          const SizedBox(height: 12),
          // Date
          _buildDetailRow('Date', formattedDate, theme),
          const SizedBox(height: 12),
          // Time
          _buildDetailRow('Heure', absence.time, theme),
          const SizedBox(height: 12),
          // Trimester
          _buildDetailRow('Trimestre', absence.trimester, theme),
        ],
      ),
    );
  }

  /// Helper method to build consistent detail rows
  Widget _buildDetailRow(String label, String value, AbsenceTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: theme.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// Card showing the reason if the absence is justified
  Widget _buildReasonCard(AbsenceTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Motif',
            style: TextStyle(
              color: theme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            absence.reason!,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Action buttons card - could include options like "Justify" or "Contact School"
  Widget _buildActionsCard(BuildContext context, AbsenceTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: TextStyle(
              color: theme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (absence.type == 'unjustified') ...[
            // Show justify button for unjustified absences
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle justify absence action
                  _showJustifyDialog(context);
                },
                icon: const Icon(Icons.edit_note),
                label: const Text('Justifier l\'absence'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Contact school button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Handle contact school action
                _showContactOptions(context);
              },
              icon: const Icon(Icons.phone),
              label: const Text('Contacter l\'établissement'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.primaryColor,
                side: BorderSide(color: theme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows dialog for justifying an absence
  void _showJustifyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Justifier l\'absence'),
          content: const Text('Cette fonctionnalité sera bientôt disponible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Shows options for contacting the school
  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Contacter l\'établissement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Appeler'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle phone call
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Envoyer un email'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle email
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}