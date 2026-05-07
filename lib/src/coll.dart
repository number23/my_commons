String getMin(List<String> lst) {
  if (lst.isEmpty) return "";
  return lst.reduce((curr, next) => curr.compareTo(next) < 0 ? curr : next);
}

String getMax(List<String> lst) {
  if (lst.isEmpty) return "";
  return lst.reduce((curr, next) => curr.compareTo(next) > 0 ? curr : next);
}
