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
    // Update the checkboxes automatically
    //
    Connections {
        target: DriverStation
        onFmsCommunicationsChanged: fms.checked = DriverStation.connectedToFMS()
        onRadioCommunicationsChanged: radio.checked = DriverStation.connectedToRadio()
        onRobotCommunicationsChanged: robot.checked = DriverStation.connectedToRobot()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Globals.spacing

        //
        // Network diagnostics label
        //
        TitleLabel {
            spacer: false
            text: qsTr ("Network Diagnostics")
        }

        //
        // FMS Checkbox
        //
        CheckBox {
            id: fms
            text: qsTr ("FMS")
            onClicked: checked = !checked
        }

        //
        // Robot Checkbox
        //
        CheckBox {
            id: robot
            text: qsTr ("Robot")
            onClicked: checked = !checked
        }

        //
        // Radio Checkbox
        //
        CheckBox {
            id: radio
            text: qsTr ("Bridge/Radio")
            onClicked: checked = !checked
        }

        //
        // Actions label
        //
        TitleLabel {
            spacer: false
            text: qsTr ("Actions")
        }

        //
        // Reboot button
        //
        Button {
            Layout.fillWidth: true
            text: qsTr ("Reboot Robot")
            onClicked: DriverStation.rebootRobot()
        }

        //
        // Restart code button
        //
        Button {
            Layout.fillWidth: true
            text: qsTr ("Restart Robot Code")
            onClicked: DriverStation.restartRobotCode()
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }
    }
}
