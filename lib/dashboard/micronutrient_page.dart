import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MicronutrientPage extends StatelessWidget {
  const MicronutrientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Micronutrients',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Section
            _buildSectionHeader('Introduction'),
            const SizedBox(height: 12),
            _buildInfoCard(
              content:
                  'Micronutrients, often referred to as vitamins and minerals, are vital to healthy development, disease prevention, and wellbeing. Except for Vitamin D, micronutrients are not produced in the body and must be derived from the diet.',
              icon: Icons.science,
              color: Colors.teal,
            ),
            const SizedBox(height: 24),

            // Importance Section
            _buildSectionHeader('Why are they Important?'),
            const SizedBox(height: 12),
            _buildInfoCard(
              content:
                  'They enable the body to produce enzymes, hormones, and other substances essential for proper growth and development. Deficiencies can lead to severe health issues.',
              icon: Icons.verified_user,
              color: Colors.amber,
            ),
            const SizedBox(height: 24),

            // Vitamins vs Minerals
            _buildSectionHeader('Vitamins vs Minerals'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTypeCard(
                    title: 'Vitamins',
                    description:
                        'Organic compounds made by plants and animals which can be broken down by heat, acid, or air.',
                    color: Colors.purpleAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTypeCard(
                    title: 'Minerals',
                    description:
                        'Inorganic, exist in soil or water and cannot be broken down.',
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Key Micronutrients
            _buildSectionHeader('Key Micronutrients'),
            const SizedBox(height: 16),

            _buildMicroDetailCard(
              title: 'Iron',
              role: 'Motor and brain development.',
              source: 'Meat, beans, spinach',
              deficiency: 'Anemia, fatigue',
              color: Colors.red[800]!,
            ),
            const SizedBox(height: 12),
            _buildMicroDetailCard(
              title: 'Vitamin A',
              role: 'Vision, immune system.',
              source: 'Carrots, sweet potatoes',
              deficiency: 'Blindness, infection risk',
              color: Colors.orange[800]!,
            ),
            const SizedBox(height: 12),
            _buildMicroDetailCard(
              title: 'Vitamin D',
              role: 'Bone health, immune function.',
              source: 'Sunlight, fatty fish',
              deficiency: 'Rickets, bone pain',
              color: Colors.yellow[800]!,
            ),
            const SizedBox(height: 12),
            _buildMicroDetailCard(
              title: 'Zinc',
              role: 'Immune function, healing.',
              source: 'Oysters, beef, pumpkin seeds',
              deficiency: 'Hair loss, diarrhea',
              color: Colors.grey[800]!,
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Did You Know?'),
            const SizedBox(height: 12),
            _buildFactCard(
              'Over 2 billion people worldwide are estimated to be deficient in essential micronutrients like Vitamin A, Iodine, and Iron.',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard({
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF4A4A4A),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: color.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicroDetailCard({
    required String title,
    required String role,
    required String source,
    required String deficiency,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    children: [
                      const TextSpan(
                        text: 'Role: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: role),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    children: [
                      const TextSpan(
                        text: 'Source: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: source),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactCard(String fact) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.teal, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fact,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.teal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
