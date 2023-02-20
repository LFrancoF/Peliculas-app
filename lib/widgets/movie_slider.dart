import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MovieSlider({super.key, required this.movies, this.title, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bool callOnNextPage = true; //bandera para controlar las llamadas a la funcion onNextPage, al iniciar el widget sera true por lo que llamaremos a la funcion al cumplir la condicion
    scrollController.addListener(() { 

      final double pixels = scrollController.position.pixels;
      final double maxScrollExtent = scrollController.position.maxScrollExtent;
      if (pixels >= maxScrollExtent-500){
        if (callOnNextPage) { //cuando cumpla la condicion y la bandera es true, se hara la peticion y el maxscroll aumentara, pero hasta que aumente pondremos la bandera en false para que no vuelva a entrar aqui y llamar de nuevo el onNextPage
          widget.onNextPage();
          callOnNextPage = false;
        }
      }else {
        callOnNextPage = true;   //una vez se actualice el maxscroll entonces entrara aqui y podremos volver a habilitar la bandera para hacer otra peticion la proxima vez que se llegue casi al final del maxscroll
      }
      

    });

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.movies.isEmpty){
      return Container(
        width: double.infinity, height: 265,
        child: const Center(child: CircularProgressIndicator())
      );
    }

    return Container(
      width: double.infinity,
      height: 265,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
      
          const SizedBox(height: 10,),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ( _ , index) {
                final String heroId = '${widget.title}-$index'; //primero colocamos este string antes de armar el heroId de la clase Movie, porque si tenemos 2 sliders el heroId se duplicaria, con esto nos aseguramos de que no se repita, usando el titulo del slider y la posicion de la pelicula en este slider
                return _MoviePoster( popularMovie : widget.movies[index], heroId: heroId,); //enviamos como parametro el heroId construido para que las posibilidades de que se repita con otro slider sean casi nulas
                }
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie popularMovie;
  final String heroId;

  const _MoviePoster({
    Key? key, required this.popularMovie, required this.heroId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    popularMovie.heroId = '$heroId-slider-${popularMovie.id}'; //concatenamos el heroId que llego como parametro con slider-Id de la pelicula, para diferenciar del swiper, y lo asignamos a su propiedad heroId de la clase Movie
    return Container(
      width: 130, height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: popularMovie),
            child: Hero(
              tag: popularMovie.heroId!, //enviamos el heroId que en este widget es diferente al cardswiper, en este caso el heroId esta con varias palabras de las propiedades del slider antes del slider-
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(popularMovie.fullPathPoster),
                  width: double.infinity, height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6, ),

          Expanded(  //envolvemos el text en un expanded porque el TextOverflow no da con caracteres extraños o letras chinas xd
            child: Text(
              popularMovie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}