import QtQuick
import QtQuick.Effects

Rectangle {
    id: root

    property string text: ""
    signal clicked()

    radius: Theme.radiusMedium
    implicitWidth: textItem.width + Theme.buttonPaddingH * 2
    implicitHeight: textItem.height + Theme.buttonPaddingV * 2

    color: {
        if (mouseArea.pressed) return Theme.tertiary
        if (mouseArea.containsMouse) return Theme.secondary
        return Theme.primary
    }

    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 2
        shadowBlur: 0.4
        shadowColor: "#80000000"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked() // Forward the click to the public signal
    }

    Text {
        id: textItem
        text: root.text
        anchors.centerIn: parent
        color: Theme.text
    }
}
