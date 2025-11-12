// lib/presentation/widgets/gps_status_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../services/location/location_service.dart';

/// GPS 상태 및 실외/실내 모드를 표시하는 위젯
/// 산책 중에 현재 위치 상태를 실시간으로 보여줌
class GPSStatusWidget extends ConsumerWidget {
  const GPSStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locationService = ref.watch(locationServiceProvider);

    // 실외 상태 스트림 감시
    final outdoorStatusAsync = ref.watch(outdoorStatusProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
                Icons.gps_fixed,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).gpsStatus,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildTrackingStatus(context, theme, locationService),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: outdoorStatusAsync.when(
                  data: (isOutdoor) => _buildOutdoorStatus(context, theme, isOutdoor),
                  loading: () => _buildLoadingStatus(context, theme),
                  error: (_, __) => _buildErrorStatus(context, theme),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildLocationInfo(context, theme, locationService),
        ],
      ),
    );
  }

  Widget _buildTrackingStatus(BuildContext context, ThemeData theme, LocationService locationService) {
    final isTracking = locationService.isTracking;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isTracking
          ? Colors.green.withOpacity(0.1)
          : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isTracking
            ? Colors.green.withOpacity(0.3)
            : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            isTracking ? Icons.gps_fixed : Icons.gps_off,
            color: isTracking ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(height: 4),
          Text(
            isTracking ? AppLocalizations.of(context).gpsTracking : AppLocalizations.of(context).gpsWaiting,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isTracking ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOutdoorStatus(BuildContext context, ThemeData theme, bool isOutdoor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isOutdoor
          ? Colors.blue.withOpacity(0.1)
          : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOutdoor
            ? Colors.blue.withOpacity(0.3)
            : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            isOutdoor ? Icons.nature : Icons.home,
            color: isOutdoor ? Colors.blue : Colors.orange,
            size: 16,
          ),
          const SizedBox(height: 4),
          Text(
            isOutdoor ? AppLocalizations.of(context).outdoorMode : AppLocalizations.of(context).indoorMode,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isOutdoor ? Colors.blue : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingStatus(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context).detecting,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorStatus(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 16,
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context).errorStatus,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(BuildContext context, ThemeData theme, LocationService locationService) {
    final samples = locationService.locationSamples;
    final validOutdoorSamples = locationService.validOutdoorSamples;
    final outdoorRatio = locationService.outdoorRatio;

    if (samples.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).searchingGpsSignal,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLocationStat(
                context,
                theme,
                AppLocalizations.of(context).locationSamples,
                AppLocalizations.of(context).countItems(samples.length),
                Icons.location_on,
              ),
              _buildLocationStat(
                context,
                theme,
                AppLocalizations.of(context).outdoorSignals,
                AppLocalizations.of(context).countItems(validOutdoorSamples),
                Icons.nature,
              ),
              _buildLocationStat(
                context,
                theme,
                AppLocalizations.of(context).outdoorRatio,
                '${(outdoorRatio * 100).toInt()}%',
                Icons.pie_chart,
              ),
            ],
          ),

          if (outdoorRatio > 0) ...[
            const SizedBox(height: 8),
            _buildBonusIndicator(context, theme, outdoorRatio),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationStat(
    BuildContext context,
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildBonusIndicator(BuildContext context, ThemeData theme, double outdoorRatio) {
    final isEligibleForBonus = outdoorRatio >= 0.5; // AppConstants.minOutdoorRatioForBonus

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isEligibleForBonus
          ? Colors.green.withOpacity(0.1)
          : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isEligibleForBonus
            ? Colors.green.withOpacity(0.3)
            : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEligibleForBonus ? Icons.star : Icons.star_border,
            size: 14,
            color: isEligibleForBonus ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isEligibleForBonus ? AppLocalizations.of(context).doubleBonusApplied : AppLocalizations.of(context).outdoorBonusRequirement,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isEligibleForBonus ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}