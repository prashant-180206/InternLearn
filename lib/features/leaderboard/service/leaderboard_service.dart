import 'package:nexus/core/singleton.dart';
import 'package:nexus/features/leaderboard/data/models/leaderboard_entry.dart';

class LeaderboardService {
  static Stream<List<LeaderboardEntry>> getLeaderboardStream() {
    return supabase
        .from('user_profile')
        .stream(primaryKey: ['user_id'])
        .order('total_xp', ascending: false)
        .map((data) {
          return List.generate(data.length, (index) {
            final json = data[index];
            return LeaderboardEntry.fromJson({...json, 'rank': index + 1});
          });
        });
  }
}
