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
import QtQuick.Controls.Universal 2.0

import "../Widgets"
import "../Globals.js" as Globals

Pane {
    Component.onCompleted: app.setTheme (darkMode.checked ?
                                             Globals.dark : Globals.light)

    Settings {
        property alias team: team.text
        property alias darkMode: darkMode.checked
        property alias material: useMaterial.checked
        property alias robotAddress: robotAddress.text
        property alias protocol: protocols.currentIndex
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Globals.spacing

        TitleLabel {
            spacer: false
            text: qsTr ("Driver Station")
        }

        RowLayout {
            Label {
                text: qsTr ("Team Number") + ": "
            }

            TextField {
                id: team
                Layout.fillWidth: true
                text: DS.teamNumber
                inputMethodHints: Qt.ImhNoPredictiveText
                onTextChanged: {
                    text = text.replace (' ', '')
                    text = text.replace (/\D/g,'')
                    if (text.length > 0)
                        DS.teamNumber = text
                }
            }
        }

        RowLayout {
            Label {
                text: qsTr ("Robot Address") + ": "
            }

            TextField {
                id: robotAddress
                Layout.fillWidth: true
                text: DS.customRobotAddress
                placeholderText: DS.defaultRobotAddress
                onTextChanged: DS.customRobotAddress = text
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
            }
        }

        RowLayout {
            Label {
                text: qsTr ("Protocol") + ": "
            }

            ComboBox {
                id: protocols
                Layout.fillWidth: true
                model: DS.protocols
                onCurrentIndexChanged: DS.setProtocol (currentIndex)
            }
        }

        TitleLabel {
            spacer: true
            text: qsTr ("Other Options")
        }

        Switch {
            id: darkMode
            checked: !IsMaterial
            text: qsTr ("Dark Theme")
            onCheckedChanged: app.setTheme (checked ? Globals.dark :
                                                      Globals.light)
        }

        Switch {
            id: useMaterial
            checked: IsMaterial
            text: qsTr ("Use Material Style") + "*"
        }

        Item {
            Layout.fillHeight: true
        }

        Label {
            color: "#666"
            font.pixelSize: 12
            text: "* " + qsTr ("Requires application restart")
        }
    }
}
