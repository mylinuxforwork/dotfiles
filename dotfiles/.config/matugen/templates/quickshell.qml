import QtQuick

QtObject {
    readonly property string fontFamily: "Fira Sans Semibold"
	<* for name, value in colors *>
		readonly property color {{name}}: "{{value.default.hex}}"
	<* endfor *>
}