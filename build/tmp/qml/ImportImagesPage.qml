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

/*
   When the user want add images to the moment, press the 'Browse' button or '+' button.
   This event display this page, whose content is created by 'ContentPeerPicker' Component with the Apps registered as Pictures providers.

   Pressing 'Browse' button or '+' is raised the signal 'importRequested' handled in Main.qml, where a connection with the ContentHub
   is created.
*/
Page {
    id: importMomentPage

    header: PageHeader {
       title: i18n.tr("Add images")
    }

    /* placeholder */
    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(8)
    }

    /*
       This Component show in the current page a list of Apps that are "Content Sources" for the "content type" provided (eg Pictures)
     */
     ContentPeerPicker {
           id:root
           anchors { fill: parent;  }
           handler: ContentHandler.Source /* to show the Apps registerd as Pictures sources (eg: Gallery, file manager...) */
           contentType: ContentType.Pictures

           onPeerSelected: {
               /* step 1: user has selected from the App list the one as Picture(s) source */
               console.log("-- onPeerSelected event: Pictures source App chosen, starting transfer");
               peer.selectionType = ContentTransfer.Multiple
               peer.request();
               /* user has selected image(s) to import: come back to the previous page */
               adaptivePageLayout.removePages(importMomentPage);
           }

           onCancelPressed: {
               console.log("Cancel pressed, no transfer to perform");
               /* user has presseed 'undo' no transfer to perform, just come back to previous page */
               adaptivePageLayout.removePages(importMomentPage);
           }
    }
}
