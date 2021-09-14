import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_event.dart';
import 'package:vendor/ui/inventory/suggested_product/bloc/suggested_product_state.dart';

class SuggestedProductBloc extends Bloc<SuggestedProductEvent, SuggestedProductState> {
  SuggestedProductBloc() : super(SuggestedProductInitialState());

  @override
  Stream<SuggestedProductState> mapEventToState(SuggestedProductEvent event) async* {
    if (event is GetProductEvent) {
      yield GetProductState();
    }
    if (event is ChangeTabEvent) {
      yield ChangeTabState(index: event.index);
    }
  }
}
