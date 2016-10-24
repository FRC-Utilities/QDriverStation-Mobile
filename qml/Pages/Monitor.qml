/*
 * Copyright (c) 2015-2016 Alex Spataru <alex_spataru@outlook.com>
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

import "../Widgets"
import "../Globals.js" as Globals

Pane {
    //
    // Changes the status labels to "--.--" if there is no robot comms.
    //
    function reset() {
        if (!DriverStation.connectedToRobot()) {
            battery.text = Globals.invalidStr
            cpuUsage.text = Globals.invalidStr
            ramUsage.text = Globals.invalidStr
            diskUsage.text = Globals.invalidStr
        }
    }

    //
    // Load status text on launch
    //
    Component.onCompleted: reset()

    //
    // Updates the status labels automatically
    //
    Connections {
        target: DriverStation
        onProtocolChanged: reset()
        onRobotCommunicationsChanged: reset()
        onCpuUsageChanged: cpuUsage.text = usage + "%"
        onRamUsageChanged: ramUsage.text = usage + "%"
        onDiskUsageChanged: diskUsage.text = usage + "%"
        onVoltageChanged: battery.text = DriverStation.voltageString()
    }

    //
    // Yay! Another column!
    //
    ColumnLayout {
        anchors.fill: parent
        spacing: Globals.spacing * 2

        //
        // Robot Voltage
        //
        RowLayout {
            spacing: Globals.spacing * 2

            Image {
                fillMode: Image.Pad
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
                    id: battery
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
                    id: cpuUsage
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
                    id: ramUsage
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
                    id: diskUsage
                }
            }
        }

        //
        // Why not? A spacer!
        //
        Item {
            Layout.fillHeight: true
        }
    }
}
