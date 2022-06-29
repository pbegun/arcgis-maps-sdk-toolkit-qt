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
#include "UtilityNetworkTraceDemo.h"

#include "Map.h"

using namespace Esri::ArcGISRuntime;

UtilityNetworkTraceDemo::UtilityNetworkTraceDemo(QObject* parent) :
  BaseDemo(parent)
{
}

UtilityNetworkTraceDemo::~UtilityNetworkTraceDemo() = default;

Map* UtilityNetworkTraceDemo::initMap_(QObject* /*parent*/) const
{
  // Don't set a default map; it will be created in the controller
  return nullptr;
}

Scene* UtilityNetworkTraceDemo::initScene_(QObject* /*parent*/) const
{
  return nullptr;
}
