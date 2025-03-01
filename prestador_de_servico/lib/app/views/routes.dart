import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/views/auth/create_user_view.dart';
import 'package:prestador_de_servico/app/views/auth/password_reset_view.dart';
import 'package:prestador_de_servico/app/views/auth/sign_in_view.dart';
import 'package:prestador_de_servico/app/views/navigation/navigation_view.dart';
import 'package:prestador_de_servico/app/views/payment/payment_view.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/pending_payment_schedules_view.dart';
import 'package:prestador_de_servico/app/views/pending_schedules/pending_provider_schedules_view.dart';
import 'package:prestador_de_servico/app/views/scheduling/scheduling_view.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/scheduling_details_view.dart';
import 'package:prestador_de_servico/app/views/service/service_category_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/service_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/service_view.dart';
import 'package:prestador_de_servico/app/views/service/show_all_services_view.dart';
import 'package:prestador_de_servico/app/views/service_day/service_day_view.dart';

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
    return _buildRoute(settings, const ServiceView());
  }
  if (settings.name == '/serviceCategoryEdit') {
    return _buildRoute(settings, const ServiceCategoryEditView());
  }
  if (settings.name == '/serviceEdit') {
    return _buildRoute(settings, const ServiceEditView());
  }
  if (settings.name == '/showAllServices') {
    final argmuments = (settings.arguments as Map);
    return _buildRoute(
      settings,
      ShowAllServicesView(
        removeServiceOfOtherScreen: (argmuments['removeServiceOfOtherScreen'] as Function({required Service service})),
        addServiceOfOtherScreen: (argmuments['addServiceOfOtherScreen'] as Function({required Service service})),
        editServiceOfOtherScreen: (argmuments['editServiceOfOtherScreen'] as Function({required Service service})),
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
    final argmuments = (settings.arguments as Map);
    return _buildRoute(
      settings,
      SchedulingDetailsView(
        serviceScheduling: (argmuments['serviceScheduling']) as ServiceScheduling,
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
