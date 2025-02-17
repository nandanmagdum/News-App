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


  FutureOr<void> initialNewsFetchEvent(
      InitialNewsFetchEvent event, Emitter<CacheState> emit) async {
    String? searchTerm = event.query;
    int page = event.page;


    if (event.isFromCache ?? false) {
      if (searchTerm == null && searchTerm!.isEmpty) {
        CacheModel localCacheModel = localStorageBloc.state.cache.firstWhere(
            (item) => item.searchTerm == "" || item.searchTerm.isEmpty);
        emit(CacheSuccessState(cacheModel: localCacheModel));
      }
      CacheModel localCacheModel = localStorageBloc.state.cache
          .firstWhere((item) => item.searchTerm == event.query);
      if (localCacheModel.news.length != 0) {
        emit(CacheSuccessState(cacheModel: localCacheModel));
        localStorageBloc.add(AddCacheEvent(cacheModel: localCacheModel));
        return;
      }
    }

    CacheModel updatedCacheModel =
        CacheModel(searchTerm: "", totalResults: 0, news: []);

    if (state is CacheSuccessState) {
      updatedCacheModel = (state as CacheSuccessState).cacheModel;
    }

    if (page == 1) emit(CacheLoadingState());

    try {
      CacheModel cacheModel = await NewsRepository.getHomePageNews(
          searchTerm: searchTerm, page: page);
      if (searchTerm != updatedCacheModel.searchTerm && searchTerm != null) {
        emit(CacheSuccessState(cacheModel: cacheModel));
        localStorageBloc.add(AddCacheEvent(cacheModel: cacheModel));
        return;
      }
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

      emit(CacheSuccessState(cacheModel: newCacheModel));

    } catch (e) {
      emit(CacheErrorState(error: e.toString(), errorCode: e.toString()));
    } finally {
      localStorageBloc.add(AddCacheEvent(cacheModel: updatedCacheModel));
    }
  }
}
