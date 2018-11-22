/*
   Function to manage sqlite Database of the Application
*/


   function getDatabase() {
      return LocalStorage.openDatabaseSync("MomentsApp_db", "1.0", "StorageDatabase", 1000000);
   }

    /*
       Create Application table
    */
    function createTable() {

        var db = getDatabase();
        db.transaction(
           function(tx) {
               tx.executeSql('CREATE TABLE IF NOT EXISTS moments(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, description TEXT, location TEXT, title TEXT, tags TEXT)');

           });
    }

    /*
      Delete a table whose name is in argument
    */
    function deleteTable(tableName) {

        var db = getDatabase();
        db.transaction(
           function(tx) {
                tx.executeSql('DELETE FROM '+tableName);
           });
    }

    /*
       Insert a new moment. Note: Images list are managed at filesystem level inside a dedicated folder for each moment
       (see Main.qml file)
    */
    function insertMoment(date, description, location, title, tags){

       var fullDate = new Date (date);

       /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
       var dateFormatted = formatDateToString(fullDate);

        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {

            var rs = tx.executeSql('INSERT INTO moments (date, description, location, title, tags) VALUES (?,?,?,?,?);', [dateFormatted, description, location, title, tags]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;
    }


    /*
       Update a moment with the provided id
    */
    function updateMoment(date, description, location, title, tags, id){

        var fullDate = new Date (date);

        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
        var dateFormatted = formatDateToString(fullDate);

        var db = getDatabase();
        var res = "";

        db.transaction(function(tx) {
            var rs = tx.executeSql('UPDATE moments SET date=?, description=?, location=?, title=?, tags=? WHERE id=?;', [dateFormatted, description, location, title, tags, id]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;
    }


    /*
       Load informations for all the Moments and fill the Listmodel to show them on application on startup
    */
    function getAllMomentsAndFillModel(){

           momentsListModel.clear();
           var db = getDatabase();

           db.transaction(function(tx) {
             var rs = tx.executeSql('SELECT id, date, description, location, title, tags FROM moments');
               for(var i =0;i < rs.rows.length;i++){
                   /* on qml file use the table field name to get filed value */
                   momentsListModel.append(rs.rows.item(i));
               }
            }
          );
    }

    /*
       Load Moment informations whose id is in argument
    */
    function getMomentById(id){

        console.log("Moment id: "+id);

        var db = getDatabase();
        var rs = "";
        db.transaction(function(tx) {
             rs = tx.executeSql('SELECT * FROM moments where id=?;',[id]);
           }
        );

        return rs;
    }

    /*
       Search for a Moment with the 'title' in argument.
       Used to check if already exist a moment with the provided title.
       Return true if a moment exist with that title. false otherwise
    */
    function isMomentDuplicated(title){

           var db = getDatabase();
           var rs = "";
           db.transaction(function(tx) {
               rs = tx.executeSql('SELECT * FROM moments where title=?;',[title]);
             }
          );

          if(rs.rows.length > 0){
             return true;
          }else{
             return false;
          }
    }

    /*
      Load and return all the Moments infomrations
    */
    function getAllMoments(){

         var db = getDatabase();
         var rs = "";
         db.transaction(function(tx) {
            rs = tx.executeSql('SELECT * FROM moments');

          }
        );

        return rs;
    }


    /*
       Search for a Moments whose title or tags list contains the provided text
    */
    function searchMomentsByTagOrTitle(searchedText) {

        /* clean old results */
        momentsListModel.clear();
        var db = getDatabase();

        db.transaction(function(tx) {

            var rs = tx.executeSql('SELECT m.date, m.description, m.location, m.title, m.tags FROM moments m where m.tags like ? OR m.title like ?;',['%'+searchedText+'%', '%'+searchedText+'%']);
            for(var i =0;i < rs.rows.length;i++){
                momentsListModel.append(rs.rows.item(i));
            }
        }
        );
    }

    /*
       Delete a moment with the id in argument
    */
    function deleteMoment(id){
        var db = getDatabase();

        db.transaction(function(tx) {
            var rs = tx.executeSql('DELETE FROM moments WHERE id =?;',[id]);
           }
        );
    }

    /*
       clean ALL the database
       This function is called when the user click on the 'trash' icon in the Application menu.
    */
    function cleanAllDatabase(){

         var db = getDatabase();

         db.transaction(function(tx) {
             var rs = tx.executeSql('DELETE FROM moments;');
            }
         );
    }


    /* utility function to format the javascript data to have double digit for day and month (default is one digit in js)
       return date like: YYYY-MM-DD
    */
    function formatDateToString(date)
    {
       var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
       var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
       var yyyy = date.getFullYear();

       return (yyyy + "-" + MM + "-" + dd);
    }
