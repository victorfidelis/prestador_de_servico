import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/search_text_field.dart';

class CustomHeaderWithSearch extends StatefulWidget {
  final String title;
  final String searchTitle;
  final Function(String) onSearch;
  final FocusNode? focusNode;
  const CustomHeaderWithSearch({
    super.key,
    required this.title,
    required this.searchTitle,
    required this.onSearch,
    this.focusNode,
  });

  @override
  State<CustomHeaderWithSearch> createState() => _CustomHeaderWithSearchState();
}

class _CustomHeaderWithSearchState extends State<CustomHeaderWithSearch> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const  EdgeInsets.only(bottom: 20),
          height: 84,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(color: Theme.of(context).colorScheme.shadow, offset: const Offset(0, 4), blurRadius: 4)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 60,
                  child: BackNavigation(
                    onTap: () => Navigator.pop(context),
                  )),
              Expanded(
                child: CustomAppBarTitle(title: widget.title),
              ),
              const SizedBox(width: 60),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: SearchTextField(
            hintText: widget.searchTitle,
            onChanged: widget.onSearch,
            focusNode: widget.focusNode,
          ),
        ),
      ],
    );
  }
}
