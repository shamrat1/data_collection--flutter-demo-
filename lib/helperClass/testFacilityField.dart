import 'package:data_collection/helperClass/surgeriesField.dart';
import 'package:data_collection/helperClass/testForAddButton.dart';
import 'package:flutter/material.dart';


class MultiSelectFormFieldForTestFacilities extends FormField<List<String>> {
  /// Holds the items to display on the dialog.
  final List<String> itemList;

  /// Enter text to show on the button.
  final String buttonText;

  /// Enter text to show question on the dialog
  final String questionText;

  // Constructor
  MultiSelectFormFieldForTestFacilities({
    this.buttonText,
    this.questionText,
    this.itemList,
    BuildContext context,
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
    List<String> initialValue,
  }) : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue ?? [], // Avoid Null
    autovalidateMode: AutovalidateMode.onUserInteraction,
    builder: (FormFieldState<List<String>> state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                  child: Card(
                      elevation: 3,
                      child: ClipPath(
                          child: Container(
                            height: 50,
                            width: 200,
                            color: Colors.blue,
                            child: Center(
                              //If value is null or no option is selected
                              child: (state.value == null ||
                                  state.value.length <= 0)

                              // Show the buttonText as it is
                                  ? Text(
                                buttonText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )

                              // Else show number of selected options
                                  : Text(
                                state.value.length == 1
                                // SINGLE FLAVOR SELECTED
                                    ? '${state.value.length.toString()} '
                                    ' ${buttonText.substring(0, buttonText.length - 1)} SELECTED '
                                // MULTIPLE FLAVOR SELECTED
                                    : '${state.value.length.toString()} '
                                    ' $buttonText SELECTED',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(3))))),
                  onTap: () async => state.didChange(await showDialog(
                      context: context,
                      builder: (_) => MultiSelectDialog(
                        question: Text(questionText),
                        answers: itemList,
                      )) ??
                      []))
            ],
          ),
          // If validation fails, display an error
          state.hasError
              ? Center(
            child: Text(
              state.errorText,
              style: TextStyle(color: Colors.red),
            ),
          )
              : Container() //Else show an empty container
        ],
      );
    },
  );
}

class MultiSelectFormFieldForServies extends FormField<List<String>> {
  /// Holds the items to display on the dialog.
  final List<String> itemList;

  /// Enter text to show on the button.
  final String buttonText;

  /// Enter text to show question on the dialog
  final String questionText;

  // Constructor
  MultiSelectFormFieldForServies({
    this.buttonText,
    this.questionText,
    this.itemList,
    BuildContext context,
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
    List<String> initialValue,
  }) : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue ?? [], // Avoid Null
    autovalidateMode: AutovalidateMode.onUserInteraction,
    builder: (FormFieldState<List<String>> state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                  child: Card(
                      elevation: 3,
                      child: ClipPath(
                          child: Container(
                            height: 50,
                            width: 200,
                            color: Colors.blue,
                            child: Center(
                              //If value is null or no option is selected
                              child: (state.value == null ||
                                  state.value.length <= 0)

                              // Show the buttonText as it is
                                  ? Text(
                                buttonText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )

                              // Else show number of selected options
                                  : Text(
                                state.value.length == 1
                                // SINGLE FLAVOR SELECTED
                                    ? '${state.value.length.toString()} '
                                    ' ${buttonText.substring(0, buttonText.length - 1)} SELECTED '
                                // MULTIPLE FLAVOR SELECTED
                                    : '${state.value.length.toString()} '
                                    ' $buttonText SELECTED',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(3))))),
                  onTap: () async => state.didChange(await showDialog(
                      context: context,
                      builder: (_) => MultiSelectDialog2(
                        question: Text(questionText),
                        answers: itemList,
                      )) ??
                      []))
            ],
          ),
          // If validation fails, display an error
          state.hasError
              ? Center(
            child: Text(
              state.errorText,
              style: TextStyle(color: Colors.red),
            ),
          )
              : Container() //Else show an empty container
        ],
      );
    },
  );
}



