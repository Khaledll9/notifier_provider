import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/activity.dart';

part 'enum_activity_state.freezed.dart';

enum ActivityStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
class EnumActivityState with _$EnumActivityState {
  const factory EnumActivityState({
    required ActivityStatus status,
    required List<Activity> activities,
    required String error,
  }) = _EnumActivityState;

  factory EnumActivityState.initial() {
    return EnumActivityState(
      status: ActivityStatus.initial,
      activities: [Activity.empty()],
      error: '',
    );
  }
}
