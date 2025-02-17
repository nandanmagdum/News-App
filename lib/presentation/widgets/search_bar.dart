import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/logic/cache_bloc/cache_bloc.dart';
import 'package:news_app/logic/local_storage_bloc/local_storage_bloc.dart';

class AppSearchBar extends StatefulWidget {
  final SearchController searchController;
  const AppSearchBar({super.key, required this.searchController});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  Timer? debounce;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: BlocBuilder<LocalStorageBloc, LocalStorageState>(
        builder: (context, state) {
          return SearchAnchor(
            viewHintText: "Search News...",
            viewOnSubmitted: (value) {
              if (widget.searchController.text.isNotEmpty) {
                context.read<CacheBloc>().add(
                      InitialNewsFetchEvent(
                        query: value,
                      ),
                    );
              }
              widget.searchController.closeView(widget.searchController.text);
              FocusScope.of(context).unfocus();
              SystemChannels.textInput.invokeListMethod('TextInput.hide');
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {});
            },
            searchController: widget.searchController,
            isFullScreen: false,
            viewTrailing: [
              IconButton(
                onPressed: () {
                  if (widget.searchController.text.isNotEmpty) {
                    context.read<CacheBloc>().add(
                          InitialNewsFetchEvent(
                            query: widget.searchController.text,
                          ),
                        );
                  }
                  FocusScope.of(context).unfocus();
                  SystemChannels.textInput.invokeMethod("TextInput.hide");
                  widget.searchController
                      .closeView(widget.searchController.text);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                icon: const Icon(
                  Icons.search,
                ),
              )
            ],
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                  hintText: "Search News...",
                  controller: widget.searchController,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus();
                    controller.openView();
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (_) {
                    controller.openView();
                    if (widget.searchController.text.isEmpty) {
                      context.read<CacheBloc>().add(const InitialNewsFetchEvent(
                            isFromCache: true,
                            query: null,
                          ));
                    }
                  },
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<CacheBloc>().add(
                            InitialNewsFetchEvent(
                              query: value,
                            ),
                          );
                    }
                  },
                  trailing: [
                    IconButton(
                      onPressed: () {
                        if (widget.searchController.text.isNotEmpty) {
                          context.read<CacheBloc>().add(
                                InitialNewsFetchEvent(
                                    query: widget.searchController.text),
                              );
                        }
                        
                      },
                      icon: const Icon(
                        Icons.search,
                      ),
                    ),
                  ]);
            },
            viewConstraints: const BoxConstraints(maxHeight: 350),
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              final list = List.from(state.cache
                  .where((item) => item.searchTerm.isNotEmpty)
                  .toList());
              return List.generate(list.length, (int index) {
                return ListTile(
                  trailing: const Icon(Icons.history),
                  title: Text(list[index].searchTerm),
                  onTap: () {
                    setState(() {
                      controller.closeView(list[index].searchTerm);
                      context.read<CacheBloc>().add(
                            InitialNewsFetchEvent(
                              isFromCache: true,
                              query: list[index].searchTerm,
                            ),
                          );
                    });
                    FocusScope.of(context).unfocus();
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                );
              });
            },
          );
        },
      ),
    );
  }
}
