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

import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0

import "../Widgets"
import "../Globals.js" as Globals

Pane {
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
                    text: DS.connectedToRobot ?
                              DS.diskUsage + " %" : Globals.invalidStr
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
