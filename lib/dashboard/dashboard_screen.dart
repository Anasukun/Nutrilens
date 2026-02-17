import 'package:flutter/material.dart';
import '../repositories/meal_repository.dart';
import 'scan_food_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: SafeArea(
        child: ValueListenableBuilder<List<LoggedMeal>>(
          valueListenable: MealRepository.instance.meals,
          builder: (context, meals, child) {
            // Calculate daily totals
            final todayCalories = MealRepository.instance.todayCalories;
            final todayMacros = MealRepository.instance.todayMacros;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeaderSection(),
                  const SizedBox(height: 24),
                  _DailySummaryCard(
                    calories: todayCalories,
                    macros: todayMacros,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _QuickActionsSection(),
                  const SizedBox(height: 24),
                  const _WellnessTipCard(),
                  const SizedBox(height: 24),
                  const _TodaysMealsHeader(),
                  const SizedBox(height: 16),
                  _MealList(meals: meals),
                  const SizedBox(height: 80), // Space for bottom nav
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const _CustomBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScanFoodScreen()),
          );
        },
        backgroundColor: const Color(0xFF4A1817), // Dark reddish brown
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning,',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              'Jessica Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A1817), // Dark reddish brown
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.5),
              width: 2,
            ),
            color: Colors.white,
          ),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.person, size: 30, color: Colors.grey),
          ), // Placeholder for profile image
        ),
      ],
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  final int calories;
  final Map<String, double> macros;

  const _DailySummaryCard({
    required this.calories,
    required this.macros,
  });

  @override
  Widget build(BuildContext context) {
    const int calorieGoal = 2000;
    final int caloriesLeft = (calorieGoal - calories).clamp(0, calorieGoal);
    final double progress = (calories / calorieGoal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: calories > 0
                      ? const Color(0xFF8B9D42).withValues(alpha: 0.2)
                      : Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  calories > 0 ? 'Tracking' : 'No Data',
                  style: TextStyle(
                    color: calories > 0 ? const Color(0xFF5D6B2C) : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 15,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF8B9D42),
                  ), // Olive green
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$caloriesLeft',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const Text(
                    'KCAL LEFT',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroNutrientInfo(
                label: 'Protein',
                amount: '${macros['Protein']!.toInt()}g',
                color: const Color(0xFF4A1817),
                percentage: (macros['Protein']! / 150).clamp(0.0, 1.0), // Example goal 150g
              ),
              _MacroNutrientInfo(
                label: 'Carbs',
                amount: '${macros['Carbs']!.toInt()}g',
                color: const Color(0xFF8B9D42),
                percentage: (macros['Carbs']! / 250).clamp(0.0, 1.0), // Example goal 250g
              ),
              _MacroNutrientInfo(
                label: 'Fat',
                amount: '${macros['Fat']!.toInt()}g',
                color: Colors.orange,
                percentage: (macros['Fat']! / 70).clamp(0.0, 1.0), // Example goal 70g
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroNutrientInfo extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final double percentage;

  const _MacroNutrientInfo({
    required this.label,
    required this.amount,
    required this.color,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          height: 6,
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScanFoodScreen()),
              );
            },
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B9D42), Color(0xFFA5B950)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Scan\nMeal',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            key: const Key('meal_history_button'),
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE4E4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.history, color: Color(0xFF4A1817)),
                ),
                const Text(
                  'Meal\nHistory',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WellnessTipCard extends StatelessWidget {
  const _WellnessTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50], // Light green tint
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lightbulb, color: Color(0xFF8B9D42)),
              ),
              const SizedBox(width: 12),
              const Text(
                'Wellness Tip',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Stay hydrated! Drinking water before meals can aid digestion and control appetite.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodaysMealsHeader extends StatelessWidget {
  const _TodaysMealsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Today's Meals",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(
              color: Color(0xFF8B9D42),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _MealList extends StatelessWidget {
  final List<LoggedMeal> meals;

  const _MealList({required this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.restaurant, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No meals logged yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Scan your first meal to get started!',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: meals.map((meal) {
        final hours = meal.timestamp.hour.toString().padLeft(2, '0');
        final minutes = meal.timestamp.minute.toString().padLeft(2, '0');
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _MealItem(
            name: meal.result.foodName,
            time: '$hours:$minutes',
            calories: '${meal.result.totalCalories} kcal',
            icon: Icons.fastfood,
          ),
        );
      }).toList(),
    );
  }
}

class _MealItem extends StatelessWidget {
  final String name;
  final String time;
  final String calories;
  final IconData icon;

  const _MealItem({
    required this.name,
    required this.time,
    required this.calories,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            calories,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B9D42),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomBottomNavigationBar extends StatelessWidget {
  const _CustomBottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      shadowColor: Colors.black12,
      elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(icon: Icons.home, label: 'Home', isActive: true),
            _NavBarItem(icon: Icons.bar_chart, label: 'Stats', isActive: false),
            const SizedBox(width: 48), // Space for FAB
            _NavBarItem(
              icon: Icons.restaurant_menu,
              label: 'Meals',
              isActive: false,
            ),
            _NavBarItem(
              icon: Icons.person_outline,
              label: 'Profile',
              isActive: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF8B9D42) : Colors.grey[400],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? const Color(0xFF8B9D42) : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
