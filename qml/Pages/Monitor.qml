/*
 * Copyright (c) 2015-2017 Alex Spataru <alex_spataru@outlook.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0

import "../Widgets"
import "../Globals.js" as Globals

Pane {
    //
    // Updates the text of the sent/recv labels
    //
    function updateNetworkUsage() {
        fmsBytes.text = labelText (DS.sentFMSBytes(), DS.receivedFMSBytes())
        robotBytes.text = labelText (DS.sentRobotBytes(), DS.receivedRobotBytes())
    }

    //
    // Returns a formatted string containing the given data
    //
    function labelText (sent, received) {
        return qsTr ("Sent") + ": " + formatLen (sent) + "<br/>" +
                qsTr ("Received") + ": " + formatLen (received)
    }

    //
    // Obtains the appropiate format for the given size in bytes
    //
    function formatLen (bytes) {
        if (bytes < 1024)
            return bytes + " bytes"

        else if (bytes < 1024 * 1024)
            return Math.round ((bytes / 1024)) + " KB"

        var mbytes = bytes / (1024 * 1024)
        return mbytes.toFixed (2) + " MB"
    }

    //
    // Update the network usage labels every second
    //
    Timer {
        repeat: true
        interval: 1000
        onTriggered: updateNetworkUsage()
        Component.onCompleted: {
            start()
            updateNetworkUsage()
        }
    }

    //
    // Layout definition
    //
    Flickable
    {
        clip: true
        anchors.fill: parent
        ScrollBar.vertical: ScrollBar {}
        contentHeight: column.implicitHeight
        Keys.onUpPressed: scrollBar.decrease()
        Keys.onDownPressed: scrollBar.increase()

        ColumnLayout {
            id: column
            anchors.fill: parent
            spacing: Globals.spacing * 2

            //
            // Sent/recv bytes title
            //
            TitleLabel {
                spacer: false
                text: qsTr ("Robot Status")
            }

            //
            // Robot Voltage
            //
            RowLayout {
                spacing: Globals.spacing * 2

                Image {
                    fillMode: Image.Pad
                    sourceSize: Qt.size (24, 24)
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    source: app.getImage ("battery.svg", false)
                }

                ColumnLayout {
                    spacing: Globals.spacing / 5

                    Label {
                        text: qsTr ("Robot Voltage")
                    }

                    Label {
                        font.pixelSize: 11
                        text: DS.connectedToRobot ?
                                  DS.voltageString : Globals.invalidStr
                    }
                }
            }

            //
            // CPU Usage
            //
            RowLayout {
                spacing: Globals.spacing * 2

                Image {
                    fillMode: Image.Pad
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    source: app.getImage ("cpu.svg", false)
                }

                ColumnLayout {
                    spacing: Globals.spacing / 5

                    Label {
                        text: qsTr ("CPU Usage")
                    }

                    Label {
                        font.pixelSize: 11
                        text: DS.connectedToRobot ?
                                  DS.cpuUsage + " %": Globals.invalidStr
                    }
                }
            }

            //
            // RAM usage
            //
            RowLayout {
                spacing: Globals.spacing * 2

                Image {
                    fillMode: Image.Pad
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    source: app.getImage ("memory.svg", false)
                }

                ColumnLayout {
                    spacing: Globals.spacing / 5

                    Label {
                        text: qsTr ("RAM Usage")
                    }

                    Label {
                        font.pixelSize: 11
                        text: DS.connectedToRobot ?
                                  DS.ramUsage + " %": Globals.invalidStr
                    }
                }
            }

            //
            // Disk usage
            //
            RowLayout {
                spacing: Globals.spacing * 2

                Image {
                    fillMode: Image.Pad
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    source: app.getImage ("storage.svg", false)
                }

                ColumnLayout {
                    spacing: Globals.spacing / 5

                    Label {
                        text: qsTr ("Disk Usage")
                    }

                    Label {
                        font.pixelSize: 11
                        text: DS.connectedToRobot ?
                                  DS.diskUsage + " %" : Globals.invalidStr
                    }
                }
            }

            //
            // Sent/recv bytes title
            //
            TitleLabel {
                spacer: false
                text: qsTr ("Network usage")
            }

            //
            // FMS network usage
            //
            RowLayout {
                spacing: Globals.spacing * 2

                Image {
                    fillMode: Image.Pad
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    source: app.getImage ("fms.svg", false)
                }

                ColumnLayout {
                    spacing: Globals.spacing / 5

                    Label {
                        text: qsTr ("FMS")
                    }

                    Label {
                        id: fmsBytes
                        font.pixelSize: 10
                    }
                }
            }

            //
            // Robot network usage
            //
            RowLayout {
                spacing: Globals.spacing * 2

                Image {
                    fillMode: Image.Pad
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    source: app.getImage ("robot.svg", false)
                }

                ColumnLayout {
                    spacing: Globals.spacing / 5

                    Label {
                        text: qsTr ("Robot")
                    }

                    Label {
                        id: robotBytes
                        font.pixelSize: 10
                    }
                }
            }

            //
            // Vertical spacer
            //
            Item {
                Layout.fillHeight: true
            }
        }
    }
}
