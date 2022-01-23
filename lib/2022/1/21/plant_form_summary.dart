import 'package:daily_ui/2022/1/21/component/stack_pages_route.dart';
import 'package:daily_ui/2022/1/21/form_page.dart';
import 'package:daily_ui/2022/1/21/plant_form_information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'component/section_seperator.dart';
import 'component/submit_button.dart';
import 'demo_data.dart';
import 'form_demo_screen.dart';
import 'styles.dart';

class PlantFormSummary extends StatelessWidget {
  const PlantFormSummary({
    Key? key,
    this.pageSize = .85,
    this.isHidden = false,
  }) : super(key: key);

  final double pageSize;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    print("Rebuilding Summary @ ${DateTime.now().millisecondsSinceEpoch}");
    return FormPage(
      pageSizeProportion: pageSize,
      isHidden: isHidden,
      title: "Order Summary",
      children: [
        _buildOrderSummary(),
        const Separator(),
        _buildOrderInfo(),
        const Separator(),
        _buildOrderTotal(),
        _buildOrderSpecialInstructions(context),
        SubmitButton(
          padding: EdgeInsets.symmetric(horizontal: Styles.hzPadding),
          child: Text('Next', style: Styles.submitButtonText),
          onPressed: () => _handleSubmit(context),
        ),
      ],
    );
  }

  void _handleSubmit(BuildContext context) {
    Navigator.push(
      context,
      StackPagesRoute(
        previousPages: [
          const PlantFormSummary(
            pageSize: .85,
            isHidden: true,
          )
        ],
        enterPage: const PlantFormInformation(),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                border: Border.all(color: Styles.grayColor),
                borderRadius: BorderRadius.circular(4),
                image: const DecorationImage(
                  image:
                      AssetImage("assets/images/plant_header_background.png"),
                ),
              ),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Styles.grayColor,
                ),
                child: Center(child: Text("1", style: Styles.imageBatch)),
              ),
            ),
          ],
        ),
        const SizedBox(width: 36),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Red Potted \nPlant w/ \nWhite Bowl",
                style: Styles.productName),
            Text("\$34.00", style: Styles.productPrice),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Subtotal', style: Styles.orderLabel),
            Text('\$34.00', style: Styles.orderPrice),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Shipping', style: Styles.orderLabel),
            Text('FREE', style: Styles.orderPrice),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderTotal() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Total', style: Styles.orderTotalLabel),
          Text('\$34.00', style: Styles.orderTotal),
        ],
      ),
    );
  }

  Widget _buildOrderSpecialInstructions(BuildContext context) {
    String name = 'Special Instructions';
    SharedFormState sharedState =
        Provider.of<SharedFormState>(context, listen: false);
    var values = sharedState.valuesByName;
    return TextFormField(
      onChanged: (value) => values[FormKeys.instructions] = value,
      initialValue: values.containsKey(FormKeys.instructions)
          ? values[FormKeys.instructions]
          : "",
      style: Styles.inputLabel,
      decoration: Styles.getInputDecoration(helper: name),
      minLines: 4,
      maxLines: 6,
    );
  }
}
