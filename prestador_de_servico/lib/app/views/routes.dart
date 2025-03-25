import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/views/auth/create_user_view.dart';
import 'package:prestador_de_servico/app/views/auth/password_reset_view.dart';
import 'package:prestador_de_servico/app/views/auth/sign_in_view.dart';
import 'package:prestador_de_servico/app/views/navigation/navigation_view.dart';
import 'package:prestador_de_servico/app/views/payment/payment_view.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/pending_payment_schedules_view.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/pending_provider_schedules_view.dart';
import 'package:prestador_de_servico/app/views/scheduling/scheduling_view.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/edit_date_and_time_view.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/edit_scheduled_services_view.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/scheduling_details_view.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/scheduling_detail_viewmodel.dart';
import 'package:prestador_de_servico/app/views/service/service_category_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/service_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/service_view.dart';
import 'package:prestador_de_servico/app/views/service/show_all_services_view.dart';
import 'package:prestador_de_servico/app/views/service_day/service_day_view.dart';
import 'package:provider/provider.dart';

Route<dynamic>? getRoute(RouteSettings settings) {
  if (settings.name == '/signIn') {
    return _buildRoute(settings, const SignInView());
  }
  if (settings.name == '/createAccount') {
    return _buildRoute(settings, const CreateUserView());
  }
  if (settings.name == '/passwordReset') {
    return _buildRoute(settings, const PasswordResetView());
  }
  if (settings.name == '/navigation') {
    return _buildRoute(settings, NavigationView());
  }
  if (settings.name == '/service') {
    bool isSelectionView = false;
    if (settings.arguments != null) {
      final arguments = settings.arguments as Map;
      if (arguments.containsKey('isSelectionView')) {
        isSelectionView = arguments['isSelectionView'];
      }
    }
    return _buildRoute(settings, ServiceView(isSelectionView: isSelectionView));
  }
  if (settings.name == '/serviceCategoryEdit') {
    final arguments = (settings.arguments as Map);
    ServiceCategory? serviceCategory;
    if (arguments.containsKey('serviceCategory')) {
      serviceCategory = arguments['serviceCategory'] as ServiceCategory;
    }
    return _buildRoute(
      settings,
      ServiceCategoryEditView(
        serviceCategory: serviceCategory,
      ),
    );
  }
  if (settings.name == '/serviceEdit') {
    final arguments = (settings.arguments as Map);
    final ServiceCategory serviceCategory = arguments['serviceCategory'] as ServiceCategory;
    Service? service;
    if (arguments.containsKey('service')) {
      service = arguments['service'] as Service;
    }
    return _buildRoute(
      settings,
      ServiceEditView(
        serviceCategory: serviceCategory,
        service: service,
      ),
    );
  }
  if (settings.name == '/showAllServices') {
    final arguments = (settings.arguments as Map);
    return _buildRoute(
      settings,
      ShowAllServicesView(
        servicesByCategory: (arguments['servicesByCategory'] as ServicesByCategory),
        removeServiceOfOtherScreen:
            (arguments['removeServiceOfOtherScreen'] as Function({required Service service})),
        addServiceOfOtherScreen:
            (arguments['addServiceOfOtherScreen'] as Function({required Service service})),
        editServiceOfOtherScreen:
            (arguments['editServiceOfOtherScreen'] as Function({required Service service})),
      ),
    );
  }
  if (settings.name == '/payment') {
    return _buildRoute(settings, const PaymentView());
  }
  if (settings.name == '/serviceDay') {
    return _buildRoute(settings, const ServiceDayView());
  }
  if (settings.name == '/scheduling') {
    return _buildRoute(settings, const SchedulingView());
  }
  if (settings.name == '/pendingProviderSchedules') {
    return _buildRoute(settings, const PendingProviderSchedulesView());
  }
  if (settings.name == '/pendingPaymentSchedules') {
    return _buildRoute(settings, const PendingPaymentSchedulesView());
  }
  if (settings.name == '/schedulingDetails') {
    final arguments = (settings.arguments as Map);
    final serviceScheduling = (arguments['serviceScheduling']) as ServiceScheduling;
    return _buildRoute(
      settings,
      ChangeNotifierProvider<SchedulingDetailViewModel>(
        create: (context) => SchedulingDetailViewModel(
          schedulingService: context.read<SchedulingService>(),
          serviceScheduling: serviceScheduling,
        ),
        child: SchedulingDetailsView(
          serviceScheduling: serviceScheduling,
        ),
      ),
    );
  }
  if (settings.name == '/editDateAndTime') {
    final arguments = (settings.arguments as Map);
    return _buildRoute(
      settings,
      ChangeNotifierProvider.value(
        value: arguments['schedulingDetailViewModel'] as SchedulingDetailViewModel,
        child: const EditDateAndTimeView(),
      ),
    );
  }
  if (settings.name == '/editScheduledServices') {
    final arguments = (settings.arguments as Map);
    return _buildRoute(
      settings,
      ChangeNotifierProvider.value(
        value: arguments['schedulingDetailViewModel'] as SchedulingDetailViewModel,
        child: const EditScheduledServicesView(),
      ),
    );
  }

  return null;
}

MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    settings: settings,
    builder: (ctx) => builder,
  );
}
