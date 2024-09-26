import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Items" as Items
import "../Pages" as Pages

Item
{
    id: root

    property color  backgroundColor
    property color  textColor
    property bool   wordUpdated: false

    signal openSubPage(string subPageName)

    function onUpdateWord(id, word, meaningWord)
    {
        database.updateWordInTable(id, word, meaningWord)
        wordsModel.updateModel()
        wordUpdated = true
    }

    function onAddWord(word, meaningWord)
    {
        database.inserWordIntoTable(word, meaningWord)
        wordsModel.updateModel()
        wordUpdated = true
    }

    function onDeleteWord(id)
    {
        database.deleteWordFromTable(id)
        wordsModel.updateModel()
        wordUpdated = true
    }

    function onItemClosed()
    {
        root.openSubPage(qsTr("WORD LIST"))
    }

    function onStatisticsWordPageOpen()
    {
        root.openSubPage(qsTr("STATISTICS"))
    }

    function onStatisticsWordPageClosed()
    {
        root.openSubPage(qsTr("EDIT WORD"))
    }

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

        RowLayout
        {
            Items.TextFieldItem
            {
                id: searchWordTextField

                Layout.fillWidth: true
                Layout.preferredHeight: 40
                backgroundColor: root.backgroundColor
                textColor: root.textColor
                pointSize: 16
                placeholderText: qsTr("Search word")
            }

            Items.ButtonItem
            {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                backgroundColor: root.backgroundColor
                textColor: root.textColor
                text: qsTr("SEARCH")
                pointSize: 16

                onButtonClicked:
                {
                    if (searchWordTextField.text.length > 0)
                    {
                        for (var i = 0; i < wordsModel.count(); ++i)
                        {
                            if (utils.stringComparison(wordsModel.getWord(i), searchWordTextField.text))
                            {
                                listView.positionViewAtIndex(i, ListView.Beginning)
                                listView.itemAtIndex(i).startFoundAnimation()
                                break;
                            }
                        }
                    }
                }
            }

            Items.ButtonItem
            {
                Layout.preferredWidth: 60
                Layout.preferredHeight: 40
                backgroundColor: root.backgroundColor
                textColor: root.textColor
                text: qsTr("ADD")
                pointSize: 16

                onButtonClicked:
                {
                    var component = Qt.createComponent("WordEditorPage.qml");
                    var object = component.createObject(root,
                                                        {
                                                            "backgroundColor": "#e23d55",
                                                            "textColor": "#ffffff",
                                                            "addWordModeEnabled": true
                                                        });
                    object.anchors.fill = root
                    object.wordAdded.connect(onAddWord)
                    object.itemClosed.connect(onItemClosed)

                    root.openSubPage(qsTr("ADD WORD"))
                }
            }
        }

        ListView
        {
            id: listView

            anchors.margins: 10
            spacing: 10

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: wordsModel

            delegate: Rectangle
            {
                id: wordDelegate

                width: listView.width
                height: 40

                color: Qt.darker(backgroundColor, 1.1)
                border.color: Qt.darker(backgroundColor, 1.2)
                border.width: 2
                radius: 4

                function startFoundAnimation()
                {
                    findingAnimation.start()
                }

                SequentialAnimation
                {
                    id: findingAnimation

                    PropertyAnimation
                    {
                        target: wordDelegate
                        property: "border.color"
                        from: Qt.darker(backgroundColor, 1.2); to: textColor
                        duration: 500
                    }

                    PropertyAnimation
                    {
                        target: wordDelegate
                        property: "border.color"
                        from: textColor; to: Qt.darker(backgroundColor, 1.2)
                        duration: 500
                    }
                }

                Text
                {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: wordDelegate.width - 20
                    height: wordDelegate.height
                    text: word
                    font.family: "Helvetica"
                    font.pointSize: 20
                    color: textColor
                    elide: Label.ElideRight
                }

                MouseArea
                {
                    anchors.fill: parent

                    onClicked:
                    {
                        var component = Qt.createComponent("WordEditorPage.qml");
                        var object = component.createObject(root,
                                                            {
                                                                "backgroundColor": "#e23d55",
                                                                "textColor": "#ffffff",
                                                                "addWordModeEnabled": false,
                                                                "id": id,
                                                                "word": word,
                                                                "meaningWord": meaningWord
                                                            });
                        object.anchors.fill = root
                        object.wordUpdated.connect(onUpdateWord)
                        object.wordDeleted.connect(onDeleteWord)
                        object.itemClosed.connect(onItemClosed)
                        object.statisticsWordPageOpen.connect(onStatisticsWordPageOpen)
                        object.statisticsWordPageClosed.connect(onStatisticsWordPageClosed)

                        root.openSubPage(qsTr("EDIT WORD"))
                    }
                }
            }
        }
    }
}
