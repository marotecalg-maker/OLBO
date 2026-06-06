import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/leagues_provider.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import 'league_standings_screen.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<LeaguesProvider>();
      if (p.leagues.isEmpty && !p.isLoading) p.fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leagues')),
      body: Consumer<LeaguesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.leagues.isEmpty) {
            return const LoadingView();
          }
          if (provider.error != null && provider.leagues.isEmpty) {
            return ErrorView(
              message: provider.error!,
              onRetry: provider.fetch,
            );
          }
          if (provider.leagues.isEmpty) {
            return const EmptyView(message: 'No leagues found');
          }

          return RefreshIndicator(
            onRefresh: provider.fetch,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.leagues.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final league = provider.leagues[i];
                return ListTile(
                  title: Text(league.name),
                  subtitle: Text(
                    [if (league.country != null) league.country!, league.type]
                        .join(' · '),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeagueStandingsScreen(league: league),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
