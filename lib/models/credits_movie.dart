// To parse this JSON data, do
//
//     final creditsMovie = creditsMovieFromJson(jsonString);

import 'dart:convert';

class CreditsMovie {
    CreditsMovie({
        required this.id,
        required this.cast,
        required this.crew,
    });

    int id;
    List<Cast> cast;
    List<Cast> crew;

    factory CreditsMovie.fromRawJson(String str) => CreditsMovie.fromJson(json.decode(str));

    factory CreditsMovie.fromJson(Map<String, dynamic> json) => CreditsMovie(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
    );

}

class Cast {
    Cast({
        required this.adult,
        required this.gender,
        required this.id,
        required this.knownForDepartment,
        required this.name,
        required this.originalName,
        required this.popularity,
        this.profilePath,
        this.castId,
        this.character,
        required this.creditId,
        this.order,
        this.department,
        this.job,
    });

    bool adult;
    int gender;
    int id;
    Department knownForDepartment;
    String name;
    String originalName;
    double popularity;
    String? profilePath;
    int? castId;
    String? character;
    String creditId;
    int? order;
    Department? department;
    String? job;

    factory Cast.fromRawJson(String str) => Cast.fromJson(json.decode(str));


    factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: departmentValues.map[json["known_for_department"]]!,
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"],
        castId: json["cast_id"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        department: departmentValues.map[json["department"]],
        job: json["job"],
    );

    String get fullProfilePath{
      return profilePath != null ?
          'https://image.tmdb.org/t/p/w500$profilePath'
        : 'https://i.stack.imgur.com/GNhxO.png';
    }
}

enum Department { ACTING, CREW, SOUND, PRODUCTION, WRITING, ART, COSTUME_MAKE_UP, VISUAL_EFFECTS, DIRECTING, EDITING, CAMERA, LIGHTING }

final departmentValues = EnumValues({
    "Acting": Department.ACTING,
    "Art": Department.ART,
    "Camera": Department.CAMERA,
    "Costume & Make-Up": Department.COSTUME_MAKE_UP,
    "Crew": Department.CREW,
    "Directing": Department.DIRECTING,
    "Editing": Department.EDITING,
    "Lighting": Department.LIGHTING,
    "Production": Department.PRODUCTION,
    "Sound": Department.SOUND,
    "Visual Effects": Department.VISUAL_EFFECTS,
    "Writing": Department.WRITING
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