class MultiSelectFormFieldForDepartment extends FormField<List<String>> {
  /// Holds the items to display on the dialog.
  final List<String> itemList;

  /// Enter text to show on the button.
  final String buttonText;

  /// Enter text to show question on the dialog
  final String questionText;

  // Constructor
  MultiSelectFormFieldForDepartment({
    this.buttonText,
    this.questionText,
    this.itemList,
    BuildContext context,
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
    List<String> initialValue,
  }) : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue ?? [], // Avoid Null
    autovalidateMode: AutovalidateMode.onUserInteraction,
    builder: (FormFieldState<List<String>> state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                  child: Card(
                      elevation: 3,
                      child: ClipPath(
                          child: Container(
                            height: 50,
                            width: 200,
                            color: Colors.blue,
                            child: Center(
                              //If value is null or no option is selected
                              child: (state.value == null ||
                                  state.value.length <= 0)

                              // Show the buttonText as it is
                                  ? Text(
                                buttonText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )

                              // Else show number of selected options
                                  : Text(
                                state.value.length == 1
                                // SINGLE FLAVOR SELECTED
                                    ? '${state.value.length.toString()} '
                                    ' ${buttonText.substring(0, buttonText.length - 1)} SELECTED '
                                // MULTIPLE FLAVOR SELECTED
                                    : '${state.value.length.toString()} '
                                    ' $buttonText SELECTED',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(3))))),
                  onTap: () async => state.didChange(await showDialog(
                      context: context,
                      builder: (_) => MultiSelectDialog4(
                        question: Text(questionText),
                        answers: itemList,
                      )) ??
                      []))
            ],
          ),
          // If validation fails, display an error
          state.hasError
              ? Center(
            child: Text(
              state.errorText,
              style: TextStyle(color: Colors.red),
            ),
          )
              : Container() //Else show an empty container
        ],
      );
    },
  );
}










class MultiSelectFormFieldForSurgeries extends FormField<List<String>> {




  /// Holds the items to display on the dialog.
  final List<String> itemList;

  /// Enter text to show on the button.
  final String buttonText;

  /// Enter text to show question on the dialog
  final String questionText;

  // Constructor
  MultiSelectFormFieldForSurgeries({
    this.buttonText,
    this.questionText,
    this.itemList,
    BuildContext context,
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
    List<String> initialValue,
  }) : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue ?? [], // Avoid Null
    autovalidateMode: AutovalidateMode.onUserInteraction,
    builder: (FormFieldState<List<String>> state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                  child: Card(
                      elevation: 3,
                      child: ClipPath(
                          child: Container(
                            height: 50,
                            width: 200,
                            color: Colors.blue,
                            child: Center(
                              //If value is null or no option is selected
                              child: (state.value == null ||
                                  state.value.length <= 0)

                              // Show the buttonText as it is
                                  ? Text(
                                buttonText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )

                              // Else show number of selected options
                                  : Text(
                                state.value.length == 1
                                // SINGLE FLAVOR SELECTED
                                    ? '${state.value.length.toString()} '
                                    ' ${buttonText.substring(0, buttonText.length - 1)} SELECTED '
                                // MULTIPLE FLAVOR SELECTED
                                    : '${state.value.length.toString()} '
                                    ' $buttonText SELECTED',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(3))))),
                  onTap: () async => state.didChange(await showDialog(
                      context: context,
                      builder: (_) => MultiSelectDialog3(
                        question: Text(questionText),
                        answers: itemList,
                      )) ??
                      []))
            ],
          ),
          // If validation fails, display an error
          state.hasError
              ? Center(
            child: Text(
              state.errorText,
              style: TextStyle(color: Colors.red),
            ),
          )
              : Container() //Else show an empty container
        ],
      );
    },
  );
}