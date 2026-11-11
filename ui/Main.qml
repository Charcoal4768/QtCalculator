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
    title: "Fancy Hello World"
    color: Theme.background
    GridLayout{
        anchors.fill: parent
        anchors.margins: mainWindow.isCompact ? Theme.pageMarginCompact : Theme.pageMarginExpanded
        columnSpacing: Theme.spaceM
        rowSpacing: Theme.spaceM
        columns: mainWindow.isPortrait ? 1 : 2
        //just for testing, lets try a text feild and a grid with 9 buttons
        TextField {
            placeholderText: "Enter your name"
            Layout.fillWidth: true
        }
        GridLayout {
            columns: 3
            columnSpacing: Theme.spaceS
            rowSpacing: Theme.spaceS
            Repeater {
                model: 9
                Button {
                    text: "Button " + (index + 1)
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
