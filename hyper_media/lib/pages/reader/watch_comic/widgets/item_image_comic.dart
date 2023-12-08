// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: library_private_types_in_public_api

part of '../view/watch_comic_view.dart';

class ItemImageComic extends StatelessWidget {
  const ItemImageComic(
      {super.key,
      required this.url,
      required this.headers,
      required this.index,
      required this.onImage,
      required this.onSaveImage,
      required this.onCopyImage,
      required this.longPress});
  final String url;
  final int index;
  final Map<String, String>? headers;
  final ValueChanged<ImageComic> onImage;
  final VoidCallback onSaveImage;
  final VoidCallback onCopyImage;
  final bool longPress;

  @override
  Widget build(BuildContext context) {
    Widget image = const SizedBox();
    if (url.startsWith("http")) {
      image = CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.fitWidth,
          httpHeaders: headers,
          placeholder: (context, url) => Container(
                height: 200,
                alignment: Alignment.center,
                child: const SpinKitPulse(
                  color: Colors.grey,
                ),
              ),
          imageBuilder: (context, imageProvider) => SizeChild(
                onChangeSize: (size) {
                  onImage.call(
                      ImageComic(height: size.height, url: url, index: index));
                },
                child: Image(image: imageProvider),
              ));
    } else if (url != "" && !url.startsWith("http")) {
      image = ImageFileWidget(
        pathFile: url,
      );
    }
    return GestureDetector(
      onLongPress: () {
        if (!longPress) return;
        showDialog(
          context: context,
          builder: (context) {
            return _DialogImageComic(
              onCopy: onCopyImage,
              onSave: onSaveImage,
            );
          },
        );
      },
      child: image,
    );
  }
}

class _DialogImageComic extends StatelessWidget {
  const _DialogImageComic({
    Key? key,
    required this.onSave,
    required this.onCopy,
  }) : super(key: key);

  final VoidCallback onSave;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          child: ThemeBuildWidget(
              builder: (context, themeData, textTheme, colorScheme) {
            return Container(
              height: 100,
              width: 200,
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.horizontalPadding + 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: Constants.borderRadius,
                  color: colorScheme.background),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onSave.call();
                        Navigator.pop(context);
                      },
                      child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: Text(
                            "book.save_image_to_library".tr(),
                            style: textTheme.bodyMedium,
                          )),
                    ),
                    Divider(
                      color: colorScheme.surface,
                      indent: 10,
                      endIndent: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        onCopy.call();
                        Navigator.pop(context);
                      },
                      child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 4, top: 4),
                          child: Text(
                            "book.copy_image".tr(),
                            style: textTheme.bodyMedium,
                          )),
                    ),
                  ]),
            );
          }),
        )
      ],
    );
  }
}

typedef SizeChange = void Function(Size size);

class SizeChild<T> extends SingleChildRenderObjectWidget {
  const SizeChild({
    super.key,
    required this.onChangeSize,
    Widget? child,
  }) : super(child: child);

  final SizeChange onChangeSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onChangeSize);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.childSize = onChangeSize;
  }
}

class _RenderMenuItem extends RenderProxyBox {
  _RenderMenuItem(this.childSize, [RenderBox? child]) : super(child);

  SizeChange childSize;
  Size? currentSize;

  @override
  void performLayout() {
    super.performLayout();
    try {
      Size? newSize = child?.size;
      if (newSize != null && currentSize != newSize) {
        currentSize = newSize;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          childSize.call(size);
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
