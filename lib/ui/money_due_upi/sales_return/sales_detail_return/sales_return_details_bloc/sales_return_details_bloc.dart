import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_detail_return/sales_return_details_bloc/sales_return_details_events.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_detail_return/sales_return_details_bloc/sales_return_details_states.dart';

class SalesReturnDetailsBloc
    extends Bloc<SalesReturnDetailsEvents, SalesReturnDetailsStates> {
  SalesReturnDetailsBloc() : super(SalesReturnDetailsInitialState());
  @override
  Stream<SalesReturnDetailsStates> mapEventToState(
      SalesReturnDetailsEvents event) async* {}
}
