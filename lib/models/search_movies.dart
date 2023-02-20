// To parse this JSON data, do
//
//     final searchMovies = searchMoviesFromJson(jsonString);

import 'dart:convert';

import 'package:peliculas_app/models/models.dart';

class SearchMovies {
    SearchMovies({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    factory SearchMovies.fromRawJson(String str) => SearchMovies.fromJson(json.decode(str));


    factory SearchMovies.fromJson(Map<String, dynamic> json) => SearchMovies(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );
}