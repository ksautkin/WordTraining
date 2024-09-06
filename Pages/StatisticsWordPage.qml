import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import "../Items" as Items

Item
{
    id: root

    property color          backgroundColor
    property color          textColor
    property int            id
    property string         word
    property list<int>      wordStatistics: []

    signal itemClosed()

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

        Flickable
        {
            clip: true

            Layout.fillWidth: true
            Layout.preferredHeight: root.height - 90
            contentHeight: chart.height + 50 * lettersListView.count + 10 * lettersListView.count

            ColumnLayout
            {
                id: statColumn

                Layout.fillWidth: true
                Layout.preferredHeight: root.height - 90

                ChartView
                {
                    id: chart

                    Layout.preferredWidth: root.width
                    Layout.preferredHeight: root.height / 2

                    antialiasing: true
                    backgroundColor: root.backgroundColor
                    legend.visible: false
                    title: qsTr("STATISTICS")
                    titleColor: textColor
                    titleFont: ({family: "Helvetica", pointSize: 24})

                    PieSeries
                    {
                        id: pieSeries

                        PieSlice
                        {
                            color: Qt.darker(root.backgroundColor, 1.2)
                            borderColor: root.backgroundColor
                            label: Number(wordStatistics[1])
                            labelColor: textColor
                            labelFont: ({family: "Helvetica", pointSize: 16})
                            labelPosition: PieSlice.LabelOutside
                            labelVisible: true
                            value: Number(wordStatistics[1])
                        }

                        PieSlice
                        {
                            color: "#55e23d"
                            borderColor: root.backgroundColor
                            label: Number(wordStatistics[0])
                            labelColor: textColor
                            labelFont: ({family: "Helvetica", pointSize: 16})
                            labelPosition: PieSlice.LabelOutside
                            labelVisible: true
                            value: Number(wordStatistics[0])
                        }
                    }
                }

                ListModel
                {
                    id: lettersModel
                }

                ListView
                {
                    id: lettersListView

                    Layout.fillWidth: true
                    Layout.preferredHeight: 50 * lettersListView.count + 10 * lettersListView.count
                    spacing: 10
                    interactive: false
                    model: lettersModel
                    orientation: ListView.Vertical
                    delegate: Items.LetterStatisticsItem
                    {
                        required property string letter
                        required property int wrong
                        required property int correct

                        width: parent.width - 20
                        height: 50
                        backgroundColor: root.textColor
                        textColor: root.backgroundColor
                        text: letter
                        countWrong: wrong
                        countCorrect: correct
                    }

                    Component.onCompleted:
                    {
                        for (var i = 0, j = 2; i < word.length; i++, j += 2)
                        {
                            lettersModel.append({"letter": word[i], "correct": wordStatistics[j], "wrong": wordStatistics[j + 1]})
                        }
                    }
                }
            }
        }

        Items.ButtonItem
        {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 180
            Layout.preferredHeight: 60
            backgroundColor: root.backgroundColor
            textColor: root.textColor
            text: qsTr("BACK")
            pointSize: 36

            onButtonClicked:
            {
                root.itemClosed()
                root.destroy()
            }
        }
    }
}
