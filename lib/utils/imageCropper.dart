import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

List<Image> splitImage(
    {required Uint8List inputImage,
    required int horizontalPieceCount,
    required int verticalPieceCount}) {
  imglib.Image image = imglib.decodeImage(inputImage)!;

  final int xLength = (image.width / horizontalPieceCount).round();
  final int yLength = (image.height / verticalPieceCount).round();
  print("xLength");
  print(xLength);
  List<imglib.Image> pieceList = [];

  for (int y = 0; y < verticalPieceCount; y++) {
    for (int x = 0; x < horizontalPieceCount; x++) {
      pieceList.add(
        imglib.copyCrop(image, x * xLength, y * yLength, xLength, yLength),
      );
    }
  }
  //Convert image from image package to Image Widget to display
  List<Image> outputImageList = [];
  for (imglib.Image img in pieceList) {
    outputImageList.add(Image.memory(
      Uint8List.fromList(imglib.encodeJpg(img)),
      fit: BoxFit.cover,
      // width: xLength.toDouble(),
      // height: yLength.toDouble(),
    ));
  }

  return outputImageList;
}
