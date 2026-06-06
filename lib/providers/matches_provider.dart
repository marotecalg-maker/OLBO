import 'package:flutter/material.dart';
import '../data/models/match.dart';
import '../data/services/api_football_service.dart';

enum MatchType { live, today, yesterday, tomorrow }

class MatchState {
  final List<Match> matches;
  final bool isLoading;
  final String? error;

  const MatchState({
    this.matches = const [],
    this.isLoading = false,
    this.error,
  });

  MatchState copyWith({
    List<Match>? matches,
    bool? isLoading,
    String? error,
  }) =>
      MatchState(
        matches: matches ?? this.matches,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class MatchesProvider extends ChangeNotifier {
  final ApiFootballService _service;

  MatchesProvider(this._service);

  final Map<MatchType, MatchState> _states = {
    MatchType.live: const MatchState(),
    MatchType.today: const MatchState(),
    MatchType.yesterday: const MatchState(),
    MatchType.tomorrow: const MatchState(),
  };

  MatchState stateFor(MatchType type) => _states[type]!;

  Future<void> fetch(MatchType type, {bool silent = false}) async {
    if (!silent) {
      _states[type] = _states[type]!.copyWith(isLoading: true, error: null);
      notifyListeners();
    }

    try {
      final matches = await _fetchByType(type);
      _states[type] = _states[type]!.copyWith(
        matches: matches,
        isLoading: false,
      );
    } catch (e) {
      _states[type] = _states[type]!.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<List<Match>> _fetchByType(MatchType type) {
    switch (type) {
      case MatchType.live:
        return _service.getLiveMatches();
      case MatchType.today:
        return _service.getTodayMatches();
      case MatchType.yesterday:
        return _service.getYesterdayMatches();
      case MatchType.tomorrow:
        return _service.getTomorrowMatches();
    }
  }

  // Group matches by league name for display
  Map<String, List<Match>> groupedMatches(MatchType type, {int? limit}) {
    final all = _states[type]!.matches;
    final matches = limit != null ? all.take(limit).toList() : all;
    final Map<String, List<Match>> grouped = {};
    for (final m in matches) {
      final key = '${m.leagueName} — ${m.leagueCountry ?? ''}';
      grouped.putIfAbsent(key, () => []).add(m);
    }
    return grouped;
  }
}
