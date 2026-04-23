import 'package:nexus/features/leaderboard/data/models/leaderboard_entry.dart';
import 'package:nexus/features/leaderboard/service/leaderboard_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leaderboard_provider.g.dart';

@riverpod
Stream<List<LeaderboardEntry>> leaderboard(Ref ref) {
  
  return LeaderboardService.getLeaderboardStream();

}
