import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry.freezed.dart';
part 'leaderboard_entry.g.dart';

@freezed
sealed class LeaderboardEntry with _$LeaderboardEntry {
  factory LeaderboardEntry({
    required String name,
    @JsonKey(name: 'total_xp') @Default(0) int totalXp,
    @Default(1) int rank,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}
