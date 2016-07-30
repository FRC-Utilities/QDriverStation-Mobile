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
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0

import "Pages"
import "Dialogs"
import "Globals.js" as Globals

ApplicationWindow {
    id: app
    width: 729
    height: 520
    visible: true
    title: AppDspName + " " + AppVersion

    //
    // Saves the current theme style (dark or light)
    //
    property var themeId: Globals.light
    property bool isDarkTheme: themeId === Globals.dark

    //
    // Load the saved theme and initialize the DS
    //
    Component.onCompleted: {
        setTheme (themeId)
        DriverStation.init()
    }

    //
    // Changes the current theme
    //
    function setTheme (theme) {
        themeId = theme

        if (isDarkTheme) {
            Material.theme = Material.Dark
            Universal.theme = Universal.Dark
        }

        else {
            Material.theme = Material.Light
            Universal.theme = Universal.Light
        }

        menuImg.source = getImage ("menu.svg", true)
        drawerImg.source = getImage ("drawer.svg", true)
    }

    //
    // Returns the toolbar image that matches the current theme and style
    //
    function getImage (image, toolbar) {
        if (themeId === Globals.dark || (IsMaterial && toolbar))
            return "qrc:/images/dark/" + image

        return "qrc:/images/light/" + image
    }

    //
    // Holds the navigation buttons and page title
    //
    header: ToolBar {
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
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                }
            }

            //
            // Shows the title of the current page
            //
            Label {
                id: titleLabel
                font.pixelSize: 17
                Layout.fillWidth: true
                elide: Label.ElideRight
            }

            //
            // Shows a menu that allows the user to open different popups
            //
            ToolButton {
                id: menuButton
                onClicked: optionsMenu.open()

                contentItem: Image {
                    id: menuImg
                    fillMode: Image.Pad
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                }

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: qsTr ("About")
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    //
    // Used to switch between available pages
    //
    Drawer {
        id: drawer
        height: app.height
        width: Math.min (app.width, app.height) / 3 * 2

        ListView {
            id: listView
            currentIndex: -1
            anchors.fill: parent

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
                text: model.title
                width: parent.width
                highlighted: ListView.isCurrentItem

                onClicked: {
                    if (listView.currentIndex != index)
                        listView.currentIndex = index

                    drawer.close()
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
                ListElement { title: qsTr ("Operator") }
                ListElement { title: qsTr ("Diagnostics") }
                ListElement { title: qsTr ("System Monitor") }
                ListElement { title: qsTr ("NetConsole") }
                ListElement { title: qsTr ("Preferences") }
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

    //
    // Loads the different pages
    //
    StackView {
        id: stackView
        anchors.fill: parent
        anchors.margins: Globals.spacing
    }

    //
    // The name says it all...
    //
    AboutDialog {
        id: aboutDialog
    }
}
