// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/manual-parameters/manual_parameters_screen.dart';
import 'package:mobile_preven_ia_app/screens/processing-file/processing_file_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_weight_update_modal.dart';
import 'package:mobile_preven_ia_app/firebase/storage/user/user_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:material_dialogs/material_dialogs.dart';

class UploadFileScreen extends ConsumerStatefulWidget {
  const UploadFileScreen({super.key});

  @override
  ConsumerState<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends ConsumerState<UploadFileScreen> {
  List<String> _missingParameters = [];

  void _proceedToProcessingScreen(String extractedText,
      {bool isUsingModel = false}) {
    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
      context,
      screen: const ProcessingFileScreen(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
      settings: RouteSettings(
        arguments: {
          'extractedText': extractedText,
          'isUsingModel': isUsingModel,
        },
      ),
    );
  }

  void _showWeightUpdateDialog(String extractedText,
      {bool isUsingModel = false}) {
    ref.read(userControllerProvider).whenData((userProfile) {
      if (userProfile != null) {
        showDialog(
          context: context,
          builder: (context) => PviWeightUpdateModal(
            currentWeight: userProfile.weight,
            showSkipButton: true,
            onWeightUpdated: () {
              _proceedToProcessingScreen(extractedText,
                  isUsingModel: isUsingModel);
            },
          ),
        );
      } else {
        _proceedToProcessingScreen(extractedText, isUsingModel: isUsingModel);
      }
    });
  }

  Future<void> _pickAndExtractPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final File pdfFile = File(result.files.single.path!);
      final List<int> bytes = pdfFile.readAsBytesSync();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final String extractedText = PdfTextExtractor(document).extractText();
      document.dispose();

      final String lowerText = extractedText.toLowerCase();

      final List<String> requiredParameters = [
        "ldl",
        "triglicéridos",
        "glucosa",
        "hba1c",
        "creatinina",
        "presión arterial sistólica",
        "presión arterial diastólica",
      ];

      final List<String> missing = requiredParameters
          .where((param) => !lowerText.contains(param))
          .toList();

      setState(() {
        _missingParameters = missing;
      });

      if (_missingParameters.isNotEmpty) {
        Dialogs.materialDialog(
          titleAlign: TextAlign.center,
          msgAlign: TextAlign.center,
          msgStyle: AppFonts.body1,
          titleStyle: AppFonts.headline4,
          context: context,
          title: "Parámetros faltantes",
          msg:
              "El análisis clínico no contiene los parámetros necesarios para un diagnóstico preciso, quieres continuar con un diagnóstico general?",
          actions: [
            Column(
              children: [
                PviTextButton(
                  textStyle: AppFonts.button1.copyWith(color: AppColors.gray5),
                  text: "Ingresar manualmente",
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      screen: const ManualParametersScreen(),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                      settings: RouteSettings(
                        arguments: {
                          'missingParameters': _missingParameters,
                          'extractedText': extractedText,
                        },
                      ),
                    );
                  },
                ),
                PviTextButton(
                  text: "Continuar",
                  onPressed: () {
                    _showWeightUpdateDialog(extractedText);
                  },
                )
              ],
            ),
          ],
        );
      } else {
        _showWeightUpdateDialog(extractedText, isUsingModel: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                PviText(
                  text: 'Subir análisis clínico',
                  style: AppFonts.headline1,
                ),
                const SizedBox(height: 16),
                PviText(
                  text:
                      'Sube tu análisis clínico (PDF) para recibir un diagnóstico personalizado',
                  style: AppFonts.body1,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PviButton(
                    onPressed: _pickAndExtractPdf,
                    child: PviText(
                      text: 'Subir archivo',
                      style: AppFonts.button1.copyWith(color: Colors.white),
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
}
