// Main analyzation function for picking oiut different phrases for scheduling
String findParams(int i, List words) {
  try {
    for (var n = 1; n < 10000000; n++) {
      // ignore non relevent words
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
        //return words[i + n].toString();

        print("THE WORD IS: " + words[i + n]);
        // If the word after the subject is at (or it since it can sometimes be missheard as it)
        print("hHEERE");
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
            if (words[i + n + 2] == "on" || words[i + n + 2] == "this") {
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
        } else if (words[i + n] == "on" || words[i + n] == "this") {
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
        if (words[i + n] == "around" || words[i + n] == "precisley") {
          if (words[i + n + 2] == "PM" || words[i + n + 2] == "AM") {
            return words[i + n] +
                " " +
                words[i + n + 1] +
                " " +
                words[i + n + 2];
          } else {
            return words[i + n] + words[i + n + 1] + words[i + n + 2];
          }
        }
        List name = [];
        print("got herer bro2");
        try {
          print("got herer bro");
          for (var l = i + n; l < words.length; l++) {
            if (words[l] != "on" && words[l] != "at" && words[l] != "and") {
              name.add(words[l]);
            } else if (words[l] == "and") {
              return name.join(" ");
            } else {
              try {
                var rest = findParams(l, words);
                return name.join(" ") + " " + rest;
              } catch (rangeError) {
                return name.join(" ");
              }
            }
          }

          return name.join(" ");
        } catch (rangeError) {
          return name.join(" ");
        }
      }
    }
    return null;
  } catch (e) {
    print("ERROR OCCURED! - " + e.toString());
    return "ERROR_OCCURED";
  }
}
