part of 'cache_bloc.dart';

sealed class CacheState {
  const CacheState();
}

final class CacheLoadingState extends CacheState {}

final class CacheErrorState extends CacheState {
  final String error;
  final String errorCode;
  const CacheErrorState({required this.error, required this.errorCode});
}

final class CacheSuccessState extends CacheState {
  final CacheModel cacheModel;
  final bool allResultsFetched;
  const CacheSuccessState(
      {required this.cacheModel, this.allResultsFetched = false});
}
