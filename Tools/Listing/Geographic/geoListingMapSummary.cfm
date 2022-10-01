<cf_geoListingMapQueryPreparation url="#url#" viewId="#url.viewId#">

<cfset vThisDatasource = evaluate("session.geoListingDataSource_#url.viewId#")>
<cfset vThisCountFemale = evaluate("session.geoListingCountFemale_#url.viewId#")>
<cfset vThisCountMale = evaluate("session.geoListingCountMale_#url.viewId#")>
<cfset vThisCountTotal = evaluate("session.geoListingCountTotal_#url.viewId#")>
<cfset vThisFilterMap = evaluate("session.geoListingFilterMap_#url.viewId#")>
<cfset vThisSummaryType = evaluate("session.geoListingSummaryType_#url.viewId#")>
<cfset vThisSummaryComplement = evaluate("session.geoListingSummaryComplement_#url.viewId#")>
<cfset vThisSummaryComplement2 = evaluate("session.geoListingSummaryComplement2_#url.viewId#")>
<cfset vThisSummaryComplement3 = evaluate("session.geoListingSummaryComplement3_#url.viewId#")>

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
    <cfset vDisplayHeader = "Member State">
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
    SELECT  MIN(Total) as MinTotal, MAX(Total) as MaxTotal, SUM(Total) as Total,
            MIN(CountFemale) as MinCountFemale, MAX(CountFemale) as MaxCountFemale, SUM(CountFemale) as TotalCountFemale,
            MIN(CountMale) as MinCountMale, MAX(CountMale) as MaxCountMale, SUM(CountMale) as TotalCountMale
    FROM    getDataSummary
</cfquery>

<cfif vThisSummaryType eq "Region">

    <cfif trim(vThisSummaryComplement) neq "">
        <cfset vComplementFilterParams = "">
        <cfloop from="1" to="#ArrayLen(vThisFilterMap)#" index="i">
            <cfset vComplementFilterParams = vComplementFilterParams & "&geoF#i#=#evaluate('url.geoF#i#')#">
        </cfloop>
        <cf_securediv 
            id="divSummaryComplement#trim(vThisSummaryComplement)#" 
            bind="url:#session.root#/tools/listing/geographic/geoListingMapSummaryComplement#vThisSummaryComplement#.cfm?viewId=#url.viewId#&zoomFunction=&country=#vComplementFilterParams#">

    </cfif>

    <cfif trim(vThisSummaryComplement2) neq "">
        <cfset vComplementFilterParams = "">
        <cfloop from="1" to="#ArrayLen(vThisFilterMap)#" index="i">
            <cfset vComplementFilterParams = vComplementFilterParams & "&geoF#i#=#evaluate('url.geoF#i#')#">
        </cfloop>
        <cf_securediv 
            id="divSummaryComplement2#trim(vThisSummaryComplement2)#" 
            bind="url:#session.root#/tools/listing/geographic/geoListingMapSummaryComplement#vThisSummaryComplement2#.cfm?viewId=#url.viewId#&zoomFunction=&country=#vComplementFilterParams#">

    </cfif>

</cfif>

<cf_tl id="Export to Excel" var="lblExportToExcel">

<cfif vThisSummaryType eq "Country">
    <cfoutput>
        <h3 style="padding-bottom:10px;">
            <img src="#session.root#/images/Excel.png" style="cursor:pointer;" width="30" height="30" onclick="Prosis.exportToExcel('detailGeoContent#url.viewId#');" title="#lblExportToExcel#">
            BY MEMBER STATE
        </h3>
    </cfoutput>
</cfif>

<cfif vThisSummaryType eq "Region">
    <cfoutput>
        <h3 style="padding-bottom:10px;">
            <img src="#session.root#/images/Excel.png" style="cursor:pointer;" width="30" height="30" onclick="Prosis.exportToExcel('detailGeoContent#url.viewId#');" title="#lblExportToExcel#">
            BY REGIONAL GROUP
        </h3>
    </cfoutput>
</cfif>

