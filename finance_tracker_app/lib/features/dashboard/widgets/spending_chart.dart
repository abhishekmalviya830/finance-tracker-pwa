import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/transaction_service.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionService>(
      builder: (context, transactionService, child) {
        final categoryBreakdown = transactionService.getCategoryBreakdown();
        
        if (categoryBreakdown.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spending by Category',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppConstants.paddingLarge),
                      child: Column(
                        children: [
                          Icon(
                            Icons.pie_chart,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: AppConstants.paddingMedium),
                          Text(
                            'No spending data yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spending by Category',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // TODO: Handle chart period selection
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'week', child: Text('This Week')),
                        const PopupMenuItem(value: 'month', child: Text('This Month')),
                        const PopupMenuItem(value: 'year', child: Text('This Year')),
                      ],
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('This Month'),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: _getChartSections(categoryBreakdown),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                _buildLegend(categoryBreakdown),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _getChartSections(Map<String, double> categoryBreakdown) {
    final total = categoryBreakdown.values.fold(0.0, (sum, amount) => sum + amount);
    final colors = [
      const Color(AppConstants.primaryColor),
      const Color(AppConstants.successColor),
      const Color(AppConstants.warningColor),
      const Color(AppConstants.errorColor),
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
    ];

    return categoryBreakdown.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final percentage = total > 0 ? (category.value / total * 100).round() : 0;
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: category.value,
        title: '$percentage%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> categoryBreakdown) {
    final colors = [
      const Color(AppConstants.primaryColor),
      const Color(AppConstants.successColor),
      const Color(AppConstants.warningColor),
      const Color(AppConstants.errorColor),
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
    ];

    return Column(
      children: categoryBreakdown.entries.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: Text(
                  category.key,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                '₹${category.value.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
} 