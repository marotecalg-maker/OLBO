class StandingTeam {
  final int id;
  final String name;
  final String? logo;

  const StandingTeam({required this.id, required this.name, this.logo});

  factory StandingTeam.fromJson(Map<String, dynamic> json) {
    return StandingTeam(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String?,
    );
  }
}

class StandingStats {
  final int played;
  final int win;
  final int draw;
  final int lose;
  final int goalsFor;
  final int goalsAgainst;

  const StandingStats({
    required this.played,
    required this.win,
    required this.draw,
    required this.lose,
    required this.goalsFor,
    required this.goalsAgainst,
  });

  int get goalDifference => goalsFor - goalsAgainst;

  factory StandingStats.fromJson(Map<String, dynamic> json) {
    final goals = json['goals'] as Map<String, dynamic>? ?? {};
    return StandingStats(
      played: json['played'] as int? ?? 0,
      win: json['win'] as int? ?? 0,
      draw: json['draw'] as int? ?? 0,
      lose: json['lose'] as int? ?? 0,
      goalsFor: goals['for'] as int? ?? 0,
      goalsAgainst: goals['against'] as int? ?? 0,
    );
  }
}

class Standing {
  final int rank;
  final StandingTeam team;
  final int points;
  final int goalsDiff;
  final String? group;
  final String? form;
  final String? status;
  final String? description;
  final StandingStats all;
  final StandingStats home;
  final StandingStats away;

  const Standing({
    required this.rank,
    required this.team,
    required this.points,
    required this.goalsDiff,
    this.group,
    this.form,
    this.status,
    this.description,
    required this.all,
    required this.home,
    required this.away,
  });

  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      rank: json['rank'] as int,
      team: StandingTeam.fromJson(json['team'] as Map<String, dynamic>),
      points: json['points'] as int? ?? 0,
      goalsDiff: json['goalsDiff'] as int? ?? 0,
      group: json['group'] as String?,
      form: json['form'] as String?,
      status: json['status'] as String?,
      description: json['description'] as String?,
      all: StandingStats.fromJson(json['all'] as Map<String, dynamic>? ?? {}),
      home: StandingStats.fromJson(json['home'] as Map<String, dynamic>? ?? {}),
      away: StandingStats.fromJson(json['away'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class LeagueStandings {
  final int leagueId;
  final String leagueName;
  final String? leagueLogo;
  final String? country;
  final int season;
  final List<List<Standing>> standings;

  const LeagueStandings({
    required this.leagueId,
    required this.leagueName,
    this.leagueLogo,
    this.country,
    required this.season,
    required this.standings,
  });

  factory LeagueStandings.fromJson(Map<String, dynamic> json) {
    final league = json['league'] as Map<String, dynamic>;
    final rawStandings = league['standings'] as List<dynamic>? ?? [];
    return LeagueStandings(
      leagueId: league['id'] as int,
      leagueName: league['name'] as String,
      leagueLogo: league['logo'] as String?,
      country: league['country'] as String?,
      season: league['season'] as int? ?? 0,
      standings: rawStandings
          .map((group) => (group as List<dynamic>)
              .map((s) => Standing.fromJson(s as Map<String, dynamic>))
              .toList())
          .toList(),
    );
  }
}
