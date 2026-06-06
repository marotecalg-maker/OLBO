import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/match.dart';

class MatchDetailScreen extends StatelessWidget {
  final Match match;

  const MatchDetailScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final showScore = match.isLive || match.isFinished;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar(match: match),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _ScoreHeader(match: match, showScore: showScore),
                const SizedBox(height: 8),
                _MatchInfoSection(match: match),
                if (showScore) _ScoreBreakdownSection(match: match),
                if (match.events.isNotEmpty) _EventsSection(match: match),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  final Match match;
  const _AppBar({required this.match});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      title: Text(
        match.leagueName,
        style: const TextStyle(fontSize: 16),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ── Score header ──────────────────────────────────────────────────────────────

class _ScoreHeader extends StatelessWidget {
  final Match match;
  final bool showScore;
  const _ScoreHeader({required this.match, required this.showScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          _StatusChip(match: match),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _TeamColumn(
                  name: match.homeTeam.name,
                  isWinner: match.homeTeam.winner,
                  align: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: showScore
                    ? Text(
                        '${match.goalsHome ?? 0} : ${match.goalsAway ?? 0}',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                      )
                    : Text(
                        'vs',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
              ),
              Expanded(
                child: _TeamColumn(
                  name: match.awayTeam.name,
                  isWinner: match.awayTeam.winner,
                  align: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final Match match;
  const _StatusChip({required this.match});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    if (match.isLive) {
      color = AppColors.live;
      label = match.elapsed != null ? "LIVE · ${match.elapsed}'" : 'LIVE';
    } else if (match.isFinished) {
      color = AppColors.finished;
      label = match.statusLong;
    } else {
      color = AppColors.scheduled;
      label = match.statusLong;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (match.isLive)
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  final String name;
  final bool? isWinner;
  final TextAlign align;

  const _TeamColumn({required this.name, this.isWinner, required this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: align,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: isWinner == true ? FontWeight.bold : FontWeight.normal,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ── Match info ────────────────────────────────────────────────────────────────

class _MatchInfoSection extends StatelessWidget {
  final Match match;
  const _MatchInfoSection({required this.match});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Match Info',
      child: Column(
        children: [
          _InfoRow(label: 'League', value: match.leagueName),
          if (match.leagueCountry != null)
            _InfoRow(label: 'Country', value: match.leagueCountry!),
          if (match.leagueRound != null)
            _InfoRow(label: 'Round', value: match.leagueRound!),
          _InfoRow(label: 'Season', value: match.leagueSeason.toString()),
          if (match.venueName != null)
            _InfoRow(
              label: 'Venue',
              value: match.venueCity != null
                  ? '${match.venueName}, ${match.venueCity}'
                  : match.venueName!,
            ),
          if (match.date != null)
            _InfoRow(
              label: 'Date',
              value: AppDateUtils.formatFullDateTime(match.date),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

// ── Score breakdown ───────────────────────────────────────────────────────────

class _ScoreBreakdownSection extends StatelessWidget {
  final Match match;
  const _ScoreBreakdownSection({required this.match});

  @override
  Widget build(BuildContext context) {
    final ht = match.halftimeScore;
    final ft = match.fulltimeScore;

    final rows = <_ScoreEntry>[
      if (ht.home != null)
        _ScoreEntry('Half Time', '${ht.home}', '${ht.away}'),
      if (ft.home != null)
        _ScoreEntry('Full Time', '${ft.home}', '${ft.away}'),
    ];

    if (rows.isEmpty) return const SizedBox();

    return _SectionCard(
      title: 'Score Breakdown',
      child: Column(
        children: [
          _ScoreTableRow(
            label: '',
            home: match.homeTeam.name,
            away: match.awayTeam.name,
            isHeader: true,
          ),
          const Divider(height: 12),
          ...rows.map(
            (e) => _ScoreTableRow(label: e.label, home: e.home, away: e.away),
          ),
        ],
      ),
    );
  }
}

class _ScoreEntry {
  final String label, home, away;
  const _ScoreEntry(this.label, this.home, this.away);
}

class _ScoreTableRow extends StatelessWidget {
  final String label;
  final String home;
  final String away;
  final bool isHeader;

  const _ScoreTableRow({
    required this.label,
    required this.home,
    required this.away,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isHeader
        ? Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w600)
        : Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ),
          Expanded(child: Text(home, style: style, overflow: TextOverflow.ellipsis)),
          Text(away, style: style, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ── Events ────────────────────────────────────────────────────────────────────

class _EventsSection extends StatelessWidget {
  final Match match;
  const _EventsSection({required this.match});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Match Events',
      child: Column(
        children: match.events
            .map((e) => _EventTile(event: e, homeTeamId: match.homeTeam.id))
            .toList(),
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final MatchEvent event;
  final int homeTeamId;

  const _EventTile({required this.event, required this.homeTeamId});

  @override
  Widget build(BuildContext context) {
    final isHome = event.teamId == homeTeamId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: isHome ? _EventContent(event: event) : const SizedBox(),
          ),
          SizedBox(
            width: 48,
            child: Text(
              "${event.elapsed}'${event.extra != null ? '+${event.extra}' : ''}",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: !isHome ? _EventContent(event: event) : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _EventContent extends StatelessWidget {
  final MatchEvent event;
  const _EventContent({required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _eventIcon(event.type, event.detail),
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.playerName ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              if (event.assistName != null &&
                  event.type?.toLowerCase() == 'goal')
                Text(
                  'Assist: ${event.assistName}',
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              if (event.detail != null)
                Text(
                  event.detail!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _eventColor(event.type, event.detail),
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              if (event.comments != null)
                Text(
                  event.comments!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _eventIcon(String? type, String? detail) {
    IconData icon;
    Color color;
    switch (type?.toLowerCase()) {
      case 'goal':
        icon = Icons.sports_soccer;
        color = detail?.toLowerCase().contains('own') == true
            ? AppColors.ownGoal
            : AppColors.goal;
        break;
      case 'card':
        icon = Icons.rectangle;
        color = detail?.toLowerCase().contains('yellow') == true
            ? AppColors.yellowCard
            : AppColors.redCard;
        break;
      case 'subst':
        icon = Icons.swap_horiz;
        color = AppColors.substitution;
        break;
      case 'var':
        icon = Icons.videocam;
        color = Colors.purple;
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
    }
    return Icon(icon, size: 18, color: color);
  }

  Color _eventColor(String? type, String? detail) {
    switch (type?.toLowerCase()) {
      case 'goal':
        return detail?.toLowerCase().contains('own') == true
            ? AppColors.ownGoal
            : AppColors.goal;
      case 'card':
        return detail?.toLowerCase().contains('yellow') == true
            ? AppColors.yellowCard
            : AppColors.redCard;
      case 'subst':
        return AppColors.substitution;
      default:
        return Colors.grey;
    }
  }
}

// ── Shared card shell ─────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
