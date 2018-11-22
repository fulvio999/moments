import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/*
   Zoom the selected image from the moment images list
*/
Dialog {
       id: imageZoomDialog

       /* the image to display */
       property string targetImageName;

       text: "<b>"+ i18n.tr("Image")+": "+ targetImageName+" ("+i18n.tr("tap to close")+")"
       contentHeight : root.height - units.gu(2);
       contentWidth : root.width - units.gu(2);

       Rectangle {
            id: conteiner
            width: root.width - units.gu(1);
            height: imageZoomDialog.height - units.gu(1);
            border.color: "black"

            Image {
                id: targetImage
                source: targetImageName
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    PopupUtils.close(imageZoomDialog)
                }
            }
       }
   }
