/*******************************************************************************
 *  Copyright 2012-2022 Esri
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/
import Esri.ArcGISRuntime.Toolkit.Controller 100.15

import QtQuick
import QtQml
import QtQuick.Controls
import QtQuick.Layouts

/*!
 \qmltype UtilityNetworkTrace
 \inqmlmodule Esri.ArcGISRuntime.Toolkit
 \ingroup ArcGISQtToolkitUiQmlViews
 \since Esri.ArcGISRuntime 100.15
 \brief The user interface for the UtilityNetworkTrace.

 xxxx
 \image docs/utilityNetworkTrace.gif
 Example code in the QML API (C++ API might differ):
 \snippet qml_quick/src/demos/UtilityNetworkTraceDemoForm.qml Set up Bookmark QML
*/

Pane {
    id: utilityNetworkTrace
    height: 500
    width: implicitWidth * 1.20

    /*!
      \qmlproperty UtilityNetworkTraceController controller
      \brief The controller handles binding logic between the UtilityNetworkTrace and
      the \c BookmarkListItem.

      The QML controller is documented \l{UtilityNetworkTraceController}{here} and the CPP controller is documented \l{Esri::ArcGISRuntime::Toolkit::UtilityNetworkTraceController}{here}.
    */
    property var controller: UtilityNetworkTraceController { }

    /*!
       \qmlproperty GeoView geoView
       \brief The \c GeoView for this tool. Currenlty, it can be a \c Map; but could be extended to use a \c Scene as well.
     */
    property var geoView;

    Binding {
        target: controller
        property: "geoView"
        value: geoView
    }

    wheelEnabled: true
    hoverEnabled: true

    contentItem: ColumnLayout {

        id: root

        TabBar {
            id: bar

            height: implicitHeight
            width: parent.width

            TabButton {
                text: qsTr("New Trace")
                font.pixelSize: 14

            }
            TabButton {
                text: qsTr("Trace Result")
                font.pixelSize: 14
            }
        }

        StackLayout {

            currentIndex: bar.currentIndex
            clip: true

            ColumnLayout {
                id: gridLayoutTrace
                spacing: 5
                width: root.width

                RowLayout {

                    Label {
                        text: "Trace Configuration"
                    }
                    Layout.margins: 0

                    ComboBox {
                        Layout.margins: 5
                        id: traceConfigurationBox
                        model: controller.traceConfigurations
                        textRole: "name"
                        onCurrentIndexChanged: {
                            const index = currentIndex;
                            const traceConfiguration = controller.traceConfigurations;
                            let modelData = traceConfiguration[index];
                            if (modelData === undefined) {
                                modelData = traceConfiguration.element(traceConfiguration.index(index, 0));
                            }
                            inputFormat.type = modelData;
                            inputFormat.updateTraceConfiguration(controller.currentPoint());
                        }
                    }
                }

                Label {
                    text: "Starting Points"
                }

                BusyIndicator {
                    Layout.alignment: Qt.AlignHCenter
                    running: controller.isAddingStartingPointInProgress
                    visible: running
                }

                ListView {
                    id: startPointList
                    anchors.margins: 4
                    width: parent.width
                    Layout.preferredHeight: 250
                    clip: true
                    ScrollBar.vertical: ScrollBar {}
                    model: controller.startingPoints
                    delegate: Pane {

                        ColumnLayout {
                            width: startPointList.width - (startPointList.anchors.margins * 4)
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 1
                                ColumnLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                        text: groupName
                                        horizontalAlignment: Text.AlignLeft
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                        text: sourceName
                                        horizontalAlignment: Text.AlignLeft
                                    }
                                }
                                Button {
                                    Layout.preferredWidth: 48
                                    icon.source: "images/zoom-to-object.svg"
                                    icon.width: 16
                                    icon.height: 16
                                }
                                Button {
                                    Layout.preferredWidth: 48
                                    icon.source: "images/trash.svg"
                                    icon.width: 16
                                    icon.height: 16
                                    onClicked: controller.removeStartingPoint(index)
                                }
                            }
                            RowLayout {
                                spacing: 4
                                Layout.fillWidth: true
                                Slider {
                                    id: slider
                                    Layout.fillWidth: true
                                    padding: 0
                                    stepSize: 0.01
                                    snapMode: RangeSlider.SnapAlways
                                    from: 0.0
                                    to: 1.0
                                    visible: hasFractionAlongEdge
                                    onValueChanged: {
                                        if (slider.first.pressed) {
                                            if (slider.first.handle.enabled) {
                                                controller.setSteps(first.value, controller.fractionAlongEdge);
                                            } else { // Reset
                                                slider.first.value = controller.fractionAlongEdge;
                                            }
                                        }
                                    }
                                    Connections {
                                        target: controller
                                        function fractionAlongEdgeChanged() {
                                            slider.setValue(controller.fractionAlongEdge);
                                        }
                                    }
                                }
                                Label {
                                    text: slider.value.toFixed(2)
                                    visible: hasFractionAlongEdge
                                }
                            }
                        }
                    }
                }

                Text {
                    visible: controller.isAddingStartingPointEnabled
                    text: "Click on the map to identify starting points."
                    horizontalAlignment: Text.AlignLeft
                }

                RowLayout {
                    Layout.margins: 0
                    visible: true

                    Button {
                        id: removeAllButton
                        text: "Remove All"
                        Layout.alignment: Qt.AlignLeft
                        Layout.maximumWidth: Layout.maximumHeight
                        padding: 0
                        onClicked: controller.removeAllStartingPoints()
                        visible: startPointList.count > 0
                    }

                    Button {
                        id: selectStartingPointButton
                        text: controller.isAddingStartingPointEnabled ? "Cancel" : "Add Starting Point"
                        Layout.alignment: Qt.AlignRight
                        Layout.maximumWidth: Layout.maximumHeight
                        padding: 0
                        onClicked: controller.isAddingStartingPointEnabled = !controller.isAddingStartingPointEnabled
                    }
                }
            }

            ColumnLayout {
                id: gridLayoutResults
                width: root.width
                spacing: 0
            }
        }
    }

    implicitHeight: 200
    implicitWidth: 300
}
