import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/model/character.dart';
import '../data/model/episode.dart';
import '../data/repository/character_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Results> results = [];
  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

   List<Results> getAllCharacters()  {
     charactersRepository.getAllCharacters().then((results) {
       emit(CharactersLoaded(results));
       this.results = results;
     });
     return results;
   }
   void getSingleEpisode() {
     charactersRepository.getSingleEpisode().then((episode) {
       emit(EpisodeLoaded(episode));
     });
   }
}
