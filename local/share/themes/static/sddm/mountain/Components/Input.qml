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
import QtQuick.Layouts 1.11

Column {
    id: inputContainer

    property Control exposeSession: sessionSelect.exposeSession
    property bool failed

    Layout.fillWidth: true

    Item {
        id: usernameField

        height: root.font.pointSize * 4.5
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        ComboBox {
            id: selectUser

            property var popkey: config.ForceRightToLeft == "true" ? Qt.Key_Right : Qt.Key_Left

            displayText: ""
            width: parent.height
            height: parent.height
            anchors.left: parent.left
            Keys.onPressed: {
                if (event.key == Qt.Key_Down && !popup.opened)
                    username.forceActiveFocus();

                if ((event.key == Qt.Key_Up || event.key == popkey) && !popup.opened)
                    popup.open();

            }
            KeyNavigation.down: username
            KeyNavigation.right: username
            z: 2
            model: userModel
            currentIndex: model.lastIndex
            textRole: "name"
            hoverEnabled: true
            onActivated: {
                username.text = currentText;
            }
            states: [
                State {
                    name: "pressed"
                    when: selectUser.down

                    PropertyChanges {
                        target: usernameIcon
                        icon.color: root.palette.text
                    }

                },
                State {
                    name: "hovered"
                    when: selectUser.hovered

                    PropertyChanges {
                        target: usernameIcon
                        icon.color: root.selectedText
                    }

                },
                State {
                    name: "focused"
                    when: selectUser.activeFocus

                    PropertyChanges {
                        target: usernameIcon
                        icon.color: root.selectedText
                    }

                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "color, border.color, icon.colselectedText"
                        duration: 150
                    }

                }
            ]

            delegate: ItemDelegate {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                highlighted: parent.highlightedIndex === index

                contentItem: Text {
                    text: model.name
                    font.pointSize: root.font.pointSize * 0.8
                    font.capitalization: Font.Capitalize
                    color: selectUser.highlightedIndex === index ? root.palette.highlight.hslLightness >= 0.7 ? "#444" : "white" : root.palette.window.hslLightness >= 0.8 ? root.palette.highlight.hslLightness >= 0.8 ? "#444" : root.palette.highlight : "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                background: Rectangle {
                    color: selectUser.highlightedIndex === index ? root.palette.highlight : "transparent"
                }

            }

            indicator: Button {
                id: usernameIcon

                width: selectUser.height * 0.8
                height: parent.height
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: selectUser.height * 0.125
                icon.height: parent.height * 0.25
                icon.width: parent.height * 0.25
                enabled: false
                icon.color: root.palette.text
                icon.source: Qt.resolvedUrl("../Assets/User.svgz")
            }

            background: Rectangle {
                color: "transparent"
                border.color: "transparent"
            }

            popup: Popup {
                y: parent.height - username.height / 3
                x: config.ForceRightToLeft == "true" ? -loginButton.width + selectUser.width : 0
                rightMargin: config.ForceRightToLeft == "true" ? root.padding + usernameField.width / 2 : undefined
                width: usernameField.width
                implicitHeight: contentItem.implicitHeight
                padding: 10

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight + 20
                    model: selectUser.popup.visible ? selectUser.delegateModel : null
                    currentIndex: selectUser.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator {
                    }

                }

                background: Rectangle {
                    radius: config.RoundCorners / 2
                    color: root.palette.window
                    layer.enabled: true

                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 10 * config.InterfaceShadowSize
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

        TextField {
            id: username

            color: root.palette.text
            selectedTextColor: root.selectedText
            selectionColor: root.selectionColor
            text: config.ForceLastUser == "true" ? selectUser.currentText : null
            font.capitalization: config.AllowBadUsernames == "false" ? Font.Capitalize : Font.MixedCase
            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            placeholderText: config.TranslatePlaceholderUsername || textConstants.userName
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            renderType: Text.QtRendering
            onFocusChanged: {
                if (focus)
                    selectAll();

            }
            onAccepted: loginButton.clicked()
            KeyNavigation.down: password
            z: 1

            background: Rectangle {
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }

        }

    }

    Item {
        id: passwordField

        height: root.font.pointSize * 4.5
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }

            }
        ]

        TextField {
            id: password

            color: root.palette.text
            selectedTextColor: root.selectedText
            selectionColor: root.selectionColor
            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            focus: config.ForcePasswordFocus == "true" ? true : false
            selectByMouse: true
            echoMode: revealSecret.checked ? TextInput.Normal : TextInput.Password
            placeholderText: config.TranslatePlaceholderPassword || textConstants.password
            horizontalAlignment: TextInput.AlignHCenter
            passwordCharacter: "•"
            passwordMaskDelay: config.ForceHideCompletePassword == "true" ? undefined : 1000
            renderType: Text.QtRendering
            onAccepted: loginButton.clicked()
            KeyNavigation.down: revealSecret

            background: Rectangle {
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }

        }

    }

    Item {
        id: secretCheckBox

        height: root.font.pointSize * 7
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        states: [
            State {
                name: "hovered"
                when: revealSecret.hovered

                PropertyChanges {
                    target: indicatorLabel
                    color: root.selectedText
                }

            }
        ]
        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color, opacity"
                    duration: 150
                }

            }
        ]

        CheckBox {
            id: revealSecret

            width: parent.width
            hoverEnabled: true
            Keys.onReturnPressed: toggle()
            Keys.onEnterPressed: toggle()
            KeyNavigation.down: loginButton

            indicator: Rectangle {
                id: indicator

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 3
                anchors.leftMargin: 4
                implicitHeight: root.font.pointSize
                implicitWidth: root.font.pointSize
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.activeFocus ? 2 : 1

                Rectangle {
                    id: dot

                    anchors.centerIn: parent
                    implicitHeight: parent.width - 6
                    implicitWidth: parent.width - 6
                    color: root.palette.text
                    opacity: revealSecret.checked ? 1 : 0
                }

            }

            contentItem: Text {
                id: indicatorLabel

                text: config.TranslateShowPassword || "Show Password"
                anchors.verticalCenter: indicator.verticalCenter
                horizontalAlignment: Text.AlignLeft
                anchors.left: indicator.right
                anchors.leftMargin: indicator.width / 2
                font.pointSize: root.font.pointSize * 0.8
                color: root.palette.text
            }

        }

    }

    Item {
        height: root.font.pointSize * 2.3
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            id: errorMessage

            width: parent.width
            text: failed ? config.TranslateLoginFailedWarning || textConstants.loginFailed + "!" : keyboard.capsLock ? config.TranslateCapslockWarning || textConstants.capslockWarning : null
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: root.font.pointSize * 0.8
            font.bold: true
            color: root.palette.text
            opacity: 0
            states: [
                State {
                    name: "fail"
                    when: failed

                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }

                },
                State {
                    name: "capslock"
                    when: keyboard.capsLock

                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }

                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity"
                        duration: 100
                    }

                }
            ]
        }

    }

    Item {
        id: login

        height: root.font.pointSize * 3
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: loginButton

            opacity: 0.8
            anchors.horizontalCenter: parent.horizontalCenter
            text: config.TranslateLogin || textConstants.login
            height: root.font.pointSize * 3
            implicitWidth: parent.width
            enabled: config.AllowEmptyPassword == "true" || username.text != "" && password.text != "" ? true : false
            hoverEnabled: true
            onClicked: config.AllowBadUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            Keys.onReturnPressed: clicked()
            Keys.onEnterPressed: clicked()
            KeyNavigation.down: sessionSelect.exposeSession
            states: [
                State {
                    name: "hovered"
                    when: loginButton.hovered

                    PropertyChanges {
                        target: loginButton.contentItem
                        color: root.selectedText
                    }

                    PropertyChanges {
                        target: buttonBackground
                        border.width: root.font.pointSize / 5
                    }

                },
                State {
                    name: "focused"
                    when: loginButton.activeFocus

                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }

                },
                State {
                    name: "enabled"
                    when: loginButton.enabled

                    PropertyChanges {
                        target: buttonBackground
                        color: root.palette.highlight
                        opacity: 1
                    }

                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }

                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity, color, background.width"
                        duration: 300
                    }

                }
            ]

            contentItem: Text {
                text: parent.text
                color: config.OverrideLoginButtonTextColor != "" ? config.OverrideLoginButtonTextColor : root.palette.highlight.hslLightness >= 0.7 ? "#444" : "white"
                font.pointSize: root.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: 0.9
            }

            background: Rectangle {
                id: buttonBackground

                color: root.selectionColor
                border.color: root.palette.text
                radius: config.RoundCorners || 0
            }

        }

    }

    SessionButton {
        id: sessionSelect

        textConstantSession: textConstants.session
        loginButtonWidth: loginButton.background.width
    }

    Connections {
        target: sddm
        onLoginSucceeded: {
        }
        onLoginFailed: {
            failed = true;
            resetError.running ? resetError.stop() && resetError.start() : resetError.start();
        }
    }

    Timer {
        id: resetError

        interval: 2000
        onTriggered: failed = false
        running: false
    }

}
