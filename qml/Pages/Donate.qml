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
import QtPurchasing 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import "../Widgets"
import "../Globals.js" as Globals

Pane {
    Store {
        Product {
            id: oneTimeDonation
            type: Product.Unlockable
            identifier: "org.qdriverstation.donation_one_time"

            onPurchaseSucceeded: {
                transaction.finalize()
                messageBox.text = qsTr ("Thanks for your donation!")
                messageBox.open()
            }

            onPurchaseFailed: {
                transition.finalize()
                messageBox.text = qsTr ("Failed to perform transaction")
                messageBox.open()
            }
        }

        Product {
            id: monthlyDonation
            type: Product.Consumable
            identifier: "org.qdriverstation.donation_monthly"

            onPurchaseSucceeded: {
                transaction.finalize()
                messageBox.text = qsTr ("Thanks for your donation!")
                messageBox.open()
            }

            onPurchaseFailed: {
                transition.finalize()
                messageBox.text = qsTr ("Failed to perform transaction")
                messageBox.open()
            }
        }
    }

    MessageDialog {
        id: messageBox
        title: app.title
        icon: StandardIcon.Information
        standardButtons: StandardButton.Close
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Globals.spacing

        Label {
            font.pixelSize: 13
            Layout.fillWidth: true
            Layout.fillHeight: true
            wrapMode: Text.WordWrap
            text: qsTr ("Hi, I hope you enjoy using this app!\n\n" +
                        "The QDriverStation is developed during my free time, " +
                        "even if I cannot participate in FRC anymore. " +
                        "If this application was useful for you and your team, " +
                        "please consider supporting this project!\n\n" +
                        "You can support the QDriverStation by donating (using Google Play), " +
                        "reporting issues and/or contributing code through GitHub.\n\n" +
                        "Sincerely,\nAlex Spataru :)")
        }

        Item {
            Layout.fillHeight: true
        }

        Button {
            id: oneTimeBt

            Connections {
                target: oneTimeDonation
                onStatusChanged: {
                    if (oneTimeDonation.status === Product.Registered) {
                        oneTimeBt.enabled = true
                        oneTimeBt.text = qsTr ("One-time Donation (%1)").arg (oneTimeDonation.price)
                    }

                    else {
                        oneTimeBt.enabled = false
                        oneTimeBt.text = qsTr ("One-time Donation (unavailable)")
                    }
                }
            }

            enabled: false
            Layout.fillWidth: true
            onClicked: oneTimeDonation.purchase()
            text: qsTr ("One-time Donation (unavailable)")
        }

        Button {
            id: monthlyDonationBt

            Connections {
                target: monthlyDonation
                onStatusChanged: {
                    if (monthlyDonation.status === Product.Registered) {
                        monthlyDonationBt.enabled = true
                        monthlyDonationBt.text = qsTr ("Monthly Donation (%1)").arg (monthlyDonation.price)
                    }

                    else {
                        monthlyDonationBt.enabled = false
                        monthlyDonationBt.text = qsTr ("Monthly Donation (unavailable)")
                    }
                }
            }

            enabled: false
            Layout.fillWidth: true
            onClicked: monthlyDonation.purchase()
            text: qsTr ("Monthly Donation (unavailable)")
        }

        Button {
            Layout.fillWidth: true
            text: qsTr ("Contribute Code")
            onClicked: Qt.openUrlExternally ("https://github.com/FRC-Utilities/")
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
