import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:news_app/data/models/cache_model.dart';

part 'local_storage_event.dart';
part 'local_storage_state.dart';

class LocalStorageBloc extends Bloc<LocalStorageEvent, LocalStorageState>
    with HydratedMixin {
  LocalStorageBloc() : super(LocalStorageState(cache: <CacheModel>[])) {
    hydrate();
    on<AddCacheEvent>(addCacheEvent);
  }

  FutureOr<void> addCacheEvent(
      AddCacheEvent event, Emitter<LocalStorageState> emit) {
    CacheModel newModel = event.cacheModel;
    List<CacheModel> cache = List.from(state.cache);

    bool isPresent = false;
    int index = -1;
    for (int i = 0; i < cache.length; i++) {
      if (cache[i].searchTerm == newModel.searchTerm) {
        isPresent = true;
        index = i;
        break;
      }
    }

    if (cache.length > 6) {
      cache = cache.sublist(cache.length - 6);
      print(
          "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
      print(cache.length);
      print(
          "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
    }

    if (!isPresent) {
      cache.insert(0, newModel);
      // cache.add(newModel);
      print("added new data in cahce ${cache.length}");
    } else {
      cache.removeAt(index);
      cache.insert(0, newModel);
      // cache.add(newModel);
      print("updated the cache ${cache.length}");
    }

    emit(LocalStorageState(cache: cache));
    print("Function is called FINSISH ");
  }

  @override
  LocalStorageState? fromJson(Map<String, dynamic> json) {
    try {
      print("HYDRATED 2222222222");
      return LocalStorageState.fromJson(json);
    } catch (e) {
      print("ERROR OCCURED HYDRATED: $e");
      throw Exception(e);
    }
  }

  @override
  Map<String, dynamic>? toJson(LocalStorageState state) {
    try {
      print("HYDRATED 111111111");
      return state.toJson();
    } catch (e) {
      print("ERRROR ZALA : $e");
      throw Exception(e);
    }
  }
}
