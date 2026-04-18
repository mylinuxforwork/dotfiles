pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root
    property bool overviewOpen: false
    property bool superReleaseMightTrigger: true
}
