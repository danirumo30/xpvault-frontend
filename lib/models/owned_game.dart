import 'package:xpvault/models/game.dart';

class OwnedGame {
  final int totalTime;
  final Game game;

  OwnedGame({
    required this.totalTime,
    required this.game,
  });

  factory OwnedGame.fromJson(Map<String, dynamic> json) {
    return OwnedGame(
      totalTime: json['totalTime'] ?? 0,
      game: Game.fromJson(json['game'] ?? {}),
    );
  }
}
