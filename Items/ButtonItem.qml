import QtQuick
import QtQuick.Controls

Item
{
    id: root

    property color  backgroundColor
    property color  textColor
    property alias  text: buttonText.text
    property int    pointSize

    signal buttonClicked()

    Button
    {
        anchors.fill: parent

        flat: true
        down: false

        contentItem: Text
        {
            id: buttonText

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "Helvetica"
            font.pointSize: pointSize
            color: textColor
        }

        background: Rectangle
        {
            color: Qt.darker(backgroundColor, 1.1)
            border.color: Qt.darker(backgroundColor, 1.2)
            border.width: 2
            radius: 4
        }

        onClicked:
        {
            buttonClicked()
        }
    }
}
