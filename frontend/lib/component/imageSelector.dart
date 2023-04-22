import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector {

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  ImageSelector({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper
  })
      : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  Future<List<XFile>> pickImage({ImageSource source = ImageSource.gallery,
    int imageQuality = 100, bool multiple = false,}) async {
    if (multiple) {
      return await _imagePicker.pickMultiImage(imageQuality: imageQuality);
    }
    final file = await _imagePicker.pickImage(
        source: source,
        imageQuality: imageQuality,
    );
    if (file != null) {
      return [file];
    } else {
      return [];
    }
  }

  Future<CroppedFile?> cropImage({required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,}) async {
    return await _imageCropper.cropImage(
        sourcePath: file.path,
        cropStyle: cropStyle,
        compressQuality: 100,
        uiSettings: [
          IOSUiSettings(),
          AndroidUiSettings(),
        ]
    );
  }
}