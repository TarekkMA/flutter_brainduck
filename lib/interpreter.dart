class LanguageKeywords {
  static const INC_PTR = ">";
  static const DEC_PTR = "<";

  static const INC_VAL = "+";
  static const DEC_VAL = "-";

  static const LOP_STR = "[";
  static const LOP_END = "]";

  static const GET_CHR = ",";
  static const PUT_CHR = ".";

  static const values = [
    INC_PTR,
    DEC_PTR,
    INC_VAL,
    DEC_VAL,
    LOP_STR,
    LOP_END,
    GET_CHR,
    PUT_CHR
  ];
}

abstract class IO {
  Future putChar(int char);
  Future<int> getChar();
}

class Interpreter {
  final List<int> memory = [0];
  final String code;
  final Future Function(int char) putChar;
  final Future<int> Function() getChar;
  int ptr = 0;
  int pc = 0;

  Interpreter({this.code, this.putChar, this.getChar});

  Future interpret() async {
    while (pc < code.length) {
      switch (code[pc]) {
        case LanguageKeywords.INC_PTR:
          ptr++;
          if (memory.length - 1 <= ptr) {
            memory.add(0);
          }
          break;
        case LanguageKeywords.DEC_PTR:
          ptr--;
          if (ptr < 0) {
            throw "ptr cannot be less than zero";
          }
          break;
        case LanguageKeywords.INC_VAL:
          memory[ptr]++;
          break;
        case LanguageKeywords.DEC_VAL:
          memory[ptr]--;
          break;
        case LanguageKeywords.GET_CHR:
          memory[ptr] = await getChar();
          break;
        case LanguageKeywords.PUT_CHR:
          await putChar(memory[ptr]);
          break;
      }

      if (code[pc] == LanguageKeywords.LOP_STR) {
        if (memory[ptr] == 0)
          pc = findClosingParen() + 1;
        else
          pc++;
      } else if (code[pc] == LanguageKeywords.LOP_END) {
        if (memory[ptr] != 0)
          pc = findOpenParen() + 1;
        else
          pc++;
      } else {
        pc++;
      }
    }
  }

  int findClosingParen() {
    int startingPC = pc;
    int closePos = pc;
    int counter = 1;
    while (counter > 0) {
      if (closePos + 1 > code.length) {
        throw "Brakects are not balanced. Make sure [ at $startingPC have a matching ]";
      }
      String c = code[++closePos];
      if (c == '[') {
        counter++;
      } else if (c == ']') {
        counter--;
      }
    }
    return closePos;
  }

  int findOpenParen() {
    int startingPC = pc;
    int openPos = pc;
    int counter = 1;
    while (counter > 0) {
      if (openPos - 1 < 0) {
        throw "Brakects are not balanced. Make sure ] at $startingPC have a matching [";
      }
      String c = code[--openPos];
      if (c == '[') {
        counter--;
      } else if (c == ']') {
        counter++;
      }
    }
    return openPos;
  }
}
