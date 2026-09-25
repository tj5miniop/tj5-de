// Quickshell config for tj5-de.

import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

ShellRoot {

    // Wallpaper — one per connected screen
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: wallpaperWin
            property var modelData
            screen: modelData

            WlrLayershell.layer: WlrLayer.Background
            anchors { top: true; bottom: true; left: true; right: true }
            color: "black"
            exclusiveZone: 0

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                source: "file:///usr/share/hyperion/wallpapers/wallpaper.png"
            }
        }
    }

    // Notifications
    NotificationServer {
        id: notifServer
        keepOnReload: false
        bodySupported: true
        onNotification: notification => {
            notification.tracked = true;
        }
    }

    PanelWindow {
        id: notifPopup
        anchors { top: true; right: true }
        implicitWidth: 320
        implicitHeight: Math.max(1, notifColumn.implicitHeight)
        color: "transparent"
        exclusiveZone: 0
        margins { top: 40; right: 10 }

        Column {
            id: notifColumn
            width: parent.width
            spacing: 8

            Repeater {
                model: notifServer.trackedNotifications

                delegate: Rectangle {
                    width: notifColumn.width
                    height: notifBody.y + notifBody.implicitHeight + 12
                    radius: 8
                    color: "#1a1b26"
                    border.color: "#33467c"
                    border.width: 1

                    Text {
                        id: notifSummary
                        x: 12; y: 10
                        width: parent.width - 24
                        text: modelData.summary
                        color: "#c0caf5"
                        font.bold: true
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        id: notifBody
                        x: 12
                        y: notifSummary.y + notifSummary.implicitHeight + 4
                        width: parent.width - 24
                        text: modelData.body
                        color: "#a9b1d6"
                        wrapMode: Text.WordWrap
                        textFormat: Text.PlainText
                    }

                    // Click to dismiss
                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.dismiss()
                    }

                    // Auto-dismiss after 6s
                    Timer {
                        running: true
                        interval: 6000
                        onTriggered: modelData.dismiss()
                    }
                }
            }
        }
    }

    // Bar
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true }
            implicitHeight: 30
            color: "#1a1b26"
            exclusiveZone: implicitHeight

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                // Launcher button
                Text {
                    text: "app menu"
                    color: "#a9b1d6"
                    font.pixelSize: 14

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached(["wofi", "--show", "drun"])
                    }
                }

                Item { Layout.fillWidth: true }

                // Notification count, only shown when something is active
                Text {
                    visible: notifServer.trackedNotifications.count > 0
                    text: "\uD83D\uDD14 " + notifServer.trackedNotifications.count
                    color: "#c0caf5"
                    font.pixelSize: 14
                }

                // Clock
                Text {
                    id: clock
                    color: "#c0caf5"
                    font.pixelSize: 14
                    text: Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm")

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm")
                    }
                }
            }
        }
    }
}
