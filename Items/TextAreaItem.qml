import QtQuick
import QtQuick.Controls

Item
{
    id: root

    property color  backgroundColor
    property color  textColor
    property alias  text: textArea.text
    property alias  placeholderText: textArea.placeholderText
    property int    pointSize
    property bool   catchEnterKey: false

    signal enterKeyСaught()

    function clear()
    {
        textArea.clear()
    }

    Flickable
    {
        anchors.fill: parent

        clip: true
        flickableDirection: Flickable.VerticalFlick
        ScrollBar.vertical: ScrollBar {}
        ScrollBar.horizontal: null

        TextArea.flickable: TextArea
        {
            id: textArea

            inputMethodHints: Qt.ImhSensitiveData
            wrapMode: TextEdit.WrapAnywhere
            font.family: "Helvetica"
            font.pointSize: pointSize
            color: textColor
            placeholderTextColor: Qt.darker(textColor, 1.2)
            background: Rectangle
            {
                color: Qt.darker(backgroundColor, 1.1)
                border.color: textArea.focus ? textColor : Qt.darker(backgroundColor, 1.2)
                border.width: 2
                radius: 4
            }

            Keys.onPressed:  (event)=>
            {
                if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && (catchEnterKey === true))
                {
                    event.accepted = true
                    enterKeyСaught()
                    focus = false
                }
            }
        }
    }
}
