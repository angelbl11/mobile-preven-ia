import 'package:flutter/material.dart';

/// PviDialog
class PviDialog extends StatelessWidget {
  /// Creates the PviDialog.
  const PviDialog({
    required this.child,
    super.key,
    this.backgroundColor,
    this.elevation = 24.0,
    this.shape,
    this.clipBehavior = Clip.none,
    this.insetPadding = true,
    this.width,
    this.showCloseButton = false,
  });

  /// The content of the dialog.
  final Widget child;

  /// The background color of the dialog.
  final Color? backgroundColor;

  /// The elevation of the dialog.
  final double elevation;

  /// The shape of the dialog.
  final ShapeBorder? shape;

  /// The clip behavior of the dialog.
  final Clip clipBehavior;

  /// Indicates if the dialog has inset padding.
  final bool insetPadding;

  /// The width of the dialog.
  final double? width;

  /// Indicates if the dialog has a close button.
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor ?? Colors.white,
      alignment: Alignment.center,
      elevation: elevation,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
      clipBehavior: clipBehavior,
      insetPadding: insetPadding ? const EdgeInsets.all(17) : EdgeInsets.zero,
      content: SizedBox(
        width: width ?? 346,
        child: Stack(
          children: [
            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(17),
              child: child,
            ),
            if (showCloseButton)
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
