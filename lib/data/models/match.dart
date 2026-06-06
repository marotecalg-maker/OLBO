class MatchEvent {
  final int? elapsed;
  final int? extra;
  final int? teamId;
  final String? teamName;
  final String? teamLogo;
  final int? playerId;
  final String? playerName;
  final int? assistId;
  final String? assistName;
  final String? type;
  final String? detail;
  final String? comments;

  const MatchEvent({
    this.elapsed,
    this.extra,
    this.teamId,
    this.teamName,
    this.teamLogo,
    this.playerId,
    this.playerName,
    this.assistId,
    this.assistName,
    this.type,
    this.detail,
    this.comments,
  });

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    final time = json['time'] as Map<String, dynamic>?;
    final team = json['team'] as Map<String, dynamic>?;
    final player = json['player'] as Map<String, dynamic>?;
    final assist = json['assist'] as Map<String, dynamic>?;
    return MatchEvent(
      elapsed: time?['elapsed'] as int?,
      extra: time?['extra'] as int?,
      teamId: team?['id'] as int?,
      teamName: team?['name'] as String?,
      teamLogo: team?['logo'] as String?,
      playerId: player?['id'] as int?,
      playerName: player?['name'] as String?,
      assistId: assist?['id'] as int?,
      assistName: assist?['name'] as String?,
      type: json['type'] as String?,
      detail: json['detail'] as String?,
      comments: json['comments'] as String?,
    );
  }
}

class MatchScore {
  final int? home;
  final int? away;

  const MatchScore({this.home, this.away});

  factory MatchScore.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MatchScore();
    return MatchScore(
      home: json['home'] as int?,
      away: json['away'] as int?,
    );
  }
}

class MatchTeam {
  final int id;
  final String name;
  final String? logo;
  final bool? winner;

  const MatchTeam({
    required this.id,
    required this.name,
    this.logo,
    this.winner,
  });

  factory MatchTeam.fromJson(Map<String, dynamic> json) {
    return MatchTeam(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      winner: json['winner'] as bool?,
    );
  }
}

class Match {
  final int fixtureId;
  final String? date;
  final int? timestamp;
  final String statusLong;
  final String statusShort;
  final String? venueName;
  final String? venueCity;
  final int leagueId;
  final String leagueName;
  final String? leagueCountry;
  final String? leagueLogo;
  final String? leagueFlag;
  final int leagueSeason;
  final String? leagueRound;
  final MatchTeam homeTeam;
  final MatchTeam awayTeam;
  final int? goalsHome;
  final int? goalsAway;
  final MatchScore halftimeScore;
  final MatchScore fulltimeScore;
  final List<MatchEvent> events;
  final int? elapsed;

  const Match({
    required this.fixtureId,
    this.date,
    this.timestamp,
    required this.statusLong,
    required this.statusShort,
    this.venueName,
    this.venueCity,
    required this.leagueId,
    required this.leagueName,
    this.leagueCountry,
    this.leagueLogo,
    this.leagueFlag,
    required this.leagueSeason,
    this.leagueRound,
    required this.homeTeam,
    required this.awayTeam,
    this.goalsHome,
    this.goalsAway,
    required this.halftimeScore,
    required this.fulltimeScore,
    required this.events,
    this.elapsed,
  });

  bool get isLive =>
      statusShort == '1H' ||
      statusShort == 'HT' ||
      statusShort == '2H' ||
      statusShort == 'ET' ||
      statusShort == 'BT' ||
      statusShort == 'P' ||
      statusShort == 'LIVE';

  bool get isFinished =>
      statusShort == 'FT' ||
      statusShort == 'AET' ||
      statusShort == 'PEN';

  bool get isScheduled =>
      statusShort == 'NS' || statusShort == 'TBD';

  factory Match.fromJson(Map<String, dynamic> json) {
    final fixture = json['fixture'] as Map<String, dynamic>;
    final status = fixture['status'] as Map<String, dynamic>? ?? {};
    final venue = fixture['venue'] as Map<String, dynamic>?;
    final league = json['league'] as Map<String, dynamic>;
    final teams = json['teams'] as Map<String, dynamic>;
    final goals = json['goals'] as Map<String, dynamic>?;
    final score = json['score'] as Map<String, dynamic>?;
    final rawEvents = json['events'] as List<dynamic>?;

    return Match(
      fixtureId: fixture['id'] as int,
      date: fixture['date'] as String?,
      timestamp: fixture['timestamp'] as int?,
      statusLong: status['long'] as String? ?? '',
      statusShort: status['short'] as String? ?? '',
      elapsed: status['elapsed'] as int?,
      venueName: venue?['name'] as String?,
      venueCity: venue?['city'] as String?,
      leagueId: league['id'] as int,
      leagueName: league['name'] as String,
      leagueCountry: league['country'] as String?,
      leagueLogo: league['logo'] as String?,
      leagueFlag: league['flag'] as String?,
      leagueSeason: league['season'] as int? ?? 0,
      leagueRound: league['round'] as String?,
      homeTeam: MatchTeam.fromJson(teams['home'] as Map<String, dynamic>),
      awayTeam: MatchTeam.fromJson(teams['away'] as Map<String, dynamic>),
      goalsHome: goals?['home'] as int?,
      goalsAway: goals?['away'] as int?,
      halftimeScore: MatchScore.fromJson(score?['halftime'] as Map<String, dynamic>?),
      fulltimeScore: MatchScore.fromJson(score?['fulltime'] as Map<String, dynamic>?),
      events: rawEvents
              ?.map((e) => MatchEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
