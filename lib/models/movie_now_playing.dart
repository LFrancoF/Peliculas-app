// To parse this JSON data, do
//
//     final movieNowPlaying = movieNowPlayingFromJson(jsonString);

import 'dart:convert';

import 'models.dart';


class MovieNowPlaying {
    MovieNowPlaying({
        required this.dates,
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    Dates dates;
    int page;
    List<Movie> results; //peliculas
    int totalPages;
    int totalResults;

    factory MovieNowPlaying.fromRawJson(String str) => MovieNowPlaying.fromJson(json.decode(str));

    //String toRawJson() => json.encode(toJson()); esta funcion convierte la instancia de la clase en un json para devolverlo, por si se requiere usarlo, en esta caso no xd

    factory MovieNowPlaying.fromJson(Map<String, dynamic> json) => MovieNowPlaying(
        dates: Dates.fromJson(json["dates"]),
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    /* esta funcion sirve para convertir la instancia en un mapa para usarlo despues si queremos, en este caso no xd
    Map<String, dynamic> toJson() => {
        "dates": dates.toJson(),
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };*/
}

class Dates {
    Dates({
        required this.maximum,
        required this.minimum,
    });

    DateTime maximum;
    DateTime minimum;

    factory Dates.fromRawJson(String str) => Dates.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson()); //esta funcion convierte la instancia de la clase en un json para devolverlo, por si se requiere usarlo, en esta caso no xd

    factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
    );

    Map<String, dynamic> toJson() => {
        "maximum": "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum": "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
    };
}

