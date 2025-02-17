part of 'cache_bloc.dart';

sealed class CacheEvent {
  const CacheEvent();
}

final class InitialNewsFetchEvent extends CacheEvent {
  final String? query;
  final int page;
  final bool? isFromCache;
  const InitialNewsFetchEvent({
    this.query,
    this.page = 1,
    this.isFromCache = false,
  });
}
