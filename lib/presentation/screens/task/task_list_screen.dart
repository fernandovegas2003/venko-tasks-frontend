import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venko_tasks_flutter_frontend/models/task_model.dart';
import 'package:venko_tasks_flutter_frontend/presentation/screens/task/task_form_screen.dart';
import 'package:venko_tasks_flutter_frontend/presentation/widgets/task_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          if (user.value != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
              },
              tooltip: 'Cerrar sesión',
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: tasks.when(
        data: (taskList) {
          if (taskList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No hay tareas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '¡Crea tu primera tarea!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () => ref.read(taskListProvider.notifier).loadTasks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                return TaskCard(
                  task: task,
                  onTap: () {
                    _showTaskDetails(context, task);
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar tareas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(taskListProvider.notifier).loadTasks(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showTaskDetails(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TaskDetailBottomSheet(task: task);
      },
    );
  }
}

class TaskDetailBottomSheet extends ConsumerWidget {
  final Task task;
  
  const TaskDetailBottomSheet({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detalles de la Tarea',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            task.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (task.description != null && task.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                task.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(task.statusText),
                backgroundColor: task.statusColor.withOpacity(0.1),
                labelStyle: TextStyle(color: task.statusColor),
              ),
              Chip(
                label: Text(task.priorityText),
                backgroundColor: task.priorityColor.withOpacity(0.1),
                labelStyle: TextStyle(color: task.priorityColor),
              ),
              if (task.dueDate != null)
                Chip(
                  label: Text(
                    'Vence: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                  ),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
              if (task.overdue)
                const Chip(
                  label: Text('Vencida'),
                  backgroundColor: Colors.red,
                  labelStyle: TextStyle(color: Colors.white),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (task.status == 'PENDIENTE')
                ElevatedButton(
                  onPressed: () {
                    ref.read(taskListProvider.notifier).startTask(task.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Iniciar'),
                ),
              if (task.status == 'EN_PROGRESO')
                ElevatedButton(
                  onPressed: () {
                    ref.read(taskListProvider.notifier).completeTask(task.id);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Completar'),
                ),
              if (task.status == 'COMPLETADA')
                ElevatedButton(
                  onPressed: () {
                    ref.read(taskListProvider.notifier).reopenTask(task.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Reabrir'),
                ),
              if (task.status != 'CANCELADA' && task.status != 'COMPLETADA')
                ElevatedButton(
                  onPressed: () {
                    ref.read(taskListProvider.notifier).cancelTask(task.id);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Cancelar'),
                ),
              IconButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar Tarea'),
                      content: const Text('¿Estás seguro de eliminar esta tarea?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirmed == true) {
                    await ref.read(taskListProvider.notifier).deleteTask(task.id);
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Creada: ${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}