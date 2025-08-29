<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="Attributes.type" default="donut">
<cfparam name="Attributes.query" default="">
<cfparam name="Attributes.itemcolumn" default="">
<cfparam name="Attributes.valuecolumn" default="">
<cfparam name="Attributes.reference" default="">
<cfparam name="Attributes.colorlist" default="">
<cfparam name="Attributes.serieslabel" default="">
<cfparam name="Attributes.seriescolor" default="">

<cfif Attributes.colorlist eq "">
    <cfif attributes.seriescolor neq "">
        <cfset Attributes.colorlist = Attributes.SeriesColor>
    </cfif>
</cfif>

<cfif thisTag.executionmode is 'start'>
    <cfoutput>
        <cfscript>
            ArrayAppend(SESSION.chartSeries,{type:"#attributes.type#", query:"#attributes.query#", categoryField:"#attributes.itemcolumn#", currentField: "#attributes.valuecolumn#", field:"#attributes.valuecolumn#", reference:"#attributes.reference#",seriesColor:#attributes.colorlist# , serieslabel:"#Attributes.serieslabel#"});
        </cfscript>
    </cfoutput>
</cfif>


