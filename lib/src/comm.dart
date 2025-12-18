var _arr = [
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
];

String getShortUuid(String uuid) {
  uuid = uuid.replaceAll("-", "");
  var sbuf = StringBuffer();
  for (int i = 0; i < 8; i++) {
    String str = uuid.substring(i * 4, i * 4 + 4);
    int x = int.parse(str, radix: 16);
    sbuf.write(_arr[x % 0x3E]);

    if ((i % 2) == 1) sbuf.write(uuid.substring(i * 4, i * 4 + 1));
  }
  return sbuf.toString();
}
