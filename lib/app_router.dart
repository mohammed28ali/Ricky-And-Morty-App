
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/presentaion/screens/characters_details.dart';
import 'package:rick_and_morty_app/presentaion/screens/characters_screen.dart';

import 'business_logic/characters_cubit.dart';
import 'constants/strings.dart';
import 'data/model/character.dart';
import 'data/repository/character_repository.dart';
import 'data/web_services/character_web_services.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(CharacterWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case characterScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CharactersCubit(charactersRepository),
            child: const CharactersScreen(),
          ),
        );
      case characterDetailsScreen:
        final character = settings.arguments as Results;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CharactersCubit(charactersRepository),
            child: CharacterDetailsScreen(
              character: character,
            ),
          ),
        );
    }
  }
}
