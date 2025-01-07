import QtQuick
import QtTest
import "../../Items" as Items

Item
{
    width: 800
    height: 600

    Items.ButtonItem
    {
        id: buttonItem

        property bool buttonWasClicked: false

        anchors.top: parent.top

        text: qsTr("Checking")
        pointSize: 16
        width: 120
        height: 40

        onButtonClicked:
        {
            buttonWasClicked = true
        }
    }

    TestCase
    {
        name: "testButtonItem"
        when: windowShown

        function test_buttonItem()
        {
            mouseClick(buttonItem)
            verify(buttonItem.buttonWasClicked)
        }
    }

    Items.CheckBoxItem
    {
        id: checkBoxItem

        property bool checkBoxWasActivate: false

        anchors.top: buttonItem.bottom

        text: qsTr("Checking")
        activate: true
        pointSize: 16
        width: 120
        height: 40

        onCheckActivated:
        {
            checkBoxWasActivate = true
        }

        onUncheckActivated:
        {
            checkBoxWasActivate = false
        }
    }

    TestCase
    {
        name: "testCheckBoxItem"
        when: windowShown

        function test_checkBoxItem()
        {
            mouseClick(checkBoxItem)
            verify(!checkBoxItem.checkBoxWasActivate)
            mouseClick(checkBoxItem)
            verify(checkBoxItem.checkBoxWasActivate)
        }
    }

    Items.LetterItem
    {
        id: letterItem

        property bool animationFinished: false

        anchors.top: checkBoxItem.bottom

        width: 50
        height: 50

        onRotationAnimationFinished:
        {
            animationFinished = true
        }
    }

    TestCase
    {
        name: "testLetterItem"
        when: windowShown

        function test_letterItem()
        {
            mouseClick(letterItem)
            wait(1000)
            verify(letterItem.animationFinished)
        }
    }

    Items.TextAreaItem
    {
        id: textAreaItem

        property bool animationFinished: false

        anchors.top: letterItem.bottom

        pointSize: 16
        width: 120
        height: 40
        catchEnterKey: true
    }

    TestCase
    {
        name: "testTextAreaItem"
        when: windowShown

        function test_textAreaItem()
        {
            textAreaItem.focusTextArea = true
            keyClick("H")
            keyClick("e")
            keyClick("l")
            keyClick("l")
            keyClick("o")
            compare(textAreaItem.text, "Hello")
            keyClick(Qt.Key_Return)
            verify(!textAreaItem.focusTextArea)
            textAreaItem.clear()
            verify(textAreaItem.text.length === 0)
        }
    }

    Items.TextFieldItem
    {
        id: textFieldItem

        anchors.top: textAreaItem.bottom

        pointSize: 16
        width: 120
        height: 40
    }

    TestCase
    {
        name: "testTextFieldItem"
        when: windowShown

        function test_textFieldItem()
        {
            textFieldItem.focusTextField = true
            keyClick("H")
            keyClick("e")
            keyClick("l")
            keyClick("l")
            keyClick("o")
            compare(textFieldItem.text, "Hello")
        }
    }
}
