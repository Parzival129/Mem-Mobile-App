String findParams(int i, List words) {
  for (var n = 1; n < 10000000; n++) {
    if (words[i + n] != "the" &&
        words[i + n] != "to" &&
        words[i + n] != "at" &&
        words[i + n] != "new" &&
        words[i + n] != "your" &&
        words[i + n] != "me") {
      //return words[i + n].toString();
      if (words[i + n + 1] == "at") {
        if (words[i + n + 3] == "PM" || words[i + n + 3] == "AM") {
          try {
            if (words[i + n + 4] == "on") {
              return words[i + n] +
                  " at " +
                  words[i + n + 2] +
                  " " +
                  words[i + n + 3] +
                  " on " +
                  words[i + n + 5] +
                  " " +
                  words[i + n + 6];
            }
          } catch (rangeError) {
            return words[i + n] +
                " at " +
                words[i + n + 2] +
                " " +
                words[i + n + 3];
          }
          //return words[i + n] + " at " + words[i + n + 2] + " " + words[i + n + 3];
        }
      } else if (words[i + n + 1] == "PM" || words[i + n + 1] == "AM") {
        //return words[i + n] + words[i + n + 1];
        try {
          if (words[i + n + 2] == "on") {
            return 'at ' +
                words[i + n] +
                words[i + n + 1] +
                " on " +
                words[i + n + 3] +
                " " +
                words[i + n + 4];
          }
        } catch (rangeError) {
          return "at " + words[i + n] + words[i + n + 1];
        }
      } else if (words[i + n + 1] == "on") {
        if (words[i + n + 2] == "Monday" ||
            words[i + n + 2] == "Tuesday" ||
            words[i + n + 2] == "Wednesday" ||
            words[i + n + 2] == "Thursday" ||
            words[i + n + 2] == "Friday" ||
            words[i + n + 2] == "Saturday" ||
            words[i + n + 2] == "Sunday") {
          return "on " + words[i + n + 2];
        } else {
          return "on " + words[i + n + 2] + " " + words[i + n + 3];
        }
      }
      return words[i + n];
    }
  }
  return null;
}
