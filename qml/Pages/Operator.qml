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
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0

import "../Widgets"
import "../Globals.js" as Globals

Pane {
    Settings {
        category: "Operator"
        property alias station: station.currentIndex
    }

    //
    // Disable robot if user changes to another page
    //
    onVisibleChanged: enableBt.checked = false

    //
    // Update UI when the DS registers an event
    //
    Connections {
        target: DriverStation

        //
        // Update the robot code checkbox automatically
        //
        onCodeStatusChanged: {
            robotCode.checked = DriverStation.isRobotCodeRunning()
        }

        //
        // Update the robot communications checkbox automatically
        //
        onRobotCommStatusChanged: {
            communications.checked = DriverStation.isConnectedToRobot()
        }

        //
        // Update the status label automatically
        //
        onStatusChanged: {
            robotStatus.text = status
        }

        //
        // Uncheck the enabled button automatically (e.g. when switching modes)
        //
        onEnabledChanged: {
            enableBt.checked = DriverStation.isEnabled()
        }
    }

    //
    // Ensure that layouts are setup correctly
    //
    Component.onCompleted: {
        controls.setVisible (true)
        joystick.setVisible (false)
        robotStatus.text = DriverStation.generalStatus()
    }

    //
    // Holds all the widgets
    //
    ColumnLayout {
        anchors.fill: parent
        spacing: Globals.spacing

        //
        // These controls are hidden when teleoperated is started
        //
        ColumnLayout {
            id: controls
            spacing: Globals.spacing
            onOpacityChanged: visible = (opacity !== 0)

            function setVisible (visible) {
                opacity = visible ? 1 : 0
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Globals.slowAnimation
                }
            }

            TitleLabel {
                spacer: false
                text: qsTr ("Robot Status")
            }

            //
            // Robot communications indicator
            //
            CheckBox {
                id: communications
                text: qsTr ("Communications")
                onClicked: checked = !checked
            }

            //
            // Robot code indicator
            //
            CheckBox {
                id: robotCode
                text: qsTr ("Robot Code")
                onClicked: checked = !checked
            }

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
                            DriverStation.switchToTeleoperated()
                            break
                        case 1:
                            DriverStation.switchToAutonomous()
                            break
                        case 2:
                            DriverStation.switchToTestMode()
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
                    Layout.fillWidth: true
                    model: DriverStation.teamStations()
                    onCurrentIndexChanged: DriverStation.setTeamStation (currentIndex)
                }
            }
        }

        //
        // Spacer between operator controls and enable/disable button
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // These widgets are shown when teleoperated is enabled
        //
        Joystick {
            id: joystick
            Layout.fillWidth: true

            function setVisible (visible) {
                opacity = visible ? 1 : 0
            }

            opacity: 0
            visible: false
            onOpacityChanged: visible = (opacity !== 0)

            Behavior on opacity {
                NumberAnimation {
                    duration: Globals.slowAnimation
                }
            }
        }

        //
        // Robot status label
        //
        Label {
            id: robotStatus
            font.bold: true
            font.pixelSize: 18
            Layout.fillWidth: true
            visible: controls.visible
            opacity: controls.opacity
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        //
        // Spacer between operator controls and enable/disable button
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // Enabled disabled button
        //
        Button {
            id: enableBt
            checked: false
            checkable: true
            highlighted: true
            Layout.fillWidth: true
            Layout.maximumWidth: 312
            anchors.horizontalCenter: parent.horizontalCenter
            text: checked ? qsTr ("Disable") : qsTr ("Enable")

            onCheckedChanged: {
                var enabled = checked

                //
                // User tried to enable robot when it cannot be enabled
                //
                if (enabled && !DriverStation.canBeEnabled())
                    enabled = false

                //
                // Update button state if neccessary
                //
                checked = enabled

                //
                // Show joysticks if robot is in teleop and enabled
                //
                if (DriverStation.isInTeleoperated() && enabled) {
                    joystick.setVisible (enabled)
                    controls.setVisible (!enabled)
                }

                //
                // Robot is not in teleop, hide joysticks
                //
                else {
                    controls.setVisible (true)
                    joystick.setVisible (false)
                }

                //
                // Finally, enable or disable the robot
                //
                DriverStation.setEnabled (enabled)
            }

            //
            // Change button color between enabled and disabled
            //
            Material.theme: Material.Light
            Universal.theme: Universal.Dark
            Universal.accent: Universal.Cobalt
            Material.accent: checked ? Material.Red : Material.Green
        }
    }
}
