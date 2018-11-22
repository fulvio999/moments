
/*
   Various utility functions used for user input Validation
*/

    /* utility functions to decide what value display in case of missing field value from DB */
    function getValueTodisplay(val) {

        if (val === undefined)
           return ""
        else
          return val;
    }

    /* used to check if a mandatory field is provided by the user */
    function isInputTextEmpty(fieldTxtValue)
    {
        if (fieldTxtValue.length <= 0 )
           return true
        else
           return false;
    }

    /* check if a mandatory field is valid (ie contains no special characters) and is present */
    function checkinputText(fieldTxtValue)
    {
        if (fieldTxtValue.length <= 0 || hasSpecialChar(fieldTxtValue))
           return false
        else
           return true;
    }

    /* return true if the input parametr contains comma sign */
    function containsComma(fieldTxtValue) {
        return /[,]|&#/.test(fieldTxtValue) ? true : false;
    }

    /* If regex matches, then string contains (at least) one special chars */
    function hasSpecialChar(fieldTxtValue) {
        /* dot sign is allowed because is the decimal separator */
        return /[<>?%#,;"!£$%&()=^.@/]|&#/.test(fieldTxtValue) ? true : false;
    }
