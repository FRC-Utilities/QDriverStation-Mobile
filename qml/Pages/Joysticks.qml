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

import DriverStation 1.0

import "../Widgets"
import "../Globals.js" as Globals

Pane {
    id: js

    //
    // If set to true, joystick values will not be sent to
    // the DS, this is good for creating a 'display only'
    // joystick control
    //
    property bool simulation: true

    //
    // Automatically configures the jsimoysticks with the DS
    //
    function registerJoysticks() {
        /* Register joysticks with DS */
        if (!simulation) {
            DS.resetJoysticks()

            if (QJoysticks.count > 0) {
                for (var i = 0; i < QJoysticks.count; ++i)
                    DS.addJoystick (QJoysticks.getNumAxes (i),
                                    QJoysticks.getNumPOVs (i),
                                    QJoysticks.getNumButtons (i))
            }

            else {
                virtualJoystick.jsId = 0
                DS.addJoystick (6, 0, 10) /* Should be dynamic... */
            }
        }

        /* Display the joystick controls */
        stackView.push (QJoysticks.count > 0 ? sdlJoystick : virtualJoystick)
    }

    //
    // Re-configure the joysticks when the user plugs (or unplugs)
    // a real joystick
    //
    Connections {
        target: QJoysticks
        onCountChanged: registerJoysticks()
    }

    //
    // Configure the DS and UI when creating the widget
    //
    Component.onCompleted: registerJoysticks()

    //
    // Holds all the widgets
    //
    ColumnLayout {
        anchors.fill: parent
        spacing: Globals.spacing

        StackView {
            id: stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: virtualJoystick

            VirtualJoystick {
                visible: false
                id: virtualJoystick
                simulation: js.simulation
            }

            SDLJoystick {
                visible: false
                id: sdlJoystick
                simulation: js.simulation
            }
        }
    }
}
