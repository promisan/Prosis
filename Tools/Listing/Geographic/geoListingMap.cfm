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
<cfparam name="url.mapStyle" 	default="">

<cf_geoListingMapQueryPreparation url="#url#" viewId="#url.viewId#">

<cfset vThisDatasource = evaluate("session.geoListingDataSource_#url.viewId#")>
<cfset vThisCountFemale = evaluate("session.geoListingCountFemale_#url.viewId#")>
<cfset vThisCountMale = evaluate("session.geoListingCountMale_#url.viewId#")>
<cfset vThisCountTotal = evaluate("session.geoListingCountTotal_#url.viewId#")>

<cfquery name="getDataCountry" datasource="#vThisDatasource#">		
    SELECT	Country as NationalityCode, 
			NationalityName,
			#preserveSingleQuotes(vThisCountFemale)# as CountFemale,
			#preserveSingleQuotes(vThisCountMale)# as CountMale,
			#preserveSingleQuotes(vThisCountTotal)# AS Total
	#preserveSingleQuotes(preparationQueryFilters)#
	GROUP BY Country, NationalityName
</cfquery>

<cfquery name="getDataCountryLimits" dbtype="query">
    SELECT  MIN(Total) as MinTotal, MAX(Total) as MaxTotal
    FROM    getDataCountry
</cfquery>

<cfset vDataList = "">
<cfoutput query="getDataCountry">
	<cfset vDataList = vDataList & "{id:'#NationalityCode#', value:#Total#}">
	<cfif currentrow neq recordCount>
		<cfset vDataList = vDataList & ", ">
	</cfif>
</cfoutput>	

<cfquery name="getTotal" dbtype="query">
	SELECT 	SUM(Total) as Total
	FROM 	getDataCountry
</cfquery>

<div align="center" class="chartwrapper" style="padding-left:40px">
	<cfoutput>
		<div id="mymap_#url.viewId#" class="chartdiv" style="#url.mapStyle#"></div>
	</cfoutput>
</div>

<cfset vMin = numberFormat(getDataCountryLimits.MinTotal, ",")>
<cfset vMax = numberFormat(getDataCountryLimits.MaxTotal, ",")>
	
<cfset ajaxOnLoad("function() { resetMap_map_#url.viewId#('#vMin#', '#vMax#', '<span style=\'font-size:14px;\'><b>[[title]]</b>: [[value]] </span>', [#vDataList#]); #trim(url.zoomFunction)# }")>