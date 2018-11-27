import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

/* import folder */
import "./dialog"

/*
  Delegate Component that display an image
*/
Item {
      id: imageItem

      Column{
          spacing:units.gu(1)

          Row{
              Rectangle {
                    id: background
                    radius: 5
                    width: imageGridView.cellWidth - units.gu(1)
                    height: imageGridView.cellHeight - units.gu(1)
                    border.color: "black"

                    Image {
                          id: image
                          anchors.fill: parent
                          anchors.horizontalCenter: parent.horizontalCenter
                          anchors.verticalCenter: parent.verticalCenter
                          width: parent.width //* 0.8
                          height: parent.height //* 0.8
                          source: imagePath+"/"+imageName
                          fillMode: Image.PreserveAspectCrop
                          /* to reduce the amount of image pixel sored, to improve performance on load, NOT the scale of the image */
                          sourceSize.width: 900
                          sourceSize.height: 900
                          asynchronous: true
                    }

                    MouseArea {
                          anchors.fill: parent
                          onClicked: {
                              /* move the item highlight animation to the current item */
                              imageGridView.currentIndex = index
                              showImagesPage.targetImageName = imageName
                              showImagesPage.targetMomentId = id
                          }
                    }
               }
         }

      }
  }
