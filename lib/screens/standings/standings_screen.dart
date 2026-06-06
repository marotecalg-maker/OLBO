import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/standing.dart';
import '../../providers/standings_provider.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/network_image.dart';

class StandingsScreen extends StatefulWidget {
  const StandingsScreen({super.key});

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<StandingsProvider>();
      if (p.standings.isEmpty && !p.isLoading) p.fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Standings')),
      body: Consumer<StandingsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.standings.isEmpty) {
            return const LoadingView();
          }
          if (provider.error != null && provider.standings.isEmpty) {
            return ErrorView(
              message: provider.error!,
              onRetry: provider.fetch,
            );
          }
          if (provider.standings.isEmpty) {
            return const EmptyView(message: 'No standings available');
          }

          return RefreshIndicator(
            onRefresh: provider.fetch,
            child: ListView.builder(
              itemCount: provider.standings.length,
              itemBuilder: (context, i) {
                final ls = provider.standings[i];
                return _LeagueStandingCard(leagueStandings: ls);
              },
            ),
          );
        },
      ),
    );
  }
}

class _LeagueStandingCard extends StatefulWidget {
  final LeagueStandings leagueStandings;

  const _LeagueStandingCard({required this.leagueStandings});

  @override
  State<_LeagueStandingCard> createState() => _LeagueStandingCardState();
}

class _LeagueStandingCardState extends State<_LeagueStandingCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final ls = widget.leagueStandings;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          // League header
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  LeagueLogo(url: ls.leagueLogo, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ls.leagueName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    ls.season.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            _TableHeader(),
            ...ls.standings.expand((group) => group).map(
                  (s) => _StandingRow(standing: s),
                ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: const [
          SizedBox(width: 28, child: Text('#', style: style, textAlign: TextAlign.center)),
          SizedBox(width: 8),
          Expanded(child: Text('Team', style: style)),
          SizedBox(width: 32, child: Text('MP', style: style, textAlign: TextAlign.center)),
          SizedBox(width: 28, child: Text('W', style: style, textAlign: TextAlign.center)),
          SizedBox(width: 28, child: Text('D', style: style, textAlign: TextAlign.center)),
          SizedBox(width: 28, child: Text('L', style: style, textAlign: TextAlign.center)),
          SizedBox(width: 36, child: Text('GD', style: style, textAlign: TextAlign.center)),
          SizedBox(width: 36, child: Text('Pts', style: style, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

class _StandingRow extends StatelessWidget {
  final Standing standing;

  const _StandingRow({required this.standing});

  Color? _rowColor(BuildContext context) {
    final desc = standing.description?.toLowerCase() ?? '';
    if (desc.contains('champions league')) return AppColors.championsLeague.withValues(alpha: 0.12);
    if (desc.contains('europa')) return AppColors.europaLeague.withValues(alpha: 0.12);
    if (desc.contains('relega')) return AppColors.relegation.withValues(alpha: 0.12);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bg = _rowColor(context);
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              standing.rank.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          TeamLogo(url: standing.team.logo, size: 22),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              standing.team.name,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _cell(context, standing.all.played.toString()),
          _cell(context, standing.all.win.toString()),
          _cell(context, standing.all.draw.toString()),
          _cell(context, standing.all.lose.toString()),
          _cell(
            context,
            '${standing.goalsDiff > 0 ? '+' : ''}${standing.goalsDiff}',
          ),
          SizedBox(
            width: 36,
            child: Text(
              standing.points.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, String text) => SizedBox(
        width: 28,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
}
