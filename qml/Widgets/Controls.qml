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
import Qt.labs.settings 1.0

import DriverStation 1.0

import "../Globals.js" as Globals

ColumnLayout {
    spacing: Globals.spacing

    //
    // Settings
    //
    Settings {
        property alias station: station.currentIndex
    }

    //
    // "Robot Status" label
    //
    TitleLabel {
        spacer: false
        text: qsTr ("Robot Status")
    }

    //
    // Robot communications indicator
    //
    CheckBox {
        text: qsTr ("Communications")
        onClicked: checked = !checked
        checked: DS.connectedToRobot
    }

    //
    // Robot code indicator
    //
    CheckBox {
        text: qsTr ("Robot Code")
        onClicked: checked = !checked
        checked: DS.robotCode
    }

    //
    // "Control Options" label
    //
    TitleLabel {
        spacer: true
        text: qsTr ("Control Options")
    }

    //
    // Control Mode selector
    //
    RowLayout {
        Layout.fillWidth: true
        spacing: Globals.spacing

        Label {
            Layout.fillWidth: true
            text: qsTr ("Control Mode") + ": "
        }

        ComboBox {
            Layout.fillWidth: true

            model: [
                qsTr ("TeleOperated"),
                qsTr ("Autonomous"),
                qsTr ("Test")
            ]

            onCurrentIndexChanged: {
                switch (currentIndex) {
                case 0:
                    DS.controlMode = LibDS.ControlTeleoperated
                    break
                case 1:
                    DS.controlMode = LibDS.ControlAutonomous
                    break
                case 2:
                    DS.controlMode = LibDS.ControlTest
                    break
                }
            }
        }
    }

    //
    // Team station selector
    //
    RowLayout {
        Layout.fillWidth: true
        spacing: Globals.spacing

        Label {
            text: qsTr ("Team Station") + ": "
        }

        ComboBox {
            id: station
            model: DS.stations
            Layout.fillWidth: true
            onCurrentIndexChanged: DS.setTeamStation (currentIndex)
        }
    }

    //
    // Robot status label
    //
    Label {
        text: DS.status
        font.bold: true
        font.pixelSize: 18
        Layout.fillWidth: true
        Layout.fillHeight: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }
}
