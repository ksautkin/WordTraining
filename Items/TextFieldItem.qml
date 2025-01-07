import QtQuick
import QtQuick.Controls

Item
{
    id: root

    property color  backgroundColor
    property color  textColor
    property alias  text: textField.text
    property alias  placeholderText: textField.placeholderText
    property alias  focusTextField: textField.focus
    property int    pointSize


    TextField
    {
        id: textField

        anchors.fill: parent

        font.family: "Helvetica"
        font.pointSize: pointSize
        color: textColor
        placeholderTextColor: Qt.darker(textColor, 1.2)
        background: Rectangle
        {
            color: Qt.darker(backgroundColor, 1.1)
            border.color: textField.focus ? textColor : Qt.darker(backgroundColor, 1.2)
            border.width: 2
            radius: 4
        }
    }
}
