// checker_item_view_model.dart
import 'package:cyfeer_apartment_handover/models/handover/handover_schedule.dart';
import 'package:cyfeer_apartment_handover/view_models/models/checker_item_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// View model for managing a single checker item in the handover process.
///
/// Handles the state and operations related to a specific item in the checklist,
/// including verification status, notes, and image management.
class CheckerItemViewModel extends StateNotifier<CheckerItemState> {
  /// Image picker utility for camera and gallery operations
  final ImagePicker _picker = ImagePicker();
  
  /// Callback function that gets called when the item changes
  final Function(CheckerItem)? onChanged;

  /// Getter for the current checker item
  CheckerItem get item => state.item;
  
  /// Creates a new [CheckerItemViewModel] instance.
  ///
  /// [state] The initial state of the checker item.
  /// [onChanged] Optional callback that gets invoked when the item changes.
  CheckerItemViewModel(CheckerItemState state, {this.onChanged}) : super(state);

  /// Toggles the verification status of the checker item.
  ///
  /// Updates the state and notifies listeners through the [onChanged] callback.
  void toggleCheck() {
    state = state.copyWith(isVerified: !item.isVerified);
    onChanged?.call(item);
  }

  /// Updates the note associated with the checker item.
  ///
  /// [note] The new note text to be saved.
  /// Updates the state and notifies listeners through the [onChanged] callback.
  void updateNote(String note) {
    state = state.copyWith(note: note);
    onChanged?.call(item);
  }

  /// Displays a dialog for the user to add an image to the checker item.
  ///
  /// [context] The build context used for showing the dialog.
  /// Provides options to take a new photo or select from the gallery.
  /// Limits the number of images to 5.
  Future<void> addImage(BuildContext context) async {
    if (item.imageUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã đủ 5 ảnh, Vui lòng không thêm nữa')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Chọn nguồn ảnh'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Chọn từ thư viện'),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Chụp ảnh'),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  /// Private helper method to handle image picking functionality.
  ///
  /// [source] The source of the image (camera or gallery).
  /// Updates the state with the new image path and notifies listeners.
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final updatedImages = List<String>.from(item.imageUrls)
        ..add(pickedFile.path);
      state = state.copyWith(imageUrls: updatedImages);
      onChanged?.call(item);
    }
  }
}

/// Provider for creating and accessing a [CheckerItemViewModel].
///
/// Uses a family provider pattern to create a unique provider for each checker item.
/// [item] The checker item to be managed by this view model.
/// [onChanged] Optional callback that gets invoked when the item changes.
final checkerItemProvider = StateNotifierProvider.family<
    CheckerItemViewModel,
    CheckerItemState,
    ({CheckerItem item, Function(CheckerItem)? onChanged})>((ref, params) {
  return CheckerItemViewModel(CheckerItemState(item: params.item),
      onChanged: params.onChanged);
});
