extension GetNameInitialsExtension on String {
  String getInitials() {
    try {
      return split(' ').map((name) => name[0]).join();
    } catch (e) {
      return this;
    }
  }
}
