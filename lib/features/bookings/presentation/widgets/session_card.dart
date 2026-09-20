import 'package:flutter/material.dart';

import '../../../../core/format/app_date.dart';
import '../../../../core/models/booking_session.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/user_avatar.dart';
import 'session_status_chip.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    this.onTap,
    this.actions,
    this.showDate = true,
  });

  final BookingSession session;
  final VoidCallback? onTap;
  final Widget? actions;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(name: session.patientName, size: 42),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.patientName,
                      style: context.text.bodyStrong,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.treatment,
                      style: context.text.meta,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SessionStatusChip(session.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              _Detail(
                icon: Icons.schedule,
                text: showDate
                    ? '${formatTime(session.startsAt)} · ${relativeDayLabel(session.startsAt)}'
                    : formatTime(session.startsAt),
              ),
              _Detail(
                icon: session.location == SessionLocation.homeVisit
                    ? Icons.home_outlined
                    : Icons.local_hospital_outlined,
                text: session.location.label,
              ),
            ],
          ),
          if (actions != null) ...[
            const SizedBox(height: AppSpacing.lg),
            actions!,
          ],
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: context.colors.inkMute),
        const SizedBox(width: AppSpacing.xs + 2),
        Text(text, style: context.text.label),
      ],
    );
  }
}
