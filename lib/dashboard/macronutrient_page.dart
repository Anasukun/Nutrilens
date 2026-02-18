import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MacronutrientPage extends StatelessWidget {
  const MacronutrientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Macronutrients',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
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
                  'Macronutrients are essential nutrients that the human body requires in large quantities to function optimally. They provide energy and support various bodily processes. The term "macro" signifies that these nutrients are needed in larger amounts compared to micronutrients.',
              icon: Icons.info_outline,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),

            // Importance Section
            _buildSectionHeader('Why are they Important?'),
            const SizedBox(height: 12),
            _buildInfoCard(
              content:
                  'They are vital for energy production, growth, repair, and overall health. A balanced intake of all three macronutrients is crucial for maintaining a healthy body.',
              icon: Icons.health_and_safety,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 24),

            // The 3 Macros
            _buildSectionHeader('The 3 Main Types'),
            const SizedBox(height: 16),

            _buildMacroDetailCard(
              title: 'Carbohydrates',
              calories: '4 kcal/g',
              description:
                  'The body\'s main and preferred source of energy. They break down into glucose which fuels the brain, kidneys, muscles, and central nervous system.',
              sources: 'Whole grains, fruits, vegetables, beans, dairy',
              color: AppColors.primary,
              icon: Icons.grass,
            ),
            const SizedBox(height: 16),

            _buildMacroDetailCard(
              title: 'Proteins',
              calories: '4 kcal/g',
              description:
                  'The "building blocks of life". Crucial for building and repairing tissues, including muscles, organs, and bones. Also vital for immune function.',
              sources: 'Poultry, eggs, red meat, seafood, dairy, legumes',
              color: AppColors.secondary,
              icon: Icons.fitness_center,
            ),
            const SizedBox(height: 16),

            _buildMacroDetailCard(
              title: 'Fats (Lipids)',
              calories: '9 kcal/g',
              description:
                  'A concentrated source of energy. Essential for brain development, hormone production, and absorption of fat-soluble vitamins (A, D, E, K).',
              sources: 'Olive oil, avocados, nuts, seeds, fatty fish',
              color: Colors.orange,
              icon: Icons.opacity,
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Did You Know?'),
            const SizedBox(height: 12),
            _buildFactCard(
              'Fiber is a type of carbohydrate that the body cannot digest, but it aids in digestive health and waste elimination.',
            ),
            const SizedBox(height: 12),
            _buildFactCard(
              'Unsaturated fats are generally considered healthier than saturated and trans fats.',
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

  Widget _buildMacroDetailCard({
    required String title,
    required String calories,
    required String description,
    required String sources,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  calories,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A4A4A),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Common Sources:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sources,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
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
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: AppColors.primaryDark, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fact,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
