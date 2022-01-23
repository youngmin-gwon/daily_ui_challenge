mixin FormMixin {
  Map<String, bool> validInputsMap = {};
  double formCompletion = 0;
  bool isFormErrorVisible = false;

  void onItemValidate({
    required String name,
    required bool isValid,
    required String value,
  });

  void onItemChange({
    required String name,
    required String value,
  });

  int countValidItems() {
    int count = 0;
    validInputsMap.forEach((name, isValid) {
      if (isValid) count++;
    });
    return count;
  }
}
