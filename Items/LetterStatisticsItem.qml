import QtQuick

Item
{
    id: root

    property color  backgroundColor
    property color  textColor
    property alias  text: letter.text
    property int    countCorrect
    property int    countWrong

    Rectangle
    {
        id: backgroundRect

        anchors.fill: parent

        color: backgroundColor
        radius: 4

        Text
        {
            id: letter

            anchors.left: parent.left
            anchors.margins: 10
            anchors.verticalCenter: parent.verticalCenter

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: letterText
            font.family: "Helvetica"
            font.pixelSize: 32
            color: textColor
            visible: true
        }

        Rectangle
        {
            anchors.left: letter.left
            anchors.right: parent.right
            anchors.margins: 40
            anchors.verticalCenter: parent.verticalCenter

            height: 20
            radius: 4

            color: "#55e23d"

            Rectangle
            {
                anchors.right: parent.right

                height: 20
                width: parent.width * (countWrong  / (countWrong + countCorrect))
                radius: 4

                color: Qt.darker("#e23d55", 1.2)
            }

            Text
            {
                anchors.centerIn: parent
                anchors.margins: 10

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: Number(countCorrect) + "/" + Number(countWrong)
                font.family: "Helvetica"
                font.pixelSize: 20
                color: backgroundColor
                visible: true
            }
        }
    }
}
