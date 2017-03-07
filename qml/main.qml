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
import QtQml.Models 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0

import "Pages"
import "Dialogs"
import "Globals.js" as Globals

ApplicationWindow {
    id: app
    width: 340
    height: 520
    visible: true
    title: AppDspName + " " + AppVersion

    //
    // Initialize the DS
    //
    Component.onCompleted: {
        DS.start()
        showMaximized()
    }

    //
    // Style options
    //
    Material.theme: Material.Light
    Material.accent: Material.Teal
    Material.primary: Material.Teal
    Universal.theme: Universal.Dark
    Universal.accent: Universal.Cobalt

    //
    // Returns the toolbar image that matches the current theme and style
    //
    function getImage (image, toolbar) {
        if (IsMaterial && toolbar || !IsMaterial)
            return "qrc:/images/dark/" + image

        return "qrc:/images/light/" + image
    }

    //
    // Holds the navigation buttons and page title
    //
    header: ToolBar {
        id: toolbar
        Material.primary: "#263238"
        Material.foreground: "white"

        RowLayout {
            anchors.fill: parent
            spacing: Globals.spacing

            //
            // Shows the navigation drawer when clicked
            //
            ToolButton {
                id: drawerButton
                onClicked: drawer.open()

                contentItem: Image {
                    id: drawerImg
                    fillMode: Image.Pad
                    source: getImage ("drawer.svg", true)
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                }
            }

            //
            // Shows the title of the current page
            //
            Label {
                id: titleLabel
                font.pixelSize: 18
                Layout.fillWidth: true
                elide: Label.ElideRight
                font.weight: Font.Medium
            }
        }
    }

    //
    // Used to switch between available pages
    //
    Drawer {
        id: drawer
        height: app.height
        width: Math.min (Math.min (app.width, app.height) * 0.90, 280)

        //
        // Drawer controls
        //
        ColumnLayout {
            spacing: 0
            anchors.margins: 0
            anchors.fill: parent

            //
            // Application name & version
            //
            Rectangle {
                z: 1
                color: {
                    if (IsMaterial)
                        return "#263238"
                    else
                        return "#414141"
                }

                Layout.fillWidth: true
                Layout.minimumHeight: 120

                RowLayout {
                    anchors.centerIn: parent
                    spacing: Globals.spacing

                    Image {
                        sourceSize: Qt.size (72, 72)
                        source: "qrc:/images/logo.png"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Globals.spacing

                        Item {
                            Layout.fillHeight: true
                        }

                        Label {
                            color: "#fff"
                            font.bold: true
                            text: AppDspName
                            font.pixelSize: 18
                        }

                        Label {
                            color: "#ccc"
                            font.pixelSize: 16
                            text: qsTr ("Version") + ": " + AppVersion
                        }

                        Label {
                            color: "#aaa"
                            font.pixelSize: 12
                            text: qsTr ("Using LibDS") + ": " + DS.libDSVersion
                        }

                        Item {
                            Layout.fillHeight: true
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            //
            // Page selector
            //
            ListView {
                z: 0
                id: listView
                currentIndex: -1
                Layout.fillWidth: true
                Layout.fillHeight: true

                //
                // Change toolbar title and current page when user changes the
                // current page title
                //
                onCurrentIndexChanged: {
                    stackView.push (pages.get (currentIndex))
                    titleLabel.text = titles.get (currentIndex).title
                }

                //
                // Open the operator page at launch
                //
                Component.onCompleted: currentIndex = 0

                //
                // This item is created for each item from the \c titles list
                //
                delegate: ItemDelegate {
                    width: parent.width
                    highlighted: ListView.isCurrentItem

                    onClicked: {
                        if (listView.currentIndex != index)
                            listView.currentIndex = index

                        drawer.close()
                    }

                    RowLayout {
                        spacing: 16
                        anchors.margins: 16
                        anchors.fill: parent

                        Image {
                            smooth: true
                            opacity: 0.72
                            fillMode: Image.Pad
                            sourceSize: Qt.size (24, 24)
                            verticalAlignment: Image.AlignVCenter
                            horizontalAlignment: Image.AlignHCenter
                            source: "qrc:/images/pages/" + model.icon
                            anchors.verticalCenter: parent.verticalCenter

                            ColorOverlay {
                                source: parent
                                color: model.color
                                anchors.fill: parent
                            }
                        }

                        Label {
                            text: model.title
                            Layout.fillWidth: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                }

                //
                // The delegate should contain a title, not the whole page itself
                //
                model: titles

                //
                // Holds the title of each page in the \c pages list
                //
                ListModel {
                    id: titles

                    ListElement {
                        color: "#2196f4"
                        icon: "operator.svg"
                        title: qsTr ("Operator")
                    }

                    ListElement {
                        color: "#F44336"
                        icon: "diagnostics.svg"
                        title: qsTr ("Diagnostics")
                    }

                    ListElement {
                        color: "#009688"
                        icon: "monitor.svg"
                        title: qsTr ("System Monitor")
                    }

                    ListElement {
                        color: "#8bc43a"
                        icon: "netconsole.svg"
                        title: qsTr ("NetConsole")
                    }

                    ListElement {
                        color: "#ff9800"
                        icon: "settings.svg"
                        title: qsTr ("Preferences")
                    }
                }

                //
                // Holds the page data (to avoid creating duplicate instances)
                //
                ObjectModel {
                    id: pages
                    Operator    { visible: false }
                    Diagnostics { visible: false }
                    Monitor     { visible: false }
                    NetConsole  { visible: false }
                    Preferences { visible: false }
                }

                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
    }

    //
    // Loads the different pages
    //
    StackView {
        id: stackView
        anchors.fill: parent
        anchors.margins: Globals.spacing
    }
}
