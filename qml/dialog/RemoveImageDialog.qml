import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import Fileutils 1.0

import QtQuick.LocalStorage 2.0
import "../js/Storage.js" as Storage

/*
    Show a confirm Dialog where the user can choose if delete the selected image from the filesystem
 */
Dialog {
    id: confirmDeleteImageDialog

    property string targetImagePath; //path with image name
    property string imageListModelIndex;

    text: "<b>"+ i18n.tr("Remove the Image")+" ?"+"<br/></b>"

    Rectangle {
        width: 180;
        height: 50
        Item{
            Column{
                spacing: units.gu(1)

                Row{
                    spacing: units.gu(1)

                    /* placeholder */
                    Rectangle {
                        color: "transparent"
                        width: units.gu(3)
                        height: units.gu(3)
                    }

                    Button {
                        id: closeButton
                        text: i18n.tr("Close")
                        onClicked: PopupUtils.close(confirmDeleteImageDialog)
                    }

                    Button {
                        id: importButton
                        text: i18n.tr("Remove")
                        color: UbuntuColors.red
                        onClicked: {
                             console.log("Removing image: "+targetImagePath);

                             Fileutils.removeImage(targetImagePath);
                             momentsImagesListModel.remove(imageListModelIndex);

                             deleteOperationResult.text = i18n.tr("Image successfully removed")
                             closeButton.enabled = true
                        }
                    }
                }

                Row{
                    Label{
                        id: deleteOperationResult
                    }
                }
            }
        }
    }
}
