import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;
  final bool overdue;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.overdue,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'PENDIENTE',
      priority: json['priority'] ?? 'MEDIA',
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userId: json['userId'] ?? 0,
      overdue: json['overdue'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? userId,
    bool? overdue,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      overdue: overdue ?? this.overdue,
    );
  }

  String get statusText {
    switch (status) {
      case 'PENDIENTE': return 'Pendiente';
      case 'EN_PROGRESO': return 'En Progreso';
      case 'COMPLETADA': return 'Completada';
      case 'CANCELADA': return 'Cancelada';
      default: return status;
    }
  }

  String get priorityText {
    switch (priority) {
      case 'BAJA': return 'Baja';
      case 'MEDIA': return 'Media';
      case 'ALTA': return 'Alta';
      case 'URGENTE': return 'Urgente';
      default: return priority;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'PENDIENTE': return Colors.orange;
      case 'EN_PROGRESO': return Colors.blue;
      case 'COMPLETADA': return Colors.green;
      case 'CANCELADA': return Colors.red;
      default: return Colors.grey;
    }
  }

  Color get priorityColor {
    switch (priority) {
      case 'BAJA': return Colors.green;
      case 'MEDIA': return Colors.blue;
      case 'ALTA': return Colors.orange;
      case 'URGENTE': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    priority,
    dueDate,
    createdAt,
    updatedAt,
    userId,
    overdue,
  ];
}