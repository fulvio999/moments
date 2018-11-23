import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0
import Ubuntu.Components.ListItems 1.3 as ListItem

/*
  Help page
*/
Page {
     id: helpPage

     header: PageHeader {
        title: i18n.tr("Help Page")
     }

     Column {

        id: helpPageColumn
        anchors.fill: parent
        spacing: units.gu(2)
        anchors.leftMargin: units.gu(2)

        property color linkColor: "blue"
        property string website : "http://www.xe.com/iso4217.php"

        function colorLinks(text) {
            return text.replace(/<a(.*?)>(.*?)</g, "<a $1><font color=\"" + linkColor + "\">$2</font><")
        }

        Rectangle{
            color: "transparent"
            width: parent.width
            height: units.gu(6)
        }

        Row{
            id: amountRow
            spacing: units.gu(4)

            TextArea {
                id: noteTextArea
                width: helpPageColumn.width
                height: helpPageColumn.height
                textFormat:TextEdit.RichText
                text: i18n.tr("With Moments you can group your pictures, images by Moments, periods of you life")+"<br>"+
                i18n.tr("(Example: marriage, holidays, party).")+"<br><br"+
                i18n.tr("Note: the images imported must be placed on the local device, not on remote sources")+"<br><br>"+
                i18n.tr("When an image is deleted, is removed the one managed by the App, NOT other copy in the device filesystem (if any)")
                readOnly: true
            }
         }
    }

}
