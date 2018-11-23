import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0
import Ubuntu.Content 1.3
/* a custom plugin */
import Fileutils 1.0

import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

/* note: alias name must have first letter in upperCase */
import "./js/ValidationUtils.js" as ValidationUtils
import "./js/ScreenUtils.js" as ScreenUtils
import "./js/Storage.js" as Storage

/* import subfolders */
import "./dialog"

/*
   Edit Moment Page for TABLET version
*/
Page{
    id: editMomentPage

    /* passed as input properties. Are the values to edit */
    property string id;
    property string date;
    property string description;
    property string location;
    property string title;
    property string photoList;
    property string tags;

    /* custom signal emitted by OperationResultDialog Componet to notify that user has pressed "Close" button */
    signal operationResultDialogClosed()

    /* callback function for 'operationResultDialogClosed' signal */
    onOperationResultDialogClosed: {
        adaptivePageLayout.removePages(editMomentPage);
    }

    Component {
        id: momentDeleteDialog
        MomentDeleteDialog{momentId:editMomentPage.id; momentTitle:editMomentPage.title}
    }

    header: PageHeader {
        title: i18n.tr("Edit Moment") +": <b>"+editMomentPage.title +"</b>"

        /* the bar on the rigth side */
        trailingActionBar.actions: [

            Action {
                iconName: "delete"
                text: i18n.tr("Delete")
                onTriggered:{
                    PopupUtils.open(momentDeleteDialog)
                }
            }
        ]
    }

    /* A PopUp that display the operation result */
    Component {
        id: errorEditMomentDialogue
        OperationResultDialog{result:i18n.tr("FAILURE") ; msg:i18n.tr("Error editing Moment")}
    }

    Component {
        id: successEditMomentDialogue
        OperationResultDialog{result:i18n.tr("SUCCESS") ; msg:i18n.tr("Moment edited successfully")}
    }

    /* to have a scrollable column when the keyboard cover some input field */
    Flickable {
        id: editMomentFlickable
        clip: true
        contentHeight: ScreenUtils.getContentHeight(editMomentPage.height) - units.gu(20)
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: editMomentPage.bottom
            bottomMargin: units.gu(2)
        }

        Column {
            id: editMomentColumn
            anchors.fill: parent
            spacing: units.gu(3.5)
            anchors.leftMargin: units.gu(2)

            Rectangle{
                color: "transparent"
                width: parent.width
                height: units.gu(6)
            }

            Row{
                anchors.left : parent.left
                spacing: units.gu(6.5)

                Label {
                    id: momentTitleLabel
                    anchors.verticalCenter : momentTitleField.verticalCenter
                    text: "* "+i18n.tr("Title")+":"
                }

                TextField {
                    id: momentTitleField
                    text: editMomentPage.title
                    echoMode: TextInput.Normal
                    inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                    readOnly: false
                    width: units.gu(50)
                }
            }

            Row{
                  spacing: units.gu(1)
                  anchors.left : parent.left

                  Label {
                      id: momentDescriptionLabel
                      anchors.verticalCenter: momentDescriptionField.verticalCenter
                      text: "* "+i18n.tr("Description")+":"
                  }

                  TextArea {
                      id: momentDescriptionField
                      width: units.gu(50)
                      height: units.gu(18)
                      textFormat:TextEdit.RichText
                      inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                      text: editMomentPage.description
                      readOnly: false
                  }
             }

             Row{
                  anchors.left : parent.left
                  spacing: units.gu(3)

                  Label {
                      id: momentLocationLabel
                      anchors.verticalCenter: momentLocationField.verticalCenter
                      text: "* "+i18n.tr("Location")+":"
                  }

                  TextField {
                        id: momentLocationField
                        text: editMomentPage.location
                        echoMode: TextInput.Normal
                        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                        readOnly: false
                        width: units.gu(50)
                    }
              }

              Row{
                    anchors.left : parent.left
                    spacing: units.gu(6)

                    Component {
                          id: popoverDateFromPickerComponent
                          Popover {
                                id: popoverDateFromPicker

                                DatePicker {
                                        id: fromTimePicker
                                        mode: "Days|Months|Years"
                                        minimum: {
                                            var time = new Date()
                                            time.setFullYear('2000')
                                            return time
                                        }
                                        /* when Datepicker is closed, is updated the date shown in the button */
                                        Component.onDestruction: {
                                            momentDateButton.text = Qt.formatDateTime(fromTimePicker.date, "dd MMMM yyyy")
                                        }
                                    }
                                }
                    }

                    Label {
                        id: momentDateLabel
                        anchors.verticalCenter: momentDateButton.verticalCenter
                        text: "* "+i18n.tr("Date")+":"
                    }

                    /* open the popover component with DatePicker */
                    Button {
                         id: momentDateButton
                         text: Qt.formatDateTime(editMomentPage.date, "dd MMMM yyyy")
                         width: units.gu(20)
                         onClicked: {
                            PopupUtils.open(popoverDateFromPickerComponent, momentDateButton)
                         }
                   }
             }

             Row{
                anchors.left : parent.left
                spacing: units.gu(4)

                Label {
                      id: momentPhotoLabel
                      anchors.leftMargin : units.gu(3)
                      anchors.verticalCenter: momentPhotosField.verticalCenter
                      text: "* "+i18n.tr("Photos")+":"
                }

                Button {
                        id: momentPhotosField
                        text: i18n.tr("Edit")+"..."
                        width: units.gu(20)
                        onClicked: {
                             adaptivePageLayout.addPageToNextColumn(editMomentPage, Qt.resolvedUrl("ImageNamesListPage.qml"), { momentTitle:title })
                        }
                 }
             }

             Row{
                 anchors.left : parent.left
                 spacing: units.gu(6)

                 Label {
                      id: momentTagLabel
                      anchors.verticalCenter: momentTagsField.verticalCenter
                      text: "* "+i18n.tr("Tags")+":"
                 }

                 TextField {
                        id: momentTagsField
                        text: editMomentPage.tags
                        placeholderText: i18n.tr("comma separated list")
                        echoMode: TextInput.Normal
                        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                        readOnly: false
                        width: units.gu(50)
                 }
              }

              Row{
                  anchors.horizontalCenter: parent.horizontalCenter

                  Button {
                        id: addSubCategoryButton
                        text: i18n.tr("Update")
                        width: units.gu(20)
                        onClicked: {

                           Storage.updateMoment(momentDateButton.text, momentDescriptionField.text, momentLocationField.text, momentTitleField.text, momentTagsField.text, editMomentPage.id);
                           Storage.getAllMomentsAndFillModel(); /* refresh moments list */
                           /* update page title */
                           editMomentPage.title = momentTitleField.text

                           PopupUtils.open(successEditMomentDialogue);
                        }
                    }
               }

               Row{
                    anchors.horizontalCenter: parent.horizontalCenter

                    Label {
                        id: fieldRequiredLabel
                        text: "* "+i18n.tr("Field required")
                        fontSize: "small"
                    }
              }
         }
    }

    /* To show a scrollbar on the side */
    Scrollbar {
        flickableItem: editMomentFlickable
        align: Qt.AlignTrailing
    }
}
