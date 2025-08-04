<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="attributes.mapId"        default="1">
<cfparam name="attributes.colorFrom"    default="##66eded">
<cfparam name="attributes.colorTo"      default="##007778">
<cfparam name="attributes.home"         default="true">
<cfparam name="attributes.zoom"         default="true">

<cf_ProsisMap 
    id="map_#attributes.mapId#" 
    target="mymap_#attributes.mapId#"
    minValue="" 
    maxValue=""
    colorFrom="#attributes.colorFrom#"
    colorTo="#attributes.colorTo#"
    showSmallMap="false"
    autoZoom="false"
    wheelZoom="false"
    home="#attributes.home#"
    zoom="#attributes.zoom#"
    onClick="clickGeoListingMap_#attributes.mapId#">

<cfoutput>
    <script>
        function clickGeoListingMap_#attributes.mapId#(e) {
            clickGeoListingMap('#attributes.mapId#', e);
        }
    </script>
</cfoutput>