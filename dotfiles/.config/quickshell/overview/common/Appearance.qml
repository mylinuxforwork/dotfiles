pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "functions"
import "." as Common

Singleton {
    id: root
    property string colorSource: Common.Config.options.appearance.colorSource
    property string caelestiaAccentProfile: Common.Config.options.appearance.caelestia.accentProfile
    property string lastCaelestiaPayload: ""
    property QtObject m3colors: {
        if (colorSource === "matugen" && matugenLoader.item)
            return matugenLoader.item;
        if (colorSource === "caelestia" && caelestiaPaletteLoaded)
            return caelestiaColors;
        return defaultColors;
    }
    property QtObject animation
    property QtObject animationCurves
    property QtObject colors
    property QtObject rounding
    property QtObject font
    property QtObject sizes
    property bool caelestiaPaletteLoaded: false

    Loader {
        id: matugenLoader
        active: root.colorSource === "matugen"
        source: "Appearance.colors.qml"
    }

    property QtObject defaultColors: QtObject {
        property bool darkmode: true
        property color m3primary: "#E5B6F2"
        property color m3onPrimary: "#452152"
        property color m3primaryContainer: "#5D386A"
        property color m3onPrimaryContainer: "#F9D8FF"
        property color m3secondary: "#D5C0D7"
        property color m3onSecondary: "#392C3D"
        property color m3secondaryContainer: "#534457"
        property color m3onSecondaryContainer: "#F2DCF3"
        property color m3background: "#161217"
        property color m3onBackground: "#EAE0E7"
        property color m3surface: "#161217"
        property color m3surfaceContainerLow: "#1F1A1F"
        property color m3surfaceContainer: "#231E23"
        property color m3surfaceContainerHigh: "#2D282E"
        property color m3surfaceContainerHighest: "#383339"
        property color m3onSurface: "#EAE0E7"
        property color m3surfaceVariant: "#4C444D"
        property color m3onSurfaceVariant: "#CFC3CD"
        property color m3inverseSurface: "#EAE0E7"
        property color m3inverseOnSurface: "#342F34"
        property color m3outline: "#988E97"
        property color m3outlineVariant: "#4C444D"
        property color m3shadow: "#000000"
    }

    property QtObject caelestiaColors: QtObject {
        property bool darkmode: defaultColors.darkmode
        property color m3primary: defaultColors.m3primary
        property color m3onPrimary: defaultColors.m3onPrimary
        property color m3primaryContainer: defaultColors.m3primaryContainer
        property color m3onPrimaryContainer: defaultColors.m3onPrimaryContainer
        property color m3secondary: defaultColors.m3secondary
        property color m3onSecondary: defaultColors.m3onSecondary
        property color m3secondaryContainer: defaultColors.m3secondaryContainer
        property color m3onSecondaryContainer: defaultColors.m3onSecondaryContainer
        property color m3background: defaultColors.m3background
        property color m3onBackground: defaultColors.m3onBackground
        property color m3surface: defaultColors.m3surface
        property color m3surfaceContainerLow: defaultColors.m3surfaceContainerLow
        property color m3surfaceContainer: defaultColors.m3surfaceContainer
        property color m3surfaceContainerHigh: defaultColors.m3surfaceContainerHigh
        property color m3surfaceContainerHighest: defaultColors.m3surfaceContainerHighest
        property color m3onSurface: defaultColors.m3onSurface
        property color m3surfaceVariant: defaultColors.m3surfaceVariant
        property color m3onSurfaceVariant: defaultColors.m3onSurfaceVariant
        property color m3inverseSurface: defaultColors.m3inverseSurface
        property color m3inverseOnSurface: defaultColors.m3inverseOnSurface
        property color m3outline: defaultColors.m3outline
        property color m3outlineVariant: defaultColors.m3outlineVariant
        property color m3shadow: defaultColors.m3shadow
    }

    function loadCaelestiaPalette() {
        getCaelestiaScheme.running = true;
    }

    function relativeLuminance(color) {
        const c = Qt.color(color);
        function channel(v) {
            return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
        }
        return (0.2126 * channel(c.r)) + (0.7152 * channel(c.g)) + (0.0722 * channel(c.b));
    }

    function bestOnColor(backgroundColor) {
        return relativeLuminance(backgroundColor) > 0.5 ? "#121212" : "#f5f5f5";
    }

    function firstColor(palette, keys, fallback) {
        for (const key of keys) {
            if (palette[key])
                return palette[key];
        }
        return fallback;
    }

    function applyCaelestiaPalette(palette, mode) {
        if (caelestiaAccentProfile === "vibrant") {
            const primary = firstColor(palette, ["blue", "klink", "term12", "primary"], defaultColors.m3primary);
            const secondary = firstColor(palette, ["mauve", "lavender", "term13", "secondary"], defaultColors.m3secondary);
            const tertiary = firstColor(palette, ["pink", "rosewater", "term11", "tertiary"], defaultColors.m3secondaryContainer);
            const primaryContainer = firstColor(palette, ["sapphire", "klinkSelection", "primaryContainer"], defaultColors.m3primaryContainer);
            const secondaryContainer = firstColor(palette, ["surface2", "secondaryContainer"], defaultColors.m3secondaryContainer);

            caelestiaColors.m3primary = primary;
            caelestiaColors.m3onPrimary = bestOnColor(primary);
            caelestiaColors.m3primaryContainer = primaryContainer;
            caelestiaColors.m3onPrimaryContainer = bestOnColor(primaryContainer);
            caelestiaColors.m3secondary = secondary;
            caelestiaColors.m3onSecondary = bestOnColor(secondary);
            caelestiaColors.m3secondaryContainer = secondaryContainer;
            caelestiaColors.m3onSecondaryContainer = bestOnColor(secondaryContainer);
            // Preserve a stronger accent presence across UI mixes.
            caelestiaColors.m3surfaceVariant = firstColor(palette, ["surface1", "surfaceVariant"], defaultColors.m3surfaceVariant);
            caelestiaColors.m3outline = firstColor(palette, ["overlay2", "outline"], defaultColors.m3outline);
            caelestiaColors.m3outlineVariant = firstColor(palette, ["overlay0", "outlineVariant"], defaultColors.m3outlineVariant);
            if (tertiary)
                caelestiaColors.m3secondaryContainer = ColorUtils.mix(secondaryContainer, tertiary, 0.7);
        } else {
            const map = {
                "primary": "m3primary",
                "onPrimary": "m3onPrimary",
                "primaryContainer": "m3primaryContainer",
                "onPrimaryContainer": "m3onPrimaryContainer",
                "secondary": "m3secondary",
                "onSecondary": "m3onSecondary",
                "secondaryContainer": "m3secondaryContainer",
                "onSecondaryContainer": "m3onSecondaryContainer",
                "surfaceVariant": "m3surfaceVariant",
                "outline": "m3outline",
                "outlineVariant": "m3outlineVariant"
            };
            for (const key in map) {
                if (palette[key])
                    caelestiaColors[map[key]] = palette[key];
            }
        }

        // Keep foundational tones from Material keys for readability.
        const baseMap = {
            "background": "m3background",
            "onBackground": "m3onBackground",
            "surface": "m3surface",
            "surfaceContainerLow": "m3surfaceContainerLow",
            "surfaceContainer": "m3surfaceContainer",
            "surfaceContainerHigh": "m3surfaceContainerHigh",
            "surfaceContainerHighest": "m3surfaceContainerHighest",
            "onSurface": "m3onSurface",
            "inverseSurface": "m3inverseSurface",
            "inverseOnSurface": "m3inverseOnSurface",
            "shadow": "m3shadow"
        };
        for (const key in baseMap) {
            if (palette[key])
                caelestiaColors[baseMap[key]] = palette[key];
        }

        if (palette["onSurfaceVariant"])
            caelestiaColors.m3onSurfaceVariant = palette["onSurfaceVariant"];

        if (mode === "light")
            caelestiaColors.darkmode = false;
        else if (mode === "dark")
            caelestiaColors.darkmode = true;
    }

    Process {
        id: getCaelestiaScheme
        command: ["sh", "-lc", "caelestia scheme get 2>/dev/null || true"]
        stdout: StdioCollector {
            id: caelestiaCollector
            onStreamFinished: {
                const text = caelestiaCollector.text;
                if (!text || !text.trim()) {
                    root.caelestiaPaletteLoaded = false;
                    return;
                }

                const ansiPattern = /\x1b\[[0-9;]*m/g;
                const lines = text.split("\n");
                let mode = "";
                const palette = ({});

                for (const rawLine of lines) {
                    const line = rawLine.replace(ansiPattern, "").trim();

                    if (line.startsWith("Mode:")) {
                        mode = line.split(":")[1]?.trim()?.toLowerCase() ?? "";
                        continue;
                    }

                    const match = line.match(/^([A-Za-z0-9_]+):\s*.*?([0-9a-fA-F]{6})$/);
                    if (!match)
                        continue;

                    palette[match[1]] = `#${match[2]}`;
                }

                const normalized = JSON.stringify({ mode: mode, palette: palette, profile: caelestiaAccentProfile });
                if (normalized === root.lastCaelestiaPayload)
                    return;

                root.lastCaelestiaPayload = normalized;
                applyCaelestiaPalette(palette, mode);
                root.caelestiaPaletteLoaded = Object.keys(palette).length > 0;
            }
        }
    }

    Timer {
        id: caelestiaRefreshTimer
        interval: Math.max(500, Common.Config.options.appearance.caelestia.refreshInterval)
        running: root.colorSource === "caelestia" && Common.Config.options.appearance.caelestia.autoRefresh
        repeat: true
        triggeredOnStart: false
        onTriggered: root.loadCaelestiaPalette()
    }

    onColorSourceChanged: {
        if (colorSource === "caelestia")
            loadCaelestiaPalette();
    }

    onCaelestiaAccentProfileChanged: {
        if (colorSource === "caelestia") {
            root.lastCaelestiaPayload = "";
            loadCaelestiaPalette();
        }
    }

    Component.onCompleted: {
        if (colorSource === "caelestia")
            loadCaelestiaPalette();
    }

    colors: QtObject {
        property color colSubtext: m3colors.m3outline
        property color colLayer0: m3colors.m3background
        property color colOnLayer0: m3colors.m3onBackground
        property color colLayer0Border: ColorUtils.mix(root.m3colors.m3outlineVariant, colLayer0, 0.4)
        property color colLayer1: m3colors.m3surfaceContainerLow
        property color colOnLayer1: m3colors.m3onSurfaceVariant
        property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45)
        property color colLayer1Hover: ColorUtils.mix(colLayer1, colOnLayer1, 0.92)
        property color colLayer1Active: ColorUtils.mix(colLayer1, colOnLayer1, 0.85)
        property color colLayer2: m3colors.m3surfaceContainer
        property color colOnLayer2: m3colors.m3onSurface
        property color colLayer2Hover: ColorUtils.mix(colLayer2, colOnLayer2, 0.90)
        property color colLayer2Active: ColorUtils.mix(colLayer2, colOnLayer2, 0.80)
        property color colPrimary: m3colors.m3primary
        property color colOnPrimary: m3colors.m3onPrimary
        property color colSecondary: m3colors.m3secondary
        property color colSecondaryContainer: m3colors.m3secondaryContainer
        property color colOnSecondaryContainer: m3colors.m3onSecondaryContainer
        property color colTooltip: m3colors.m3inverseSurface
        property color colOnTooltip: m3colors.m3inverseOnSurface
        property color colShadow: ColorUtils.transparentize(m3colors.m3shadow, 0.7)
        property color colOutline: m3colors.m3outline
    }

    rounding: QtObject {
        property int unsharpen: Common.Config.options.appearance.rounding.unsharpen
        property int verysmall: Common.Config.options.appearance.rounding.verysmall
        property int small: Common.Config.options.appearance.rounding.small
        property int normal: Common.Config.options.appearance.rounding.normal
        property int large: Common.Config.options.appearance.rounding.large
        property int full: Common.Config.options.appearance.rounding.full
        property int screenRounding: Common.Config.options.appearance.rounding.screenRounding
        property int windowRounding: Common.Config.options.appearance.rounding.windowRounding
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: Common.Config.options.appearance.font.family.main
            property string title: Common.Config.options.appearance.font.family.title
            property string expressive: Common.Config.options.appearance.font.family.expressive
        }
        property QtObject pixelSize: QtObject {
            property int smaller: Common.Config.options.appearance.font.pixelSize.smaller
            property int small: Common.Config.options.appearance.font.pixelSize.small
            property int normal: Common.Config.options.appearance.font.pixelSize.normal
            property int larger: Common.Config.options.appearance.font.pixelSize.larger
            property int huge: Common.Config.options.appearance.font.pixelSize.huge
        }
    }

    animationCurves: QtObject {
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1]
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property real expressiveDefaultSpatialDuration: Common.Config.options.appearance.animation.duration.elementMove
        readonly property real expressiveEffectsDuration: Common.Config.options.appearance.animation.duration.elementMoveFast
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }

        property QtObject elementMoveEnter: QtObject {
            property int duration: Common.Config.options.appearance.animation.duration.elementMoveEnter
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }

        property QtObject elementMoveFast: QtObject {
            property int duration: animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
                }
            }
        }
    }

    sizes: QtObject {
        property real elevationMargin: Common.Config.options.appearance.sizes.elevationMargin
    }
}
