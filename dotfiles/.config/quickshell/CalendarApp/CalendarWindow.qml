import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.CustomTheme

PanelWindow {
    id: root
    
    // --- WAYLAND CONFIGURATION ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore
    
    implicitWidth: 340
    implicitHeight: 340 
    color: "transparent"

    // Anchored to the Upper Side
    anchors {
        left: true
        top: true
    }

    // --- CLICK OUTSIDE TO CLOSE (Native Hyprland) ---
    HyprlandFocusGrab {
        windows: [root]
        active: root.isOpen && root.showWindow // <-- Updated this line
        onCleared: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- ESCAPE KEY LISTENER ---
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- ANIMATION LOGIC (Vertical Slide + Wayland Fix) ---
    property bool isOpen: false
    
    // Guard variable to prevent Wayland from unmapping the window too early
    property bool showWindow: false
    visible: showWindow
    
    // Map the window immediately when opened
    onIsOpenChanged: {
        if (isOpen) {
            showWindow = true
            
            // Auto-refresh "Today" if the date changed while Quickshell was running
            let now = new Date();
            if (now.getDate() !== todayDate || now.getMonth() !== todayMonth) {
                todayDate = now.getDate()
                todayMonth = now.getMonth()
                todayYear = now.getFullYear()
                
                currentMonth = todayMonth
                currentYear = todayYear
                updateCalendar(currentYear, currentMonth)
            }
        }
    }
    
    // Animate between your specific 87px top margin and off-screen (-800)
    property real currentTopMargin: isOpen ? 87 : -800 

    margins { 
        top: root.currentTopMargin
        left: 20
    }

    Behavior on currentTopMargin {
        NumberAnimation {
            id: slideAnim
            duration: 350
            easing.type: Easing.OutQuint 
            
            // Unmap the window ONLY after the hide animation completely finishes
            onRunningChanged: {
                if (!running && !root.isOpen) {
                    root.showWindow = false
                }
            }
        }
    }

    IpcHandler {
        target: "calendar"
        function toggle(): void { root.isOpen = !root.isOpen }
        function open(): void { root.isOpen = true }   
        function close(): void { root.isOpen = false } 
    }

    // --- REUSABLE COMPONENTS ---
    component ActionIcon: Button {
        property string iconTxt: ""
        implicitWidth: 28  
        implicitHeight: 28
        text: iconTxt
        font.family: "monospace"
        background: Rectangle { color: "transparent" }
        contentItem: Text { 
            text: parent.text; color: Theme.primary; font.pixelSize: 18; 
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        }
    }

    // Styled ML4W Button for the "Today" action
    component ML4WButton: Button {
        background: Rectangle {
            color: "transparent"
            border.color: Theme.primary
            border.width: 1
            radius: 8
        }
        contentItem: Text {
            text: parent.text
            font.family: Theme.fontFamily
            font.pixelSize: 12
            color: Theme.primary
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            padding: 4
            leftPadding: 10
            rightPadding: 10
        }
    }

    // --- CALENDAR LOGIC & DATA ---
    property var monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    property var dayNames: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    property int currentMonth: new Date().getMonth()
    property int currentYear: new Date().getFullYear()
    
    property int todayDate: new Date().getDate()
    property int todayMonth: new Date().getMonth()
    property int todayYear: new Date().getFullYear()

    ListModel { id: dayModel }
    ListModel { id: weekModel }

    Component.onCompleted: updateCalendar(currentYear, currentMonth)

    function prevMonth() {
        if (currentMonth === 0) {
            currentMonth = 11;
            currentYear--;
        } else {
            currentMonth--;
        }
        updateCalendar(currentYear, currentMonth);
    }

    function nextMonth() {
        if (currentMonth === 11) {
            currentMonth = 0;
            currentYear++;
        } else {
            currentMonth++;
        }
        updateCalendar(currentYear, currentMonth);
    }

    function updateCalendar(year, month) {
        dayModel.clear()
        weekModel.clear()

        let firstDay = new Date(year, month, 1)
        let startingDayOfWeek = firstDay.getDay() 
        let startCell = startingDayOfWeek === 0 ? 6 : startingDayOfWeek - 1

        let daysInMonth = new Date(year, month + 1, 0).getDate()
        let daysInPrevMonth = new Date(year, month, 0).getDate()

        for (let row = 0; row < 6; row++) {
            let dateInRow = new Date(year, month, 1 + (row * 7) - startCell)
            let d = new Date(Date.UTC(dateInRow.getFullYear(), dateInRow.getMonth(), dateInRow.getDate()));
            d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay()||7));
            let yearStart = new Date(Date.UTC(d.getUTCFullYear(),0,1));
            let weekNo = Math.ceil(( ( (d - yearStart) / 86400000) + 1)/7);
            
            weekModel.append({ weekNumber: weekNo })
        }

        for (let i = 0; i < 42; i++) {
            if (i < startCell) {
                dayModel.append({ day: daysInPrevMonth - startCell + i + 1, isCurrentMonth: false, isToday: false })
            } else if (i >= startCell && i < startCell + daysInMonth) {
                let dayNum = i - startCell + 1
                let isTod = (dayNum === todayDate && month === todayMonth && year === todayYear)
                dayModel.append({ day: dayNum, isCurrentMonth: true, isToday: isTod })
            } else {
                dayModel.append({ day: i - startCell - daysInMonth + 1, isCurrentMonth: false, isToday: false })
            }
        }
    }

    // ==========================================
    // MAIN PANEL BACKGROUND
    // ==========================================
    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: Theme.background
            border.color: Theme.primary
            border.width: 2
            radius: 10
            opacity: 0.95 // Only the background is transparent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // --- HEADER: MONTH NAVIGATION & TODAY BUTTON ---
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 30

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 5
                    
                    ActionIcon { 
                        iconTxt: "" 
                        onClicked: prevMonth()
                    }
                    
                    Text {
                        Layout.preferredWidth: 120 
                        text: monthNames[currentMonth] + " " + currentYear
                        color: Theme.primary
                        font.family: Theme.fontFamily
                        font.pixelSize: 18
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                    
                    ActionIcon { 
                        iconTxt: "" 
                        onClicked: nextMonth()
                    }
                }

                ML4WButton {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Today"
                    
                    opacity: (currentMonth !== todayMonth || currentYear !== todayYear) ? 1.0 : 0.0
                    enabled: opacity > 0
                    
                    Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutQuad } }

                    onClicked: {
                        currentMonth = todayMonth;
                        currentYear = todayYear;
                        updateCalendar(currentYear, currentMonth);
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.primary; opacity: 0.3 }

            // --- CALENDAR BODY ---
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 15

                ColumnLayout {
                    Layout.fillHeight: true
                    spacing: 5
                    
                    Text {
                        Layout.fillWidth: true
                        text: "Wk"
                        color: Theme.on_background
                        opacity: 0.5
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        Layout.bottomMargin: 5
                    }

                    Repeater {
                        model: weekModel
                        Text {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            text: model.weekNumber
                            color: Theme.primary
                            opacity: 0.7
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Rectangle { Layout.fillHeight: true; implicitWidth: 1; color: Theme.primary; opacity: 0.3 }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 5

                    RowLayout {
                        Layout.fillWidth: true
                        Repeater {
                            model: root.dayNames
                            Text {
                                Layout.fillWidth: true
                                text: modelData
                                color: Theme.primary
                                font.family: Theme.fontFamily
                                font.pixelSize: 14
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }

                    GridLayout {
                        columns: 7
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        rowSpacing: 5
                        columnSpacing: 5
                        
                        Repeater {
                            model: dayModel
                            
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: width / 2 
                                color: model.isToday ? Theme.primary : "transparent"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: model.day
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 14
                                    font.bold: model.isToday
                                    color: model.isToday ? Theme.background : Theme.on_background
                                    opacity: (model.isCurrentMonth || model.isToday) ? 1.0 : 0.3
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}