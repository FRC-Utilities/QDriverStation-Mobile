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

import "../Globals.js" as Globals

ColumnLayout {
    anchors.fill: parent
    spacing: Globals.spacing

    property var jsId: 0
    property var numThumbs: 0
    property var numButtons: 0
    property var numTriggers: 0
    property var numAxes: numThumbs * 2 + numTriggers
    property bool triggersEnabled: parent.height >  (520 + (18 * numTriggers))

    //
    // Register the joystick when created
    //
    Component.onCompleted: {
        DriverStation.registerJoystick (numAxes, numButtons, 0)
        jsId = DriverStation.joystickCount() - 1
    }

    //
    // Buttons title
    //
    TitleLabel {
        spacer: false
        text: qsTr ("Buttons")
        Layout.fillWidth: true
    }

    //
    // Joystick buttons
    //
    Grid {
        id: buttons

        spacing: 2
        Layout.fillWidth: true
        columns: numButtons / (triggersEnabled || IsMaterial ? 2 : 3)

        Repeater {
            model: numButtons
            delegate: Button {
                flat: true
                text: qsTr ("" + (index + 1))
                width: (buttons.width / buttons.columns) - (buttons.spacing)
                onPressedChanged: {
                    DriverStation.updateButton (jsId, index, pressed)
                }
            }
        }
    }

    //
    // Thumbs title
    //
    TitleLabel {
        spacer: true
        text: qsTr ("Thumbs")
        Layout.fillWidth: true
    }

    //
    // Spacer
    //
    Item {
        Layout.fillHeight: true
    }

    //
    // Thumbs row
    //
    Row {
        id: thumbs
        spacing: Globals.spacing * 2
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            id: circles
            model: numThumbs

            function getIndexX (input) {
                return input === 0 ? 0 : input + 1
            }

            function getIndexY (input) {
                return input === 0 ? 1 : input + 2
            }

            delegate: JoystickAxis {
                height: width
                width: Math.min (app.width * 0.38, 156)

                onXChanged: {
                    DriverStation.updateAxis (jsId,
                                              circles.getIndexX (index),
                                              value)
                }

                onYChanged: {
                    DriverStation.updateAxis (jsId,
                                              circles.getIndexY (index),
                                              value)
                }
            }
        }
    }

    //
    // Triggers label
    //
    TitleLabel {
        spacer: true
        text: qsTr ("Triggers")
        visible: triggersEnabled
    }

    //
    // Triggers column
    //
    Repeater {
        model: numTriggers
        delegate: Slider {
            value: 0.5
            Layout.fillWidth: true
            visible: triggersEnabled
            Material.accent: Material.Red
            Universal.accent: Universal.Cobalt

            onPressedChanged: {
                if (!pressed)
                    value = 0.5
            }

            onValueChanged: {
                DriverStation.updateAxis (jsId,
                                          numThumbs * 2 + index,
                                          (value - 0.5) * 2)
            }
        }
    }

    //
    // Another spacer
    //
    Item {
        Layout.fillHeight: true
    }
}
