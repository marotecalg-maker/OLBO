import 'package:flutter/material.dart';
import '../data/models/league.dart';
import '../data/services/api_football_service.dart';

class LeaguesProvider extends ChangeNotifier {
  final ApiFootballService _service;

  LeaguesProvider(this._service);

  List<League> _leagues = [];
  bool _isLoading = false;
  String? _error;

  List<League> get leagues => _leagues;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetch() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final all = await _service.getLeagues()..shuffle();
      _leagues = all.take(3).toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
