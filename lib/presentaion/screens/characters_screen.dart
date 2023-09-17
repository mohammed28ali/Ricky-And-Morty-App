import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/model/character.dart';
import '../widgets/character_item.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Results> allResults;
  late List<Results> searchedForCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColor.myGrey,
      decoration: const InputDecoration(
        hintText: 'Find a Character',
        border: InputBorder.none,
        hintStyle: TextStyle(color: MyColor.myGrey, fontSize: 18),
      ),
      style: const TextStyle(color: MyColor.myGrey, fontSize: 18),
      onChanged: (value) {
        addSearchedItemForSearchedList(value);
      },
    );
  }

  void addSearchedItemForSearchedList(String searchedCharacter) {
    searchedForCharacters = allResults
        .where((character) =>
            character.name.toLowerCase().startsWith(searchedCharacter))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarAction() {
    if (_isSearching) {
      return [
        IconButton(
            onPressed: () {
              _clearSearch();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: MyColor.myGrey,
            ))
      ];
    } else {
      return [
        IconButton(
            onPressed: _startSearch,
            icon: const Icon(
              Icons.search,
              color: MyColor.myGrey,
            ))
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  _clearSearch() {
    setState(() {
      searchedForCharacters.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocBuilder() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          allResults = (state).result;
          return buildLoadedListWidgets();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
        child: CircularProgressIndicator(
      color: MyColor.myYellow,
    ));
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColor.myGrey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchTextController.text.isEmpty
          ? allResults.length
          : searchedForCharacters.length,
      itemBuilder: (context, index) {
        return CharacterItem(
          results: _searchTextController.text.isEmpty
              ? allResults[index]
              : searchedForCharacters[index],
        );
      },
    );
  }

  Widget _buildAppBarTitle() {
    return const Text(
      'Characters',
      style: TextStyle(color: MyColor.myGrey),
    );
  }

  Widget buildNoInternet() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'No Internet',
              style: TextStyle(fontSize: 20, color: MyColor.myGrey),
            ),
            Image.asset('assets/images/undraw_going_offline_ihag.png')
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.myYellow,
          leading: _isSearching
              ? const BackButton(
                  color: MyColor.myGrey,
                )
              : Container(),
          title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
          actions: _buildAppBarAction(),
        ),
        body: OfflineBuilder(
          connectivityBuilder: (context, value, child) {
            final connected = value != ConnectivityResult.none;
            if (connected) {
              return buildBlocBuilder();
            } else {
              return buildNoInternet();
            }
          },
          child: showLoadingIndicator(),
        ));
  }
}
