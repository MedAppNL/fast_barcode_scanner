import 'dart:math';

import '../../fast_barcode_scanner_platform_interface.dart';
import 'barcode_type.dart';
import 'barcode_value_type.dart';

/// Describes a Barcode with type and value.
/// [Barcode] is value-equatable.
class Barcode {
  /// Creates a [Barcode] from a Flutter Message Protocol
  Barcode(List<dynamic> data)
      : type = BarcodeType.values.firstWhere((e) => e.name == data[0]),
        value = data[1],
        valueType = data[2] != null ? BarcodeValueType.values[data[2]] : null,
        boundingBox = null;
  // boundingBox = parsePoints(data.sublist(3).cast<List<double>>());

  /// The type of the barcode.
  ///
  ///
  final BarcodeType type;

  /// The actual value of the barcode.
  ///
  ///
  final String value;

  /// The type of content of the barcode.
  ///
  /// On available on Android.
  /// Returns [null] on iOS.
  final BarcodeValueType? valueType;

  /// The corners of the visible barcode. This can be used for custom drawing.
  final Rectangle? boundingBox;

  // static Rectangle? parsePoints(List<Object?> pointList) {
  //   final topLeft = Point(pointList[0][0], pointList[0][1]);
  //   final bottomRight = Point(pointList[3][0], pointList[3][1]);
  //   return Rectangle.fromPoints(topLeft, bottomRight);
  // }

  @override
  bool operator ==(Object other) =>
      other is Barcode &&
      other.type == type &&
      other.value == value &&
      other.valueType == valueType &&
      other.boundingBox == boundingBox;

  @override
  int get hashCode =>
      super.hashCode ^ type.hashCode ^ value.hashCode ^ valueType.hashCode ^ boundingBox.hashCode;

  @override
  String toString() {
    return '''
    Barcode {
      type: $type,
      value: $value,
      valueType: $valueType,
      rect: $boundingBox
    }
    ''';
  }
}
