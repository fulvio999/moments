import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0
/* custom plugin */
import Fileutils 1.0

import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "./js/Storage.js" as Storage

/* import folder */
import "./dialog"


/*
  Show the list of moment images with a ListItem.
  With swipe movemnt is possbile delete or open the image
*/
Page {
    id: imageListManagerPage

    /* passed as input properties when the Page is added */
    property string momentTitle;

    /* the currently selected image name in the GridView */
    property string targetImageName;
    property string imageListModelIndex;

    Component {
        id: imageZoomDialogue
        ImageZoomDialog{targetImagePath:Fileutils.getHomePath()+"/"+root.imagesSavingRootPath+"/moments/"+imageListManagerPage.momentTitle+"/images/"+imageListManagerPage.targetImageName; imageName: imageListManagerPage.targetImageName}
    }

    Component {
        id: removeImageDialog
        RemoveImageDialog{targetImagePath:Fileutils.getHomePath()+"/"+root.imagesSavingRootPath+"/moments/"+imageListManagerPage.momentTitle+"/images/"+imageListManagerPage.targetImageName; imageListModelIndex: imageListManagerPage.imageListModelIndex}
    }

    header: PageHeader {
       title: i18n.tr("Images found")+": "+momentsImagesListModel.count

       trailingActionBar.actions: [
            Action {
                iconName: "list-add"
                text: i18n.tr("Add")
                onTriggered:{
                     /* emit custom signal 'importRequested' to notify that we want import images so that Connection with contenthub must be start
                        and transfer process started.
                        That signal is handled in ImportImagesPage
                     */
                     root.importRequested()
                     /* add a new image for the selected moment */
                     adaptivePageLayout.addPageToNextColumn(imageListManagerPage, Qt.resolvedUrl("ImportImagesPage.qml"))
                }
            }
        ]
    }

    Component.onCompleted: {
       if(imageListManagerPage.momentTitle !== '-1'){ /* if momentTitle== -1 we are adding a new Moment: no image exist yet */
          console.log("Loading images list for Moment with title: "+imageListManagerPage.momentTitle);
          getMomentImagesList(imageListManagerPage.momentTitle);
       }
    }

    /* show the images associated at the moment */
    UbuntuListView {
        id: momentPhotoListView
        anchors.fill: parent
        anchors.topMargin: units.gu(6) /* amount of space from the above component */
        model: momentsImagesListModel
        delegate: ImageNamesListItem{}
    }

    /*
       Load the images names for the currently selected target moment
    */
    function getMomentImagesList(momentTitle)
    {
        console.log("Loading imaged for moment with momentTitle: "+momentTitle);

        var imagePath = Fileutils.getHomePath()+"/"+root.imagesSavingRootPath+"/moments/"+momentTitle+"/images/";
        console.log("Searching image from path: "+imagePath);
        var fileList = Fileutils.getMomentImages(imagePath);

        momentsImagesListModel.clear();

        for(var i=0; i<fileList.length; i++) {
            console.log("Image name:"+ fileList[i]);
            momentsImagesListModel.append( { imageName: fileList[i], imagePath: imagePath, value:i } );
        }
    }
}
