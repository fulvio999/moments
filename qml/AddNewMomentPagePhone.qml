import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0
import Ubuntu.Content 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "./js/ValidationUtils.js" as ValidationUtils
import "./js/ScreenUtils.js" as ScreenUtils
import "./js/Storage.js" as Storage

/* import folder */
import "./dialog"

/*
   Add a new Moment PHONE version
*/
Page {
    id: addNewMomentPage

    /* custom signal emitted by OperationResultDialog Componet to notify that user has pressed "Close" button */
    signal operationResultDialogClosed()

    header: PageHeader {
       title: i18n.tr("Add new moment")
    }

    /* callback function for 'operationResultDialogClosed' signal  */
    onOperationResultDialogClosed: {
       adaptivePageLayout.removePages(addNewMomentPage);
    }

    Component {
        id: missingRequiredFieldDialogue
        OperationResultDialog{isInvalidInput:true; result:i18n.tr("") ; msg:i18n.tr("Invalid Title (empty or invalid characters)")}
    }

    Component {
        id: duplicatedTitleMomentDialogue
        OperationResultDialog{isInvalidInput:true; result:i18n.tr("") ; msg:i18n.tr("Moment title existing, please change it")}
    }

    Component {
        id: errorAddingMomentDialogue
        OperationResultDialog{isInvalidInput:false; result:i18n.tr("FAILURE") ; msg:i18n.tr("Error adding new Moment")}
    }

    Component {
        id: successAddingMomentDialogue
        OperationResultDialog{isInvalidInput:false; result:i18n.tr("SUCCESS") ; msg:i18n.tr("Moment added successfully")}
    }

    Flickable {
        id: newMomentPageFlickable
        clip: true
        contentHeight: ScreenUtils.getContentHeight(addNewMomentPage.height) - units.gu(20)
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: addNewMomentPage.bottom
            bottomMargin: units.gu(2)
        }

        Column {
            id: addNewMomentColumn
            anchors.fill: parent
            spacing: units.gu(3.5)
            anchors.leftMargin: units.gu(2)

            Rectangle{
                color: "transparent"
                width: parent.width
                height: units.gu(6)
            }

            Row{
                id: newMomentRow
                anchors.left : parent.left
                spacing: units.gu(5)

                Label {
                    id: momentTitleLabel
                    anchors.verticalCenter: momentTitleField.verticalCenter
                    text: "* "+i18n.tr("Title")+":"
                }

                TextField {
                    id: momentTitleField
                    text: ""
                    placeholderText: ""
                    echoMode: TextInput.Normal
                    inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                    readOnly: false
                    width: units.gu(33)
                }
             }

             Row{
                 spacing: units.gu(1)
                 anchors.left : parent.left

                  Label {
                      id: momentDescriptionLabel
                      anchors.verticalCenter: momentDescriptionField.verticalCenter
                      text: i18n.tr("Description")+":"
                  }

                  TextArea {
                      id: momentDescriptionField
                      width: units.gu(33)
                      height: units.gu(15)
                      textFormat:TextEdit.RichText
                      inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                      readOnly: false
                  }
             }

             Row{
                  anchors.left : parent.left
                  spacing: units.gu(3)

                  Label {
                      id: momentLocationLabel
                      anchors.verticalCenter: momentLocationField.verticalCenter
                      text: i18n.tr("Location")+":"
                  }

                  TextField {
                        id: momentLocationField
                        text: ""
                        placeholderText: ""
                        echoMode: TextInput.Normal
                        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                        readOnly: false
                        width: units.gu(33)
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
                                        /* when Datepicker is closed updated the date shown in the button */
                                        Component.onDestruction: {
                                            momentDateButton.text = Qt.formatDateTime(fromTimePicker.date, "dd MMMM yyyy")
                                        }
                                    }
                                }
                    }

                    Label {
                        id: momentDateLabel
                        anchors.verticalCenter: momentDateButton.verticalCenter
                        text: i18n.tr("Date")+":"
                    }

                    /* open the popover component with DatePicker */
                    Button {
                         id: momentDateButton
                         text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
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
                      anchors.verticalCenter: momentPhotosField.verticalCenter
                      text: i18n.tr("Photos")+":"
                }

                Button {
                      id: momentPhotosField
                      text: i18n.tr("Choose")+"..."
                      width: units.gu(20)
                      onClicked: {
                         if(ValidationUtils.isInputTextEmpty(momentTitleField.text) || ValidationUtils.hasSpecialChar(momentTitleField.text))
                         {
                            PopupUtils.open(missingRequiredFieldDialogue)

                         }else if (Storage.isMomentDuplicated(momentTitleField.text))
                         {
                            PopupUtils.open(duplicatedTitleMomentDialogue)

                         }else{
                            /* necessary to set the copy destination path for ContentHub */
                            root.targetMomentTitle = momentTitleField.text
                            /* ''-1' means that we are adding a new moment (ie: no images are associated yet) */
                            adaptivePageLayout.addPageToNextColumn(addNewMomentPage, Qt.resolvedUrl("ImageNamesListPage.qml"), { momentTitle:'-1' })
                         }
                      }
                 }
             }

             Row{
                 anchors.left : parent.left
                 spacing: units.gu(6)

                 Label {
                      id: momentTagLabel
                      anchors.verticalCenter: momentTagsField.verticalCenter
                      text: i18n.tr("Tag")+":"
                 }

                 TextField {
                        id: momentTagsField
                        text: ""
                        placeholderText: i18n.tr("comma separated list")
                        echoMode: TextInput.Normal
                        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                        readOnly: false
                        width: units.gu(33)
                  }
              }

              Row{
                   anchors.horizontalCenter: parent.horizontalCenter

                   Button {
                        id: addMomentButton
                        objectName: "Add"
                        text: i18n.tr("Add")
                        width: units.gu(20)
                        onClicked: {

                            if(ValidationUtils.isInputTextEmpty(momentTitleField.text) || ValidationUtils.hasSpecialChar(momentTitleField.text))
                            {
                               PopupUtils.open(missingRequiredFieldDialogue)

                            } else if (Storage.isMomentDuplicated(momentTitleField.text))
                            {
                               PopupUtils.open(duplicatedTitleMomentDialogue)
                            } else {
                               /* necessary to set the copy destination path for ContentHub */
                               root.targetMomentTitle = momentTitleField.text

                               Storage.insertMoment(momentDateButton.text, momentDescriptionField.text, momentLocationField.text, momentTitleField.text, momentTagsField.text);
                               Storage.getAllMomentsAndFillModel(); /* refresh moments list */

                               PopupUtils.open(successAddingMomentDialogue);
                            }
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

    /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: newMomentPageFlickable
        align: Qt.AlignTrailing
    }
}
