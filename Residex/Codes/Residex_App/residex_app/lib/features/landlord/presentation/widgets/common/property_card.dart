import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Property card for portfolio screen
class PropertyCard extends StatefulWidget {
  final String propertyName;
  final String unitNumber;
  final String? address;
  final PropertyStatus status;
  final String? tenantName;
  final RentStatus? rentStatus;
  final double? monthlyRent;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    required this.propertyName,
    required this.unitNumber,
    this.address,
    required this.status,
    this.tenantName,
    this.rentStatus,
    this.monthlyRent,
    this.onTap,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool _pressed = false;

  Color get _statusColor {
    switch (widget.status) {
      case PropertyStatus.occupied:
        return AppColors.success;
      case PropertyStatus.vacant:
        return AppColors.blue400;
      case PropertyStatus.maintenance:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rentColor = widget.rentStatus == RentStatus.paid
        ? AppColors.success
        : AppColors.warning;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.blue500.withValues(alpha: 0.08),
                      AppColors.blue600.withValues(alpha: 0.04),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _statusColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Status-coloured property icon
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: _statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _statusColor.withValues(alpha: 0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _statusColor.withValues(alpha: 0.2),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.apartment_rounded,
                            size: 20,
                            color: _statusColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Property info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.propertyName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${widget.unitNumber} · ${widget.address ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _statusColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            widget.status == PropertyStatus.occupied
                                ? 'OCCUPIED'
                                : widget.status == PropertyStatus.maintenance
                                    ? 'MAINT.'
                                    : 'VACANT',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: _statusColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Tenant section (occupied only)
                    if (widget.status == PropertyStatus.occupied &&
                        widget.tenantName != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.07),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Tenant avatar
                            Container(
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                color: AppColors.blue500.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      AppColors.blue500.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _getInitials(widget.tenantName!),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.blue400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.tenantName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            // Rent pill
                            if (widget.rentStatus != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: rentColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: rentColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  widget.rentStatus == RentStatus.paid
                                      ? 'PAID'
                                      : 'PENDING',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: rentColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}

/// Property occupancy status
enum PropertyStatus { occupied, vacant, maintenance }

/// Rent payment status
enum RentStatus { paid, pending, overdue }
