import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venko_tasks_flutter_frontend/core/networkt/api_client.dart';
import 'package:venko_tasks_flutter_frontend/models/task_model.dart';


final taskListProvider = StateNotifierProvider<TaskListController, AsyncValue<List<Task>>>(
  (ref) => TaskListController(ref),
);

class TaskListController extends StateNotifier<AsyncValue<List<Task>>> {
  final Ref ref;
  
  TaskListController(this.ref) : super(const AsyncLoading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      state = const AsyncLoading();
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.getTasks();
      
      final tasks = (response as List)
          .map((json) => Task.fromJson(json))
          .toList();
      
      state = AsyncData(tasks);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> createTask(Task task) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.createTask(task.toJson());
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.updateTask(task.id, task.toJson());
      
      final currentTasks = state.value;
      if (currentTasks != null) {
        final index = currentTasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          final updatedTasks = List<Task>.from(currentTasks);
          updatedTasks[index] = task;
          state = AsyncData(updatedTasks);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.deleteTask(taskId);
      
      final currentTasks = state.value;
      if (currentTasks != null) {
        final updatedTasks = currentTasks.where((t) => t.id != taskId).toList();
        state = AsyncData(updatedTasks);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startTask(int taskId) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.startTask(taskId);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeTask(int taskId) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.completeTask(taskId);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelTask(int taskId) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.cancelTask(taskId);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reopenTask(int taskId) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.reopenTask(taskId);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Task>> getTasksByStatus(String status) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.getTasksByStatus(status);
      
      return (response as List)
          .map((json) => Task.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Task>> getOverdueTasks() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.getOverdueTasks();
      
      return (response as List)
          .map((json) => Task.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}