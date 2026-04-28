import 'package:flutter/material.dart';

class Tour {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final List<String> imageGallery;
  final List<Itinerary> itinerary;
  final int maxCapacity;
  final int currentCapacity;
  final Guide guide;
  final String pickupLocation;
  final String category;
  final List<String> amenities;
  final bool isFavorite;
  final String tourType; // 'one-day', 'multi-day', 'overnight'
  final String difficulty; // 'easy', 'moderate', 'hard'

  Tour({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.imageGallery,
    required this.itinerary,
    required this.maxCapacity,
    required this.currentCapacity,
    required this.guide,
    required this.pickupLocation,
    required this.category,
    required this.amenities,
    required this.isFavorite,
    required this.tourType,
    required this.difficulty,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'] as int? ?? 0,
      imageUrl: json['image_url'] as String,
      imageGallery: List<String>.from(json['image_gallery'] as List? ?? []),
      itinerary: (json['itinerary'] as List?)
          ?.map((i) => Itinerary.fromJson(i as Map<String, dynamic>))
          .toList() ??
          [],
      maxCapacity: json['max_capacity'] as int,
      currentCapacity: json['current_capacity'] as int? ?? 0,
      guide: Guide.fromJson(json['guide'] as Map<String, dynamic>),
      pickupLocation: json['pickup_location'] as String,
      category: json['category'] as String? ?? 'Tour',
      amenities: List<String>.from(json['amenities'] as List? ?? []),
      isFavorite: json['is_favorite'] as bool? ?? false,
      tourType: json['tour_type'] as String? ?? 'one-day',
      difficulty: json['difficulty'] as String? ?? 'easy',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'price': price,
        'rating': rating,
        'reviews_count': reviewsCount,
        'image_url': imageUrl,
        'image_gallery': imageGallery,
        'itinerary': itinerary.map((i) => i.toJson()).toList(),
        'max_capacity': maxCapacity,
        'current_capacity': currentCapacity,
        'guide': guide.toJson(),
        'pickup_location': pickupLocation,
        'category': category,
        'amenities': amenities,
        'is_favorite': isFavorite,
        'tour_type': tourType,
        'difficulty': difficulty,
      };

  get availableSeats => maxCapacity - currentCapacity;
  get isFull => availableSeats <= 0;
  get duration => endDate.difference(startDate).inDays + 1;
}

class Itinerary {
  final int day;
  final String title;
  final String description;
  final String location;
  final List<String> activities;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  Itinerary({
    required this.day,
    required this.title,
    required this.description,
    required this.location,
    required this.activities,
    this.startTime,
    this.endTime,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      day: json['day'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      activities: List<String>.from(json['activities'] as List? ?? []),
      startTime: json['start_time'] != null
          ? _parseTime(json['start_time'] as String)
          : null,
      endTime: json['end_time'] != null
          ? _parseTime(json['end_time'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'title': title,
        'description': description,
        'location': location,
        'activities': activities,
        'start_time': startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
        'end_time': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      };

  static TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

class Guide {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String imageUrl;
  final String bio;
  final List<String> languages;
  final double rating;
  final int toursGuided;

  Guide({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.bio,
    required this.languages,
    required this.rating,
    required this.toursGuided,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      imageUrl: json['image_url'] as String,
      bio: json['bio'] as String? ?? '',
      languages: List<String>.from(json['languages'] as List? ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      toursGuided: json['tours_guided'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'image_url': imageUrl,
        'bio': bio,
        'languages': languages,
        'rating': rating,
        'tours_guided': toursGuided,
      };
}

class TourCategory {
  final int id;
  final String name;
  final String icon;
  final String description;

  TourCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  factory TourCategory.fromJson(Map<String, dynamic> json) {
    return TourCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'description': description,
      };
}
