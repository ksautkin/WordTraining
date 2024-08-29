import QtQuick
import QtQuick.Controls

Item
{
    id: root

    property color  backgroundColor
    property color  textColor
    property alias  text: contentText.text
    property int    pointSize
    property bool   activate: false

    signal checkActivated()
    signal uncheckActivated()

    CheckBox
    {
        id: checkBox

        checked: true
        checkState: activate ? Qt.Checked : Qt.Unchecked

        contentItem: Text
        {
            id: contentText

            font.family: "Helvetica"
            font.pointSize: pointSize
            color: textColor
            verticalAlignment: Text.AlignVCenter
            leftPadding: checkBox.indicator.width
        }

        indicator: Rectangle
        {
            id: indicator

            y: checkBox.height / 2 - height / 2
            implicitWidth: 25
            implicitHeight: 25

            color: Qt.darker(backgroundColor, 1.1)
            border.color: Qt.darker(backgroundColor, 1.2)
            border.width: 2
            radius: 4

            Rectangle
            {
                anchors.fill: parent
                anchors.margins: 2

                color: textColor
                radius: 4
                visible: checkBox.checkState === Qt.Checked
            }
        }

        onCheckStateChanged:
        {
            if (checkState === Qt.Checked)
                checkActivated()
            else
                uncheckActivated()
        }
    }
}
