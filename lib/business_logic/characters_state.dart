part of 'characters_cubit.dart';

@immutable
abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Results> result;

  CharactersLoaded(this.result);
}
class EpisodeLoaded extends CharactersState {
  final List<Episode> episode;

  EpisodeLoaded(this.episode);
}
