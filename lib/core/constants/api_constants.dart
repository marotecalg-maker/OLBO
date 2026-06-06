class ApiConstants {
  static const String baseUrl =
      'https://api-koora-production.up.railway.app/api/football';

  static const String health = '/health';
  static const String live = '/live';
  static const String today = '/today';
  static const String yesterday = '/yesterday';
  static const String tomorrow = '/tomorrow';
  static const String teams = '/teams';
  static const String standings = '/standings';
  static const String leagues = '/leagues';

  static String standingsByLeague(int leagueId, int season) =>
      '/standings?league=$leagueId&season=$season';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
