import 'package:flutter/material.dart';
import 'package:venko_tasks_flutter_frontend/constants/app_constants.dart';
import 'package:venko_tasks_flutter_frontend/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onDelete,
    this.onEdit,
  });

  String _getStatusText(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return 'Pendiente';
      case AppConstants.statusInProgress:
        return 'En Progreso';
      case AppConstants.statusCompleted:
        return 'Completada';
      case AppConstants.statusCancelled:
        return 'Cancelada';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return Colors.orange;
      case AppConstants.statusInProgress:
        return Colors.blue;
      case AppConstants.statusCompleted:
        return Colors.green;
      case AppConstants.statusCancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return Icons.pending;
      case AppConstants.statusInProgress:
        return Icons.play_circle_fill;
      case AppConstants.statusCompleted:
        return Icons.check_circle;
      case AppConstants.statusCancelled:
        return Icons.cancel;
      default:
        return Icons.task;
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case AppConstants.priorityLow:
        return 'Baja';
      case AppConstants.priorityMedium:
        return 'Media';
      case AppConstants.priorityHigh:
        return 'Alta';
      case AppConstants.priorityUrgent:
        return 'Urgente';
      default:
        return priority;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case AppConstants.priorityLow:
        return Colors.green;
      case AppConstants.priorityMedium:
        return Colors.blue;
      case AppConstants.priorityHigh:
        return Colors.orange;
      case AppConstants.priorityUrgent:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case AppConstants.priorityLow:
        return Icons.arrow_downward;
      case AppConstants.priorityMedium:
        return Icons.remove;
      case AppConstants.priorityHigh:
        return Icons.arrow_upward;
      case AppConstants.priorityUrgent:
        return Icons.warning;
      default:
        return Icons.flag;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (taskDate == today) {
      return 'Hoy, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (taskDate == yesterday) {
      return 'Ayer, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: task.overdue
                ? Border.all(color: Colors.red, width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y acciones
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono de estado
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(task.status).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(task.status),
                      color: _getStatusColor(task.status),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Título y subtítulo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: task.status == AppConstants.statusCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.status == AppConstants.statusCompleted
                                ? Colors.grey
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (task.description != null && task.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              task.description!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Badge de vencida
                  if (task.overdue)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'VENCIDA',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Información de estado y prioridad
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Badge de estado
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(task.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(task.status),
                          size: 14,
                          color: _getStatusColor(task.status),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusText(task.status),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: _getStatusColor(task.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Badge de prioridad
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getPriorityIcon(task.priority),
                          size: 14,
                          color: _getPriorityColor(task.priority),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getPriorityText(task.priority),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: _getPriorityColor(task.priority),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Fecha de vencimiento
                  if (task.dueDate != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: task.overdue ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: task.overdue ? Colors.red : Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(task.dueDate!),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: task.overdue ? Colors.red : Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Footer con fecha de creación y acciones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Fecha de creación
                  Text(
                    'Creada: ${_formatDateTime(task.createdAt)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  // Acciones (opcionales)
                  if (onEdit != null || onDelete != null)
                    Row(
                      children: [
                        if (onEdit != null)
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: onEdit,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Editar tarea',
                          ),
                        if (onDelete != null)
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                            onPressed: onDelete,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Eliminar tarea',
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}