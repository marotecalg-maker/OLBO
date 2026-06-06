import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/league.dart';
import '../../data/models/standing.dart';
import '../../data/services/api_football_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

class LeagueStandingsScreen extends StatefulWidget {
  final League league;

  const LeagueStandingsScreen({super.key, required this.league});

  @override
  State<LeagueStandingsScreen> createState() => _LeagueStandingsScreenState();
}

class _LeagueStandingsScreenState extends State<LeagueStandingsScreen> {
  final _service = ApiFootballService();
  LeagueStandings? _data;
  bool _isLoading = false;
  String? _error;

  int get _season {
    final seasons = widget.league.seasons;
    final current = seasons.where((s) => s.current == true).firstOrNull;
    return current?.year ??
        (seasons.isNotEmpty ? seasons.last.year : DateTime.now().year);
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result =
          await _service.getLeagueStandings(widget.league.id, _season);
      setState(() => _data = result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.league.name, overflow: TextOverflow.ellipsis),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _fetch);
    if (_data == null || _data!.standings.isEmpty) {
      return const EmptyView(message: 'No standings available');
    }

    final groups = _data!.standings;
    final multiGroup = groups.length > 1;

    return RefreshIndicator(
      onRefresh: _fetch,
      child: ListView(
        children: [
          const _TableHeader(),
          const Divider(height: 1),
          for (final group in groups) ...[
            if (multiGroup && group.isNotEmpty)
              _GroupHeader(name: group.first.group ?? 'Group'),
            ...group.map((s) => _StandingRow(standing: s)),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String name;
  const _GroupHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        name,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          SizedBox(
              width: 28,
              child: Text('#', style: style, textAlign: TextAlign.center)),
          SizedBox(width: 8),
          Expanded(child: Text('Team', style: style)),
          SizedBox(
              width: 32,
              child: Text('MP', style: style, textAlign: TextAlign.center)),
          SizedBox(
              width: 28,
              child: Text('W', style: style, textAlign: TextAlign.center)),
          SizedBox(
              width: 28,
              child: Text('D', style: style, textAlign: TextAlign.center)),
          SizedBox(
              width: 28,
              child: Text('L', style: style, textAlign: TextAlign.center)),
          SizedBox(
              width: 36,
              child: Text('GD', style: style, textAlign: TextAlign.center)),
          SizedBox(
              width: 36,
              child: Text('Pts', style: style, textAlign: TextAlign.center)),
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
    if (desc.contains('champions league')) {
      return AppColors.championsLeague.withValues(alpha: 0.12);
    }
    if (desc.contains('europa')) {
      return AppColors.europaLeague.withValues(alpha: 0.12);
    }
    if (desc.contains('relega')) {
      return AppColors.relegation.withValues(alpha: 0.12);
    }
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
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              standing.team.name,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _cell(context, standing.all.played.toString(), 32),
          _cell(context, standing.all.win.toString(), 28),
          _cell(context, standing.all.draw.toString(), 28),
          _cell(context, standing.all.lose.toString(), 28),
          _cell(
            context,
            '${standing.goalsDiff > 0 ? '+' : ''}${standing.goalsDiff}',
            36,
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

  Widget _cell(BuildContext context, String text, double width) => SizedBox(
        width: width,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
}
