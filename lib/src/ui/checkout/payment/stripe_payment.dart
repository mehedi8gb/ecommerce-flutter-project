import 'package:app/src/blocs/checkout_form_bloc.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/checkout/order_result_model.dart';
import 'package:app/src/models/checkout/order_review_model.dart';
import 'package:app/src/models/checkout/stripeSource.dart';
import 'package:app/src/ui/checkout/order_summary.dart';
import 'package:app/src/ui/checkout/payment/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePayment extends StatefulWidget {
  final OrderReviewModel orderReviewModel;
  final CheckoutFormBloc checkoutFormBloc;
  const StripePayment(
      {Key? key,
      required this.orderReviewModel,
      required this.checkoutFormBloc})
      : super(key: key);
  @override
  _StripePaymentState createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {

  late String stripePublicKey;
  CardFieldInputDetails? _card;
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    stripePublicKey = widget.orderReviewModel.paymentMethods
        .singleWhere((method) => method.id == 'stripe')
        .stripePublicKey;
    Stripe.publishableKey = stripePublicKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        CardField(
          dangerouslyGetFullCardDetails: true,
          onCardChanged: (card) async {
            setState(() {
              _card = card;
            });
          },
        ),
        SizedBox(height: 16),
        LoadingButton(
            text: appStateModel.blocks.localeText.localeTextContinue,
            onPressed: _card?.complete == true ? _processStripePayment : null),
      ],
    );
  }

  Future<void> _processStripePayment() async {

    final address = Address(
      city: widget.checkoutFormBloc.formData['billing_city'] != null
          ? widget.checkoutFormBloc.formData['billing_city']
          : '',
      country: widget.checkoutFormBloc.formData['billing_country'] != null
          ? widget.checkoutFormBloc.formData['billing_country']
          : '',
      line1: widget.checkoutFormBloc.formData['billing_address_1'] != null
          ? widget.checkoutFormBloc.formData['billing_address_1']
          : '',
      line2: widget.checkoutFormBloc.formData['billing_address_2'] != null
          ? widget.checkoutFormBloc.formData['billing_address_2']
          : '',
      state: widget.checkoutFormBloc.formData['billing_state'] != null
          ? widget.checkoutFormBloc.formData['billing_state']
          : '',
      postalCode: widget.checkoutFormBloc.formData['billing_postcode'] != null
          ? widget.checkoutFormBloc.formData['billing_postcode']
          : '',
    );

    final tokenData = await Stripe.instance.createToken(
      CreateTokenParams(type: TokenType.Card, address: address),
    );

    var stripeSourceParams = new Map<String, dynamic>();
    stripeSourceParams['type'] = 'card';
    stripeSourceParams['token'] = tokenData.id;
    stripeSourceParams['key'] = stripePublicKey;

    StripeSourceModel? stripeSource = await widget.checkoutFormBloc.getStripeSource(stripeSourceParams);
    if(stripeSource?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text(appStateModel.blocks.localeText.paymentError)));
      return;
    }

    widget.checkoutFormBloc.formData['stripe_source'] = stripeSource!.id;
    widget.checkoutFormBloc.formData['wc-stripe-payment-token'] = 'new';

    OrderResult orderResult = await widget.checkoutFormBloc.placeOrder();

    if (orderResult.result != 'success') {
      print(orderResult.messages);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text(parseHtmlString(orderResult.messages))));
      return;
    }

    orderDetails(orderResult);
  }

  void orderDetails(OrderResult orderResult) {
    if (orderResult.result == 'success') {
      var orderId = getOrderIdFromUrl(orderResult.redirect);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderSummary(
                    id: orderId,
                  )));
    }
  }
}
