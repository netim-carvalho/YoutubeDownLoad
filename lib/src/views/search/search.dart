import 'package:curso_youtube/src/repositories/search/search_repository.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate<String> {
  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => "Pesquisar";
  final SearchRepository searchRepository;

  Search(this.searchRepository);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, query);
      },
      icon: const BackButton(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  void showResults(BuildContext context) {
    close(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder<List>(
          future: searchRepository.suggestionsVideos(query),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].toString()),
                    leading: const Icon(Icons.play_arrow),
                    onTap: () {
                      close(context, snapshot.data![index]);
                    },
                  );
                },
              );
            }
          });
    }
  }
}
