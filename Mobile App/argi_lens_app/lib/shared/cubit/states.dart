import 'dart:io';

import '../../models/SensorDataModel.dart';

abstract class AppStates{}

class AppInitialStates extends AppStates{}

class AppBottomNavState extends AppStates{}

class AppProfileOpenedState extends AppStates{}

class AppProfileClosedState extends AppStates{}

class TimerResetState extends AppStates{}

class TimerSavedState extends AppStates{}

class AppUpdateTimeState extends AppStates{}

class AppHealthUpdatedState extends AppStates{}

class BottomSheetShownState extends AppStates{}

class ButtonChangeState extends AppStates{}
class ButtonResetState extends AppStates{}
class AppChangeFilterState extends AppStates{}
class DateRangeUpdatedState extends AppStates{}
class DateRangeClearedState extends AppStates{}

class FarmLoading extends AppStates {}

class FarmDataUpdated extends AppStates {}

class UserDataLoadedState extends AppStates {}

class UserDataLoadingState extends AppStates {}

class UserDataErrorState extends AppStates {}

class UserDataSavedSuccessState extends AppStates {}

class TimerSentToServerState extends AppStates {}
class TimerSendErrorState extends AppStates {
  final String error;
  TimerSendErrorState(this.error);
}

class UserDataImageUpdatedState extends AppStates {
  final File? updatedImage;

  UserDataImageUpdatedState(this.updatedImage);
}

class FarmLoaded extends AppStates {
  final Map<String, dynamic> farmData;
  FarmLoaded(this.farmData);
}

class FarmError extends AppStates {
  final String message;
  FarmError(this.message);
}

class SensorLoading extends AppStates {}

class SensorLoaded extends AppStates {
  final SensorDataModel data;
  SensorLoaded(this.data);
}

class SensorError extends AppStates {
  final String message;
  SensorError(this.message);
}

class PotPreviewLoadedState extends AppStates {
  final int potId;

  PotPreviewLoadedState(this.potId);
}

class ReportsLoading extends AppStates {}

class ReportsLoaded extends AppStates {}

class ReportsInitial extends AppStates {}


class ReportsError extends AppStates {
  final String error;
  ReportsError(this.error);
}

class HistoryInitialState extends AppStates {}

class FilteredReportsState extends AppStates {}









