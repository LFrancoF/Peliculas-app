import 'package:flutter/material.dart';

import 'package:peliculas_app/models/models.dart';
import 'package:provider/provider.dart';
import 'package:peliculas_app/providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String? get searchFieldLabel => 'Buscar pelicula';  //propiedad para cambiar el texto placeholder de la busqueda
  

  @override
  List<Widget>? buildActions(BuildContext context) {
    
    return [
      IconButton(
      onPressed: () => query = '', 
      icon: const Icon(Icons.clear)
    )
    ];

  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if (query.isEmpty) return _emptySearch();

    

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    
    //con un FutureBuilder se hara peticion cada vez que escribamos algo o movamos el cursor del search
    /*return FutureBuilder(
      future: moviesProvider.searchMovies(query),
      builder: (_, snapshot) {

        if (!snapshot.hasData) return _emptySearch();

        final List<Movie> movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, index) => _MoviesSuggestion(movie: movies[index]),
        );
      },
    );*/


    //En vez de FutureBuilder usaremos StreamBuilder para aplicar Debouncer y no hacer peticion a cada rato que se escribe o se mueva el cursor en el search
    moviesProvider.getSuggestionByQuery(query);
    
    return GestureDetector(   //lo envolvemos en un gestureDetector para quitar el teclado cuando se hace scroll, esto con la propiedad onTapDown
      onTapDown: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      
      child: StreamBuilder(
        stream: moviesProvider.suggestionStream,
        builder: (_, snapshot) {
      
          if (!snapshot.hasData) return _emptySearch();
          
          final List<Movie> movies = snapshot.data!;
      
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, index) => _MoviesSuggestion(movie: movies[index]),
          );
        },
      ),
    );




  }

  Widget _emptySearch(){
    return const Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 100),
      );
  }

}

class _MoviesSuggestion extends StatelessWidget {

  final Movie movie;

  const _MoviesSuggestion({required this.movie});

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${movie.id}';   //asignamos el heroId a la propiedad heroId de la clase Movie para hacer el Hero Animation, esto siempre sera unico en pantalla porque la busqueda muestra peliculas diferentes

    return Hero(
      tag: movie.heroId!,
      child: ListTile(
        visualDensity: const VisualDensity(vertical: 4),  //height
        leading: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPathPoster),
                width: 50, fit: BoxFit.contain,
        ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
      ),
    );
  }
}