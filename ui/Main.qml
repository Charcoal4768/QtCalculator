import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
                color: Theme.textSecondary
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
                        expressionField.text = expressionField.text.slice(0, -1)
                    }
                }
                AltButton {
                    text: "AC"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: {
                        expressionField.text = ""
                        resultText.text = "Result"
                    }
                }
                AltButton {
                    text: "="
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: {
                        try {
                            const result = MathEngine.eval(expressionField.text)
                            resultText.text = Number.isFinite(result)
                                ? "Result: " + result
                                : "Error: Invalid expression"
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
                                expressionField.text += text
                            }
                        }
                    }
                    CustomButton {
                        text: "0"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            expressionField.text += text
                        }
                    }
                    CustomButton {
                        text: "00"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
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
                            expressionField.text += text
                        }
                    }
                    CustomButton {
                        text: "-"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            expressionField.text += text
                        }
                    }
                    CustomButton {
                        text: "x"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            expressionField.text += text
                        }
                    }
                    CustomButton {
                        text: "÷"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: {
                            expressionField.text += text
                        }
                    }
                }
            }
        }
    }
}
