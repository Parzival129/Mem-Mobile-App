String findParams(int i, List words) {
  for (var n = 1; n < 10000000; n++) {
    if (words[i + n] != "the" &&
        words[i + n] != "to" &&
        words[i + n] != "at" &&
        words[i + n] != "it" &&
        words[i + n] != "new" &&
        words[i + n] != "your" &&
        words[i + n] != "that" &&
        words[i + n] != "me") {
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
        print("HEREEE");
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
      } else if (words[i + n] == "on") {
        // ! for "meet me at the airport at 5pm, it is detecting airport as the word and not on"
        // ! gotta have it look for 'on' after airport
        // ? Range error exception could maybe nbe fix? like we did last time
        if (words[i + n + 1] == "Monday" ||
            words[i + n + 1] == "Tuesday" ||
            words[i + n + 1] == "Wednesday" ||
            words[i + n + 1] == "Thursday" ||
            words[i + n + 1] == "Friday" ||
            words[i + n + 1] == "Saturday" ||
            words[i + n + 1] == "Sunday") {
          print("asdlkjasldkj");
          if (words[i + n + 2] == "at") {
            return "on " + words[i + n + 1] + " at " + words[i + n + 3];
          }
          return "on " + words[i + n + 1];
        } else {
          return "on " + words[i + n + 1] + " " + words[i + n + 2];
        }
      } else if (words[i + n] != "on") {
        if (words[i + n + 1] == "on") {
          print("hey!!!!!!!!!!x");
        }
      }
      return words[i + n];
    }
  }
  return null;
}
