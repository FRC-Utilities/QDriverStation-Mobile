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
import QtQuick.Controls.Universal 2.0

import "../Globals.js" as Globals

Rectangle {
    id: js

    //
    // Holds the position of the knob
    //
    property int knobX: width / 2
    property int knobY: height / 2

    //
    // Emitted when user moves the thumb
    //
    signal xChanged (var value)
    signal yChanged (var value)

    Behavior on height {NumberAnimation{}}
    Behavior on width  {NumberAnimation{}}

    //
    // Center the knobs when the size of the thumb changes
    //
    onWidthChanged: knobX = width / 2
    onHeightChanged: knobY = height / 2

    //
    // Make the rectangle a circle and give it some color
    //
    radius: width / 2
    color: {
        if (IsMaterial) {
            return app.isDarkTheme ? "#2a2a2a" : "#e2e2e2"
        }

        else {
            return app.isDarkTheme ? "#1f1f1f" : "#efefef"
        }
    }

    //
    // Knob circles (arranged as a 'gradient')
    //
    Repeater {
        model: 8
        delegate: Rectangle {
            property bool isCenter: index >= 9
            property bool isBorder: index == 0

            color: IsMaterial ? "#F44336" : "#3E65FF"

            height: width
            radius: width / 2
            x: js.knobX - (width / 2)
            y: js.knobY - (height / 2)
            width: js.width * (0.78 - (index / 10))
            opacity: isCenter ? 1 : isBorder ? 0.1 : (index / 8)
        }
    }

    //
    // Moves the knobs and calculates the axis values
    //
    MouseArea {
        anchors.fill: parent

        function press (mouse) {
            knobX = Math.min (Math.max (mouse.x, parent.width / 4), parent.width * 0.8)
            knobY = Math.min (Math.max (mouse.y, parent.height / 4), parent.height * 0.8)

            xChanged ((knobX * 4 / parent.width) - 2)
            yChanged ((knobY * 4 / parent.height) - 2)
        }

        function release (mouse) {
            xChanged (0)
            yChanged (0)
            knobX = parent.width / 2
            knobY = parent.height / 2
        }

        onPressed: press (mouse)
        onReleased: release (mouse)
        onPositionChanged: press (mouse)
    }
}
