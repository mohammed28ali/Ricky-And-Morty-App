import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/constants/my_colors.dart';
import '../../constants/strings.dart';
import '../../data/model/character.dart';

class CharacterItem extends StatelessWidget {
  final Results results;

  const CharacterItem({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MyColor.myWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, characterDetailsScreen,arguments: results),
        child: GridTile(
          footer: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.black45,
            alignment: Alignment.bottomCenter,
            child: Text(
              results.name,
              style: const TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  color: MyColor.myWhite,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          child: Hero(
            tag: results.id,
            child: Container(
              color: MyColor.myGrey,
              child: results.image.isNotEmpty
                  ? FadeInImage.assetNetwork(
                      height: double.infinity,
                      width: double.infinity,
                      placeholder: 'assets/images/loading.gif',
                      image: results.image,
                      fit: BoxFit.cover,
                    )
                  : Image.asset('assets/images/imageNotFound.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}
