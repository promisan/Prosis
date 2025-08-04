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

<cfoutput>

    <script>

        function clickGeoListingMap(viewId, e) {
            var vContextValue = encodeURIComponent(e.mapObject.id);
            showGeoListingCountryDetail(viewId, vContextValue);
        }

        function showGeoListingSummary(viewId) {
            showGeoListingDrillDown(viewId, '', 'geoListingMapSummary.cfm');
        }

        function showGeoListingSummaryMapSummary(viewId) {
            showGeoListingDrillDown(viewId, '', 'geoListingSummaryMapDetail.cfm');
        }

        function showGeoListingCountryDetail(viewId, country) {
            showGeoListingDrillDown(viewId, country, 'geoListingMapDetail.cfm');
        }

        function showGeoListingDrillDown(viewId, parCountry, template) {
            var vFilterValues = '';
            for (var i = 1; i <= 100; i++) {
                if ($('##geoF'+i).length == 1) {
                    vFilterValues = vFilterValues + "&" + 'geoF' + i + '=' + $('##geoF'+i).val();
                }
            }
            ptoken.navigate('#session.root#/Tools/Listing/Geographic/'+template+'?viewId='+viewId+'&representation=&region=&country='+parCountry+vFilterValues, viewId+'MapTable');
            ptoken.navigate('#session.root#/Tools/Listing/Geographic/geoListingMap.cfm?zoomFunction=&viewId='+viewId+'&representation=&region=&country='+parCountry+vFilterValues, viewId+'MapContainer');
        }

        function showGeoListingRegionDrillDown(viewId, region) {
            var vFilterValues = '';
            for (var i = 1; i <= 100; i++) {
                if ($('##geoF'+i).length == 1) {
                    vFilterValues = vFilterValues + "&" + 'geoF' + i + '=' + $('##geoF'+i).val();
                }
            }
            ptoken.navigate('#session.root#/Tools/Listing/Geographic/geoListingMapDetail.cfm?viewId='+viewId+'&representation=&country=&region='+region+vFilterValues, viewId+'MapTable');
            ptoken.navigate('#session.root#/Tools/Listing/Geographic/geoListingMap.cfm?zoomFunction=&viewId='+viewId+'&representation=&country=&region='+region+vFilterValues, viewId+'MapContainer');
        }

        function showGeoListingRepresentationDrillDown(viewId, rep) {
            var vFilterValues = '';
            for (var i = 1; i <= 100; i++) {
                if ($('##geoF'+i).length == 1) {
                    vFilterValues = vFilterValues + "&" + 'geoF' + i + '=' + $('##geoF'+i).val();
                }
            }
            ptoken.navigate('#session.root#/Tools/Listing/Geographic/geoListingMapDetail.cfm?viewId='+viewId+'&country=&region=&representation='+rep+vFilterValues, viewId+'MapTable');
            ptoken.navigate('#session.root#/Tools/Listing/Geographic/geoListingMap.cfm?zoomFunction=&viewId='+viewId+'&country=&region=&representation='+rep+vFilterValues, viewId+'MapContainer');
        }

    </script>

    <style>
        ##mymap {
            height: 90%;
            width: 90%:
            background-color:##EEEEEE;
        }
        
        .chartwrapper {
            width: 100%;
            height: 100%;
            position: relative;
            padding-bottom: 55%;
            box-sizing: border-box;
        }
        
        .chartdiv {
            position: absolute;
            width: 90%;
            height: 90%;		 
            align: center;
        }

        .dataTables_length, .dataTables_info, .dataTables_paginate {
            display:none;
        }

        .table > tbody > tr > td {
            padding-top:3px;
            padding-bottom:3px;
        }

        .tableDetail > thead > tr > th {
            position:-webkit-sticky !important; 
            position:sticky !important; 
            top:0; 
            background-color:##ededed;
        }

        @media only screen and (max-width: 1200px) {
            .tableDetail > thead > tr > th, .clsMapContainer {
                position:relative !important; 
            }
        }
    </style>

</cfoutput>