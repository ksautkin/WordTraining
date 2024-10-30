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
                text: qsTr("NEED CSV FORMAT!")
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

            ColumnLayout
            {
                id: buttonsRow

                spacing: 10

                Items.ButtonItem
                {
                    Layout.fillWidth: true
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

                        onAccepted:
                        {
                            if (utils.checkFileFormat(fileDialogImport.selectedFile, "csv"))
                            {
                                if (database.inserWordsIntoTable(utils.importVocabulary(fileDialogImport.selectedFile)))
                                {
                                    wordsImported()
                                }
                            }
                            else
                            {
                                errorPopup.open()
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
                    Layout.fillWidth: true
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

                        onAccepted:
                        {
                            if (utils.checkFileFormat(fileDialogExport.selectedFile, "csv"))
                            {
                                utils.exportVocabulary(fileDialogExport.selectedFile, database.exportWordsFromTable())
                            }
                            else
                            {
                                errorPopup.open()
                            }
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
