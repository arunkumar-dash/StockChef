import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

/// Captures a photo (or picks one) and runs Google ML Kit on-device text
/// recognition — fully offline, no paid API. The bundled Latin recognizer
/// ships in the app, so no first-run model download is needed.
class TextRecognitionService {
  TextRecognitionService({ImagePicker? picker, TextRecognizer? recognizer})
    : _picker = picker ?? ImagePicker(),
      _recognizer = recognizer ?? TextRecognizer(script: TextRecognitionScript.latin);

  final ImagePicker _picker;
  final TextRecognizer _recognizer;

  /// Capture from the camera and recognize. Returns null if the user cancels.
  Future<String?> captureAndRecognize() =>
      _pickAndRecognize(ImageSource.camera);

  /// Pick from the gallery and recognize (useful on devices without a camera).
  Future<String?> pickAndRecognize() =>
      _pickAndRecognize(ImageSource.gallery);

  Future<String?> _pickAndRecognize(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 90);
    if (file == null) return null;
    final input = InputImage.fromFilePath(file.path);
    final result = await _recognizer.processImage(input);
    return result.text;
  }

  Future<void> dispose() => _recognizer.close();
}
