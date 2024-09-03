import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Pages" as Pages

ApplicationWindow
{
    width: 450
    height: 800
    visible: true
    title: qsTr("Word Training")

    function updatePageName(currentIndex)
    {
        if (currentIndex === 0)
        {
            pageHeader.text = qsTr("GUESS WORD")
        }
        else if (currentIndex === 1)
        {
            pageHeader.text = qsTr("WORD LIST")
        }
        else if (currentIndex === 2)
        {
            pageHeader.text = qsTr("SETTINGS")
        }
    }

    Popup
    {
        id: errorPopup

        anchors.centerIn: parent
        width: parent.width - 20
        height: 250
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        background: Rectangle
        {
            color: "#e23d55"
            border.color: Qt.darker("#e23d55", 1.2)
            border.width: 2
            radius: 4
        }

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 10

            Text
            {
                Layout.maximumWidth: parent.width
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("THE WORD LIST IS EMPTY!\nPLEASE ADD WORDS")
                font.family: "Helvetica"
                font.pointSize: 24
                color: "#ffffff"
                wrapMode: Text.WordWrap
            }

            Button
            {
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: 180
                Layout.preferredHeight: 60
                flat: true
                down: false

                contentItem: Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("OK")
                    font.family: "Helvetica"
                    font.pointSize: 36
                    color: "#ffffff"
                }

                background: Rectangle
                {
                    color: Qt.darker("#e23d55", 1.1)
                    border.color: Qt.darker("#e23d55", 1.2)
                    border.width: 2
                    radius: 4
                }

                onClicked:
                {
                    errorPopup.close()
                }
            }
        }
    }

    Rectangle
    {
        id: pageHeader

        property alias text: pageName.text

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: 40
        color: Qt.darker("#e23d55", 1.1)

        Text
        {
            id: pageName

            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "Helvetica"
            font.pointSize: 24
            color: "#ffffff"
            wrapMode: Text.WordWrap
        }

        Button
        {
            id: pervPageButton

            anchors.left: parent.left
            width: 60
            height: 40

            contentItem: Text
            {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "←"
                font.family: "Helvetica"
                font.pointSize: 20
                color: "#ffffff"
            }

            background: Rectangle
            {
                color: Qt.darker("#e23d55", 1.1)
            }

            onClicked:
            {
                view.decrementCurrentIndex()
            }
        }

        Button
        {
            id: nextPageButton

            anchors.right: parent.right
            width: 60
            height: 40

            contentItem: Text
            {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "→"
                font.family: "Helvetica"
                font.pointSize: 20
                color: "#ffffff"
            }

            background: Rectangle
            {
                color: Qt.darker("#e23d55", 1.1)
            }

            onClicked:
            {
                view.incrementCurrentIndex()
            }
        }
    }

    SwipeView
    {
        id: view

        anchors.top: pageHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Pages.GuessWordPage
        {
            id: guessWord

            property list<string> data: []
            property int indexData: 0
            backgroundColor: "#e23d55"
            textColor: "#ffffff"

            function updateData()
            {
                data = database.selectWordsFromTable()
                indexData = 0;
                if (data.length === 0)
                {
                    id = -1
                    setWord("")
                    setMeaningWord("")
                }
                else
                {
                    id = data[indexData++]
                    setWord(data[indexData++])
                    setMeaningWord(data[indexData++])
                }
            }

            onNextWord:
            {
                if (indexData < data.length)
                {
                    id = data[indexData++]
                    setWord(data[indexData++])
                    setMeaningWord(data[indexData++])
                }
                else
                {
                    updateData()
                }
            }

            Component.onCompleted:
            {
                updateData()
            }
        }

        Pages.ListWordsPage
        {
            id: listWords

            backgroundColor: "#e23d55"
            textColor: "#ffffff"
        }

        Pages.SettingsPage
        {
            id: settings

            backgroundColor: "#e23d55"
            textColor: "#ffffff"

            Connections
            {
                target: settingsManager
                function onSettingsUpdated(settingType)
                {
                    if (settingType === "randomSequence")
                        guessWord.updateData()
                    else if (settingType === "enterCheckWord")
                        guessWord.enterCheckWordEnabled()
                }
            }
        }

        onCurrentIndexChanged:
        {
            if (currentIndex === 0 && listWords.wordUpdated)
            {
                guessWord.updateData()
                listWords.wordUpdated = false                
            }

            updatePageName(currentIndex)
        }

        Component.onCompleted:
        {
            guessWord.data = database.selectWordsFromTable()
            currentIndex = guessWord.data.length > 0 ? 0 : 1

            if (guessWord.data.length == 0)
                errorPopup.open()

            updatePageName(currentIndex)
        }
    }
}
