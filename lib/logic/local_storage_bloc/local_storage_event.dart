part of 'local_storage_bloc.dart';

sealed class LocalStorageEvent {
  const LocalStorageEvent();
}

final class AddCacheEvent extends LocalStorageEvent {
  final CacheModel cacheModel;
  const AddCacheEvent({required this.cacheModel});
}
