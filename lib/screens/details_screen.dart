import 'package:flutter/material.dart';

import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie: movie),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie: movie),
              _Overview(movie: movie),
              const SizedBox(height: 10),
              CreditCards(movieId: movie.id),
              
            ])
          )
        ],
        
      ),
    );
  }
}


class _CustomAppBar extends StatelessWidget {
  
  final Movie movie;
  
  const _CustomAppBar({
    Key? key, required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          alignment: Alignment.bottomCenter,
          color: Colors.black26,   //un color medio transparente por si la imagen de fondo es blanco y el texto no se vea
          child: Text(
            movie.title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          )
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


class _PosterAndTitle extends StatelessWidget {
  
  final Movie movie;
  
  const _PosterAndTitle({
    Key? key, required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,  //aqui recibimos el movie.heroId para indicar que aqui se dirigira el Hero Animation, ya asignamos este valor a la propiedad heroId de Movie al pulsar su widget de la anterior pantalla la cual se asigno con la palabra swiper- o slider- o search-
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullPathPoster),
                width: 140, height: 200, fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 10),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width-190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textTheme.headline5, overflow: TextOverflow.ellipsis, maxLines: 2),
                Text(movie.originalTitle, style: textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2),
                Row(
                  children: [
                    const Icon(Icons.star_outline, size: 15, color: Colors.yellow),
                    const SizedBox(width: 5,),
                    Text('Rating: ${movie.voteAverage.toString()}', style: textTheme.caption)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


class _Overview extends StatelessWidget {
  
  final Movie movie;
  
  const _Overview({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}