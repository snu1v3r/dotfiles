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
import "Components"
import QtGraphicalEffects 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

Pane {
    id: root

    property color selectedText: Qt.lighter(root.palette.highlight, 2)
    property color selectionColor: Qt.lighter(Qt.rgba(root.palette.highlight.r, root.palette.highlight.g, root.palette.highlight.b, 0.5))
    property bool leftleft: config.HaveFormBackground == "true" && config.PartialBlur == "false" && config.FormPosition == "left" && config.BackgroundImageHAlignment == "left"
    property bool leftcenter: config.HaveFormBackground == "true" && config.PartialBlur == "false" && config.FormPosition == "left" && config.BackgroundImageHAlignment == "center"
    property bool rightright: config.HaveFormBackground == "true" && config.PartialBlur == "false" && config.FormPosition == "right" && config.BackgroundImageHAlignment == "right"
    property bool rightcenter: config.HaveFormBackground == "true" && config.PartialBlur == "false" && config.FormPosition == "right" && config.BackgroundImageHAlignment == "center"

    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.ScreenWidth
    LayoutMirroring.enabled: config.ForceRightToLeft == "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    padding: config.ScreenPadding
    palette.button: "transparent"
    palette.highlight: config.AccentColor
    palette.text: config.MainColor
    palette.buttonText: config.MainColor
    palette.window: config.BackgroundColor
    font.family: config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true

    Item {
        id: sizeHelper

        anchors.fill: parent
        height: parent.height
        width: parent.width

        Rectangle {
            id: tintLayer

            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: "black"
            opacity: config.DimBackgroundImage
            z: 1
        }

        Rectangle {
            id: formBackground

            anchors.fill: form
            anchors.centerIn: form
            color: root.palette.window
            visible: config.HaveFormBackground == "true" ? true : false
            opacity: config.PartialBlur == "true" ? 0.3 : 1
            z: 1
        }

        LoginForm {
            id: form

            height: parent.height
            width: parent.width / 2.5
            anchors.horizontalCenter: config.FormPosition == "center" ? parent.horizontalCenter : undefined
            anchors.left: config.FormPosition == "left" ? parent.left : undefined
            anchors.right: config.FormPosition == "right" ? parent.right : undefined
            z: 1
        }

        Image {
            id: backgroundImage

            height: parent.height
            width: config.HaveFormBackground == "true" && config.FormPosition != "center" && config.PartialBlur != "true" ? parent.width - formBackground.width : parent.width
            anchors.left: leftleft || leftcenter ? formBackground.right : undefined
            anchors.right: rightright || rightcenter ? formBackground.left : undefined
            horizontalAlignment: config.BackgroundImageHAlignment == "left" ? Image.AlignLeft : config.BackgroundImageHAlignment == "right" ? Image.AlignRight : Image.AlignHCenter
            verticalAlignment: config.BackgroundImageVAlignment == "top" ? Image.AlignTop : config.BackgroundImageVAlignment == "bottom" ? Image.AlignBottom : Image.AlignVCenter
            source: config.background || config.Background
            fillMode: config.ScaleImageCropped == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: true
            clip: true
            mipmap: true
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask

            sourceItem: backgroundImage
            width: form.width
            height: parent.height
            anchors.centerIn: form
            sourceRect: Qt.rect(x, y, width, height)
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }

        GaussianBlur {
            id: blur

            height: parent.height
            width: config.FullBlur == "true" ? parent.width : form.width
            source: config.FullBlur == "true" ? backgroundImage : blurMask
            radius: config.BlurRadius
            samples: config.BlurRadius * 2 + 1
            cached: true
            anchors.centerIn: config.FullBlur == "true" ? parent : form
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }

    }

}
