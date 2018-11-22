import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/*
   Generic dialog to notify an operation result to the user
*/
Dialog {

    id: operationResultDialog

    /* flag to know that the Dialog was opened due to invalid input */
    property bool isInvalidInput;

    /* the message to display */
    property string msg;

    /* operation result: success, failure */
    property string result;

    title: i18n.tr("Operation Result")

    Component.onCompleted: {
        if(result == 'SUCCESS') {
           messageLabel.color = UbuntuColors.green
        }else{
           messageLabel.color = UbuntuColors.red
        }
    }

    Label{
        id: messageLabel
        text: result+" "+msg
    }

    Button {
        text: i18n.tr("Close")
        onClicked:{
            PopupUtils.close(operationResultDialog)

            /* If Dialog was opened NOT for invalid input, Emit custom signal named 'operationResultDialogClosed' to notify that the Dialog will be closed:
               receivers Components when the signal is emitted can apply some logic (see EditMomentPage)
             */
            if(!isInvalidInput)
              operationResultDialogClosed();
        }
    }
}
