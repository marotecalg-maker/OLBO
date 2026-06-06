import 'package:flutter/material.dart';
import '../data/models/standing.dart';
import '../data/services/api_football_service.dart';

class StandingsProvider extends ChangeNotifier {
  final ApiFootballService _service;

  StandingsProvider(this._service);

  List<LeagueStandings> _standings = [];
  bool _isLoading = false;
  String? _error;

  List<LeagueStandings> get standings => _standings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetch() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _standings = await _service.getStandings();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
