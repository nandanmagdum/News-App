import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news_app/data/models/cache_model.dart';
import 'package:news_app/data/repositories/news_repository.dart';
import 'package:news_app/logic/local_storage_bloc/local_storage_bloc.dart';

part 'cache_event.dart';
part 'cache_state.dart';

class CacheBloc extends Bloc<CacheEvent, CacheState> {
  final LocalStorageBloc localStorageBloc;
  CacheBloc(this.localStorageBloc) : super(CacheLoadingState()) {
    on<InitialNewsFetchEvent>(initialNewsFetchEvent);
  }

  // FutureOr<void> initialNewsFetchEvent(
  //     InitialNewsFetchEvent event, Emitter<CacheState> emit) async {
  //   String? searchTerm = event.query;
  //   int page = event.page;
  //   CacheModel updatedCacheModel =
  //       CacheModel(searchTerm: "", totalResults: 0, news: []);
  //   if (state is CacheSuccessState) {
  //     updatedCacheModel = CacheModel(
  //       searchTerm: (state as CacheSuccessState).cacheModel.searchTerm,
  //       totalResults: (state as CacheSuccessState).cacheModel.totalResults,
  //       news: (state as CacheSuccessState).cacheModel.news,
  //     );
  //   }
  //   if (page == 1) emit(CacheLoadingState());
  //   try {
  //     CacheModel cacheModel = await NewsRepository.getHomePageNews(
  //         searchTerm: searchTerm, page: page);
  //     updatedCacheModel.news.addAll(cacheModel.news);
  //     print("⭐️");
  //     print(updatedCacheModel.news.length);
  //     emit(CacheSuccessState(
  //         cacheModel: CacheModel(
  //       searchTerm: updatedCacheModel.searchTerm,
  //       totalResults: updatedCacheModel.totalResults,
  //       news: updatedCacheModel.news,
  //     )));
  //     // localStorageBloc.add(AddCacheEvent(cacheModel: updatedCacheModel));
  //   } catch (e) {
  //     emit(CacheErrorState(error: e.toString()));
  //   }
  // }

  FutureOr<void> initialNewsFetchEvent(
      InitialNewsFetchEvent event, Emitter<CacheState> emit) async {
    String? searchTerm = event.query;
    int page = event.page;
    print("***********");
    print("Page Number : ${page}");
    print("CODE REACHED HERE");

    // chech if search term is alreay present in cache
    CacheModel hydratedCacheModel = localStorageBloc.state.cache.firstWhere(
        (item) => item.searchTerm == searchTerm,
        orElse: () =>
            CacheModel(searchTerm: "error100", totalResults: -1, news: []));
    if (hydratedCacheModel.searchTerm != "error100" ||
        hydratedCacheModel.totalResults != -1) {
      emit(CacheSuccessState(cacheModel: hydratedCacheModel));
      return;
    }

    // cache
    if (event.isFromCache ?? false) {
      if (searchTerm == null && searchTerm!.isEmpty) {
        print("Code reached here");
        CacheModel localCacheModel = localStorageBloc.state.cache.firstWhere(
            (item) => item.searchTerm == "" || item.searchTerm.isEmpty);
        emit(CacheSuccessState(cacheModel: localCacheModel));
      }
      // find object from local storage bloc
      CacheModel localCacheModel = localStorageBloc.state.cache
          .firstWhere((item) => item.searchTerm == event.query);
      if (localCacheModel.news.length != 0) {
        emit(CacheSuccessState(cacheModel: localCacheModel));
        localStorageBloc.add(AddCacheEvent(cacheModel: localCacheModel));
        return;
      }
    }
    // cache

    CacheModel updatedCacheModel =
        CacheModel(searchTerm: "", totalResults: 0, news: []);

    if (state is CacheSuccessState) {
      updatedCacheModel = (state as CacheSuccessState).cacheModel;
    }

    print("Updated News Length = ${updatedCacheModel.news.length}");
    if (page == 1) emit(CacheLoadingState());

    try {
      CacheModel cacheModel = await NewsRepository.getHomePageNews(
          searchTerm: searchTerm, page: page);
      if (searchTerm != updatedCacheModel.searchTerm && searchTerm != null) {
        emit(CacheSuccessState(cacheModel: cacheModel));
        localStorageBloc.add(AddCacheEvent(cacheModel: cacheModel));
        return;
      }
      print("API NEWS LENGTH = ${cacheModel.news.length}");
      if (cacheModel.news.isEmpty) {
        emit(CacheSuccessState(
          cacheModel: updatedCacheModel,
          allResultsFetched: true,
        ));
        emit(CacheSuccessState(cacheModel: updatedCacheModel));
        localStorageBloc.add(AddCacheEvent(cacheModel: updatedCacheModel));
        return;
      }
      CacheModel newCacheModel = CacheModel(
        searchTerm: updatedCacheModel.searchTerm,
        totalResults: cacheModel.totalResults,
        news: [...updatedCacheModel.news, ...cacheModel.news],
      );
      print("AFTER CONCANICATION : ${newCacheModel.news.length}");
      emit(CacheSuccessState(cacheModel: newCacheModel));
      print("Successful state emited");
      // localStorageBloc.add(AddCacheEvent(cacheModel: updatedCacheModel));
    } catch (e) {
      emit(CacheErrorState(error: e.toString(), errorCode: e.toString()));
    } finally {
      localStorageBloc.add(AddCacheEvent(cacheModel: updatedCacheModel));
    }
  }
}
