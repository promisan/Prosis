<cf_geoListingMapQueryPreparation url="#url#">

<cfquery name="getDataCountry" datasource="srcInspira">		
    SELECT	S.Country as NationalityCode, 
			ISNULL(N.Name, '[Undef]') as NationalityName,
			COUNT(CASE WHEN S.Gender = 'Female' THEN 1 END) as CountFemale,
			COUNT(CASE WHEN S.Gender = 'Male' THEN 1 END) as CountMale,
			COUNT(*) AS Total
	#preserveSingleQuotes(preparationQueryFilters)#
	GROUP BY 
			S.Country,
			N.Name
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
		<div id="mymap_#url.viewId#" class="chartdiv"></div>
	</cfoutput>
</div>

<cfset vMin = numberFormat(getDataCountryLimits.MinTotal, ",")>
<cfset vMax = numberFormat(getDataCountryLimits.MaxTotal, ",")>
	
<cfset ajaxOnLoad("function() { resetMap_map_#url.viewId#('#vMin#', '#vMax#', '<span style=\'font-size:14px;\'><b>[[title]]</b>: [[value]] </span>', [#vDataList#]); }")>