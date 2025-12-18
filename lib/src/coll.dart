String getMin(List<String> lst) {
  return lst.reduce((curr, next) => curr.compareTo(next) < 0 ? curr : next);
}

String getMax(List<String> lst) {
  return lst.reduce((curr, next) => curr.compareTo(next) > 0 ? curr : next);
}
