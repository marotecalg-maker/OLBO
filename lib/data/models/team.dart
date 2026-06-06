class TeamVenue {
  final int? id;
  final String? name;
  final String? address;
  final String? city;
  final int? capacity;
  final String? surface;
  final String? image;

  const TeamVenue({
    this.id,
    this.name,
    this.address,
    this.city,
    this.capacity,
    this.surface,
    this.image,
  });

  factory TeamVenue.fromJson(Map<String, dynamic> json) {
    return TeamVenue(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      capacity: json['capacity'] as int?,
      surface: json['surface'] as String?,
      image: json['image'] as String?,
    );
  }
}

class Team {
  final int id;
  final String name;
  final String? code;
  final String? country;
  final int? founded;
  final bool? national;
  final String? logo;
  final TeamVenue? venue;

  const Team({
    required this.id,
    required this.name,
    this.code,
    this.country,
    this.founded,
    this.national,
    this.logo,
    this.venue,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    // API may return {team: {...}, venue: {...}} or a flat object
    final teamData = json.containsKey('team')
        ? json['team'] as Map<String, dynamic>
        : json;
    final venueData = json['venue'] as Map<String, dynamic>?;

    return Team(
      id: teamData['id'] as int,
      name: teamData['name'] as String,
      code: teamData['code'] as String?,
      country: teamData['country'] as String?,
      founded: teamData['founded'] as int?,
      national: teamData['national'] as bool?,
      logo: teamData['logo'] as String?,
      venue: venueData != null ? TeamVenue.fromJson(venueData) : null,
    );
  }
}
