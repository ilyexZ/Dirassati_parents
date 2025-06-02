// lib/features/school_info/presentation/pages/school_info_page.dart
import 'package:dirassati/features/school_info/domain/models/school_info_model.dart';
import 'package:dirassati/features/school_info/domain/providers/school_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main page that displays school information with expandable sections
/// This follows the Flutter provider pattern you're using in your codebase
final Color iconColor = const Color.fromARGB(255, 14, 99, 168);

class SchoolInfoPage extends ConsumerWidget {
  const SchoolInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the school info provider to get data and loading states
    final schoolInfoAsync = ref.watch(schoolInfoProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: -8,
        title: const Text(
          "Informations d'établissement",
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: schoolInfoAsync.when(
        // While data is loading, show loading indicator
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        // If there's an error, show error message with retry option
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(schoolInfoProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        // When data is loaded successfully, show the school info
        data: (schoolInfoAsync) => SchoolInfoContent(schoolInfo: schoolInfoAsync),
      ),
    );
  }
}

/// Widget that displays the actual school information content
/// Separated for better code organization and reusability
class SchoolInfoContent extends StatelessWidget {
  final SchoolInfo schoolInfo;

  const SchoolInfoContent({
    Key? key,
    required this.schoolInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // School logo - you can replace this with an actual image
          Container(
              width: 160,
              height: 160,
              margin: EdgeInsets.all(8),
              child: Center(
                child: Hero(
                  tag: 'schoolP',
                  child:
                      SizedBox(height: 160, width: 160, child: Image.asset("assets/img/sc.png")),
                ),
              )),

          // Main school information card
          _buildMainInfoCard(),
          const SizedBox(height: 16),

          // Expandable contact section
          _buildExpandableSection(
            title: 'Contact',
            icon: Icons.phone,
            content: _buildContactContent(),
          ),
          const SizedBox(height: 16),

          // Expandable payment section
          _buildExpandableSection(
            title: 'Paiment',
            icon: Icons.payment,
            content: _buildPaymentContent(),
          ),
        ],
      ),
    );
  }

  /// Builds the main information card with school logo and basic details
  Widget _buildMainInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFEDEFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // School information rows
          _buildInfoRow('Nom', schoolInfo.name),
          _buildInfoRow('Adresse', schoolInfo.address),
          _buildInfoRow('Directeur', schoolInfo.director),
          _buildInfoRow('siteWeb', schoolInfo.siteWeb, isWeb: true),
        ],
      ),
    );
  }

  /// Helper method to build consistent information rows
  Widget _buildInfoRow(String label, String value, {bool isWeb = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isWeb ? Colors.blue[600] : Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                decoration: isWeb ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds expandable sections for contact and payment information
  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return ExpansionTile(
      backgroundColor: Color(0xFFEDEFFF),
      collapsedBackgroundColor: Color(0xFFEDEFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue[600], size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 8, 4),
          child: content,
        ),
      ],
    );
  }

  /// Builds the contact information content for the expandable section
  Widget _buildContactContent() {
    final phones = schoolInfo.contactInfo.getAllPhones();

    return Column(
      children: [
        // Display all phone numbers
        ...phones.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final phone = entry.value;
          return _buildContactRow('$index er N° de téléphone', phone);
        }).toList(),

        // Email address
        if (schoolInfo.contactInfo.email.isNotEmpty)
          _buildContactRow('Adresse email', schoolInfo.contactInfo.email),
      ],
    );
  }

  /// Builds the payment information content for the expandable section
  Widget _buildPaymentContent() {
    return Column(
      children: [
        _buildContactRow(
          'Mode de paiement',
          schoolInfo.paymentInfo.paymentMode.isNotEmpty
              ? schoolInfo.paymentInfo.paymentMode
              : 'Non spécifié',
        ),
        _buildContactRow(
          'RIP du compte',
          schoolInfo.paymentInfo.accountRip.isNotEmpty
              ? schoolInfo.paymentInfo.accountRip
              : 'Non spécifié',
        ),
      ],
    );
  }

  /// Helper method to build contact/payment information rows
  Widget _buildContactRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
