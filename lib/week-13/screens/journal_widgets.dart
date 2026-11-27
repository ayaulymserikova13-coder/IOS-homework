import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/diary_entry.dart';

const journalGreen = Color(0xFF315E48);
const journalInk = Color(0xFF203D32);
const journalSoft = Color(0xFFE5EDE5);
const journalBackground = Color(0xFFF5F5F0);
const journalMuted = Color(0xFF718078);
const journalBorder = Color(0xFFE0E5DD);

String formatJournalDate(DateTime value) {
  final date = value.toLocal();

  String two(int n) => n.toString().padLeft(2, '0');

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${two(date.day)} '
      '${months[date.month - 1]} '
      '${date.year} · '
      '${two(date.hour)}:${two(date.minute)}';
}

class JournalCard extends StatelessWidget {
  const JournalCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: journalBorder,
        ),

        boxShadow: [
          BoxShadow(
            color: journalInk.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.number,
    required this.title,
    required this.icon,
  });

  final String number;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: journalSoft,
            borderRadius: BorderRadius.circular(13),
          ),

          child: Icon(
            icon,
            color: journalGreen,
            size: 21,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                number,
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w500,
                  color: journalMuted,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: journalInk,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    super.key,
    this.path,
    this.compact = false,
  });

  final String? path;
  final bool compact;

  Widget _placeholder() {
    return ColoredBox(
      color: journalSoft,

      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(
                path == null
                    ? Icons.photo_camera_outlined
                    : Icons.broken_image_outlined,

                size: compact ? 25 : 42,
                color: journalGreen,
              ),

              if (!compact) ...[
                const SizedBox(height: 12),

                Text(
                  path == null
                      ? 'A moment worth keeping'
                      : 'Photo unavailable',

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: journalInk,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  path == null
                      ? 'Take a photo or choose from your gallery.'
                      : 'The image could not be loaded.',

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: journalMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final value = path;

    if (value == null || value.isEmpty) {
      return _placeholder();
    }

    if (kIsWeb) {
      try {
        if (value.startsWith('data:image/')) {
          final bytes = base64Decode(
            value.substring(value.indexOf(',') + 1),
          );

          return Image.memory(
            bytes,
            width: double.infinity,
            height: double.infinity,
            fit: compact ? BoxFit.cover : BoxFit.contain,

            errorBuilder: (context, error, stackTrace) {
              return _placeholder();
            },
          );
        }

        return Image.network(
          value,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,

          errorBuilder: (context, error, stackTrace) {
            return _placeholder();
          },
        );
      } catch (_) {
        return _placeholder();
      }
    }

    return Image.file(
      File(value),
      width: double.infinity,
      height: double.infinity,
      fit: compact ? BoxFit.cover : BoxFit.contain,

      errorBuilder: (context, error, stackTrace) {
        return _placeholder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        compact ? 12 : 17,
      ),

      child: ColoredBox(
        color: journalBackground,
        child: _buildImage(),
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.position,
    required this.loading,
    required this.onFetch,
  });

  final Position? position;
  final bool loading;
  final VoidCallback? onFetch;

  Widget _metric(
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),

      decoration: BoxDecoration(
        color: journalBackground,
        borderRadius: BorderRadius.circular(13),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 15,
                color: journalGreen,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: journalMuted,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,

            child: Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: journalInk,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = position;

    return JournalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          const SectionTitle(
            number: '02 / LOCATION',
            title: 'Remember the place',
            icon: Icons.location_on_outlined,
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _metric(
                  'Latitude',
                  p?.latitude.toStringAsFixed(6) ?? '—',
                  Icons.explore_outlined,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _metric(
                  'Longitude',
                  p?.longitude.toStringAsFixed(6) ?? '—',
                  Icons.public,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _metric(
                  'Accuracy',
                  p == null
                      ? '—'
                      : '± ${p.accuracy.toStringAsFixed(1)} m',
                  Icons.gps_fixed,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _metric(
                  'Altitude',
                  p == null ||
                          (kIsWeb &&
                              p.altitudeAccuracy == 0)
                      ? '—'
                      : '${p.altitude.toStringAsFixed(1)} m',
                  Icons.terrain,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (p != null)
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: journalGreen,
                  size: 16,
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Text(
                    'Location acquired · '
                    '${formatJournalDate(p.timestamp)}',

                    style: const TextStyle(
                      color: journalGreen,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            )
          else
            const Text(
              'Attach your current location to this memory.',

              style: TextStyle(
                fontSize: 12,
                color: journalMuted,
              ),
            ),

          const SizedBox(height: 15),

          OutlinedButton.icon(
            onPressed: loading ? null : onFetch,

            icon: loading
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.my_location,
                    size: 19,
                  ),

            label: Text(
              loading
                  ? 'Finding your location...'
                  : 'Fetch GPS Location',
            ),
          ),
        ],
      ),
    );
  }
}

class DiaryEntryCard extends StatelessWidget {
  const DiaryEntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  final DiaryEntry entry;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return JournalCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 86,
            height: 108,

            child: PhotoPreview(
              path: entry.photoPath,
              compact: true,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  entry.caption,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: journalInk,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  'Lat: ${entry.latitude.toStringAsFixed(6)}\n'
                  'Lng: ${entry.longitude.toStringAsFixed(6)}',

                  style: const TextStyle(
                    color: journalGreen,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Accuracy: ± '
                  '${entry.accuracy.toStringAsFixed(1)} m',

                  style: const TextStyle(
                    color: journalMuted,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  formatJournalDate(entry.timestamp),

                  style: const TextStyle(
                    color: journalMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Delete memory',
            onPressed: onDelete,

            icon: const Icon(
              Icons.delete_outline,
              color: journalMuted,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}