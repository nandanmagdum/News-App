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

    if (!isPresent) {
      cache.insert(0, newModel);

    } else {
      cache.removeAt(index);
      cache.insert(0, newModel);
    }

    if (cache.length > 6) {
      cache = cache.sublist(0, 6);
    }

    emit(LocalStorageState(cache: cache));
  }

  @override
  LocalStorageState? fromJson(Map<String, dynamic> json) {
    try {
      return LocalStorageState.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Map<String, dynamic>? toJson(LocalStorageState state) {
    try {
      return state.toJson();
    } catch (e) {
      throw Exception(e);
    }
  }
}
