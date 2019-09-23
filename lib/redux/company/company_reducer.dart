import 'package:built_collection/built_collection.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/company/company_state.dart';
import 'package:invoiceninja_flutter/redux/product/product_reducer.dart';
import 'package:invoiceninja_flutter/redux/client/client_reducer.dart';
import 'package:invoiceninja_flutter/redux/invoice/invoice_reducer.dart';
import 'package:invoiceninja_flutter/redux/dashboard/dashboard_reducer.dart';
import 'package:invoiceninja_flutter/redux/company/company_actions.dart';
import 'package:invoiceninja_flutter/redux/document/document_reducer.dart';
import 'package:invoiceninja_flutter/redux/expense/expense_reducer.dart';
import 'package:invoiceninja_flutter/redux/vendor/vendor_reducer.dart';
import 'package:invoiceninja_flutter/redux/task/task_reducer.dart';
import 'package:invoiceninja_flutter/redux/project/project_reducer.dart';
import 'package:invoiceninja_flutter/redux/payment/payment_reducer.dart';
import 'package:invoiceninja_flutter/redux/quote/quote_reducer.dart';
import 'package:sentry/sentry.dart';
// STARTER: import - do not remove comment

UserCompanyState companyReducer(UserCompanyState state, dynamic action) {
  if (action is RefreshData && action.loadCompanies) {
    return UserCompanyState();
  }

  return state.rebuild((b) => b
    ..userCompany.replace(companyEntityReducer(state.userCompany, action))
    ..documentState.replace(documentsReducer(state.documentState, action))
    ..clientState.replace(clientsReducer(state.clientState, action))
    ..dashboardState.replace(dashboardReducer(state.dashboardState, action))
    ..productState.replace(productsReducer(state.productState, action))
    ..invoiceState.replace(invoicesReducer(state.invoiceState, action))
    ..expenseState.replace(expensesReducer(state.expenseState, action))
    ..vendorState.replace(vendorsReducer(state.vendorState, action))
    ..taskState.replace(tasksReducer(state.taskState, action))
    ..projectState.replace(projectsReducer(state.projectState, action))
    ..paymentState.replace(paymentsReducer(state.paymentState, action))
    ..quoteState.replace(quotesReducer(state.quoteState, action)));
  // STARTER: reducer - do not remove comment
}

Reducer<UserCompanyEntity> companyEntityReducer = combineReducers([
  TypedReducer<UserCompanyEntity, LoadCompanySuccess>(
      loadCompanySuccessReducer),
]);

UserCompanyEntity loadCompanySuccessReducer(
    UserCompanyEntity company, LoadCompanySuccess action) {
  var userCompany = action.company;

  userCompany = userCompany.rebuild((b) => b.company
    ..taskStatuses.replace(<TaskStatusEntity>[])
    ..taskStatusMap.replace(BuiltMap<String, TaskStatusEntity>())
    ..expenseCategories.replace(<ExpenseCategoryEntity>[])
    ..expenseCategoryMap.replace(BuiltMap<String, ExpenseCategoryEntity>())
    ..users.replace(<UserEntity>[])
    ..userMap.replace(BuiltMap<String, UserEntity>()));

  print(
      '${userCompany.company.companyKey} map: ${userCompany.company.expenseCategoryMap}');

  return userCompany;

  if (userCompany.company.taskStatuses != null) {
    userCompany = userCompany
      ..company.rebuild((b) => b
        ..taskStatusMap.addAll(Map.fromIterable(
          userCompany.company.taskStatuses,
          key: (dynamic item) => item.id,
          value: (dynamic item) => item,
        )));
  }

  if (userCompany.company.expenseCategories != null) {
    userCompany = userCompany
      ..company.rebuild((b) => b
        ..expenseCategoryMap.addAll(Map.fromIterable(
          userCompany.company.expenseCategories,
          key: (dynamic item) => item.id,
          value: (dynamic item) => item,
        )));
  }

  return userCompany
    ..company.rebuild((b) => b
      ..userMap.addAll(Map.fromIterable(
        action.company.company.users,
        key: (dynamic item) => item.id,
        value: (dynamic item) => item,
      )));
}
