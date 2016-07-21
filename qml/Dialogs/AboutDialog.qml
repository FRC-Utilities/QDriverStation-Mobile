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

import "../Globals.js" as Globals

Popup {
    id: dialog
    modal: true
    focus: true
    y: app.height / 6
    x: (app.width - width) / 2
    contentWidth: column.width * 1.2
    contentHeight: column.height * 1.2

    Column {
        id: column
        spacing: Globals.spacing
        anchors.centerIn: parent

        Image {
            fillMode: Image.Pad
            source: "qrc:/images/logo.png"
            verticalAlignment: Image.AlignVCenter
            horizontalAlignment: Image.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            font.bold: true
            text: AppDspName
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            font.pixelSize: 12
            text: qsTr ("Version") + " " + AppVersion
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RowLayout {
            spacing: Globals.spacing
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                Layout.fillWidth: true
                text: qsTr ("Visit Website")
                onClicked: Qt.openUrlExternally ("http://frc-utilities.github.io")
            }

            Button {
                Layout.fillWidth: true
                text: qsTr ("Report a Bug")
                onClicked: Qt.openUrlExternally ("http://github.com/frc-utilities/qdriverstation-mobile/issues")
            }
        }
    }
}
