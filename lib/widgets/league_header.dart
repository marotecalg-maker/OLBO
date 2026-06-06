import 'package:flutter/material.dart';
import '../data/models/match.dart';
import 'network_image.dart';

class LeagueHeader extends StatelessWidget {
  final Match match;

  const LeagueHeader({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              match.leagueName,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (match.leagueFlag != null) ...[
            const SizedBox(width: 6),
            FlagImage(url: match.leagueFlag),
          ],
          const SizedBox(width: 6),
          if (match.leagueCountry != null)
            Text(
              match.leagueCountry!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
