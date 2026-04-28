class Booking {
  final int id;
  final int userId;
  final int tourId;
  final DateTime bookingDate;
  final DateTime startDate;
  final List<Traveler> travelers;
  final double totalPrice;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final String? notes;
  final DateTime? cancelledAt;
  final int adults;
  final int children;

  Booking({
    required this.id,
    required this.userId,
    required this.tourId,
    required this.bookingDate,
    required this.startDate,
    required this.travelers,
    required this.totalPrice,
    required this.status,
    this.notes,
    this.cancelledAt,
    required this.adults,
    required this.children,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      tourId: json['tour_id'] as int,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      startDate: DateTime.parse(json['start_date'] as String),
      travelers: (json['travelers'] as List?)
          ?.map((t) => Traveler.fromJson(t as Map<String, dynamic>))
          .toList() ??
          [],
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      adults: json['adults'] as int? ?? 0,
      children: json['children'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'tour_id': tourId,
        'booking_date': bookingDate.toIso8601String(),
        'start_date': startDate.toIso8601String(),
        'travelers': travelers.map((t) => t.toJson()).toList(),
        'total_price': totalPrice,
        'status': status,
        'notes': notes,
        'cancelled_at': cancelledAt?.toIso8601String(),
        'adults': adults,
        'children': children,
      };

  get totalTravelers => travelers.length;
  get isConfirmed => status == 'confirmed';
  get isCancelled => status == 'cancelled';
  get isPending => status == 'pending';
}

class Traveler {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String passportNumber;
  final DateTime dateOfBirth;
  final String nationality;
  final String type; // 'adult', 'child'

  Traveler({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.passportNumber,
    required this.dateOfBirth,
    required this.nationality,
    required this.type,
  });

  factory Traveler.fromJson(Map<String, dynamic> json) {
    return Traveler(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      passportNumber: json['passport_number'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      nationality: json['nationality'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'passport_number': passportNumber,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'nationality': nationality,
        'type': type,
      };

  get fullName => '$firstName $lastName';
}

class BookingConfirmation {
  final int bookingId;
  final String confirmationCode;
  final String paymentStatus;
  final DateTime confirmationDate;
  final String? voucherUrl;

  BookingConfirmation({
    required this.bookingId,
    required this.confirmationCode,
    required this.paymentStatus,
    required this.confirmationDate,
    this.voucherUrl,
  });

  factory BookingConfirmation.fromJson(Map<String, dynamic> json) {
    return BookingConfirmation(
      bookingId: json['booking_id'] as int,
      confirmationCode: json['confirmation_code'] as String,
      paymentStatus: json['payment_status'] as String,
      confirmationDate: DateTime.parse(json['confirmation_date'] as String),
      voucherUrl: json['voucher_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'booking_id': bookingId,
        'confirmation_code': confirmationCode,
        'payment_status': paymentStatus,
        'confirmation_date': confirmationDate.toIso8601String(),
        'voucher_url': voucherUrl,
      };
}
