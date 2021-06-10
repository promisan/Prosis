<cf_geoListingMapQueryPreparation url="#url#" viewId="#url.viewId#">

<cfset vThisDatasource = evaluate("session.geoListingDataSource_#url.viewId#")>
<cfset vThisCountFemale = evaluate("session.geoListingCountFemale_#url.viewId#")>
<cfset vThisCountMale = evaluate("session.geoListingCountMale_#url.viewId#")>
<cfset vThisCountTotal = evaluate("session.geoListingCountTotal_#url.viewId#")>
<cfset vThisSummaryType = evaluate("session.geoListingSummaryType_#url.viewId#")>

<cfset vDisplayHeader = "">
<cfset vDrilldownFunction = "">
<cfset vDrilldownStyle = "">

<cfif vThisSummaryType eq "Region">
    <cfset vDisplayHeader = "Regional Group">

    <cfquery name="getDataSummary" datasource="#vThisDatasource#">		
        SELECT	CASE
                    WHEN CountryGroup = '--' THEN '[Undef]'
                    ELSE CountryGroup
                END as SummaryField,
                CASE
                    WHEN CountryGroup = '--' THEN '[Undef]'
                    ELSE CountryGroup
                END as SummaryFieldDisplay,
                #preserveSingleQuotes(vThisCountFemale)# as CountFemale,
                #preserveSingleQuotes(vThisCountMale)# as CountMale,
                #preserveSingleQuotes(vThisCountTotal)# AS Total
        #preserveSingleQuotes(preparationQueryFilters)#
        GROUP BY 
                CountryGroup
    </cfquery>
</cfif>

<cfif vThisSummaryType eq "Country">
    <cfset vDisplayHeader = "Country">
    <cfquery name="getDataSummary" datasource="#vThisDatasource#">		
        SELECT	Rank as SummaryOrder,
                Country as SummaryField,
                NationalityName as SummaryFieldDisplay,
                #preserveSingleQuotes(vThisCountFemale)# as CountFemale,
                #preserveSingleQuotes(vThisCountMale)# as CountMale,
                #preserveSingleQuotes(vThisCountTotal)# AS Total
        #preserveSingleQuotes(preparationQueryFilters)#
        GROUP BY 
                Rank,
                Country,
                NationalityName
    </cfquery>
</cfif>

<cfquery name="getDataSummaryLimits" dbtype="query">
    SELECT  MIN(Total) as MinTotal, MAX(Total) as MaxTotal
    FROM    getDataSummary
</cfquery>

<table class="table tableDetail tablePaginate table-striped table-bordered table-hover detailGeoContent<cfoutput>#url.viewId#</cfoutput>" style="width:100%;">
    <thead>
        <tr>
            <cfif vThisSummaryType eq "Country">
                <th><cf_tl id="Rank"></th>
            </cfif>
            <th><cf_tl id="#vDisplayHeader#"></th>
            <th><cf_tl id="Female"></th>
            <th><cf_tl id="Male"></th>
            <th><cf_tl id="Total"></th>
        </tr>
    </thead>
    <cfset vTotalF = 0>
    <cfset vTotalM = 0>
    <cfset vTotal = 0>
    <cf_tl id="Show region detail" var="lblDetail">
    <cfoutput query="getDataSummary">
        <tr>
            <cfif vThisSummaryType eq "Country">
                <td>#numberFormat(SummaryOrder, ",")#</td>
            </cfif>

            <cfif vThisSummaryType eq "Region">
                <cfset vDrilldownFunction = "showGeoListingRegionDrillDown('#url.viewId#','#SummaryField#');">
                <cfset vDrilldownStyle = "color:##30a5ff; cursor:pointer;">
            </cfif>

            <td onclick="#vDrilldownFunction#" style="#vDrilldownStyle#" title="#lblDetail#">
                #SummaryFieldDisplay#
            </td>
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

<cfset vOrderCol = 0>

<cfif vThisSummaryType eq "Country">
    <cfset vOrderCol = 4>
</cfif>

<cfif vThisSummaryType eq "Region">
    <cfset vOrderCol = 3>
</cfif>

<cfset ajaxOnLoad("function(){ $('.detailGeoContent#url.viewId#').DataTable({ 'pageLength':25, 'lengthMenu':[10,25,50,100,200], 'order': [[#vOrderCol#, 'desc']] }); }")>

<cfif vThisSummaryType eq "Region">

    <!--- Pie chart --->
    <cfset "doChart_summaryMapChart" = "">

    <cfset vSeriesArray = ArrayNew(1)>
    <cfset vSeries = StructNew()>
    <cfset vSeries.query = "#getDataSummary#">
    <cfset vSeries.label = "SummaryField">
    <cfset vSeries.value = "Total">
    <cfset vSeries.color = "orange">
    <cfset vSeries.transparency = 0.9>
    <cfset vSeriesArray[1] = vSeries>

    <cf_mobileGraph
        id = "summaryMapChart"
        type = "Pie"
        series = "#vSeriesArray#"
        responsive = "yes"
        scaleStep = "5"
        height = "200px"
        legend = "true"
        legendPosition = "right"
        maxScale = "#getDataSummaryLimits.MaxTotal#"
        scaleLabel = "<%= numberAddCommas(value) %>"
        tooltipLabel = "<%if (label){%><%=label%>: <%}%><%= numberAddCommas(value) %>">
    </cf_mobileGraph>

    <cfset ajaxOnLoad("function(){ #doChart_summaryMapChart# }")>

    <style>
        .dataTables_length, .dataTables_info, .dataTables_paginate {
            display:none;
        }
    </style>

</cfif>

<cfif vThisSummaryType eq "Country">
    <style>
        .dataTables_length, .dataTables_info, .dataTables_paginate {
            display:block;
        }
    </style>
</cfif>