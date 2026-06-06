class LeagueSeason {
  final int year;
  final String? start;
  final String? end;
  final bool? current;

  const LeagueSeason({
    required this.year,
    this.start,
    this.end,
    this.current,
  });

  factory LeagueSeason.fromJson(Map<String, dynamic> json) {
    return LeagueSeason(
      year: json['year'] as int,
      start: json['start'] as String?,
      end: json['end'] as String?,
      current: json['current'] as bool?,
    );
  }
}

class League {
  final int id;
  final String name;
  final String type;
  final String? logo;
  final String? country;
  final String? countryCode;
  final String? countryFlag;
  final List<LeagueSeason> seasons;

  const League({
    required this.id,
    required this.name,
    required this.type,
    this.logo,
    this.country,
    this.countryCode,
    this.countryFlag,
    required this.seasons,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    final leagueData = json.containsKey('league')
        ? json['league'] as Map<String, dynamic>
        : json;
    final countryData = json['country'] as Map<String, dynamic>?;
    final rawSeasons = json['seasons'] as List<dynamic>? ?? [];

    return League(
      id: leagueData['id'] as int,
      name: leagueData['name'] as String,
      type: leagueData['type'] as String? ?? '',
      logo: leagueData['logo'] as String?,
      country: countryData?['name'] as String?,
      countryCode: countryData?['code'] as String?,
      countryFlag: countryData?['flag'] as String?,
      seasons: rawSeasons
          .map((s) => LeagueSeason.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
