import QtQuick

Item
{
    id: root

    property color  backgroundColor
    property color  textColor
    property alias  text: letter.text

    function startOpenLetterAnimation()
    {
        if (letter.opacity === 0.0)
            rotationAnimation.start()
    }

    signal rotationAnimationFinished()

    Rectangle
    {
        id: backgroundRect

        anchors.fill: parent

        color: backgroundColor
        radius: 4

        Text
        {
            id: letter

            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.family: "Helvetica"
            font.pixelSize: 32
            color: textColor
            opacity: 0.0
            visible: true
        }

        transform:
        [
            Rotation
            {
                id: yRotation

                origin.x: backgroundRect.width / 2
                origin.y: backgroundRect.height / 2
                axis { x: 0; y: 1; z: 0 }
            }
        ]

        SequentialAnimation
        {
            id: rotationAnimation

            NumberAnimation
            {
                target: yRotation
                property: "angle"
                from: 180; to: 0
                duration: 500
            }

            PropertyAnimation
            {
                target: letter
                property: "opacity"
                from: 0; to: 1
                duration: 250
            }

            onFinished:
            {
                rotationAnimationFinished()
            }
        }

        MouseArea
        {
            anchors.fill: parent

            onClicked:
            {
                startOpenLetterAnimation()
            }
        }
    }
}
