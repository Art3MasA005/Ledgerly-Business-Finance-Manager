import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/home_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(currentBusinessProvider);
    final summaryAsync = ref.watch(businessSummaryProvider);
    final subscriptionAsync = ref.watch(subscriptionProvider);
    final contactsAsync = ref.watch(contactsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(businessSummaryProvider);
          ref.invalidate(contactsProvider);
          ref.invalidate(dailySalesProvider);
          ref.invalidate(subscriptionProvider);
        },
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // ── App Bar ────────────────────────────────────────────────────
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: AppColors.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 16,
              title: Row(
                children: [
                  // Business name
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text('৳',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  business?.name ?? 'Ledgerly',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subscriptionAsync.when(
                                  data: (sub) => _SubscriptionBadge(sub: sub),
                                  loading: () => const SizedBox.shrink(),
                                  error: (_, __) => const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textSecondary, size: 20),
                        ],
                      ),
                    ),
                  ),
                  // Inbox + Help
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications_outlined,
                            color: AppColors.textSecondary),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.debo,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline,
                        color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(height: 1, color: AppColors.divider),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Summary Cards ──────────────────────────────────────
                  summaryAsync.when(
                    data: (summary) => _SummaryCards(summary: summary),
                    loading: () => _SummaryCardsSkeleton(),
                    error: (_, __) => _SummaryCards(summary: const BusinessSummary()),
                  ),
                  const SizedBox(height: 16),

                  // ── Quick Actions Grid ─────────────────────────────────
                  _QuickActionsGrid(),
                  const SizedBox(height: 16),

                  // ── Sales Chart ────────────────────────────────────────
                  _SalesChartCard(),
                  const SizedBox(height: 16),

                  // ── Contacts Header ────────────────────────────────────
                  _ContactsHeader(),
                  const SizedBox(height: 8),
                ]),
              ),
            ),

            // ── Contacts List ──────────────────────────────────────────────
            contactsAsync.when(
              data: (contacts) {
                if (contacts.isEmpty) return _emptyContacts(context);
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _ContactRow(contact: contacts[i]),
                      childCount: contacts.length,
                    ),
                  ),
                );
              },
              loading: () => SliverToBoxAdapter(child: _ContactsSkeleton()),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addTransaction),
        icon: const Icon(Icons.add),
        label: const Text('লেনদেন'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  SliverToBoxAdapter _emptyContacts(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Text('👤', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'এখনো কোনো কাস্টমার বা সাপ্লায়ার নেই',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'প্রথম কাস্টমার যোগ করুন',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textHint),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('কাস্টমার যোগ করুন'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Summary Cards ──────────────────────────────────────────────────────────────

class _SummaryCards extends StatelessWidget {
  final BusinessSummary summary;
  const _SummaryCards({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'মোট পাবো',
            amount: summary.totalPabo,
            color: AppColors.pabo,
            bgColor: AppColors.paboLight,
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'মোট দেবো',
            amount: summary.totalDebo,
            color: AppColors.debo,
            bgColor: AppColors.deboLight,
            icon: Icons.arrow_upward_rounded,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      )),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            CurrencyFormatter.format(amount),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions Grid ─────────────────────────────────────────────────────────

class _QuickActionsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = [
      {'icon': Icons.point_of_sale_outlined, 'label': 'বিক্রি', 'route': AppRoutes.addSale},
      {'icon': Icons.people_outline, 'label': 'কাস্টমার', 'route': AppRoutes.addContact},
      {'icon': Icons.inventory_2_outlined, 'label': 'স্টক', 'route': null},
      {'icon': Icons.upload_file_outlined, 'label': 'ডাটা আমদানি', 'route': AppRoutes.import_},
      {'icon': Icons.download_outlined, 'label': 'রিপোর্ট', 'route': AppRoutes.export_},
      {'icon': Icons.receipt_long_outlined, 'label': 'খরচ', 'route': AppRoutes.addExpense},
      {'icon': Icons.backup_outlined, 'label': 'ব্যাকআপ', 'route': null},
      {'icon': Icons.bar_chart_outlined, 'label': 'বিশ্লেষণ', 'route': AppRoutes.reports},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: actions.length,
      itemBuilder: (_, i) {
        final action = actions[i];
        return _QuickActionTile(
          icon: action['icon'] as IconData,
          label: action['label'] as String,
          onTap: () {
            final route = action['route'] as String?;
            if (route != null) context.push(route);
          },
        );
      },
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryDark, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sales Chart ────────────────────────────────────────────────────────────────

class _SalesChartCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartDays = ref.watch(chartDaysProvider);
    final salesAsync = ref.watch(dailySalesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('বিক্রির চার্ট',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                // Period toggle
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PeriodChip(
                        label: '৭ দিন',
                        selected: chartDays == 7,
                        onTap: () =>
                            ref.read(chartDaysProvider.notifier).state = 7,
                      ),
                      _PeriodChip(
                        label: '৩০ দিন',
                        selected: chartDays == 30,
                        onTap: () =>
                            ref.read(chartDaysProvider.notifier).state = 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: salesAsync.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('📊', style: TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text('এখনো কোনো বিক্রি নেই',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textHint)),
                        ],
                      ),
                    );
                  }
                  final maxY = data
                      .map((d) => d.totalSales)
                      .fold(0.0, (a, b) => a > b ? a : b);
                  return BarChart(
                    BarChartData(
                      maxY: maxY == 0 ? 100 : maxY * 1.2,
                      minY: 0,
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) {
                              final idx = val.toInt();
                              if (idx >= 0 && idx < data.length) {
                                return Text(
                                  DateFormatter.formatShortDate(
                                      data[idx].date, bangla: false),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontSize: 9),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      barGroups: data.asMap().entries.map((e) {
                        final isToday = e.value.date.day == DateTime.now().day;
                        return BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: e.value.totalSales,
                              color: isToday
                                  ? AppColors.primary
                                  : AppColors.primaryLight,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                              width: 20,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
                loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
                error: (_, __) => const Center(child: Text('চার্ট লোড হয়নি')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Contacts Section ───────────────────────────────────────────────────────────

class _ContactsHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: AppColors.textHint, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'খুঁজুন...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textHint),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Icon(Icons.tune_outlined, color: AppColors.textSecondary, size: 20),
        ),
        const SizedBox(width: 8),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Icon(Icons.download_outlined, color: AppColors.textSecondary, size: 20),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final Contact contact;
  const _ContactRow({required this.contact});

  @override
  Widget build(BuildContext context) {
    final balance = contact.balance ?? 0;
    final isPabo = balance > 0;
    final isZero = balance == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        tileColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.divider),
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _avatarColor(contact.name),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              contact.initials,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
          ),
        ),
        title: Text(contact.name,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(
          contact.type == ContactType.supplier
              ? 'সাপ্লায়ার${contact.lastTransactionDate != null ? ' · ${DateFormatter.formatRelative(contact.lastTransactionDate!)}' : ''}'
              : 'কাস্টমার${contact.lastTransactionDate != null ? ' · ${DateFormatter.formatRelative(contact.lastTransactionDate!)}' : ''}',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textHint),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isZero)
              Text(
                CurrencyFormatter.format(balance.abs()),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isPabo ? AppColors.pabo : AppColors.debo,
                    ),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.textHint, size: 18),
          ],
        ),
        onTap: () => context.push('/contacts/${contact.id}'),
      ),
    );
  }

  Color _avatarColor(String name) {
    final colors = AppColors.avatarColors;
    return colors[name.codeUnitAt(0) % colors.length];
  }
}

// ── Subscription Badge ────────────────────────────────────────────────────────

class _SubscriptionBadge extends StatelessWidget {
  final Subscription? sub;
  const _SubscriptionBadge({this.sub});

  @override
  Widget build(BuildContext context) {
    if (sub == null) return const SizedBox.shrink();

    Color badgeColor;
    switch (sub!.status) {
      case SubscriptionStatus.trial:
        badgeColor = AppColors.trialBadge;
        break;
      case SubscriptionStatus.active:
      case SubscriptionStatus.expiring:
        badgeColor = AppColors.activeBadge;
        break;
      case SubscriptionStatus.expired:
      case SubscriptionStatus.suspended:
        badgeColor = AppColors.expiredBadge;
        break;
      default:
        badgeColor = AppColors.pendingBadge;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        sub!.status.badgeLabelBn,
        style: TextStyle(
            fontSize: 9, color: badgeColor, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ── Skeletons ──────────────────────────────────────────────────────────────────

class _SummaryCardsSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.divider,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactsSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: AppColors.surfaceVariant,
        highlightColor: AppColors.divider,
        child: Column(
          children: List.generate(
            5,
            (_) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
