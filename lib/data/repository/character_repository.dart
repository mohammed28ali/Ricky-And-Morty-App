import 'package:rick_and_morty_app/data/model/episode.dart';

import '../model/character.dart';
import '../web_services/character_web_services.dart';

class CharactersRepository {
  final CharacterWebServices characterWebServices;

  CharactersRepository(this.characterWebServices);

  Future<List<Results>> getAllCharacters() async {
    final List<Map<String, dynamic>> characters =
        await characterWebServices.getAllCharacters();
    return List<Results>.from(characters.map((x) => Results.fromJson(x)));
  }

  Future< List<Episode>> getSingleEpisode() async {
    final  List<Map<String, dynamic>> episode = await characterWebServices.getAllEpisode();
    return List<Episode>.from(episode.map((x) => Episode.fromJson(x)));  }
}
