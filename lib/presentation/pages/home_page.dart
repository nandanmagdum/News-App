import 'package:flutter/material.dart';
import 'package:news_app/data/models/cache_model.dart';
import 'package:news_app/data/models/news_model.dart';
import 'package:news_app/logic/cache_bloc/cache_bloc.dart';
import 'package:news_app/logic/local_storage_bloc/local_storage_bloc.dart';
import 'package:news_app/presentation/widgets/news_tile.dart';
import 'package:news_app/presentation/widgets/search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presentation/widgets/static_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SearchController searchController = SearchController();
  final ScrollController scrollController = ScrollController();
  int page = 1;
  void incrementPage() {
    page++;
    print("😂 $page");
    context.read<CacheBloc>().add(
          InitialNewsFetchEvent(
            query: searchController.text.isEmpty ? null : searchController.text,
            page: page,
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        final state = context.read<CacheBloc>().state;
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            state is CacheSuccessState &&
            ((state as CacheSuccessState).allResultsFetched != true)) {
          incrementPage();
        } else {
          print("API NOT CALLEDING (!*@#&DSFLKKSDHFLKJSDHFKJHSDLKFSDJKFLSDF)");
        }
      },
    );
    context.read<CacheBloc>().add(
          const InitialNewsFetchEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     List<CacheModel> cache =
        //         context.read<LocalStorageBloc>().state.cache;
        //     print("👀 ${cache.length}");
        //   },
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: AppSearchBar(
                  searchController: searchController,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BlocConsumer<CacheBloc, CacheState>(
                listener: (context, state) {
                  if (state is CacheErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  if (state is CacheLoadingState && page == 1) {
                    return StaticContainer(
                      isLoading: true,
                    );
                  } else if (state is CacheErrorState) {
                    String errorMessage = "${state.error}";
                    if (state.errorCode.contains("429")) {
                      errorMessage =
                          " 🚨 Sorry for inconvinience \nMaximum API Limit reached, please change the API KEY from api_constants.dart file 😔";
                    }
                    return StaticContainer(
                      isLoading: false,
                      message: errorMessage,
                    );
                  } else if (state is CacheSuccessState) {
                    final successState = (state as CacheSuccessState);
                    final List<NewsModel> newsList =
                        successState.cacheModel.news;
                    final totalResults = state.cacheModel.totalResults;
                    if (newsList.isEmpty) {
                      return StaticContainer(
                        message: "No news found matching with this search",
                      );
                    }

                    return Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: newsList.length + 1,
                        itemBuilder: (context, index) {
                          // return NewsTile(newsModel: news);
                          print(
                              "🙈 ${newsList.length} and total results = ${totalResults}");
                          return (index < newsList.length)
                              ? NewsTile(newsModel: newsList[index])
                              : Center(
                                  child: (state.allResultsFetched ||
                                          newsList.length == totalResults)
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(child: Divider()),
                                              Text(
                                                "  Reached the end. Check back later!  ",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Expanded(child: Divider()),
                                            ],
                                          ),
                                        )
                                      : CircularProgressIndicator(),
                                );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 15);
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text("No Data"));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
