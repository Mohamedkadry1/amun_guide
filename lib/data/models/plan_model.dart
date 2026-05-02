import 'place_model.dart';

class PlanModel {
  final int id;
  final String title;
  final List<PlanItemModel> items;
  final String? createdAt;

  PlanModel({
    required this.id,
    required this.title,
    this.items = const [],
    this.createdAt,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    var list = json['plan_items'] as List? ?? [];
    return PlanModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Travel Plan',
      items: list.map((i) => PlanItemModel.fromJson(i)).toList(),
      createdAt: json['created_at'],
    );
  }
}

class PlanItemModel {
  final int id;
  final int dayIndex;
  final PlaceModel? place;

  PlanItemModel({
    required this.id,
    required this.dayIndex,
    this.place,
  });

  factory PlanItemModel.fromJson(Map<String, dynamic> json) {
    return PlanItemModel(
      id: json['id'] ?? 0,
      dayIndex: json['day_index'] ?? 0,
      place: json['place'] != null ? PlaceModel.fromJson(json['place']) : null,
    );
  }
}
