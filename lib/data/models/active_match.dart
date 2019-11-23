import 'game_field.dart';
import 'target_field.dart';

class Match {
  GameField gameField;
  TargetField targetField;

  Match({this.gameField, this.targetField});

  Match.fromMap(Map<String, dynamic> map) {
    gameField = GameField(grid: map['grid']);
    targetField = TargetField(grid: map['target']);
  }
}

class ActiveMatch extends Match {
  String matchId;
  String enemyName;
  String winnerName;
  String enemyUrl;
  int moves;
  int enemyMoves;
  int gfid;
  int started;
  int playerDone;
  int enemyDone;
  int isPlayerHost;
  TargetField enemyTargetField;
  DateTime time;

  ActiveMatch.fromMap(Map<String, dynamic> map) {
    gameField = GameField(grid: map['gf']);
    targetField = TargetField(grid: map['target']);
    matchId = map['matchid'];
    enemyName = map['enemyname'];
    winnerName = map['winnername'];
    enemyUrl = map['enemyurl'];
    moves = int.parse(map['moves'].toString());
    enemyMoves = int.parse(map['enemymoves'].toString());
    gfid = int.parse(map['gfid'].toString());
    started = int.parse(map['started'].toString());
    playerDone = int.parse(map['playerdone'].toString());
    enemyDone = int.parse(map['enemydone'].toString());
    isPlayerHost = int.parse(map['isplayerhost'].toString());
    enemyTargetField = TargetField(grid: map['enemytarget']);
    time = DateTime.fromMillisecondsSinceEpoch(map['time']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gf': gameField.grid,
      'target': targetField.grid,
      'matchid': matchId,
      'enemyname': enemyName,
      'winnername': winnerName,
      'enemyurl': enemyUrl,
      'moves': moves,
      'enemymoves': enemyMoves,
      'gfid': gfid,
      'started': started,
      'playerdone': playerDone,
      'enemydone': enemyDone,
      'isplayerhost': isPlayerHost,
      'enemytarget': enemyTargetField.grid,
      'time': time.millisecondsSinceEpoch,
    };
  }
}
