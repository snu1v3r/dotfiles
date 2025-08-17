//
// This file is part of SDDM Mountain Theme.
// A theme for the Simple Display Desktop Manager.
//
// Copyright (C) 2023 Arthur Deierlein
//
// Copyright (C) 2018–2020 Marian Arlt
//
// SDDM Mountain Theme is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or any later version.
//
// You are required to preserve this and any additional legal notices, either
// contained in this file or in other files that you received along with
// SDDM Mountain Theme that refer to the author(s) in accordance with
// sections §4, §5 and specifically §7b of the GNU General Public License.
//
// SDDM Mountain Theme is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with SDDM Mountain Theme. If not, see <https://www.gnu.org/licenses/>
//

import QtGraphicalEffects 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    id: sessionButton

    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property Control exposeSession: selectSession

    height: root.font.pointSize
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter

    ComboBox {
        id: selectSession

        hoverEnabled: true
        anchors.left: parent.left
        Keys.onPressed: {
            if (event.key == Qt.Key_Up && loginButton.state != "enabled" && !popup.opened)
                revealSecret.focus = true, revealSecret.state = "focused", currentIndex = currentIndex + 1;

            if (event.key == Qt.Key_Up && loginButton.state == "enabled" && !popup.opened)
                loginButton.focus = true, loginButton.state = "focused", currentIndex = currentIndex + 1;

            if (event.key == Qt.Key_Down && !popup.opened)
                systemButtons.children[0].focus = true, systemButtons.children[0].state = "focused", currentIndex = currentIndex - 1;

            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened)
                popup.open();

        }
        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"
        states: [
            State {
                name: "hovered"
                when: selectSession.hovered

                PropertyChanges {
                    target: displayedItem
                    color: root.selectedText
                }

                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.lighter(root.palette.highlight, 1.1)
                }

            },
            State {
                name: "focused"
                when: selectSession.visualFocus

                PropertyChanges {
                    target: displayedItem
                    color: root.selectedText
                }

            }
        ]
        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }

            }
        ]

        indicator {
            visible: false
        }

        delegate: ItemDelegate {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            highlighted: parent.highlightedIndex === index

            contentItem: Text {
                text: model.name
                font.pointSize: root.font.pointSize * 0.8
                color: selectSession.highlightedIndex === index ? root.palette.highlight.hslLightness >= 0.7 ? "#444444" : "white" : root.palette.window.hslLightness >= 0.8 ? root.palette.highlight.hslLightness >= 0.8 ? "#444444" : root.palette.highlight : "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            background: Rectangle {
                color: selectSession.highlightedIndex === index ? root.palette.highlight : "transparent"
            }

        }

        contentItem: Text {
            id: displayedItem

            text: (config.TranslateSession || (textConstantSession + ":")) + " " + selectSession.currentText
            color: root.palette.text
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 3
            font.pointSize: root.font.pointSize * 0.8
            Keys.onReleased: parent.popup.open()
        }

        background: Rectangle {
            color: "transparent"
            border.width: parent.visualFocus ? 1 : 0
            border.color: "transparent"
            height: parent.visualFocus ? 2 : 0
            width: displayedItem.implicitWidth
            anchors.top: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 3
        }

        popup: Popup {
            id: popupHandler

            y: parent.height - 1
            x: config.ForceRightToLeft == "true" ? -loginButtonWidth + displayedItem.width : 0
            width: sessionButton.width
            implicitHeight: contentItem.implicitHeight
            padding: 10

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight + 20
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator {
                }

            }

            background: Rectangle {
                radius: config.RoundCorners / 2
                color: config.BackgroundColor
                layer.enabled: true

                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 20 * config.InterfaceShadowSize
                    samples: 41 * config.InterfaceShadowSize
                    cached: true
                    color: Qt.hsla(0, 0, 0, config.InterfaceShadowOpacity)
                }

            }

            enter: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                }

            }

        }

    }

}
