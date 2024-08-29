import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Items" as Items

Item
{
    id: root

    property color  backgroundColor
    property color  textColor

    signal settingsUpdated(string settingType)

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
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("randomSequence", true)
                    database.enableRandomSequence(true)
                    settingsUpdated("randomSequence")
                }

                onUncheckActivated:
                {
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("randomSequence", false)
                    database.enableRandomSequence(false)
                    settingsUpdated("randomSequence")
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
                    settingsUpdated("enterCheckWord")
                }

                onUncheckActivated:
                {
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("enterCheckWord", false)
                    settingsUpdated("enterCheckWord")
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
                    settingsUpdated("savingStatistics")
                }

                onUncheckActivated:
                {
                    if (settingsManager)
                        settingsManager.setCheckBoxValue("savingStatistics", false)
                    settingsUpdated("savingStatistics")
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
