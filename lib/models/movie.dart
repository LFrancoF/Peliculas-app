import 'dart:convert';

class Movie {
    Movie({
        required this.adult,
        this.backdropPath,
        required this.genreIds,
        required this.id,
        required this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        this.posterPath,
        this.releaseDate,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    //Algunas propiedas son opcionales segun la API entonces eliminamos su required
    bool adult;
    String? backdropPath;
    List<int> genreIds;
    int id;
    String originalLanguage;  //cambiomos el tipo de dato de OriginalLanguage a un String por las modificaciones que hicimos
    String originalTitle;
    String overview;
    double popularity;
    String? posterPath;
    String? releaseDate;
    String title;
    bool video;
    double voteAverage;
    int voteCount;

    String? heroId;  //un Id para hacer el Hero Animation

    String get fullPathPoster{
      return posterPath != null ?
          'https://image.tmdb.org/t/p/w500$posterPath'
        : 'https://i.stack.imgur.com/GNhxO.png';
    }

    String get fullBackdropPath{
      return backdropPath != null ?
          'https://image.tmdb.org/t/p/w500$backdropPath'
        : 'https://i.stack.imgur.com/GNhxO.png';
    }

    factory Movie.fromRawJson(String str) => Movie.fromJson(json.decode(str));

    //String toRawJson() => json.encode(toJson());  esta funcion convierte la instancia de la clase en un json para devolverlo, por si se requiere usarlo, en esta caso no xd

    factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
       // originalLanguage: originalLanguageValues.map[json["original_language"]]!, de esta manera trata de enumerar este parametro para asignarlo, simplemente podemos acceder a la propiedad original language sin hacer todo esto
        originalLanguage: json["original_language"]!,
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        //releaseDate: DateTime.parse(json["release_date"]),   No es necesario convertir el valor en un tipo de dato Date, en esta caso no es necesario, entonces lo asignamos como string y cambiamos el tipo de variable en la propiedad releaseDate de la clase
        releaseDate: json["release_date"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
    );

    /*Map<String, dynamic> toJson() => {    funcion para devolver la instancia de la clase en un Map por si queremos usarlo como para enviarlo a otr API, en este caso no lo vamos a usar
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };*/
}


//Toda esta parte era la enumeracion para asignar a la propiedad originalLanguage, esto era por si teniamos mas idiomas,
//pero como lo asignamos directamente, todo el sgte codigo ya no es necesario

/*enum OriginalLanguage { EN, ES, RU }

final originalLanguageValues = EnumValues({
    "en": OriginalLanguage.EN,
    "es": OriginalLanguage.ES,
    "ru": OriginalLanguage.RU
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
*/