import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return_bloc/sales_return_events.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return_bloc/sales_return_states.dart';

class SalesReturnBloc extends Bloc<SalesReturnEvents, SalesReturnStates> {
  SalesReturnBloc() : super(SalesReturnInitialState());
  @override
  Stream<SalesReturnStates> mapEventToState(SalesReturnEvents event) async* {}
}
