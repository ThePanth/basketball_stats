import 'dart:async';

class _EventBus {
  final StreamController<String> _createController =
      StreamController.broadcast();
  final StreamController<String> _changeController =
      StreamController.broadcast();
  final StreamController<String> _deleteController =
      StreamController.broadcast();

  void sendChangeEvent(String event) {
    _changeController.add(event); // Send event to all listeners
  }

  void sendCreateEvent(String event) {
    _createController.add(event); // Send event to all listeners
  }

  void sendDeleteEvent(String event) {
    _deleteController.add(event); // Send event to all listeners
  }

  Stream<String> get changeEvents =>
      _changeController.stream; // Consumers listen here
  Stream<String> get createEvents =>
      _createController.stream; // Consumers listen here
  Stream<String> get deleteEvents =>
      _deleteController.stream; // Consumers listen here
}

final eventBus = _EventBus();
