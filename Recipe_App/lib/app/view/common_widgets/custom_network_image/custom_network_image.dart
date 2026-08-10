import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.child,
    this.colorFilter,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // If URL is empty, we handle it as an error immediately
    if (imageUrl.isEmpty) {
      log("Error: Image URL is empty", name: "CustomNetworkImage");
      return _buildErrorWidget();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      // The errorListener is the best place for logging background errors
      errorListener: (Object error) {
        log("Network Image Error: $error",
            name: "CustomNetworkImage", error: error);
      },
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            colorFilter: colorFilter,
          ),
        ),
        child: child,
      ),
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

  // Extracted Placeholder for cleaner code
  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withValues(alpha: 0.3),
      highlightColor: Colors.grey.withValues(alpha: 0.1),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor ?? Colors.white,
          borderRadius: borderRadius,
          shape: boxShape,
        ),
      ),
    );
  }

  // Extracted Error Widget
  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: border,
        color: backgroundColor ?? Colors.grey[200],
        borderRadius: borderRadius,
        shape: boxShape,
      ),
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
