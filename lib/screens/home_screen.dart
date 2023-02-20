import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:peliculas_app/search/search_delegate.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //inicio del provider
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas de Hoy'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [      
          //Peliculas en un swiper o stack
          CardSwiper(movies : moviesProvider.nowPlayingMovies),

          //Listado horizontal de pelis
          MovieSlider(
            movies: moviesProvider.popularMovies,
            title : 'Populares',
            onNextPage: () => moviesProvider.getPopularMovies(),
          )

        ],
      ),
      )
    );
  }
}