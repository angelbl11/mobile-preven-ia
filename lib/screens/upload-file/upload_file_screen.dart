// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_preven_ia_app/core/classes/message_status.dart';
import 'package:mobile_preven_ia_app/core/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_dialog.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/screens/manual-parameters/manual_parameters_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UploadFileScreen extends ConsumerStatefulWidget {
  const UploadFileScreen({super.key});

  @override
  ConsumerState<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends ConsumerState<UploadFileScreen> {
  void _proceedToManualParametersScreen(File file) {
    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
      context,
      screen: const ManualParametersScreen(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
      settings: RouteSettings(arguments: {
        'fileToUpload': file,
      }),
    );
  }

  void _showPdfPreviewDialog(File file) {
    showDialog(
      context: context,
      builder: (context) => PviDialog(
        width: MediaQuery.of(context).size.width * 0.9,
        showCloseButton: true,
        child: Column(
          children: [
            const PviText(
              text: 'Vista previa del análisis clínico',
              variant: TextVariant.headline2,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      surface: Colors.white,
                      background: Colors.white,
                    ),
                  ),
                  child: SfPdfViewer.file(
                    file,
                    canShowPaginationDialog: false,
                    canShowScrollHead: false,
                    enableDoubleTapZooming: true,
                    enableTextSelection: true,
                    pageLayoutMode: PdfPageLayoutMode.single,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PviFormButton(
                  buttonColor: AppColors.primary,
                  buttonVariant: ButtonVariant.text,
                  onSubmit: () => Navigator.pop(context),
                  buttonText: 'Cancelar',
                  isFullWidth: false,
                ),
                const SizedBox(width: 8),
                PviFormButton(
                  buttonVariant: ButtonVariant.primary,
                  onSubmit: () => handleUploadFile(file),
                  buttonText: 'Confirmar',
                  isFullWidth: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleUploadFile(File file) async {
    try {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close the dialog
      }
      await Future.delayed(
          const Duration(milliseconds: 100)); // Give time for dialog to close
      if (mounted) {
        _proceedToManualParametersScreen(file);
      }
    } catch (e) {
      if (mounted) {
        showToast(
          status: MessageStatus.error,
          context: context,
          message: 'Error al procesar el archivo: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final File pdfFile = File(result.files.single.path!);
      _showPdfPreviewDialog(pdfFile);
    } else {
      showToast(
        status: MessageStatus.error,
        context: context,
        message: 'No se pudo seleccionar el archivo',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lotties/upload-file.json',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 24),
              const Text(
                'Subir análisis clínico',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sube tu análisis clínico (PDF) para recibir un diagnóstico personalizado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              PviFormButton(
                onSubmit: _pickPdf,
                buttonText: 'Subir archivo',
              )
            ],
          ),
        ),
      ),
    );
  }
}
