import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import Fileutils 1.0

import QtQuick.LocalStorage 2.0
import "../js/Storage.js" as Storage


/* Show a Dialog where the user can choose to delete ALL the saved Moments */
Dialog {
    id: dataBaseEraserDialog
    text: "<b>"+ i18n.tr("Remove ALL saved Moments")+" ?"+"<br/>"+i18n.tr("(there is no restore)")+"</b>"

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
                        onClicked: PopupUtils.close(dataBaseEraserDialog)
                    }

                    Button {
                        id: importButton
                        text: i18n.tr("Delete")
                        width: units.gu(12)
                        color: UbuntuColors.red
                        onClicked: {
                            loadingPageActivity.running = true

                            /* delete tables */
                            Storage.cleanAllDatabase();

                            /* remove Moments folder */
                            var folderToRemove = Fileutils.getHomePath()+"/"+root.imagesSavingRootPath+"/moments";
                            Fileutils.deleteMomentFolder(folderToRemove);

                            deleteOperationResult.text = i18n.tr("Succesfully Removed ALL moments data")
                            closeButton.enabled = true

                            /* refresh */
                            Storage.getAllMomentsAndFillModel();
TOGLIERE pagina con miniature !!
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
