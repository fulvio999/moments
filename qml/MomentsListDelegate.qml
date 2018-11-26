import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import "./js/Storage.js" as Storage

/*
  Delegate Component that display Moments information inside a rectangle:
  - title
  - location
  - date

*/
Component {
    id: momentsListDelegate

    Item {
        id: categoryItem

        width: listView.width
        height: units.gu(12) //heigth of the rectangle

        /* create a container for each Moment */
        Rectangle {
            id: background
            x: 2; y: 2; width: parent.width - x*2; height: parent.height - y*1
            border.color: "black"
            radius: 5
        }

        /* This mouse region covers the entire delegate */
        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent
            onClicked: {

                /* move the highlight component to the currently selected item */
                listView.currentIndex = index

                /* remove pages on the right side */
                adaptivePageLayout.removePages(momentsListPage)
            }
        }

        /* crete a row for each entry in the Model */
        Row {
            id: topLayout
            x: 10; y: 7; height: background.height; width: parent.width
            spacing: units.gu(4)

            Column {
                width: background.width/3 *2.2;
                anchors.verticalCenter: topLayout.Center
                spacing: 1
                Label {
                    text: title
                    fontSize: "large"
                }

                Label {
                    text: i18n.tr("Location")+": " +location
                    fontSize: "medium"
                }

                Label {
                    text: i18n.tr("Date")+": " +date
                    fontSize: "medium"
                }
            }

            /* Moments management functions */
            Column{
                  id: editExpenseColumn
                  anchors.verticalCenter: topLayout.Center
                  spacing: units.gu(1.5)

                  /* --------- EDIT function -------- */
                  Row{
                      Icon {
                            id: editMomentIcon
                            width: units.gu(4)
                            height: units.gu(4)
                            name: "edit"

                            MouseArea {
                                  width: editMomentIcon.width
                                  height: editMomentIcon.height
                                  onClicked: {

                                      /* depending on the root page width decide the page to load */
                                      var editPage = Qt.resolvedUrl("EditMomentPagePhone.qml");

                                      if (root.width > units.gu(80)){
                                          editPage = Qt.resolvedUrl("EditMomentPageTablet.qml");
                                      }

                                      adaptivePageLayout.addPageToNextColumn(momentsListPage, editPage,
                                                                             {
                                                                                 /* <page-variable-name>:<property-value from db> */
                                                                                 id:id,
                                                                                 date:date,
                                                                                 description:description,
                                                                                 location:location,
                                                                                 title:title,
                                                                                 tags:tags
                                                                             }

                                                                             )

                                      /* move the highlight component to the currently selected item */
                                      listView.currentIndex = index
                                  }
                            }
                      }
                  }

                  /* --------- DETAILS function ---------- */
                  Row{
                       Icon {
                            id: showMomentImagesIcon
                            width: units.gu(4)
                            height: units.gu(4)
                            name: "search"

                            MouseArea {
                                width: showMomentImagesIcon.width
                                height: showMomentImagesIcon.height
                                onClicked: {

                                      /* depending on the root page width decide the page to load */
                                      var showImagesPage = Qt.resolvedUrl("ShowImagesPagePhone.qml");

                                      if (root.width > units.gu(80)){
                                          showImagesPage = Qt.resolvedUrl("ShowImagesPageTablet.qml");
                                      }

                                      adaptivePageLayout.addPageToNextColumn(momentsListPage, showImagesPage,
                                                                             {
                                                                                 /* <page-variable-name>:<property-value from db> */
                                                                                 id:id,
                                                                                 //date:date,
                                                                                 //description:description,
                                                                                 //location:location,
                                                                                 title:title
                                                                                 //tags:tags
                                                                             }

                                                                             )

                                      /* move the highlight component to the currently selected item */
                                      listView.currentIndex = index                                    
                                }
                            }
                      }
                  }

            }//second col
        }
    }
}
