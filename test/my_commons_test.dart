import 'package:flutter_test/flutter_test.dart';

import 'package:my_commons/my_commons.dart';
import 'package:my_commons/src/comm.dart';

void main() {
  test('test getMin && getMax func', () {
    final List<String> lst = ['2025-12-10', '2025-12-01', '2025-12-05'];
    expect(getMin(lst), '2025-12-01');
    expect(getMax(lst), '2025-12-10');
  });

  test('test getShortUuid', () {
    expect(getShortUuid("92c66973b5f546b399d989f6fccefe3d"), 'cz6tV4pE8QLf');
  });
}
