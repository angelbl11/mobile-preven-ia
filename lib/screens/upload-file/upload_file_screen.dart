import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  Future<void> _pickAndExtractPdf() async {
    // Let user pick a single PDF file.
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final File pdfFile = File(result.files.single.path!);
      // Read the file as bytes.
      final List<int> bytes = pdfFile.readAsBytesSync();
      // Load the PDF document.
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      // Extract text from the document.
      final String extractedText = PdfTextExtractor(document).extractText();
      print("Extracted text: $extractedText");
      // Dispose the document.
      document.dispose();
    } else {
      print("No file selected or file path is null.");
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
