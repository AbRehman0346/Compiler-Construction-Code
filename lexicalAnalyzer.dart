/*
* Here we are going to build a lexical analyser that accpets the declaration statements and
* creates a symbole table.
* */

void main() {
  print("Success: ${tokenize('String s;')}");
  print("Success: ${tokenize('String s = "Abdul Rehman";')}");
  print("Success: ${tokenize('int i = 30;')}");
  print("Success: ${tokenize('float j = 40.0;')}");
  print("Success: ${tokenize('float j = 45;')}");

  // The below print statement line doesn't contain the valid statement so the program will throw an error
  // As it should. There is one comma extra so it can't be tokanized...So it will throw an error to user.
  // Thanks...
  // print(tokenize('String s = "Abdul" Rehman";'));
}

List<Map> tokenize(String stmt) {
  Keywords keywords = Keywords();
  Identifier iden = Identifier();
  Punction pun = Punction();
  Literal lit = Literal();
  Operator op = Operator();
  Types type = Types();

  List<String> tokens = createTokens(stmt);
  List<Map> table = [];
  for (String s in tokens) {
    if (keywords.isKeyword(s)) {
      table.add(createSymbolTableEntry(type: type.keyword, value: s));
    } else if (iden.isIdentifier(s)) {
      table.add(createSymbolTableEntry(type: type.identifier, value: s));
    } else if (op.isOperator(s)) {
      table.add(createSymbolTableEntry(type: type.operator, value: s));
    } else if (pun.isPunction(s)) {
      table.add(createSymbolTableEntry(type: type.punction, value: s));
    } else if (lit.isLiteral(s)) {
      table.add(createSymbolTableEntry(type: type.literal, value: s));
    } else {
      exception("Invalid Token");
    }
  }
  return table;
}

List<String> createTokens(String stmt) {
  Punction pun = Punction();
  Operator op = Operator();
  List<String> tokens = [];
  stmt = stmt.trim();
  String word = "";
  bool startCotes = false;
  for (int i = 0; i < stmt.length; i++) {
    // Identifies the String value;
    if (stmt[i] == '"') {
      word += stmt[i];
      startCotes = !startCotes;
      if (!startCotes) {
        tokens.add(word);
        word = "";
      }
      continue;
    } else if (startCotes) {
      word += stmt[i];
      continue;
    }

    // Identifies Punctions that are without spaces
    if (pun.isPunction(stmt[i])) {
      tokens.add(stmt[i]);
      continue;
    }

    //Checking for Operators
    if (op.isOperator(stmt[i])) {
      tokens.add(stmt[i]);
      continue;
    }

    // Identifies the Int Value;
    if (stmt[i] == " ") {
      if (word != "") {
        tokens.add(word);
        word = "";
      }
    } else {
      word += stmt[i];
    }
  }
  if (word != "") {
    tokens.add(word);
  }
  return tokens;
}

Map createSymbolTableEntry({required type, required String value}) {
  return {
    "type": type,
    "value": value,
  };
}

void exception(String msg) {
  throw Exception(msg);
}

class Types {
  String keyword = "keyword";
  String identifier = "identifier";
  String operator = "operator";
  String literal = "literal";
  String punction = "punction";
}

class Identifier {
  bool isIdentifier(String iden) {
    Keywords keywords = Keywords();
    if (keywords.isKeyword(iden)) {
      return false;
    }

    // It uses the apprach to checking if it is an identifier.
    for (int i = 0; i < iden.length; i++) {
      bool notUpperCaseLetter =
          (iden.codeUnitAt(i) < 65 || iden.codeUnitAt(i) > 90);
      bool notLowerCaseLetter =
          (iden.codeUnitAt(i) < 97 || iden.codeUnitAt(i) > 122);
      bool notUnderScore = iden.codeUnitAt(i) != 95;
      if (notUpperCaseLetter && notLowerCaseLetter && notUnderScore) {
        return false;
      }
    }
    return true;
  }
}

class Keywords {
  String integer = "int";
  String float = "float";
  String string = "String";
  bool isKeyword(String s) {
    List<String> list = [integer, float, string];
    for (String i in list) {
      if (i == s) {
        return true;
      }
    }
    return false;
  }
}

class Operator {
  String equal = "=";
  String add = "+";
  String sub = "-";
  String multiply = "*";
  String divide = "/";
  List<String> operator = [];
  Operator() {
    operator.add(equal);
    operator.add(add);
    operator.add(sub);
    operator.add(multiply);
    operator.add(divide);
  }

  void displayOperators() {
    print(operator);
  }

  bool isOperator(String s) {
    for (String op in operator) {
      if (s == op) {
        return true;
      }
    }
    return false;
  }
}

class Literal {
  bool isLiteral(String s) {
    return isNumberLiteral(s) || isStringLiteral(s);
  }

  bool isNumberLiteral(String s) {
    for (int i = 0; i < s.length; i++) {
      bool notNumber = (s[i].codeUnitAt(0) < 48) || (s[i].codeUnitAt(0) > 57);
      bool notDot = s[i].codeUnitAt(0) != 46;
      if (notNumber && notDot) {
        return false;
      }
    }
    return true;
  }

  bool isStringLiteral(String s) {
    bool doesStartAndEndWithCotes = s.startsWith('"') && s.endsWith('"');
    int countCoutes = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == '"') {
        countCoutes++;
      }
    }
    return doesStartAndEndWithCotes && countCoutes == 2;
  }
}

class Punction {
  String comma = '"';
  String semiColon = ";";
  List<String> literals = [];

  Punction() {
    literals.add(comma);
    literals.add(semiColon);
  }

  bool isPunction(String value) {
    for (String s in literals) {
      if (s == value) {
        return true;
      }
    }
    return false;
  }
}
