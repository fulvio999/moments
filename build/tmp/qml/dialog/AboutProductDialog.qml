import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/*
   Info about the application
   (To pass arguments to a qml:  var dialog = PopupUtils.open(Qt.resolvedUrl("./ConfirmPhotoDeleteDialog.qml"), photoGrid); )
*/
Dialog {
       id: aboutProductDialogue
       title: i18n.tr("Product Info")
       text: "Moments: "+ i18n.tr("version")+root.appVersion+"<br> "+ i18n.tr("Author")+": "+"Fulvio"+"<br>"+
       i18n.tr("Credits: Mario Guerriero for the base idea")
       Button {
           text:  i18n.tr("Close")
           onClicked: PopupUtils.close(aboutProductDialogue)
       }
}
