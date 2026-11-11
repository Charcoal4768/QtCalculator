pragma Singleton
import QtQuick

QtObject {
    property bool isDarkMode: false

    readonly property color background: isDarkMode ? "#2c2a2a" : "#F9F7F7"
    readonly property color primary: isDarkMode ? "#325b8e" : "#3F72AF"
    readonly property color secondary: isDarkMode ? "#0f77f5" : "#005bcb"
    readonly property color tertiary: isDarkMode ? "#1A3263" : "#112D4E"
    readonly property color text: isDarkMode ? "#efefef" : "#000000"

    readonly property int spaceXS: 4      // Tight gaps (icon-to-text, compact badges)
    readonly property int spaceS: 8       // Standard element spacing (form inputs, list items)
    readonly property int spaceM: 16      // Default component padding (cards, buttons, dialogs)
    readonly property int spaceL: 24      // Section spacing (between distinct UI groups)
    readonly property int spaceXL: 32     // Page margins on larger screens

    readonly property int buttonPaddingH: 16
    readonly property int buttonPaddingV: 8
    readonly property int cardPadding: 16
    readonly property int pageMarginCompact: 16
    readonly property int pageMarginExpanded: 24

    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 8
    readonly property int radiusLarge: 12
    readonly property int borderWidth: 1

    readonly property int compactBreakpoint: 600
    readonly property int mediumBreakpoint: 900
}
