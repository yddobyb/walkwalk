// lib/presentation/widgets/location_permission_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../l10n/app_localizations.dart';
import '../../services/location/location_service.dart';

/// 위치 권한 상태 및 요청 위젯
/// 설정 화면이나 산책 시작 전에 표시됨
class LocationPermissionWidget extends ConsumerStatefulWidget {
  final VoidCallback? onPermissionGranted;
  final bool showCompactView;

  const LocationPermissionWidget({
    super.key,
    this.onPermissionGranted,
    this.showCompactView = false,
  });

  @override
  ConsumerState<LocationPermissionWidget> createState() => _LocationPermissionWidgetState();
}

class _LocationPermissionWidgetState extends ConsumerState<LocationPermissionWidget> {
  bool _isLoading = false;
  LocationPermission? _currentPermission;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final locationService = ref.read(locationServiceProvider);
    final permission = await locationService.checkLocationPermission();
    if (mounted) {
      setState(() {
        _currentPermission = permission;
      });
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final locationService = ref.read(locationServiceProvider);
      final permission = await locationService.requestLocationPermission();

      setState(() {
        _currentPermission = permission;
        _isLoading = false;
      });

      if ((permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always) &&
          widget.onPermissionGranted != null) {
        widget.onPermissionGranted!();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).locationPermissionError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openAppSettings() async {
    final locationService = ref.read(locationServiceProvider);
    await locationService.openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showCompactView) {
      return _buildCompactView(context);
    }
    return _buildFullView(context);
  }

  Widget _buildCompactView(BuildContext context) {
    final theme = Theme.of(context);

    if (_currentPermission == LocationPermission.whileInUse ||
        _currentPermission == LocationPermission.always) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: Colors.green,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).gpsOutdoorMode,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_off,
            color: Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context).indoorMode,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullView(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).gpsOutdoorMode,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildPermissionStatus(context, theme),

          const SizedBox(height: 16),

          _buildBenefitsSection(context, theme),

          const SizedBox(height: 20),

          _buildActionButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildPermissionStatus(BuildContext context, ThemeData theme) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    String statusDescription;

    final l10n = AppLocalizations.of(context);

    switch (_currentPermission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = l10n.locationPermissionGranted;
        statusDescription = l10n.locationPermissionGrantedDesc;
        break;
      case LocationPermission.denied:
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        statusText = l10n.locationPermissionRequired;
        statusDescription = l10n.locationPermissionRequiredDesc;
        break;
      case LocationPermission.deniedForever:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = l10n.locationPermissionDenied;
        statusDescription = l10n.locationPermissionDeniedDesc;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = l10n.checkingPermissionStatus;
        statusDescription = '';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (statusDescription.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              statusDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: statusColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBenefitsSection(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.outdoorModeBenefits,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        _buildBenefitItem(
          context,
          theme,
          icon: Icons.pets,
          title: l10n.doubleReward,
          description: l10n.doubleRewardDesc,
        ),

        const SizedBox(height: 8),

        _buildBenefitItem(
          context,
          theme,
          icon: Icons.timeline,
          title: l10n.accurateDistanceTracking,
          description: l10n.accurateDistanceTrackingDesc,
        ),

        const SizedBox(height: 8),

        _buildBenefitItem(
          context,
          theme,
          icon: Icons.emoji_events,
          title: l10n.specialBadges,
          description: l10n.specialBadgesDesc,
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context);

    if (_currentPermission == LocationPermission.whileInUse ||
        _currentPermission == LocationPermission.always) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _checkPermission,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.refresh),
              const SizedBox(width: 8),
              Text(l10n.refreshPermissionStatus),
            ],
          ),
        ),
      );
    }

    if (_currentPermission == LocationPermission.deniedForever) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _openAppSettings,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings),
              const SizedBox(width: 8),
              Text(l10n.allowPermissionInSettings),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _requestPermission,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(Icons.location_on),
            const SizedBox(width: 8),
            Text(_isLoading ? l10n.requestingPermission : l10n.activateGpsOutdoorMode),
          ],
        ),
      ),
    );
  }
}