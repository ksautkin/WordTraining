import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import "../Items" as Items

Item
{
    id: root

    property color  backgroundColor
    property color  textColor

    signal wordsImported()

    Rectangle
    {
        id: backgroundRect

        anchors.fill: parent
        color: backgroundColor
    }

    Flickable
    {
        clip: true

        anchors.fill: parent
        anchors.margins: 10
        contentHeight: settingsColumn.height

        ColumnLayout
        {
            id: settingsColumn
            spacing: 10

            anchors.fill: parent

            Text
            {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Settings")
                font.family: "Helvetica"
                font.pointSize: 20
                color: root.textColor
                Layout.fillWidth: true
            }

            Items.CheckBoxItem
            {
                text: qsTr("Random sequence of words")
                backgroundColor: root.backgroundColor
                textColor: root.textColor
                pointSize: 16
                activate: settingsManager ? settingsManager.checkBoxValue("randomSequence") : false
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                onCheckActivated:
                {
                    database.enableRandomSequence(true)
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("randomSequence", true)
                }

                onUncheckActivated:
                {
                    database.enableRandomSequence(false)
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("randomSequence", false)
                }
            }

            Items.CheckBoxItem
            {
                text: qsTr("Checking word after pressing Enter")
                backgroundColor: root.backgroundColor
                textColor: root.textColor
                pointSize: 16
                activate: settingsManager ? settingsManager.checkBoxValue("enterCheckWord") : false
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                onCheckActivated:
                {
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("enterCheckWord", true)
                }

                onUncheckActivated:
                {
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("enterCheckWord", false)
                }
            }

            Items.CheckBoxItem
            {
                text: qsTr("Saving statistics")
                backgroundColor: root.backgroundColor
                textColor: root.textColor
                pointSize: 16
                activate: settingsManager ? settingsManager.checkBoxValue("savingStatistics") : false
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                onCheckActivated:
                {
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("savingStatistics", true)
                }

                onUncheckActivated:
                {
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("savingStatistics", false)
                }
            }

            Text
            {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Import/Export .csv vocabulary file")
                font.family: "Helvetica"
                font.pointSize: 20
                color: root.textColor
                Layout.fillWidth: true
            }

            RowLayout
            {
                id: buttonsRow

                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Items.ButtonItem
                {
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 60
                    backgroundColor: root.backgroundColor
                    textColor: root.textColor
                    text: qsTr("IMPORT")
                    pointSize: 36

                    FileDialog
                    {
                        id: fileDialogImport
                        fileMode: FileDialog.OpenFile
                        title: qsTr("Open file")
                        nameFilters: [ qsTr("Import file (*.csv)") ]

                        onAccepted:
                        {
                            if (database.inserWordsIntoTable(utils.importVocabulary(fileDialogImport.selectedFile)))
                            {
                                wordsImported()
                            }
                        }
                    }

                    onButtonClicked:
                    {
                        fileDialogImport.visible = true
                    }
                }

                Items.ButtonItem
                {
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 60
                    backgroundColor: root.backgroundColor
                    textColor: root.textColor
                    text: qsTr("EXPORT")
                    pointSize: 36

                    FileDialog
                    {
                        id: fileDialogExport
                        fileMode: FileDialog.SaveFile
                        title: qsTr("Save file")
                        nameFilters: [ qsTr("Export file (*.csv)") ]

                        onAccepted:
                        {
                            utils.exportVocabulary(fileDialogExport.selectedFile, database.exportWordsFromTable())
                        }
                    }

                    onButtonClicked:
                    {
                        fileDialogExport.visible = true
                    }
                }
            }

            Text
            {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("About App")
                font.family: "Helvetica"
                font.pointSize: 20
                color: root.textColor
                Layout.fillWidth: true
            }

            Text
            {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("This is just an app for practicing spelling words.")
                font.family: "Helvetica"
                font.pointSize: 16
                color: root.textColor
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Text
            {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Version " + Qt.application.version + "β 2024")
                font.family: "Helvetica"
                font.pointSize: 16
                color: root.textColor
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }
}
