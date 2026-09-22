import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/page_scaffold.dart';
import '../../model/complaint.dart';
import '../../providers/complaints_provider.dart';
import '../widgets/complaint_card.dart';

class MyComplaintsScreen extends ConsumerWidget {
  const MyComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaints = ref.watch(complaintsProvider);

    return PageScaffold(
      title: 'My complaints',
      showBack: true,
      child: switch (complaints) {
        AsyncLoading() => const LoadingView(message: 'Loading complaints'),
        AsyncError(:final error) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(complaintsProvider),
        ),
        _ => _List(items: ref.watch(complaintsNewestFirstProvider)),
      },
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.items});

  final List<Complaint> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.support_agent_outlined,
        title: 'No complaints yet',
        message: 'Anything you report will be listed here.',
        actionLabel: 'Report an issue',
        onAction: () => context.push(AppRoutes.reportIssue),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        AppSpacing.lg,
        AppSpacing.pageGutter,
        AppSpacing.xxl,
      ),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => ComplaintCard(complaint: items[index]),
    );
  }
}
