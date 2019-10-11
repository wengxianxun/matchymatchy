import 'package:squazzle/data/data.dart';

class HomeMatchListRepo {
  final DbProvider _dbProvider;
  final SharedPrefsProvider _prefsProvider;
  final ApiProvider _apiProvider;

  HomeMatchListRepo(this._dbProvider, this._prefsProvider, this._apiProvider);

  Future<void> updateMatches() async {
    String uid = await _prefsProvider.getUid();
    List<ActiveMatch> activeMatches = await _apiProvider.getActiveMatches(uid);
    activeMatches.sort((a, b) => b.time.compareTo(a.time));
    await _dbProvider.deleteActiveMatches();
    await _dbProvider.storeActiveMatches(activeMatches);
    List<PastMatch> pastMatches = await _apiProvider.getPastMatches(uid);
    pastMatches.sort((a, b) => b.time.compareTo(a.time));
    await _dbProvider.storePastMatches(pastMatches);
  }

  Future<List<ActiveMatch>> getActiveMatches() async =>
      await _dbProvider.getActiveMatches();

  Future<List<PastMatch>> getPastMatches() async =>
      await _dbProvider.getPastMatches();
}