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

import "../Globals.js" as Globals

ColumnLayout {
    spacing: Globals.spacing

    //
    // Custom properties
    //
    property bool simulation: true
    property alias jsId: selector.currentIndex

    //
    // Joysticks title
    //
    TitleLabel {
        spacer: false
        Layout.fillWidth: true
        visible: QJoysticks.count > 1
        text: qsTr ("Available Joysticks")
    }

    //
    // Joysticks selector
    //
    ComboBox {
        id: selector
        Layout.fillWidth: true
        visible: QJoysticks.count > 1
        model: QJoysticks.deviceNames
    }

    //
    // Buttons label
    //
    TitleLabel {
        spacer: false
        Layout.fillWidth: true
        visible: QJoysticks.getNumButtons (jsId) > 0
        text: qsTr ("Buttons (%1)").arg (QJoysticks.getNumButtons (jsId))
    }

    //
    // Joystick buttons
    //
    Grid {
        id: buttons
        property var numButtons: QJoysticks.getNumButtons (jsId)

        spacing: 2
        Layout.fillWidth: true
        visible: QJoysticks.getNumButtons (jsId) > 0
        columns: numButtons / (numButtons % 2 === 0 ? 2 : 3)

        Repeater {
            model: buttons.numButtons
            delegate: Button {
                id: bt
                flat: true
                checkable: true
                text: qsTr ("" + (index + 1))
                width: (buttons.width / buttons.columns) - buttons.spacing

                onCheckedChanged: {
                    if (!simulation)
                        DS.setJoystickButton (jsId, index, pressed)
                }

                MouseArea {
                    anchors.fill: parent
                }

                Connections {
                    target: QJoysticks
                    onButtonChanged: {
                        if (js === jsId && button === index)
                            bt.checked = pressed
                    }
                }
            }
        }
    }

    //
    // Axes label
    //
    TitleLabel {
        spacer: false
        Layout.fillWidth: true
        visible: QJoysticks.getNumAxes (jsId) > 0
        text: qsTr ("Axes (%1)").arg (QJoysticks.getNumAxes (jsId))
    }

    //
    // Joystick axes
    //
    Grid {
        id: axes
        property var numAxes: QJoysticks.getNumAxes (jsId)

        spacing: 2
        Layout.fillWidth: true
        visible: QJoysticks.getNumAxes (jsId) > 0
        columns: numAxes / (numAxes % 2 === 0 ? 2 : 3)

        Repeater {
            model: axes.numAxes
            delegate: ProgressBar {
                id: bar
                to: 100
                from: -100
                width: (axes.width / axes.columns) - axes.spacing

                onValueChanged: {
                    if (!simulation)
                        DS.setJoystickAxis (jsId, index, value / 100)
                }

                Behavior on value {NumberAnimation{}}

                Connections {
                    target: QJoysticks
                    onAxisChanged: {
                        if (js === jsId && axis === index)
                            bar.value = value * 100
                    }
                }
            }
        }
    }

    //
    // POV label
    //
    TitleLabel {
        spacer: false
        Layout.fillWidth: true
        visible: QJoysticks.getNumPOVs (jsId) > 0
        text: qsTr ("Hats (%1)").arg (QJoysticks.getNumPOVs (jsId))
    }

    //
    // Joystick POVs
    //
    Grid {
        id: hats
        property var numHats: QJoysticks.getNumPOVs (jsId)

        spacing: 2
        columns: numHats
        Layout.fillWidth: true
        visible: QJoysticks.getNumAxes (jsId) > 0

        Repeater {
            model: hats.numHats
            delegate: SpinBox {
                id: hat
                to: 360
                from: 0
                enabled: false
                width: (hats.width / hats.columns) - hats.spacing
                onValueChanged: {
                    if (!simulation)
                        DS.setJoystickHat (jsId, index, value)
                }

                Connections {
                    target: QJoysticks
                    onPovChanged: {
                        if (js === jsId && pov === index)
                            hat.value = angle
                    }
                }
            }
        }
    }

    //
    // Spacer
    //
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
