import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0
import Ubuntu.Content 1.3

import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "./js/ValidationUtils.js" as ValidationUtils
import "./js/Storage.js" as Storage

/* import folder */
import "./dialog"


/*
   Show saved moments. It is the first page loaded
*/
Page{
    id: momentsListPage

    Component.onCompleted: {
       Storage.getAllMomentsAndFillModel();
    }

    header: PageHeader {
        title: i18n.tr("Moments")

        /* the bar on the left side */
        leadingActionBar.actions: [
            Action {
                id: aboutProductPage
                iconName: "info"
                text: i18n.tr("About")
                onTriggered:{
                    PopupUtils.open(Qt.resolvedUrl("./dialog/AboutProductDialog.qml"))
                }
            },

            Action {
                id: helpPage
                iconName: "help"
                text: i18n.tr("Help")
                onTriggered:{
                    adaptivePageLayout.addPageToNextColumn(momentsListPage, Qt.resolvedUrl("HelpPage.qml"))
                }
            }
        ]

        /* the bar on the rigth side */
        trailingActionBar.actions: [
            Action {
                iconName: "list-add"
                text: i18n.tr("Add")
                onTriggered:{

                    /* depending on the root page width decide the page to load */
                    var addPage = Qt.resolvedUrl("AddNewMomentPagePhone.qml");

                    if (root.width > units.gu(80)){
                        addPage = Qt.resolvedUrl("AddNewMomentPageTablet.qml");
                    }

                    adaptivePageLayout.addPageToNextColumn(momentsListPage, addPage )
                }
            },

            Action {
                iconName: "delete"
                text: i18n.tr("Delete")
                onTriggered:{
                    PopupUtils.open(Qt.resolvedUrl("./dialog/DataBaseEraserDialog.qml"))
                }
            }
        ]
    }


    /* Show saved Moments */
    UbuntuListView {
        id: listView
        anchors.fill: parent
        model: sortedMomentsListModel  //momentsListModel
        delegate: MomentsListDelegate{}

        /* disable the dragging of the model list elements */
        boundsBehavior: Flickable.StopAtBounds
        highlight:
                Component {
                    id: highlightComponent
                    Rectangle {
                        width: units.gu(40); //180;
                        height: 44
                        color: "blue";
                        radius: 2

                        /* show an animation on change ListItem selection */
                        Behavior on y {
                            SpringAnimation {
                                spring: 5
                                damping: 0.1
                            }
                        }
                    }
                }

        focus: true

        /* header for the list. Is declared here, inside at the ListView, to access at the List items width */
        Component{
            id: listHeader
            Item {
                id: listHeaderItem
                width: parent.width
                height: units.gu(24)
                x: 5; y: 8;

                Column{
                    id: col1
                    spacing: units.gu(1)
                    anchors.verticalCenter: parent.verticalCenter

                    /* placeholder */
                    Rectangle {
                        color: "transparent"
                        width: parent.width
                        height: units.gu(5)
                    }

                    Row{
                        id:row1
                        spacing: units.gu(2)

                        TextField{
                            id: searchField
                            placeholderText: i18n.tr("moment to search")
                            width: momentsListPage.width - filterButton.width - units.gu(3)
                            onTextChanged: {
                                if(text.length === 0 ) { /* show all */
                                    Storage.getAllMomentsAndFillModel();
                                    categoryFoundLabel.text = i18n.tr("Total moments found")+": " + listView.count
                                }
                            }
                        }

                        Button{
                            id: filterButton
                            objectName: "Search"
                            width: units.gu(13)
                            text: i18n.tr("Filter")
                            onClicked: {
                                if(searchField.text.length > 0 ) /* do filter */
                                {
                                    Storage.searchMomentsByTagOrTitle(searchField.text);

                                    categoryFoundLabel.text = i18n.tr("Total moments found")+": " + listView.count +" "+i18n.tr("(filtered)")
                                }
                            }
                        }
                    }

                    Row{
                        Label{
                            id: categoryFoundLabel
                            text: i18n.tr("Total moments found")+": " + listView.count
                            font.bold: false
                            font.pointSize: units.gu(1.2)
                        }
                    }
                }
            }
        }

        header: listHeader
    }

    Scrollbar {
        flickableItem: listView
        align: Qt.AlignTrailing
    }
}
