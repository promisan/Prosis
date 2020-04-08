
<cfinclude template="SummaryPreparation.cfm">

<cfset vDataList = "">
<cfquery name="getGraphData" dbtype="query">
	SELECT 	CountryCode,
			CountryName,
			SUM(	<cfloop index="yr" from="#url.pyear#" to="#url.pyear-4#" step="-1">
					Collection#yr# +
				</cfloop> 0
			) as Total
	FROM 	getData
	GROUP BY CountryCode, CountryName
</cfquery>

<cfoutput query="getGraphData">
	<cfset vDataList = vDataList & "{id:'#CountryCode#', value:#round(total)#}">
	<cfif currentrow neq recordCount>
		<cfset vDataList = vDataList & ", ">
	</cfif>
</cfoutput>

<cf_mobileRow style="padding-top:20px;">
	<div align="center" class="chartwrapper" style="padding-left:40px">
  		<div id="mycollectionsmap" class="chartdiv"></div>
	</div>
</cf_mobileRow>

<cfset ajaxOnLoad("function(){  resetMap_2('-', '+', '<span style=\'font-size:14px;\'><b>[[title]]</b>: [[value]] </span>', [#vDataList#]); }")>