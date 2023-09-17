import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/model/character.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final Results character;

  const CharacterDetailsScreen({Key? key, required this.character})
      : super(key: key);

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getSingleEpisode();
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColor.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          widget.character.name,
          style: const TextStyle(color: MyColor.myWhite),
        ),
        background: Hero(
            tag: widget.character.id,
            child: Image.network(
              widget.character.image,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          TextSpan(
            text: title,
            style: const TextStyle(
                color: MyColor.myWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
                color: MyColor.myWhite,
                fontWeight: FontWeight.normal,
                fontSize: 16),
          ),
        ]));
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: MyColor.myYellow,
      height: 30,
      endIndent: endIndent,
      thickness: 2,
    );
  }

  Widget checkIfEpisodeLoaded(CharactersState state) {
    if (state is EpisodeLoaded) {
      var episode = (state).episode;
      return displayRandomEpisodeOrEmptySpace(state, episode);
    } else {
      return showProgressIndicator();
    }
  }

  Widget showProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColor.myYellow,
      ),
    );
  }

  Widget displayRandomEpisodeOrEmptySpace(CharactersState state, episode) {
    if (episode.length != 0) {
      int randomEpisodeNumber = Random().nextInt(episode.length - 1);
      return Center(
        child: DefaultTextStyle(
            style:
                const TextStyle(fontSize: 20, color: MyColor.myWhite, shadows: [
              Shadow(
                blurRadius: 7,
                color: MyColor.myYellow,
                offset: Offset(0, 0),
              )
            ]),
            child: AnimatedTextKit(
              animatedTexts: [
                FlickerAnimatedText(episode[randomEpisodeNumber].name)
              ],
              repeatForever: true,
            )),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.myGrey,
        body: CustomScrollView(
          slivers: [
            buildSliverAppBar(),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo('species : ', widget.character.species),
                      buildDivider(290),
                      characterInfo('status : ', widget.character.status),
                      buildDivider(300),
                      characterInfo('origin : ', widget.character.origin.name),
                      buildDivider(300),
                      characterInfo(
                          'location : ', widget.character.location.name),
                      buildDivider(280),
                      characterInfo('episode : ',
                          widget.character.episode.length.toString()),
                      buildDivider(280),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state) {
                          return checkIfEpisodeLoaded(state);
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 500,
                )
              ]),
            ),
          ],
        ));
  }
}
