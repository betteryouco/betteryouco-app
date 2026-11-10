class SpecialistDashboardGreeting {
  final String date;
  final int sessionsToday;

  const SpecialistDashboardGreeting({
    required this.date,
    required this.sessionsToday,
  });

  factory SpecialistDashboardGreeting.fromJson(Map<String, dynamic> json) {
    return SpecialistDashboardGreeting(
      date: json['date'] ?? '',
      sessionsToday: json['sessions_today'] ?? 0,
    );
  }
}

class SpecialistDashboardTiles {
  final int activeClients;
  final String activeClientsCaption;
  final int sessionsThisWeek;
  final String sessionsThisWeekCaption;
  final double? avgStressTrend;
  final String avgStressTrendCaption;
  final double earningsTotal;
  final double? earningsTrendPct;
  final String earningsCaption;

  const SpecialistDashboardTiles({
    required this.activeClients,
    required this.activeClientsCaption,
    required this.sessionsThisWeek,
    required this.sessionsThisWeekCaption,
    this.avgStressTrend,
    required this.avgStressTrendCaption,
    required this.earningsTotal,
    this.earningsTrendPct,
    required this.earningsCaption,
  });

  factory SpecialistDashboardTiles.fromJson(Map<String, dynamic> json) {
    return SpecialistDashboardTiles(
      activeClients: json['active_clients'] ?? 0,
      activeClientsCaption: json['active_clients_caption'] ?? '',
      sessionsThisWeek: json['sessions_this_week'] ?? 0,
      sessionsThisWeekCaption: json['sessions_this_week_caption'] ?? '',
      avgStressTrend: json['avg_stress_trend'] != null
          ? double.tryParse('${json['avg_stress_trend']}')
          : null,
      avgStressTrendCaption: json['avg_stress_trend_caption'] ?? '',
      earningsTotal: double.tryParse('${json['earnings_total']}') ?? 0,
      earningsTrendPct: json['earnings_trend_pct'] != null
          ? double.tryParse('${json['earnings_trend_pct']}')
          : null,
      earningsCaption: json['earnings_caption'] ?? '',
    );
  }
}

class TodaySessionModel {
  final int bookingId;
  final String clientName;
  final String time;
  final String type;
  final String status;
  final int? minutesUntil;

  const TodaySessionModel({
    required this.bookingId,
    required this.clientName,
    required this.time,
    required this.type,
    required this.status,
    this.minutesUntil,
  });

  factory TodaySessionModel.fromJson(Map<String, dynamic> json) {
    return TodaySessionModel(
      bookingId: json['booking_id'],
      clientName: json['client_name'] ?? 'Client',
      time: json['time'] ?? '',
      type: json['type'] ?? 'Consultation',
      status: json['status'] ?? 'scheduled',
      minutesUntil: json['minutes_until'] != null
          ? int.tryParse('${json['minutes_until']}'.split('.').first)
          : null,
    );
  }
}

class AtRiskClientModel {
  final int id;
  final String clientName;
  final String ruleId;
  final String severity;
  final String message;
  final DateTime? firedAt;

  const AtRiskClientModel({
    required this.id,
    required this.clientName,
    required this.ruleId,
    required this.severity,
    required this.message,
    this.firedAt,
  });

  factory AtRiskClientModel.fromJson(Map<String, dynamic> json) {
    return AtRiskClientModel(
      id: json['id'],
      clientName: json['client_name'] ?? 'Client',
      ruleId: json['rule_id'] ?? '',
      severity: json['severity'] ?? 'high',
      message: json['message'] ?? '',
      firedAt: json['fired_at'] != null
          ? DateTime.tryParse(json['fired_at'])
          : null,
    );
  }
}

class PendingTaskModel {
  final String type;
  final String label;
  final String subtitle;
  final int? conversationId;
  final String? clientName;

  const PendingTaskModel({
    required this.type,
    required this.label,
    required this.subtitle,
    this.conversationId,
    this.clientName,
  });

  factory PendingTaskModel.fromJson(Map<String, dynamic> json) {
    return PendingTaskModel(
      type: json['type'] ?? '',
      label: json['label'] ?? '',
      subtitle: json['subtitle'] ?? '',
      conversationId: json['conversation_id'],
      clientName: json['client_name'],
    );
  }
}

class PayoutHistoryModel {
  final int id;
  final double amount;
  final String? periodStart;
  final String? periodEnd;
  final String status;
  final DateTime? approvedAt;

  const PayoutHistoryModel({
    required this.id,
    required this.amount,
    this.periodStart,
    this.periodEnd,
    required this.status,
    this.approvedAt,
  });

  factory PayoutHistoryModel.fromJson(Map<String, dynamic> json) {
    return PayoutHistoryModel(
      id: json['id'],
      amount: double.tryParse('${json['amount']}') ?? 0,
      periodStart: json['period_start'],
      periodEnd: json['period_end'],
      status: json['status'] ?? 'pending',
      approvedAt: json['approved_at'] != null
          ? DateTime.tryParse(json['approved_at'])
          : null,
    );
  }
}

/// Earnings Dashboard breakdown from the onboarding/payment doc: pending
/// (accruing), available (ready for payout) and paid, plus recent payout
/// history.
class EarningsBreakdownModel {
  final double pending;
  final double available;
  final double paid;
  final List<PayoutHistoryModel> recentPayouts;

  const EarningsBreakdownModel({
    required this.pending,
    required this.available,
    required this.paid,
    required this.recentPayouts,
  });

  factory EarningsBreakdownModel.fromJson(Map<String, dynamic> json) {
    return EarningsBreakdownModel(
      pending: double.tryParse('${json['pending']}') ?? 0,
      available: double.tryParse('${json['available']}') ?? 0,
      paid: double.tryParse('${json['paid']}') ?? 0,
      recentPayouts: ((json['recent_payouts'] as List?) ?? [])
          .map((e) => PayoutHistoryModel.fromJson(e))
          .toList(),
    );
  }
}

class SpecialistDashboardModel {
  final SpecialistDashboardGreeting greeting;
  final SpecialistDashboardTiles tiles;
  final List<TodaySessionModel> todaySessions;
  final List<AtRiskClientModel> atRiskClients;
  final List<PendingTaskModel> pendingTasks;
  final EarningsBreakdownModel earnings;

  const SpecialistDashboardModel({
    required this.greeting,
    required this.tiles,
    required this.todaySessions,
    required this.atRiskClients,
    required this.pendingTasks,
    required this.earnings,
  });

  factory SpecialistDashboardModel.fromJson(Map<String, dynamic> json) {
    return SpecialistDashboardModel(
      greeting: SpecialistDashboardGreeting.fromJson(json['greeting'] ?? {}),
      tiles: SpecialistDashboardTiles.fromJson(json['tiles'] ?? {}),
      todaySessions: ((json['today_sessions'] as List?) ?? [])
          .map((e) => TodaySessionModel.fromJson(e))
          .toList(),
      atRiskClients: ((json['at_risk_clients'] as List?) ?? [])
          .map((e) => AtRiskClientModel.fromJson(e))
          .toList(),
      pendingTasks: ((json['pending_tasks'] as List?) ?? [])
          .map((e) => PendingTaskModel.fromJson(e))
          .toList(),
      earnings: EarningsBreakdownModel.fromJson(json['earnings'] ?? {}),
    );
  }
}
