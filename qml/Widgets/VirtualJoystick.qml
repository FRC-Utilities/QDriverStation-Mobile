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

import "../Globals.js" as Globals

ColumnLayout {
    spacing: Globals.spacing

    //
    // Custom properties
    //
    property var jsId: 0
    property bool simulation: true

    //
    // Do not allow the robot to apply a "surprise madafaka!"
    //
    onVisibleChanged: {
        thumbA.release()
        thumbB.release()
        triggerA.value = 0.5
        triggerB.value = 0.5
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
        property var numButtons: 10

        spacing: 2
        Layout.fillWidth: true
        columns: numButtons / (numButtons % 2 === 0 ? 2 : 3)

        Repeater {
            model: buttons.numButtons
            delegate: Button {
                flat: true
                text: qsTr ("" + (index + 1))
                width: (buttons.width / buttons.columns) - (buttons.spacing)
                onPressedChanged: {
                    if (!simulation)
                        DS.setJoystickButton (jsId, index, pressed)
                }
            }
        }
    }

    //
    // Thumbs title
    //
    TitleLabel {
        spacer: true
        text: qsTr ("Axes")
        Layout.fillWidth: true
    }

    //
    // Thumbs and triggers
    //
    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: app.spacing * 2

        //
        // First slider
        //
        Slider {
            value: 0.5
            id: triggerA
            Layout.fillHeight: true
            orientation: Qt.Vertical

            onPressedChanged: {
                if (!pressed)
                    value = 0.5
            }

            onValueChanged: {
                if (!simulation)
                    DS.setJoystickAxis (jsId, 2, (value - 0.5) * 2)
            }
        }

        //
        // Thumbs row
        //
        Item {
            id: thumbs
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: thumbA.height
            anchors.horizontalCenter: parent.horizontalCenter

            //
            // Moves the appropiate thumbs based on the touch configuration
            // of the mobile device
            //
            function react() {
                /* Know if one or two fingers are pressing the screen */
                var aPressed = pointA.pressed
                var bPressed = pointB.pressed

                /* Get finger positions */
                var ax = pointA.x
                var bx = pointB.x
                var ay = pointA.y * (thumbA.height / height)
                var by = pointB.y * (thumbB.height / height)

                /* Get position of each thumb */
                var XposA = (thumbA.x - multitouch.x) + (thumbA.width / 2)
                var XposB = (thumbB.x - multitouch.x) + (thumbB.width / 2)

                /* Only one finger pressed, decide which thumb to move */
                if (aPressed !== bPressed) {
                    /* Get distances between the press and each thumb */
                    var distanceA = Math.abs (XposA - ax)
                    var distanceB = Math.abs (XposB - ax)

                    /* Press is closer to first thumb */
                    if (distanceA < distanceB) {
                        thumbB.release()
                        thumbA.press (ax, ay)
                    }

                    /* Press is closer to second thumb */
                    else {
                        thumbA.release()
                        thumbB.press (ax - XposB + XposA, ay)
                    }
                }

                /* Two fingers pressed, move both thumbs */
                else if (aPressed && bPressed) {
                    /* Finger A is closer to thumb A */
                    if (ax < bx) {
                        thumbA.press (ax, ay)
                        thumbB.press (bx - XposB + XposA, by)
                    }

                    /* Finger B is closer to thumb A (press order matters) */
                    else {
                        thumbA.press (bx, by)
                        thumbB.press (ax - XposB + XposA, ay)
                    }
                }

                /* No fingers pressed, center thumbs */
                else {
                    thumbA.release()
                    thumbB.release()
                }
            }

            //
            // Multi-touch panel
            //
            MultiPointTouchArea {
                id: multitouch
                mouseEnabled: true
                anchors.top: parent.top
                anchors.left: thumbA.left
                anchors.right: thumbB.right
                anchors.bottom: parent.bottom

                touchPoints: [
                    TouchPoint {
                        id: pointA
                        onXChanged: thumbs.react()
                        onYChanged: thumbs.react()
                        onPressedChanged: thumbs.react()
                    },
                    TouchPoint {
                        id: pointB
                        onXChanged: thumbs.react()
                        onYChanged: thumbs.react()
                        onPressedChanged: thumbs.react()
                    }
                ]
            }

            //
            // First thumb
            //
            VirtualJoystickAxis {
                id: thumbA
                height: width
                anchors.right: center.left
                anchors.rightMargin: app.width * 0.05
                width: Math.min (app.width * 0.26, 156)
                anchors.verticalCenter: parent.verticalCenter

                onXValueChanged: {
                    if (!simulation)
                        DS.setJoystickAxis (jsId, 0, xValue)
                }

                onYValueChanged: {
                    if (!simulation)
                        DS.setJoystickAxis (jsId, 1, yValue)
                }
            }

            Item {
                id: center
                Layout.fillWidth: true
                anchors.centerIn: parent
            }

            //
            // Second thumb
            //
            VirtualJoystickAxis {
                id: thumbB
                height: width
                width: thumbA.width
                anchors.left: center.right
                anchors.leftMargin: app.width * 0.05
                anchors.verticalCenter: parent.verticalCenter

                onXValueChanged: {
                    if (!simulation)
                        DS.setJoystickAxis (jsId, 4, xValue)
                }

                onYValueChanged: {
                    if (!simulation)
                        DS.setJoystickAxis (jsId, 5, yValue)
                }
            }
        }

        //
        // Second slider
        //
        Slider {
            value: 0.5
            id: triggerB
            Layout.fillHeight: true
            orientation: Qt.Vertical

            onPressedChanged: {
                if (!pressed)
                    value = 0.5
            }

            onValueChanged: {
                if (!simulation)
                    DS.setJoystickAxis (jsId, 3, (value - 0.5) * 2)
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
