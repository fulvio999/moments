import QtQuick 2.4

import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.1

import Fileutils 1.0

/* import folder */
import "./dialog"

/*
   Delegate used to display and manage an image associated with a moment.
   The available operation are shown with a Swipe movement.
*/
ListItem {
    id: standardItem

    Label {
        id: label
        verticalAlignment: Text.AlignVCenter
        text: "<b>"+imageName+"</b>"
        height: parent.height
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        id: selectableMouseArea
        anchors.fill: parent
        onClicked: {
            momentPhotoListView.currentIndex = index
        }
    }

    /* Swipe to right movement: delete file */
    leadingActions: ListItemActions {
        actions: [
           Action {
               iconName: "delete"
               onTriggered: {
                   momentPhotoListView.currentIndex = index
                   imageListManagerPage.imageListModelIndex = index
                   imageListManagerPage.targetImageName = momentsImagesListModel.get(index).imageName
                   //var imageToDelete = momentsImagesListModel.get(index).imageName; /* name without path */
                   //var imagePath = Fileutils.getHomePath()+"/"+root.imagesSavingRootPath+"/moments/"+imageListManagerPage.id+"/images/"+imageToDelete;

                   PopupUtils.open(removeImageDialog)

               }
           }
        ]
     }

    /* Swipe to right movement: edit file */
    trailingActions: ListItemActions {
         actions: [
               Action {
                   iconName: "find"
                   onTriggered: {
                        momentPhotoListView.currentIndex = index
                        imageListManagerPage.targetImageName = momentsImagesListModel.get(index).imageName
                        /* show image */
                        PopupUtils.open(imageZoomDialog)
                   }
               }
         ]
    }

}
