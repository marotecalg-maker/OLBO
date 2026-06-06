import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_utils.dart';
import '../data/models/match.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback? onTap;

  const MatchCard({super.key, required this.match, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _StatusRow(match: match),
              const SizedBox(height: 10),
              _TeamsRow(match: match),
              if (match.isLive && match.events.isNotEmpty)
                _LastEventRow(event: match.events.last),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final Match match;
  const _StatusRow({required this.match});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statusBadge(context),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            match.isScheduled
                ? AppDateUtils.formatMatchTime(match.date)
                : match.venueName ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(BuildContext context) {
    Color color;
    String label;

    if (match.isLive) {
      color = AppColors.live;
      label = match.elapsed != null ? "${match.elapsed}'" : 'LIVE';
    } else if (match.isFinished) {
      color = AppColors.finished;
      label = match.statusShort;
    } else {
      color = AppColors.scheduled;
      label = match.statusShort;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (match.isLive)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamsRow extends StatelessWidget {
  final Match match;
  const _TeamsRow({required this.match});

  @override
  Widget build(BuildContext context) {
    final showScore = match.isLive || match.isFinished;

    return Row(
      children: [
        Expanded(
          child: _TeamSide(
            name: match.homeTeam.name,
            logo: match.homeTeam.logo,
            isWinner: match.homeTeam.winner,
            alignment: CrossAxisAlignment.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: showScore
              ? _ScoreBox(
                  home: match.goalsHome,
                  away: match.goalsAway,
                )
              : Text(
                  'vs',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
        ),
        Expanded(
          child: _TeamSide(
            name: match.awayTeam.name,
            logo: match.awayTeam.logo,
            isWinner: match.awayTeam.winner,
            alignment: CrossAxisAlignment.end,
          ),
        ),
      ],
    );
  }
}

class _TeamSide extends StatelessWidget {
  final String name;
  final String? logo;
  final bool? isWinner;
  final CrossAxisAlignment alignment;

  const _TeamSide({
    required this.name,
    this.logo,
    this.isWinner,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == CrossAxisAlignment.start;
    final nameWidget = Text(
      name,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isWinner == true ? FontWeight.bold : FontWeight.normal,
          ),
      textAlign: isLeft ? TextAlign.left : TextAlign.right,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        nameWidget,
      ],
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final int? home;
  final int? away;

  const _ScoreBox({this.home, this.away});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${home ?? '-'} : ${away ?? '-'}',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
      ),
    );
  }
}

class _LastEventRow extends StatelessWidget {
  final MatchEvent event;
  const _LastEventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          _eventIcon(event.type),
          const SizedBox(width: 6),
          Text(
            "${event.elapsed}' ${event.playerName ?? ''}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _eventIcon(String? type) {
    IconData icon;
    Color color;
    switch (type?.toLowerCase()) {
      case 'goal':
        icon = Icons.sports_soccer;
        color = AppColors.goal;
        break;
      case 'card':
        icon = Icons.rectangle;
        color = AppColors.yellowCard;
        break;
      case 'subst':
        icon = Icons.swap_horiz;
        color = AppColors.substitution;
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
    }
    return Icon(icon, size: 14, color: color);
  }
}
