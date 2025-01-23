import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/views/auth/create_user_view.dart';
import 'package:prestador_de_servico/app/views/auth/password_reset_view.dart';
import 'package:prestador_de_servico/app/views/auth/sign_in_view.dart';
import 'package:prestador_de_servico/app/views/navigation/navigation_view.dart';
import 'package:prestador_de_servico/app/views/service/service_category_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/service_edit_view.dart';
import 'package:prestador_de_servico/app/views/service/service_view.dart';
import 'package:prestador_de_servico/app/views/service/show_all_services_view.dart';

Route<dynamic>? getRoute(RouteSettings settings) {
    if (settings.name == '/signIn') {
        // FooRoute constructor expects SomeObject
        return _buildRoute(settings, const SignInView());
    } 
    if (settings.name == '/createAccount') {
        // FooRoute constructor expects SomeObject
        return _buildRoute(settings, const CreateUserView());
    } 
    if (settings.name == '/passwordReset') {
        // FooRoute constructor expects SomeObject
        return _buildRoute(settings, const PasswordResetView());
    } 
    if (settings.name == '/navigation') {
        // FooRoute constructor expects SomeObject
        return _buildRoute(settings, NavigationView());
    } 
    if (settings.name == '/service') {
        // FooRoute constructor expects SomeObject
        return _buildRoute(settings, const ServiceView());
    } 
    if (settings.name == '/serviceCategoryEdit') {
        // FooRoute constructor expects SomeObject
        return _buildRoute(settings, const ServiceCategoryEditView());
    } 
    if (settings.name == '/serviceEdit') {
        // FooRoute constructor expects SomeObject
        return _buildRoute(settings, const ServiceEditView());
    } 
    if (settings.name == '/showAllServices') {
        // FooRoute constructor expects SomeObject
        return _buildRoute(settings, ShowAllServicesView(removeServiceOfOtherScreen: (settings.arguments as Function({required Service service}))));
    } 
    

    return null;
}

MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
        settings: settings,
        builder: (ctx) => builder,
    );
}