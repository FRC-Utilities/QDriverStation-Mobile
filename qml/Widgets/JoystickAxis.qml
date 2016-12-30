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
import QtQuick.Controls.Material 2.0
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
    // Holds the values of the thumb axes
    //
    property double xValue: 0
    property double yValue: 0

    //
    // Moves the knob to the x and y values of the touch point
    //
    function press (x, y) {
        knobX = Math.min (Math.max (x, width / 4), width * 0.75)
        knobY = Math.min (Math.max (y, height / 4), height * 0.75)

        xValue = (knobX * 4 / width) - 2
        yValue = (knobY * 4 / height) - 2
    }

    //
    // Centers the knobs again
    //
    function release() {
        xValue = 0
        yValue = 0
        knobX = width / 2
        knobY = height / 2
    }

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
            return app.isDarkTheme ? "#2a2a2a" : "#ececec"
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

            color: IsMaterial ? Material.accent : Universal.accent

            height: width
            radius: width / 2
            x: js.knobX - (width / 2)
            y: js.knobY - (height / 2)
            width: js.width * (0.78 - (index / 10))
            opacity: isCenter ? 1 : isBorder ? 0.1 : (index / 8)
        }
    }
}
