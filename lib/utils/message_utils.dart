import 'dart:async';

import 'package:event_bus/event_bus.dart';

class AppMessage {
  AppMessage._();

  static final EventBus _eventBus = EventBus();

  static StreamSubscription addListener<T>(void Function(T event)? onData) => _eventBus.on<T>().listen(onData);

  static void send<T>(T event) => _eventBus.fire(event);
}

class ActionEvent {
  final ActionType action;

  ActionEvent(this.action);
}

enum ActionType {
  playSleep,
}

// class DownloadTaskEvent{
//   final DownloadTask task;
//   DownloadTaskEvent(this.task);
// }
//
// typedef EventCallback<T> = void Function(T event);
