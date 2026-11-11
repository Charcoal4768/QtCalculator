import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts 1.15
import FirstProject

ApplicationWindow {
    readonly property bool isPortrait: height > width
    readonly property bool isCompact: width < Theme.compactBreakpoint
    readonly property bool isMedium: width >= Theme.compactBreakpoint && width < Theme.mediumBreakpoint
    readonly property bool isExpanded: width >= Theme.mediumBreakpoint

    id: mainWindow
    width: 600
    height: 800
    visible: true
    title: "Calculator QT"
    color: Theme.background
    GridLayout{
        anchors.fill: parent
        anchors.margins: mainWindow.isCompact ? Theme.pageMarginCompact : Theme.pageMarginExpanded
        columnSpacing: Theme.spaceM
        rowSpacing: Theme.spaceM
        columns: mainWindow.isPortrait ? 1 : 2
        //just for testing, lets try a text feild and a grid with 9 buttons
        ColumnLayout {
            spacing: 0
            TextField {
                id: expressionField
                height: 40
                font.pixelSize: 32
                placeholderText: "Enter Expression"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                color: Theme.text
                background: Rectangle {
                    color: Theme.input
                }
            }
            Rectangle {
                color: Theme.input
                height: 32
                Layout.fillWidth: true
                Text {
                    id: resultText
                    text: "Result"
                    font.pixelSize: 16
                    color: Theme.textSecondary
                    Layout.fillWidth: true
                }
            }
        }
        RowLayout{
            GridLayout {
                columns: 3
                columnSpacing: Theme.spaceS
                rowSpacing: Theme.spaceS
                //digits
                Repeater {
                    model: 9
                    Button {
                        text: (index + 1).toString()
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }
            ColumnLayout {
                spacing: Theme.spaceS
                Button {
                    text: "0"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                }
                Button {
                    text: "="
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Button {
                    id: themeToggleButton
                    text: Theme.isDarkMode ? "Light" : "Dark"
                    onClicked: Theme.isDarkMode = !Theme.isDarkMode
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
