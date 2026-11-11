import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FirstProject

ApplicationWindow {
    readonly property bool isPortrait: height > width
    readonly property bool isCompact: width < Theme.compactBreakpoint
    readonly property bool isMedium: width >= Theme.compactBreakpoint && width < Theme.mediumBreakpoint
    readonly property bool isExpanded: width >= Theme.mediumBreakpoint
    property bool errorOccurred: false

    id: mainWindow
    width: 600
    height: 800
    visible: true
    title: "Calculator QT"
    color: Theme.background
    Row {
        id: debugPanel
        property bool expanded: false

        anchors.top: parent.top
        anchors.right: parent.right
        z: 1
        spacing: 0
        width: debugToggle.width + togglePanelButton.width
        height: 48
        clip: true

        ToolButton {
            id: debugToggle
            width: 44
            height: debugPanel.height
            text: "👾"
            font.pixelSize: 20
            Accessible.name: MathEngine.debugMode ? "Disable debug logging" : "Enable debug logging"
            onClicked: MathEngine.debugMode = !MathEngine.debugMode

            Behavior on width {
                NumberAnimation { duration: 180; easing.type: Easing.InOutCubic }
            }
            Behavior on opacity {
                NumberAnimation { duration: 180 }
            }

            states: State {
                name: "collapsed"
                when: !debugPanel.expanded
                PropertyChanges {
                    target: debugToggle
                    width: 0
                    opacity: 0
                }
            }

            background: Rectangle {
                radius: width / 2
                color: MathEngine.debugMode ? Theme.secondary : Theme.primary
            }
        }

        ToolButton {
            id: togglePanelButton
            width: 22
            height: debugPanel.height
            text: debugPanel.expanded ? "‹" : "›"
            font.pixelSize: 18
            Accessible.name: debugPanel.expanded ? "Hide debug toggle" : "Show debug toggle"
            onClicked: debugPanel.expanded = !debugPanel.expanded

            background: Rectangle {
                id: toggleBackground
                radius: 10
                color: Theme.primary

                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.radius + 1
                    color: parent.color
                }
            }
        }
    }

    GridLayout{
        anchors.fill: parent
        anchors.margins: mainWindow.isCompact ? Theme.pageMarginCompact : Theme.pageMarginExpanded
        columnSpacing: Theme.spaceM
        rowSpacing: Theme.spaceM
        columns: mainWindow.isPortrait ? 1 : 2
        ColumnLayout {
            spacing: 0
            Layout.alignment: Qt.AlignTop
            Layout.fillHeight: mainWindow.isPortrait ? false : true
            TextField {
                id: expressionField
                height: 40
                font.pixelSize: 32
                padding: Theme.spaceS
                placeholderText: "Enter Expression"
                Layout.fillWidth: true
                Layout.fillHeight: mainWindow.isPortrait ? false : true
                horizontalAlignment: Text.AlignRight
                color: Theme.text
                background: Rectangle {
                    color: Theme.input
                    topLeftRadius: Theme.radiusMedium
                    topRightRadius: Theme.radiusMedium
                }
            }
            Label {
                id: resultText
                padding: Theme.spaceS
                text: "Result"
                font.pixelSize: 16
                color: errorOccurred ? '#ff0000' : Theme.textSecondary
                Layout.fillWidth: true
                background: Rectangle {
                    color: Theme.input
                    bottomLeftRadius: Theme.radiusMedium
                    bottomRightRadius: Theme.radiusMedium
                }
            }
        }

        ColumnLayout {
            spacing: Theme.spaceS
            Layout.fillWidth: true
            Layout.fillHeight: true
            RowLayout{
                spacing: Theme.spaceS
                CustomButton {
                    text: "+/-"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: {
                        errorOccurred = false
                        if (expressionField.text.startsWith("-")) {
                            expressionField.text = expressionField.text.slice(1)
                        } else {
                            expressionField.text = "-" + expressionField.text
                        }
                    }
                }
                CustomButton {
                    text: "⌫"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: {
                        errorOccurred = false
                        expressionField.text = expressionField.text.slice(0, -1)
                    }
                }
                AltButton {
                    text: "AC"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: {
                        errorOccurred = false
                        expressionField.text = ""
                        resultText.text = "Result Here"
                    }
                }
                AltButton {
                    text: "="
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: {
                        errorOccurred = false
                        try {
                            const result = MathEngine.eval(expressionField.text)
                            const errorMsg = MathEngine.error()
                            if (errorMsg) {
                                resultText.text = errorMsg
                                errorOccurred = true
                                return
                            }
                            resultText.text = result
                        } catch (error) {
                            resultText.text = "Error: " + error.message
                        }
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
                        CustomButton {
                            text: (index+1).toString()
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            onClicked: {
                                errorOccurred = false
                                expressionField.text += text
                            }
                        }
                    }
                    CustomButton {
                        text: "0"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            errorOccurred = false
                            expressionField.text += text
                        }
                    }
                    CustomButton {
                        text: "."
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            errorOccurred = false
                            expressionField.text += text
                        }
                    }
                    CustomButton {
                        text: Theme.isDarkMode ? "☀️" : "🌙"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            Theme.isDarkMode = !Theme.isDarkMode
                        }
                    }
                }
                ColumnLayout {
                    spacing: Theme.spaceS
                    Layout.fillHeight: true
                    CustomButton {
                        text: "+"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            errorOccurred = false
                            expressionField.text += text
                        }
                    }
                    CustomButton {
                        text: "-"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            errorOccurred = false
                            expressionField.text += text
                        }
                    }
                    CustomButton {
                        text: "*"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            errorOccurred = false
                            expressionField.text += text
                        }
                    }
                    CustomButton {
                        text: "/"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            errorOccurred = false
                            expressionField.text += text
                        }
                    }
                }
            }
        }
    }
}
