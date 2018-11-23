import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import Fileutils 1.0

import QtQuick.LocalStorage 2.0
import "../js/Storage.js" as Storage


/*
   Show a Dialog where the user can choose to delete the selected Moment:
   - delete moment info in the database
   - delete moment images
*/
Dialog {
    id: momentDeleteDialog

    /* info about the moment to delete */
    property string momentId;
    property string momentTitle;

    text: "<b>"+ i18n.tr("Remove the Moment")+" ?"+"<br/>"+i18n.tr("(there is no restore)")+"</b>"

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
                        width: units.gu(12)
                        onClicked: {
                            PopupUtils.close(momentDeleteDialog)

                            /* Emit custom signal named 'operationResultDialogClosed' to notify that the Dialog will be closed:
                               receivers Components when the signal is emitted can apply some logic (see EditMomentPage)
                             */
                            operationResultDialogClosed();
                        }
                    }

                    Button {
                        id: importButton
                        text: i18n.tr("Delete")
                        width: units.gu(12)
                        color: UbuntuColors.red
                        onClicked: {
                            loadingPageActivity.running = true

                            var momentFolder = Fileutils.getHomePath()+"/"+root.imagesSavingRootPath+"/moments/"+momentDeleteDialog.momentTitle;
                            console.log("Deleting moment with id:"+momentId+ " with folder: "+momentFolder);

                            Storage.deleteMoment(momentId);
                            Fileutils.deleteMomentFolder(momentFolder);

                            Storage.getAllMomentsAndFillModel();

                            deleteOperationResult.text = i18n.tr("Succesfully removed Moment")
                            closeButton.enabled = true

                            loadingPageActivity.running = false
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
