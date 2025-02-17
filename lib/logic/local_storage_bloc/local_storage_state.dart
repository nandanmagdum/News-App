part of 'local_storage_bloc.dart';

final class LocalStorageState {
  final List<CacheModel> cache;
  const LocalStorageState({required this.cache});

  // CopyWith method to help in state updates
  LocalStorageState copyWith({List<CacheModel>? cache}) {
    return LocalStorageState(cache: cache ?? this.cache);
  }

  // Convert state to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'cache': cache.map((item) => item.toJson()).toList(),
    };
  }

  // Create state from JSON
  factory LocalStorageState.fromJson(Map<String, dynamic> json) {
    return LocalStorageState(
      cache: (json['cache'] as List<dynamic>)
          .map((item) => CacheModel.fromJson(item))
          .toList(),
    );
  }
}
