import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Items" as Items

Item
{
    id: root

    property color  backgroundColor
    property color  textColor
    property int    id

    signal nextWord()

    function setWord(word)
    {
        lettersModel.clear()
        for (var i = 0; i < word.length; ++i)
        {
            lettersModel.append({"letter": word[i]})
        }
        lettersModel.word = word
        wordTextArea.clear()
        wordTextArea.enabled = true
    }

    function setMeaningWord(meaningWord)
    {
        meaningTextArea.clear()
        meaningTextArea.text = meaningWord
    }

    function enterCheckWordEnabled()
    {
        wordTextArea.catchEnterKey = settingsManager ? settingsManager.checkBoxValue("enterCheckWord") : false
    }

    Rectangle
    {
        id: backgroundRect

        anchors.fill: parent
        color: backgroundColor
    }

    Popup
    {
        id: wrongAnswer

        x: root.width / 2 - wrongAnswer.width / 2
        y: -wrongAnswer.height
        width: 150
        height: 150
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        background: Rectangle
        {
            color: backgroundColor
            border.color: Qt.darker(backgroundColor, 1.2)
            border.width: 2
            radius: 180

            Item
            {
                anchors.centerIn: parent

                Rectangle
                {
                    anchors.centerIn: parent
                    width: 20
                    height: 100
                    color: textColor
                    border.color: textColor
                    border.width: 2
                    radius: 4
                    rotation: 45
                }

                Rectangle
                {
                    anchors.centerIn: parent
                    width: 20
                    height: 100
                    color: textColor
                    border.color: textColor
                    border.width: 2
                    radius: 4
                    rotation: -45
                }
            }
        }

        NumberAnimation on y
        {
            id: wrongAnswerAinmation

            to: root.height / 2 - wrongAnswer.height / 2
            duration: 500
            running: false
            easing.type: Easing.InOutQuad

            onFinished:
            {
                wrongAnswer.close()
                wrongAnswerAinmation.running = false
                wrongAnswer.x = root.width / 2 - wrongAnswer.width / 2
                wrongAnswer.y = -wrongAnswer.height
            }
        }

        function show()
        {
            wrongAnswer.open()
            wrongAnswerAinmation.running = true
        }
    }

    Popup
    {
        id: goodAnswer

        x: root.width / 2 - goodAnswer.width / 2
        y: -goodAnswer.height
        width: 150
        height: 150
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        background: Rectangle
        {
            color: "#55e23d"
            border.color: Qt.darker("#55e23d", 1.2)
            border.width: 2
            radius: 180

            Item
            {
                Rectangle
                {
                    x: 80
                    y: 30
                    width: 20
                    height: 100
                    color: textColor
                    border.color: textColor
                    border.width: 2
                    radius: 4
                    rotation: 45
                }

                Rectangle
                {
                    x: 30
                    y: 60
                    width: 20
                    height: 70
                    color: textColor
                    border.color: textColor
                    border.width: 2
                    radius: 4
                    rotation: -45
                }
            }
        }

        NumberAnimation on y
        {
            id: goodAnswerAnimation

            to: root.height / 2 - goodAnswer.height / 2
            duration: 500
            running: false
            easing.type: Easing.InOutQuad

            onFinished:
            {
                goodAnswer.close()
                goodAnswerAnimation.running = false
                goodAnswer.x = root.width / 2 - goodAnswer.width / 2
                goodAnswer.y = -goodAnswer.height
            }
        }

        function show()
        {
            goodAnswer.open()
            goodAnswerAnimation.running = true
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Items.TextAreaItem
        {
            id: meaningTextArea

            Layout.fillWidth: true
            Layout.fillHeight: true
            backgroundColor: root.backgroundColor
            textColor: root.textColor
            enabledEdit: false
            pointSize: 36
        }

        ListModel
        {
            id: lettersModel

            property string word
        }

        ListView
        {
            id: lettersListView

            cacheBuffer: 50 * lettersListView.count
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: 50
            spacing: 10
            clip: true
            model: lettersModel
            orientation: ListView.Horizontal
            delegate: Items.LetterItem
            {
                required property string letter
                width: 50
                height: 50
                backgroundColor: root.textColor
                textColor: root.backgroundColor
                text: letter
            }
        }

        Items.TextAreaItem
        {
            id: wordTextArea

            Layout.fillWidth: true
            Layout.fillHeight: true
            backgroundColor: root.backgroundColor
            textColor: root.textColor
            pointSize: 36
            placeholderText: qsTr("Enter word")
            catchEnterKey: settingsManager ? settingsManager.checkBoxValue("enterCheckWord") : false

            onEnterKeyСaught:
            {
                checkButtomItem.buttonClicked()
            }
        }

        Items.ButtonItem
        {
            id: checkButtomItem

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 180
            Layout.preferredHeight: 60
            backgroundColor: root.backgroundColor
            textColor: root.textColor
            text: qsTr("CHECK")
            pointSize: 36

            onButtonClicked:
            {
                if (wordTextArea.text.length === 0 || meaningTextArea.text.length === 0)
                    return

                var correctAnswer = true
                if (text === qsTr("CHECK"))
                {
                    if (settingsManager ? settingsManager.checkBoxValue("savingStatistics") : false)
                    {
                        var correctLetters = utils.wordComparisonByLetters(wordTextArea.text, lettersModel.word)
                        for (var i = 0; i < correctLetters.length; ++i)
                        {
                            if (!correctLetters[i])
                                correctAnswer = false
                        }
                        database.inserStatisticsWord(id, correctLetters)
                    }
                    else
                    {
                        correctAnswer = utils.stringComparison(wordTextArea.text, lettersModel.word)
                    }
                }

                if (correctAnswer)
                {
                    if (text === qsTr("NEXT"))
                    {
                        root.nextWord()
                        text = qsTr("CHECK")
                        return;
                    }

                    wordTextArea.enabled = false
                    goodAnswer.show()
                    for (var i = 0; i < lettersListView.count && lettersListView.itemAtIndex(i) !== null; ++i)
                    {
                        lettersListView.itemAtIndex(i).startOpenLetterAnimation()
                    }
                    text = qsTr("NEXT")
                }
                else
                {
                    wrongAnswer.show()
                }
            }
        }
    }
}