<table class="table tableDetail tablePaginate table-striped table-bordered table-hover detailGeoContent<cfoutput>#url.viewId#</cfoutput>" id="detailGeoContent<cfoutput>#url.viewId#</cfoutput>" style="width:100%;">
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
            <td style="text-align:right;" data-order="#CountFemale#">
                <table width="100%">
                    <tr>
                        <td style="font-size:60%;">
                            <cfif getDataSummaryLimits.TotalCountFemale neq 0>
                                #numberFormat(CountFemale*100/getDataSummaryLimits.TotalCountFemale, ",._")# %
                            </cfif>
                        </td>
                        <td style="text-align:right;">#numberFormat(CountFemale, ",")#</td>
                    </tr>
                </table>
            </td>
            <td style="text-align:right;" data-order="#CountMale#">
                <table width="100%">
                    <tr>
                        <td style="font-size:60%;">
                            <cfif getDataSummaryLimits.TotalCountMale neq 0>
                                #numberFormat(CountMale*100/getDataSummaryLimits.TotalCountMale, ",._")# %
                            </cfif>
                        </td>
                        <td style="text-align:right;"> #numberFormat(CountMale, ",")# </td>
                    </tr>
                </table>
            </td>
            <td style="text-align:right;" data-order="#Total#">
                <table width="100%">
                    <tr>
                        <td style="font-size:60%;">
                            <cfif getDataSummaryLimits.Total neq 0>
                                #numberFormat(Total*100/getDataSummaryLimits.Total, ",._")# %
                            </cfif>
                        </td>
                        <td style="text-align:right;">#numberFormat(Total, ",")#</td>
                    </tr>
                </table>
            </td>
        </tr>
        <cfset vTotalF = vTotalF + CountFemale>
        <cfset vTotalM = vTotalM + CountMale>
        <cfset vTotal = vTotal + Total>
    </cfoutput>
    <tfoot>
        <tr>
            <cfif vThisSummaryType eq "Country">
                <th></th>
            </cfif>
            <th><cf_tl id="Total"></th>
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

    <cfif getDataSummaryLimits.Total neq 0>

        <!--- Pie chart --->
        <cfset "doChart_summaryMapChart" = "">

        <cfset vSeriesArray = ArrayNew(1)>
        <cfset vSeries = StructNew()>
        <cfset vSeries.query = "#getDataSummary#">
        <cfset vSeries.label = "SummaryField">
        <cfset vSeries.value = "Total">
    
        <cfset vSeries.colorMode = "custom">
        <cfset vSeries.color = ['##00a8ff','##c23616','##44bd32','##fbc531','##8c7ae6','##ff9ff3','##1dd1a1','##ee5253', '##ff5252', '##474787', '##ffda79']>

        <cfset vSeries.transparency = 0.9>
        <cfset vSeriesArray[1] = vSeries>

        <cf_mobileGraph
            id = "summaryMapChart"
            type = "Pie"
            series = "#vSeriesArray#"
            responsive = "yes"
            scaleStep = "5"
            height = "200px"
            dataPoints = "yes"
            dataPointsPercentage = "yes"
            legend = "true"
            legendPosition = "right"
            maxScale = "#getDataSummaryLimits.MaxTotal#"
            scaleLabel = "<%= numberAddCommas(value) %>"
            tooltipLabel = "<%if (label){%><%=label%>: <%}%><%= numberAddCommas(value) %>">
        </cf_mobileGraph>

        <cfset ajaxOnLoad("function(){ #doChart_summaryMapChart# }")>

    </cfif>

    <style>
        .dataTables_length, .dataTables_info, .dataTables_paginate {
            display:none;
        }
    </style>

</cfif>

<cfif vThisSummaryType eq "Region">

    <cfif trim(vThisSummaryComplement3) neq "">
        <cfset vComplementFilterParams = "">
        <cfloop from="1" to="#ArrayLen(vThisFilterMap)#" index="i">
            <cfset vComplementFilterParams = vComplementFilterParams & "&geoF#i#=#evaluate('url.geoF#i#')#">
        </cfloop>
        <cf_securediv 
            id="divSummaryComplement3#trim(vThisSummaryComplement3)#" 
            bind="url:#session.root#/tools/listing/geographic/geoListingMapSummaryComplement#vThisSummaryComplement3#.cfm?viewId=#url.viewId#&zoomFunction=&country=#vComplementFilterParams#">

    </cfif>

</cfif>

<cfif vThisSummaryType eq "Country">
    <style>
        .dataTables_length, .dataTables_info, .dataTables_paginate {
            display:block;
        }
    </style>
</cfif>