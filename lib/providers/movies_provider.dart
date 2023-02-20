import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';

class MoviesProvider with ChangeNotifier{

  final String _apiKey = '3d94129f46dcfae2b0bf4f420415fcca';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  int _popularPage = 0;

  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> movieCredits = {};

  //Codigo para el Debouncer de Helper para el searchSuggestion-------------------

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController< List<Movie> > _suggestionStreamController = StreamController.broadcast();
  Stream< List<Movie> > get suggestionStream => _suggestionStreamController.stream;

  //-------------------------------------------------------------------------------

  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endPoint, {int page = 1, String query=''}) async{

    final url = Uri.https(_baseUrl, endPoint, {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : '$page',  //como String, no int, porque es para armar la URL para la peticion
      'query' : query
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }
  
  getOnDisplayMovies() async {

    final String response = await _getJsonData('3/movie/now_playing');
    
    //bien podemos manejar la informacion mapeandolo y usarelo directamente, como en las sgtes lineas
    //var jsonResponse = json.decode(response.body) as Map<String, dynamic>;    otra forma y usando la libreria convert sin poner as convert
    //final Map<String, dynamic>jsonResponse = convert.jsonDecode(response.body);  poniendo el tipo de variable al inicio

    //Pero usaremos modelos y crearemos una instancia de MovieNowPlaying de nuestro modelo para mapear el json, asi sera mas facil manejar el mapa como una clase
    final jsonResponse = MovieNowPlaying.fromRawJson(response);
    nowPlayingMovies = jsonResponse.results;
    notifyListeners();

  }

  getPopularMovies() async{

    _popularPage++;
    final String response = await _getJsonData('3/movie/popular', page: _popularPage);
    final jsonResponse = PopularMovies.fromRawJson(response);
    popularMovies = [...popularMovies, ...jsonResponse.results];
    notifyListeners();

  }

  Future<List<Cast>> getMovieCredits(int movieId) async{
    //primero revisamos si ya se hizo una peticion anterior con el mismo movieId para no volver a realizar otra peticion sino cargar los actores que ya estan en memoria o en nuestro mapa movieCredits
    if (movieCredits.containsKey(movieId)) return movieCredits[movieId]!;
    
    final String response = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsMovie.fromRawJson(response);

    movieCredits[movieId] = creditsResponse.cast; //llenamos el mapa con el id de la pelicula y la lista de actores
    return movieCredits[movieId]!;

  }

  Future< List<Movie> > searchMovies(String query) async{

    final String response = await _getJsonData('3/search/movie', query: query);
    final searchResponse = SearchMovies.fromRawJson(response);
    return searchResponse.results;

  }

  //metodo para el StreamController y Debouncer
  void getSuggestionByQuery(String query){

    debouncer.value = '';
    debouncer.onValue = (value) async{
      // print('Tenemos valor a buscar: $value');
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) { 
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());

  }


}