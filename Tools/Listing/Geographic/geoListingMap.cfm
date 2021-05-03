<cfparam name="url.mapStyle" 	default="">

<cf_geoListingMapQueryPreparation url="#url#" viewId="#url.viewId#">

<cfquery name="getDataCountry" datasource="#session.geoListingDataSource#">		
    SELECT	Country as NationalityCode, 
			NationalityName,
			#preserveSingleQuotes(session.geoListingCountFemale)# as CountFemale,
			#preserveSingleQuotes(session.geoListingCountMale)# as CountMale,
			#preserveSingleQuotes(session.geoListingCountTotal)# AS Total
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