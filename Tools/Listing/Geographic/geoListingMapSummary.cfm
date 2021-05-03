<cf_geoListingMapQueryPreparation url="#url#" viewId="#url.viewId#">

<cfquery name="getDataCountryGroup" datasource="#session.geoListingDataSource#">		
    SELECT	CASE
				WHEN CountryGroup = '--' THEN '[Undef]'
				ELSE CountryGroup
			END as CountryGroup,
            #preserveSingleQuotes(session.geoListingCountFemale)# as CountFemale,
			#preserveSingleQuotes(session.geoListingCountMale)# as CountMale,
			#preserveSingleQuotes(session.geoListingCountTotal)# AS Total
	#preserveSingleQuotes(preparationQueryFilters)#
	GROUP BY 
			CountryGroup
</cfquery>

<cfquery name="getDataCountryGroupLimits" dbtype="query">
    SELECT  MIN(Total) as MinTotal, MAX(Total) as MaxTotal
    FROM    getDataCountryGroup
</cfquery>

<table class="table tableDetail table-striped table-bordered table-hover detailGeoContent<cfoutput>#url.viewId#</cfoutput>" style="width:100%;">
    <thead>
        <tr>
            <th><cf_tl id="Regional Group"></th>
            <th><cf_tl id="Female"></th>
            <th><cf_tl id="Male"></th>
            <th><cf_tl id="Total"></th>
        </tr>
    </thead>
    <cfset vTotalF = 0>
    <cfset vTotalM = 0>
    <cfset vTotal = 0>
    <cfoutput query="getDataCountryGroup">
        <tr>
            <td>#CountryGroup#</td>
            <td style="text-align:right;">#numberFormat(CountFemale, ",")#</td>
            <td style="text-align:right;">#numberFormat(CountMale, ",")#</td>
            <td style="text-align:right;">#numberFormat(Total, ",")#</td>
        </tr>
        <cfset vTotalF = vTotalF + CountFemale>
        <cfset vTotalM = vTotalM + CountMale>
        <cfset vTotal = vTotal + Total>
    </cfoutput>
    <tfoot>
        <tr>
            <th style="text-align:right;"><cf_tl id="Total"></th>
            <cfoutput>
                <th style="text-align:right;">
                    #numberFormat(vTotalF, ",")#
                </th>
                <th style="text-align:right;">
                    #numberFormat(vTotalM, ",")#
                </th>
                <th style="text-align:right;">
                    #numberFormat(vTotal, ",")#
                </th>
            </cfoutput>
        </tr>
    </tfoot>
</table>

<!--- Pie chart --->
<cfset "doChart_countryGroupChart" = "">

<cfset vSeriesArray = ArrayNew(1)>
<cfset vSeries = StructNew()>
<cfset vSeries.query = "#getDataCountryGroup#">
<cfset vSeries.label = "CountryGroup">
<cfset vSeries.value = "Total">
<cfset vSeries.color = "orange">
<cfset vSeries.transparency = 0.9>
<cfset vSeriesArray[1] = vSeries>

<cf_mobileGraph
    id = "countryGroupChart"
    type = "Pie"
    series = "#vSeriesArray#"
    responsive = "yes"
    scaleStep = "5"
    height = "200px"
    legend = "true"
    legendPosition = "right"
    maxScale = "#getDataCountryGroupLimits.MaxTotal#"
    scaleLabel = "<%= numberAddCommas(value) %>"
    tooltipLabel = "<%if (label){%><%=label%>: <%}%><%= numberAddCommas(value) %>">
</cf_mobileGraph>

<cfset ajaxOnLoad("function(){ #doChart_countryGroupChart# $('.detailGeoContent#url.viewId#').DataTable({ 'pageLength':200, 'lengthMenu':[10,25,50,100,200], 'order': [[3, 'desc']] }); }")>