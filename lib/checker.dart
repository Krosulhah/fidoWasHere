
class Checker {


  bool emailValidity(String mail) {
    String alphabet = "abcdefghijklmnopqrstuvwxyz";
    String alphabetCaps = alphabet.toUpperCase();

    alphabet = alphabet + alphabetCaps;
    String numbers = "0123456789";

    List<Object> alphanumericalValue = new List();
    List<Object> allowedSymbols = new List();

    for (int i = 0; i < alphabet.length; i++)
      alphanumericalValue.add(alphabet[i]);
    for (int i = 0; i < numbers.length; i++)
      alphanumericalValue.add(numbers[i]);

    allowedSymbols.add('-');
    allowedSymbols.add('.');


    //the system is looking for @ symbol
    int indexOfAt = 0;
    for (indexOfAt = 0; indexOfAt < mail.length; indexOfAt++) {
      if (mail[indexOfAt] == '@')
        break;
    }

    /* mail must be in the format username@domain
      *
      * if mail[0]='@'  -> invalid mail
      * if '@' is the last character of mail or the mail doesn't contain it -> invalid mail
      *
    */

    if (indexOfAt == 0 || indexOfAt >= mail.length)
      return false;

    String username = mail.substring(0, indexOfAt);
    String domain = mail.substring(indexOfAt + 1, mail.length);

    //username syntax: username cannot start or finish with a symbol
    if (allowedSymbols.contains(username[username.length - 1]) ||
        allowedSymbols.contains(username[0]))
      return false;

    //username syntax: username cannot have consecutive symbols
    bool hasPrecSymbol = false;

    for (int i = 0; i < username.length; i++) {
      if (alphanumericalValue.contains(username[i]))
        hasPrecSymbol = false;
      else if (allowedSymbols.contains(username[i])) {
        if (hasPrecSymbol)
          return false;
        hasPrecSymbol = true;
      }
      else if (!allowedSymbols.contains(username[i]))
        return false;
    }
    //domain syntax: domain cannot have consecutive symbols
    //after the last '.' only 2/3 characters are allowed and they can't be numbers
    hasPrecSymbol = false;
    int lastPoint = 0;
    for (int i = 0; i < domain.length; i++) {
      if (alphanumericalValue.contains(domain[i]))
        hasPrecSymbol = false;
      else if (allowedSymbols.contains(domain[i])) {
        if (hasPrecSymbol)
          return false;
        hasPrecSymbol = true;
      }
      else if (!allowedSymbols.contains(domain[i]))
        return false;
      if (domain[i] == '.')
        lastPoint = i;
    }

    if (lastPoint == 0 || lastPoint >= domain.length)
      return false;

    String domainExtension = domain.substring(lastPoint, domain.length);
    if (domainExtension.length != 2 && domainExtension.length != 3)
      return false;

    for (int i = 0; i < domainExtension.length; i++) {
      if (!alphanumericalValue.contains(domainExtension[i]))
        return false;
    }

    return true;
  }

}


