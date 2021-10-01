String findParams(int i, List words) {
  for (var n = 1; n < 10000000; n++) {
    if (words[i + n] != "the" &&
        words[i + n] != "to" &&
        words[i + n] != "at" &&
        words[i + n] != "it" &&
        words[i + n] != "new" &&
        words[i + n] != "your" &&
        words[i + n] != "that" &&
        words[i + n] != "us" &&
        words[i + n] != "me") {
      // !STOP HERE!!!!!!!
      // TODO: Put alll this into a if statement to see if a name or subject is after verb
      //return words[i + n].toString();

      print("THE WORD IS: " + words[i + n]);
      if (words[i + n + 1] == "at" || words[i + n + 1] == "it") {
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
          print("YO");
          return "at " + words[i + n] + words[i + n + 1];
        }
      } else if (words[i + n] == "on") {
        // ? Range error exception could maybe nbe fix? like we did last time
        try {
          if (words[i + n + 1] == "Monday" ||
              words[i + n + 1] == "Tuesday" ||
              words[i + n + 1] == "Wednesday" ||
              words[i + n + 1] == "Thursday" ||
              words[i + n + 1] == "Friday" ||
              words[i + n + 1] == "Saturday" ||
              words[i + n + 1] == "Sunday") {
            if (words[i + n + 2] == "at") {
              return "on " + words[i + n + 1] + " at " + words[i + n + 3];
            }
            return "on " + words[i + n + 1];
          } else {
            return "on " + words[i + n + 1] + " " + words[i + n + 2];
          }
        } catch (rangeError) {
          return "on " + words[i + n + 1];
        }
      } else if (words[i + n] != "on") {
        try {
          if (words[i + n + 1] == "on") {
            if (words[i + n + 2] == "January" ||
                words[i + n + 2] == "February" ||
                words[i + n + 2] == "March" ||
                words[i + n + 2] == "April" ||
                words[i + n + 2] == "May" ||
                words[i + n + 2] == "June" ||
                words[i + n + 2] == "July" ||
                words[i + n + 2] == "August" ||
                words[i + n + 2] == "September" ||
                words[i + n + 2] == "October" ||
                words[i + n + 2] == "November" ||
                words[i + n + 2] == "December") {
              return "on " + words[i + n + 2] + " " + words[i + n + 3];
            }
            return words[i + n] + " on " + words[i + n + 2];
          }
        } catch (rangeError) {
          return "on " + words[i + n + 1];
        }
      }
      List name = [];
      try {
        for (var l = i + n; l < words.length; l++) {
          if (words[l] != "on" && words[l] != "at") {
            name.add(words[l]);
          } else {
            var rest = findParams(l - 1, words);
            return name.join(" ") + " " + rest;
          }
        }

        return name.toString();
      } catch (RangeError) {
        return name.toString();
      }
    }
  }
  return null;
}
