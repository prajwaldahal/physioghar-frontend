import 'package:flutter/material.dart';

import '../../../../core/models/booking_session.dart';
import '../../../../core/widgets/state_chip.dart';

class SessionStatusChip extends StatelessWidget {
  const SessionStatusChip(this.status, {super.key});

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    final tone = switch (status) {
      SessionStatus.pending => ChipTone.pending,
      SessionStatus.upcoming => ChipTone.active,
      SessionStatus.completed => ChipTone.done,
      SessionStatus.cancelled || SessionStatus.declined => ChipTone.danger,
    };
    return StateChip(status.label, tone: tone);
  }
}
