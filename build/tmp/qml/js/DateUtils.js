
/*
 Utility function for dates manipulation
*/


/* Return the todayDate with UTC values set to zero */
function getTodayDate(){

    var today = new Date();
    today.setUTCHours(0);
    today.setUTCMinutes(0);
    today.setUTCSeconds(0);
    today.setUTCMilliseconds(0);

    return today;
}

/* Utility function to format the javascript date to have double digits for day and month (default is one digit in js)
   Example return date like: YYYY-MM-DD
   eg: 2017-04-28
*/
function formatDateToString(date)
{
   var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
   var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
   var yyyy = date.getFullYear();

   return (yyyy + "-" + MM + "-" + dd);
}
