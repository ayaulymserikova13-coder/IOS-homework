import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/diary_entry.dart';
import '../services/device_service.dart';
import '../services/storage_service.dart';

import 'journal_widgets.dart';
import 'web_camera_screen.dart';

class PhotoDiaryScreen extends StatefulWidget {
  const PhotoDiaryScreen({super.key});

  @override
  State<PhotoDiaryScreen> createState() =>
      _PhotoDiaryScreenState();
}

class _PhotoDiaryScreenState
    extends State<PhotoDiaryScreen> {
  final _caption = TextEditingController();
  final _scroll = ScrollController();

  final _device = DeviceService();
  final _storage = StorageService();

  List<DiaryEntry> _entries = [];

  String? _photoPath;
  Position? _position;

  int _selectedTab = 0;

  bool _initializing = true;
  bool _loadFailed = false;
  bool _picking = false;
  bool _locating = false;
  bool _saving = false;

  bool get _busy =>
      _initializing ||
      _picking ||
      _locating ||
      _saving;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final entries = await _storage.loadEntries();

      if (!mounted) return;

      setState(() {
        _entries = entries;
        _loadFailed = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loadFailed = true);

      _message('Could not load saved memories.');
    }

    try {
      final photo = await _device.recoverLostPhoto();

      if (photo != null) {
        final path = await _device.preparePhoto(photo);

        if (!mounted) return;

        setState(() => _photoPath = path);
      }
    } catch (_) {
      _message('Could not recover the previous photo.');
    } finally {
      if (mounted) {
        setState(() => _initializing = false);
      }
    }
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _scrollToTop() {
    if (_scroll.hasClients) {
      _scroll.jumpTo(0);
    }
  }

  void _changeTab(int index) {
    if (_busy) return;

    FocusScope.of(context).unfocus();

    setState(() => _selectedTab = index);

    _scrollToTop();
  }

  Future<void> _showIssue(DeviceIssue issue) async {
    if (!mounted) return;

    if (kIsWeb ||
        issue.action == RecoveryAction.none) {
      _message(issue.message);
      return;
    }

    final open = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(
            issue.action == RecoveryAction.locationSettings
                ? 'Enable GPS'
                : 'Permission required',
          ),

          content: Text(issue.message),

          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );

    if (!mounted || open != true) return;

    try {
      final opened =
          issue.action == RecoveryAction.locationSettings
              ? await Geolocator.openLocationSettings()
              : await openAppSettings();

      if (!opened) {
        _message('Please open device settings manually.');
      }
    } catch (_) {
      _message('Could not open device settings.');
    }
  }

  Future<void> _pick(ImageSource source) async {
    if (_busy) return;

    setState(() => _picking = true);

    try {
      XFile? photo;

      if (kIsWeb && source == ImageSource.camera) {
        photo = await Navigator.of(context).push<XFile>(
          MaterialPageRoute(
            builder: (context) =>
                const WebCameraScreen(),
          ),
        );
      } else {
        photo = await _device.pickPhoto(source);
      }

      if (!mounted || photo == null) return;

      final path = await _device.preparePhoto(photo);

      if (!mounted) return;

      setState(() {
        _photoPath = path;
        _position = null;
      });
    } on DeviceIssue catch (issue) {
      await _showIssue(issue);
    } catch (_) {
      _message(
        'Could not load the photo. '
        'Check permissions and try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _picking = false);
      }
    }
  }

  Future<void> _fetchLocation() async {
    if (_busy) return;

    setState(() {
      _locating = true;
      _position = null;
    });

    try {
      final position = await _device.fetchPosition();

      if (!mounted) return;

      setState(() => _position = position);

      _message('Location acquired successfully.');
    } on DeviceIssue catch (issue) {
      await _showIssue(issue);
    } on TimeoutException {
      _message(
        'Location request timed out. Please try again.',
      );
    } catch (_) {
      _message(
        kIsWeb
            ? 'Check location permissions in Chrome.'
            : 'Could not get GPS. Check device settings.',
      );
    } finally {
      if (mounted) {
        setState(() => _locating = false);
      }
    }
  }

  Future<void> _save() async {
    if (_busy || _loadFailed) return;

    final photo = _photoPath;
    final position = _position;
    final caption = _caption.text.trim();

    if (photo == null) {
      _message('Please add a photo first.');
      return;
    }

    if (position == null) {
      _message('Please fetch your current location.');
      return;
    }

    if (caption.isEmpty) {
      _message('Write a caption for your memory.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() => _saving = true);

    try {
      final entry = await _storage.saveEntry(
        photoPath: photo,
        caption: caption,
        position: position,
        existing: _entries,
      );

      if (!mounted) return;

      setState(() {
        _entries = [entry, ..._entries];
        _photoPath = null;
        _position = null;
        _caption.clear();
        _selectedTab = 1;
      });

      _scrollToTop();

      _message('Your memory has been saved.');
    } on FormatException catch (error) {
      _message(error.message);
    } catch (_) {
      _message(
        'Could not save the memory. '
        'Your draft has been kept.',
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _delete(DiaryEntry entry) async {
    if (_busy) return;

    final confirmed = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Delete memory?'),

          content: const Text(
            'This photo and its details will be removed '
            'from your diary.',
          ),

          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true || _busy) {
      return;
    }

    setState(() => _saving = true);

    try {
      await _storage.deleteEntry(
        entry: entry,
        existing: _entries,
      );

      if (!mounted) return;

      setState(() {
        _entries.removeWhere(
          (item) => item.id == entry.id,
        );
      });

      _message('Memory deleted.');
    } catch (_) {
      _message('Could not delete this memory.');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  void dispose() {
    _caption.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,

          decoration: BoxDecoration(
            color: journalGreen,
            borderRadius: BorderRadius.circular(14),
          ),

          child: const Icon(
            Icons.auto_stories_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'memoir.',

                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: journalInk,
                ),
              ),

              Text(
                'NARXOZ PHOTO JOURNAL',

                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.2,
                  color: journalMuted,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),

          decoration: BoxDecoration(
            color: journalSoft,
            borderRadius: BorderRadius.circular(30),
          ),

          child: Text(
            '${_entries.length} memories',

            style: const TextStyle(
              color: journalGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tab(
    int index,
    String label,
    IconData icon,
  ) {
    final selected = _selectedTab == index;

    return Expanded(
      child: Material(
        color: selected
            ? journalGreen
            : Colors.transparent,

        borderRadius: BorderRadius.circular(12),

        child: InkWell(
          onTap: _busy
              ? null
              : () => _changeTab(index),

          borderRadius: BorderRadius.circular(12),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 6,
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  icon,
                  size: 18,

                  color: selected
                      ? Colors.white
                      : journalGreen,
                ),

                const SizedBox(width: 7),

                Flexible(
                  child: Text(
                    label,

                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,

                      color: selected
                          ? Colors.white
                          : journalGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navigation() {
    return Container(
      padding: const EdgeInsets.all(5),

      decoration: BoxDecoration(
        color: journalSoft,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          _tab(
            0,
            'New memory',
            Icons.add_a_photo_outlined,
          ),

          const SizedBox(width: 5),

          _tab(
            1,
            'My memories',
            Icons.collections_bookmark_outlined,
          ),
        ],
      ),
    );
  }

  Widget _intro() {
    return Column(
      children: [
        Text(
          _selectedTab == 0
              ? 'THE LITTLE THINGS MATTER'
              : 'YOUR PERSONAL COLLECTION',

          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w600,
            color: journalGreen,
          ),
        ),

        const SizedBox(height: 9),

        Text(
          _selectedTab == 0
              ? 'Collect little moments.'
              : 'My memories',

          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
            color: journalInk,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          _selectedTab == 0
              ? 'Every memory deserves a place.'
              : 'A collection of moments worth keeping.',

          textAlign: TextAlign.center,

          style: const TextStyle(
            color: journalMuted,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _photoCard() {
    return JournalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Row(
            children: [
              const Expanded(
                child: SectionTitle(
                  number: '01 / PHOTOGRAPH',
                  title: 'Capture a moment',
                  icon: Icons.photo_camera_outlined,
                ),
              ),

              if (_photoPath != null)
                IconButton(
                  tooltip: 'Remove photo',

                  onPressed: _busy
                      ? null
                      : () {
                          setState(() {
                            _photoPath = null;
                            _position = null;
                          });
                        },

                  icon: const Icon(
                    Icons.close,
                    color: journalMuted,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: _photoPath == null ? 180 : 260,

            child: PhotoPreview(
              path: _photoPath,
            ),
          ),

          const SizedBox(height: 14),

          LayoutBuilder(
            builder: (context, constraints) {
              final cameraButton = FilledButton.icon(
                onPressed: _busy
                    ? null
                    : () => _pick(ImageSource.camera),

                icon: const Icon(
                  Icons.photo_camera_outlined,
                  size: 18,
                ),

                label: const Text('Take Photo'),
              );

              final galleryButton = OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _pick(ImageSource.gallery),

                icon: const Icon(
                  Icons.photo_library_outlined,
                  size: 18,
                ),

                label: const Text('Pick Gallery'),
              );

              if (constraints.maxWidth < 300) {
                return Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                  children: [
                    cameraButton,
                    const SizedBox(height: 8),
                    galleryButton,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: cameraButton),
                  const SizedBox(width: 10),
                  Expanded(child: galleryButton),
                ],
              );
            },
          ),

          if (_picking) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ],

          if (_photoPath != null) ...[
            const SizedBox(height: 12),

            const Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: journalGreen,
                  size: 16,
                ),

                SizedBox(width: 7),

                Expanded(
                  child: Text(
                    'Photo ready · Optimized for storage',

                    style: TextStyle(
                      color: journalGreen,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _captionCard() {
    return JournalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          const SectionTitle(
            number: '03 / YOUR STORY',
            title: 'Tell your story',
            icon: Icons.edit_note,
          ),

          const SizedBox(height: 18),

          TextField(
            controller: _caption,
            enabled: !_saving,
            minLines: 2,
            maxLines: 4,
            maxLength: 500,

            textCapitalization:
                TextCapitalization.sentences,

            decoration: const InputDecoration(
              hintText: 'What made this moment special?',
              labelText: 'Caption',
              alignLabelWithHint: true,
            ),
          ),

          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: journalMuted,
                size: 16,
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  formatJournalDate(DateTime.now()),

                  style: const TextStyle(
                    color: journalMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: _busy || _loadFailed
                ? null
                : _save,

            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,

                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: journalGreen,
                    ),
                  )
                : const Icon(
                    Icons.bookmark_add_outlined,
                  ),

            label: Text(
              _saving ? 'Saving...' : 'Save Entry',
            ),
          ),
        ],
      ),
    );
  }

  Widget _newMemory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        _photoCard(),

        const SizedBox(height: 15),

        LocationCard(
          position: _position,
          loading: _locating,
          onFetch: _busy ? null : _fetchLocation,
        ),

        const SizedBox(height: 15),

        _captionCard(),
      ],
    );
  }

  Widget _memories() {
    if (_initializing) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_entries.isEmpty) {
      return JournalCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
          ),

          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,

                decoration: const BoxDecoration(
                  color: journalSoft,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.collections_bookmark_outlined,
                  size: 35,
                  color: journalGreen,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Your story starts here',

                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: journalInk,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Save your first photo, place and thought.',

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: journalMuted,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _changeTab(0),

                icon: const Icon(Icons.add),

                label: const Text('Create a memory'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: _entries.length,

      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },

      itemBuilder: (context, index) {
        final entry = _entries[index];

        return DiaryEntryCard(
          key: ValueKey(entry.id),
          entry: entry,

          onDelete: _busy
              ? null
              : () => _delete(entry),
        );
      },
    );
  }

  Widget _loadError() {
    return JournalCard(
      child: Column(
        children: [
          const Text(
            'Could not load your saved memories.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: _busy
                ? null
                : () {
                    setState(() {
                      _initializing = true;
                    });

                    _initialize();
                  },

            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 620,
            ),

            child: ListView(
              controller: _scroll,

              padding: const EdgeInsets.fromLTRB(
                16,
                22,
                16,
                28,
              ),

              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,

              children: [
                _header(),

                const SizedBox(height: 20),

                _navigation(),

                const SizedBox(height: 26),

                _intro(),

                const SizedBox(height: 22),

                if (_loadFailed) ...[
                  _loadError(),
                  const SizedBox(height: 15),
                ],

                if (_selectedTab == 0)
                  _newMemory()
                else if (!_loadFailed)
                  _memories(),

                const SizedBox(height: 25),

                const Divider(color: journalBorder),

                const SizedBox(height: 10),

                const Text(
                  'memoir. — Made for moments worth remembering.',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: journalMuted,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Narxoz University · Laboratory Work 13',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: journalMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}