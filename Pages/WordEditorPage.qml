import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Items" as Items

Item
{
    id: root

    property color      backgroundColor
    property color      textColor
    property bool       addWordModeEnabled: false
    property int        id
    property string     word
    property string     meaningWord

    signal wordAdded(string word, string meaningWord)
    signal wordUpdated(int id, string word, string meaningWord)
    signal wordDeleted(int id)
    signal itemClosed()
    signal statisticsWordPageOpen()
    signal statisticsWordPageClosed()

    Rectangle
    {
        id: backgroundRect

        anchors.fill: parent
        color: backgroundColor
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Items.TextAreaItem
        {
            id: wordTextArea

            Layout.fillWidth: true
            Layout.fillHeight: true
            backgroundColor: root.backgroundColor
            textColor: root.textColor
            text: root.word
            pointSize: 36
            placeholderText: qsTr("Enter word")
        }

        Items.TextAreaItem
        {
            id: meaningTextArea

            Layout.fillWidth: true
            Layout.fillHeight: true
            backgroundColor: root.backgroundColor
            textColor: root.textColor
            text: meaningWord
            pointSize: 36
            placeholderText: qsTr("Enter meaning")
        }

        Items.ButtonItem
        {
            id: statisticsButtomItem

            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            backgroundColor: root.backgroundColor
            textColor: root.textColor
            text: qsTr("STATISTICS")
            pointSize: 36
            visible: !addWordModeEnabled && (settingsManager ? settingsManager.checkBoxValue("savingStatistics") : false)
            property var object

            onButtonClicked:
            {
                var component = Qt.createComponent("StatisticsWordPage.qml");
                object = component.createObject(root,
                                                {
                                                    "backgroundColor": "#e23d55",
                                                    "textColor": "#ffffff",
                                                    "id": id,
                                                    "word": word,
                                                    "wordStatistics": database.statisticsWord(id)
                                                });
                object.anchors.fill = root

                object.itemClosed.connect(statisticsWordPageClosed)

                root.statisticsWordPageOpen()
            }

            Connections
            {
                target: settingsManager
                function onSettingsUpdated(settingType)
                {
                    if (settingType === "savingStatistics")
                    {
                        statisticsButtomItem.visible = settingsManager.checkBoxValue("savingStatistics")
                        if (!settingsManager.checkBoxValue("savingStatistics") && statisticsButtomItem.object)
                        {
                            statisticsButtomItem.object.destroy()
                            root.statisticsWordPageClosed()
                        }
                    }
                }
            }
        }

        Flickable
        {
            Layout.fillWidth: true
            Layout.preferredHeight: buttonsRow.height
            clip: true

            contentWidth: buttonsRow.width

            RowLayout
            {
                id: buttonsRow

                spacing: 10

                Items.ButtonItem
                {
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 60
                    backgroundColor: root.backgroundColor
                    textColor: root.textColor
                    text: addWordModeEnabled ? qsTr("ADD") : qsTr("APPLY")
                    pointSize: 36

                    onButtonClicked:
                    {
                        if (wordTextArea.text.length === 0 || meaningTextArea.text.length === 0)
                            return

                        if (addWordModeEnabled)
                            root.wordAdded(wordTextArea.text, meaningTextArea.text)
                        else
                            root.wordUpdated(id, wordTextArea.text, meaningTextArea.text)

                        root.itemClosed()
                        root.destroy()
                    }
                }

                Items.ButtonItem
                {
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 60
                    visible: !addWordModeEnabled
                    backgroundColor: root.backgroundColor
                    textColor: root.textColor
                    text: qsTr("DELETE")
                    pointSize: 36

                    onButtonClicked:
                    {
                        if (wordTextArea.text.length === 0 || meaningTextArea.text.length === 0)
                            return

                        root.wordDeleted(id)
                        root.destroy()
                    }
                }

                Items.ButtonItem
                {
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 60
                    backgroundColor: root.backgroundColor
                    textColor: root.textColor
                    text: qsTr("CANCEL")
                    pointSize: 36

                    onButtonClicked:
                    {
                        root.itemClosed()
                        root.destroy()
                    }
                }
            }
        }
    }
}
