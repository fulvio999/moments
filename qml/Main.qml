import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0
import Ubuntu.Content 1.3

/*
  Custom plugin name. That name is the one used to register the plugin in plugin.cpp file
*/
import Fileutils 1.0

import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

/* note: alias name must have first letter in upperCase */
import "./js/ValidationUtils.js" as ValidationUtils
import "./js/Storage.js" as Storage

/* import folder content */
import "./dialog"

MainView {

    id: root

    objectName: "mainView"
    automaticOrientation: true
    anchorToKeyboard: true

    applicationName: "moments.fulvio"
    property string appVersion : "1.0"

    /* application hidden folder where save imported image. (path is fixed due to Appp confinement) */
    property string imagesSavingRootPath: ".local/share/moments.fulvio"

    /* the title of the currently selected moment */
    property string targetMomentTitle: ""

    property bool initialized: false
    property var activeTransfer: null

    /* emitted when user want add images at the moment */
    signal importRequested

    /* Connection with the contentHub (must be place ONLY in the MainView Component ? place in a different Page Component does not work) */
    Connections {
         target: ContentHub

         /* handle custom event 'importRequested' raised when user press 'Browse' button or 'Add' button */
         onImportRequested: {
                console.log("- onImportRequested event import started");
                /* bind the 'transfer' field of the ContentHub, to the local var 'activeTransfer' the field to be checked
                  to get info about the Transfer status process.
                */
                root.activeTransfer = transfer

                if (root.activeTransfer.state === ContentTransfer.Charged){
                   /* transfer is completed from Pictures App source */
                   root.processPictures(root.activeTransfer.items)
                }
         }
    }

    Connections {
        target: root.activeTransfer
        onStateChanged: {
           console.log("Tranfert State Changed to status: " + root.activeTransfer.state); //4 = completed ?
           if (root.activeTransfer.state === ContentTransfer.Charged){
               /* transfer is completed from the Pictures App source  */
               root.processPictures(root.activeTransfer.items)
           }
       }
    }

    /*------- Tablet (width >= 110) -------- */
    //vertical
    //width: units.gu(75)
    //height: units.gu(111)

    //horizontal (rel)
    width: units.gu(100)
    height: units.gu(75)

    //Tablet horizontal
    //width: units.gu(128)
    //height: units.gu(80)

    //Tablet vertical
    //width: units.gu(80)
    //height: units.gu(128)

    /* ----- phone 4.5 (the smallest one) ---- */
    //vertical
    //width: units.gu(50)
    //height: units.gu(96)

    //horizontal
    //width: units.gu(96)
    //height: units.gu(50)
    /* -------------------------------------- */

    Settings {
        id:settings
        /* to create DB table on first use */
        property bool isFirstUse : true;
    }

    Component.onCompleted: {
       if(settings.isFirstUse == true) {
          Storage.createTable();
          settings.isFirstUse = false
        }
    }

    AdaptivePageLayout {

        id: adaptivePageLayout
        anchors.fill: parent

        /* first page to load */
        primaryPage: MomentsListPage{}

        /* images associated with a moment */
        ListModel{
           id: momentsImagesListModel
        }

        /* list of saved Moments. Filled on startup */
        ListModel{
           id: momentsListModel
        }

        /* keep sorted the loaded moments List */
        SortFilterModel {
            id: sortedMomentsListModel
            model: momentsListModel
            sort.order: Qt.AscendingOrder
            sortCaseSensitivity: Qt.CaseSensitive
        }
    }

    /*
       Callback function called when the Images(s) transfer from Image App source (eg. Gallery) is completed.
       At the end of the import, the image(s) are placed under:
       '/home/phablet/.cache/moments.fulvio/HubIncoming/<id>' folder by ContentHub.
       Where <id> is a progressive integer number created after each import by ContentHub

       After device reboot, folder '/home/phablet/.cache/moments.fulvio/HubIncoming/<id>' will be removed.
       Remains only /home/phablet/.cache/moments.fulvio/HubIncoming/
       So that is necessary move the images in a persistent folder under App confinement,
       then update the ListModel.

       (Note: Running on desktop the root folder is /.tmp/ NOT /home/phablet)
    */
    function processPictures(items)
    {
        var homeFolder = Fileutils.getHomePath();
        //console.log("Home folder: "+homeFolder);

        for (var i = 0; i < items.length; i++)
        {
            var url = items[i].url
            //console.log("Selected Image full path: " + url);

            var imageName = getImageNameFromPath(String(url));
            //console.log("imageName: "+imageName);

            /* sourcePath is the folder where contenthub place selected images: /HubIncoming/<id_import> where <id_import> is an id created by contenthub
               to identify the import
            */
            var sourcePath = getPathFromUrl(url).replace(imageName, "");
            var destinationPath = Fileutils.getHomePath()+"/"+root.imagesSavingRootPath+"/moments/"+root.targetMomentTitle+"/images";

            console.log("Image Copy source path: " + sourcePath);
            console.log("Image Copy destination path: " + destinationPath);

            /* copy images in a folder under the App confinement */
            Fileutils.moveImage(sourcePath, destinationPath,imageName);

            momentsImagesListModel.append( { imageName: imageName, imagePath: destinationPath, value:i } );
        }
    }

    /*
      Load from filesystem moments images
    */
    function getMomentImagesList(momentId){

          var imagePath = Fileutils.getHomePath()+"/"+root.imagesSavingRootPath+"/moments/"+root.targetMomentTitle+"/images";

          var fileList = Fileutils.getMomentImages(imagePath);
          momentsImagesListModel.clear();

          for(var i=0; i<fileList.length; i++) {
              momentsImagesListModel.append( { imageName: fileList[i], imagePath: imagePath, value:i } );
          }
    }

    /*
       Extract the image name from a full url path
    */
    function getImageNameFromPath(url){

        var imageName = url.split("/");
        //console.log("imageName: " + imageName[imageName.length -1]);
        return imageName[imageName.length -1];
    }

    /*
       Utility to remove 'file://' prefix
       return string like this: /home/.cache/moments.fulvio/HubIncoming/<id>
       Where <id> is a numeri identifier of the import
    */
    function getPathFromUrl(url){
        return url.toString().replace("file://", "");
    }

}
