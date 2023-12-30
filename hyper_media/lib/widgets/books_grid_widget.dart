// ignore_for_file: unused_element

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/widgets/item_book.dart';
import 'package:js_runtime/js_runtime.dart';

import 'empty_list_data_widget.dart';
import 'loading_widget.dart';

typedef OnFetchListBook = Future<List<Book>> Function(int page);

class BooksGridWidget extends StatefulWidget {
  const BooksGridWidget(
      {super.key,
      this.onFetchListBook,
      this.emptyWidget,
      this.onChangeBooks,
      this.useFetch = true,
      this.useRefresh = true,
      this.initialBooks,
      this.listenBooks = false,
      this.onTap,
      this.onLongTap,
      this.layout = BookLayoutType.column});
  final OnFetchListBook? onFetchListBook;
  final Widget? emptyWidget;
  final ValueChanged<List<Book>>? onChangeBooks;
  final bool useFetch;
  final List<Book>? initialBooks;
  final bool useRefresh;
  final bool listenBooks;
  final ValueChanged<Book>? onTap;
  final ValueChanged<Book>? onLongTap;
  final BookLayoutType layout;

  @override
  State<BooksGridWidget> createState() => _BooksGridWidgetState();
}

class _BooksGridWidgetState extends State<BooksGridWidget> {
  int _page = 1;
  List<Book> _listBook = [];
  bool _isLoading = false;

  bool _isLoadMore = false;

  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if ((_scrollController.offset >
              _scrollController.position.maxScrollExtent - 200) &&
          !_isLoadMore) {
        _onLoadMore();
      }
      // if (_listBook.isNotEmpty &&
      //     context.height > _scrollController.position.maxScrollExtent &&
      //     !_isLoadMore) {
      //   _onLoadMore();
      // }
    });

    if (!widget.useFetch) {
      _listBook = widget.initialBooks ?? [];
    } else {
      _onLoading();
    }
    super.initState();
  }

  void _onLoading() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _page = 1;
      _listBook.clear();
      List<Book> books = await widget.onFetchListBook!.call(_page);

      if (books.isNotEmpty && books.length < 15) {
        _page++;
        final result = await widget.onFetchListBook!.call(_page);
        books.addAll(result);
      }
      _listBook.addAll(books);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on JsRuntimeException catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onLoadMore() async {
    setState(() {
      _isLoadMore = true;
    });
    try {
      _page++;
      final list = await widget.onFetchListBook!.call(_page);
      if (list.isNotEmpty) {
        setState(() {
          _listBook.addAll(list);
        });
        widget.onChangeBooks?.call(_listBook);
      }
    } catch (error) {
      //
    }
    setState(() {
      _isLoadMore = false;
    });
  }

  int getCrossAxisCount() {
    final width = context.width;
    if (Platform.isAndroid || Platform.isIOS) {
      return width ~/ 120;
    }
    return width ~/ 200;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.useFetch) {
      return const LoadingWidget();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.horizontalPadding,
      ),
      child: _refreshWidget(
        child: _listBook.isEmpty
            ? const EmptyListDataWidget(
                svgType: SvgType.defaultSvg,
              )
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 8),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getCrossAxisCount(),
                        crossAxisSpacing: 8,
                        childAspectRatio: 2 / 3.8,
                        mainAxisSpacing: 8),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final book = _listBook[index];
                        return ItemBook(
                          book: book,
                          layout: widget.layout,
                          onTap: () => widget.onTap?.call(book),
                          onLongTap: () => widget.onLongTap?.call(book),
                        );
                      },
                      childCount: _listBook.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _isLoadMore
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SpinKitThreeBounce(
                              color: context.colorScheme.primary,
                              size: 25.0,
                            ),
                          )
                        : const SizedBox(height: 8),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant BooksGridWidget oldWidget) {
    if (widget.initialBooks != oldWidget.initialBooks) {
      setState(() {
        _listBook = widget.initialBooks!;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _refreshWidget({required Widget child}) {
    if (widget.useRefresh) {
      return RefreshIndicator(
        onRefresh: () async {
          _onLoading();
        },
        child: child,
      );
    }
    return child;
  }
}
