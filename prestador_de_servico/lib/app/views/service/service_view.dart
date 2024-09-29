import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_sliver_search_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';

class ServiceView extends StatelessWidget {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: SliverAppBarDelegate(
              maxHeight: 64,
              minHeight: 64,
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.only(top: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 60,
                        child: BackNavigation(
                            onTap: () => Navigator.pop(context))),
                    const Expanded(
                      child: CustomAppBarTitle(title: 'Serviços'),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
            ),
          ),
          CustomSliverSearchHeader(
            hintText: 'Pesquise por um serviço ou categoria',
            onChanged: (String value) {},
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  color: Colors.red,
                );
              },
              childCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}
