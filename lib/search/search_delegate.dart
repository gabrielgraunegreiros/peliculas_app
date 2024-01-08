import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/themes/app_theme.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  final List<Movie> moviesDefault;

  MovieSearchDelegate(
      {super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      required this.moviesDefault});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return AppTheme.lightTheme;
  }

  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    moviesProvider.getSuggestionsByQuery(query);

    if (query.isEmpty) {
      return _emptyContainer(context, moviesDefault);
    }

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return _emptyContainer(context, moviesDefault);
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) => _MovieItem(movie: movies[index]),
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  const _MovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'movieItem-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/images/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}

Widget _emptyContainer(BuildContext context, List<Movie> moviesDefault) {
  return ListView.builder(
      itemCount: moviesDefault.length,
      itemBuilder: (_, index) {
        final movie = moviesDefault[index];
        movie.heroId = 'default-${movie.id}-$index';
        return ListTile(
          leading: Hero(
            tag: movie.heroId!,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/no-image.jpg'),
              image: NetworkImage(movie.fullPosterImg),
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(movie.title),
          subtitle: Text(movie.originalTitle),
          onTap: () {
            Navigator.pushNamed(context, 'details', arguments: movie);
          },
        );
      });
}
