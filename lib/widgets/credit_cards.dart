import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:provider/provider.dart';

import 'package:peliculas_app/providers/movies_provider.dart';

class CreditCards extends StatelessWidget {

  final int movieId;

  const CreditCards({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCredits(movieId),
      builder: ( _ , snapshot) {

        if (!snapshot.hasData){  //antes de cargar los actores que muestre un CircularProgressIndicator
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final List<Cast> casts = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount: casts.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) => _ActorCard(actor: casts[index]),
          ),
        );

      },
    );

  }
}

class _ActorCard extends StatelessWidget {

  final Cast actor;

  const _ActorCard({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110, height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              width: double.infinity, height: 140, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}