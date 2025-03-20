import 'package:mobile_preven_ia_app/firebase/storage/mappers/analysis_data.dart';

class AnalysisDetailsArguments {
  final AnalysisData analysis;

  const AnalysisDetailsArguments({
    required this.analysis,
  });

  Map<String, dynamic> toMap() {
    return {
      'analysis': analysis.toMap(),
    };
  }

  static AnalysisDetailsArguments? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    final analysisData = map['analysis'];
    if (analysisData is AnalysisData) {
      return AnalysisDetailsArguments(analysis: analysisData);
    }

    if (analysisData is Map<String, dynamic>) {
      return AnalysisDetailsArguments(
        analysis: AnalysisData.fromMap(analysisData),
      );
    }

    return null;
  }
}
