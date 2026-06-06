import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/matches_provider.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/match_card.dart';
import '../../widgets/league_header.dart';
import 'match_detail_screen.dart';

class MatchesListScreen extends StatefulWidget {
  final MatchType matchType;
  final bool autoRefresh;

  const MatchesListScreen({
    super.key,
    required this.matchType,
    this.autoRefresh = false,
  });

  @override
  State<MatchesListScreen> createState() => _MatchesListScreenState();
}

class _MatchesListScreenState extends State<MatchesListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  void _fetch() {
    context.read<MatchesProvider>().fetch(widget.matchType);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<MatchesProvider>(
      builder: (context, provider, _) {
        final state = provider.stateFor(widget.matchType);

        if (state.isLoading && state.matches.isEmpty) {
          return const LoadingView();
        }

        if (state.error != null && state.matches.isEmpty) {
          return ErrorView(message: state.error!, onRetry: _fetch);
        }

        if (state.matches.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sports_soccer,
                    size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No matches found',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _fetch,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        final grouped = provider.groupedMatches(widget.matchType, limit: 5);
        final leagueKeys = grouped.keys.toList();

        return RefreshIndicator(
          onRefresh: () => provider.fetch(widget.matchType),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: leagueKeys.length,
            itemBuilder: (context, i) {
              final key = leagueKeys[i];
              final matches = grouped[key]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeagueHeader(match: matches.first),
                  const Divider(height: 1),
                  ...matches.map(
                    (m) => MatchCard(
                      match: m,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MatchDetailScreen(match: m),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
