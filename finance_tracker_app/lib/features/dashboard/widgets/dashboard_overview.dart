import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/transaction_service.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionService>(
      builder: (context, transactionService, child) {
        final stats = transactionService.getSpendingStats();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: AppConstants.paddingMedium,
              mainAxisSpacing: AppConstants.paddingMedium,
              childAspectRatio: 1.5,
              children: [
                _buildOverviewCard(
                  context,
                  'Total Spent',
                  '₹${stats['totalSpent'].toStringAsFixed(0)}',
                  Icons.trending_down,
                  const Color(AppConstants.errorColor),
                ),
                _buildOverviewCard(
                  context,
                  'Total Earned',
                  '₹${stats['totalEarned'].toStringAsFixed(0)}',
                  Icons.trending_up,
                  const Color(AppConstants.successColor),
                ),
                _buildOverviewCard(
                  context,
                  'This Month',
                  '₹${stats['thisMonth'].toStringAsFixed(0)}',
                  Icons.calendar_today,
                  const Color(AppConstants.primaryColor),
                ),
                _buildOverviewCard(
                  context,
                  'Balance',
                  '₹${stats['balance'].toStringAsFixed(0)}',
                  Icons.account_balance_wallet,
                  const Color(AppConstants.warningColor),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const Spacer(),
                Icon(
                  Icons.more_vert,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
            const Spacer(),
            Text(
              amount,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 