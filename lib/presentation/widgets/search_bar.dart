import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/data/models/cache_model.dart';
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
    // List<CacheModel> searchTermList =
    //     context.read<LocalStorageBloc>().state.cache;
    // print("👀 ${searchTermList.length}");
    // searchTermList.removeWhere(
    //   (item) => item.searchTerm.isEmpty,
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: BlocBuilder<LocalStorageBloc, LocalStorageState>(
        builder: (context, state) {
          return SearchAnchor(
            viewHintText: "Search News...",
            viewOnSubmitted: (value) {
              // if (value.isEmpty) {
              //   context.read<CacheBloc>().add(
              //         InitialNewsFetchEvent(
              //           isFromCache: true,
              //           query: "",
              //         ),
              //       );
              //   widget.searchController.closeView(widget.searchController.text);
              //   SystemChannels.textInput.invokeListMethod('TextInput.hide');
              //   setState(() {});
              //   // FocusScope.of(context).requestFocus(FocusNode());
              //   return;
              // }
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
                    FocusScope.of(context).unfocus();
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    widget.searchController
                        .closeView(widget.searchController.text);
                  } else {
                    context.read<CacheBloc>().add(
                        InitialNewsFetchEvent(isFromCache: true, query: ""));
                    FocusScope.of(context).unfocus();
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    widget.searchController
                        .closeView(widget.searchController.text);
                  }
                },
                icon: Icon(
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
                    print("CHANGE ZALA ");
                    controller.openView();
                    if (widget.searchController.text.isEmpty) {
                      context.read<CacheBloc>().add(InitialNewsFetchEvent(
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
                        } else {
                          context.read<CacheBloc>().add(
                                InitialNewsFetchEvent(
                                    isFromCache: true,
                                    query: widget.searchController.text),
                              );
                        }
                      },
                      // onChanged: (value) {
                      //   if (debounce?.isActive ?? false) debounce?.cancel();
                      //   debounce = Timer(const Duration(milliseconds: 1000), () {
                      //     if (value.isNotEmpty) {
                      //       context.read<CacheBloc>().add(
                      //             InitialNewsFetchEvent(
                      //               query: value,
                      //             ),
                      //           );
                      //     } else {
                      //       context.read<CacheBloc>().add(
                      //             const InitialNewsFetchEvent(),
                      //           );
                      //     }
                      //   });
                      // },
                      icon: Icon(
                        Icons.search,
                      ),
                    ),
                  ]);
            },
            viewConstraints: BoxConstraints(maxHeight: 350),
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              final list = List.from(state.cache
                  .where((item) => item.searchTerm.isNotEmpty)
                  .toList());
              return List.generate(list.length, (int index) {
                return ListTile(
                  trailing: Icon(Icons.history),
                  title: Text(list[index].searchTerm),
                  onTap: () {
                    setState(() {
                      // FocusScope.of(context).requestFocus(FocusNode());
                      controller.closeView(state.cache[index].searchTerm);
                      context.read<CacheBloc>().add(
                            InitialNewsFetchEvent(
                              isFromCache: true,
                              query: list[index].searchTerm,
                            ),
                          );
                    });
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
