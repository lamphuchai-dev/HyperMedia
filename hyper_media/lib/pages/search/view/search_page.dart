import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchCubit _searchCubit;
  late FocusNode _focusNode;
  @override
  void initState() {
    _focusNode = FocusNode();
    _searchCubit = context.read<SearchCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: TextField(
          focusNode: _focusNode,
          controller: _searchCubit.textEditingController,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            filled: false,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Nhập nội dung tìm kiếm",
          ),
          onEditingComplete: () {
            _focusNode.unfocus();
            _searchCubit.onSearch();
          },
        ),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {
                _searchCubit.textEditingController.clear();
                _focusNode.requestFocus();
              },
              icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return SafeArea(
            child: switch (state.status) {
              StatusType.loading => const LoadingWidget(),
              StatusType.loaded => BooksGridWidget(
                  initialBooks: state.books,
                  useFetch: false,
                  useRefresh: false,
                  onFetchListBook: (page) =>
                      _searchCubit.onLoadMoreSearch(page),
                  onTap: (book) {
                    Navigator.pushNamed(context, RoutesName.detail,
                        arguments: book.bookUrl);
                  },
                ),
              _ => const SizedBox()
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchCubit.textEditingController.dispose();
    super.dispose();
  }
}
