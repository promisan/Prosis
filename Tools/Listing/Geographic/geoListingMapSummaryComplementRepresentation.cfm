<cf_geoListingMapQueryPreparation url="#url#" viewId="#url.viewId#">

<cfset vThisDatasource = evaluate("session.geoListingDataSource_#url.viewId#")>
<cfset vThisCountFemale = evaluate("session.geoListingCountFemale_#url.viewId#")>
<cfset vThisCountMale = evaluate("session.geoListingCountMale_#url.viewId#")>
<cfset vThisCountTotal = evaluate("session.geoListingCountTotal_#url.viewId#")>

<cfquery name="getComplementDataDetail" datasource="#vThisDatasource#">		
    SELECT  Status,
			#preserveSingleQuotes(vThisCountFemale)# as CountFemale,
			#preserveSingleQuotes(vThisCountMale)# as CountMale,
			#preserveSingleQuotes(vThisCountTotal)# AS Total

	#preserveSingleQuotes(preparationQueryFilters)#

	GROUP BY Status
	ORDER BY Status
</cfquery>

<cfquery name="getComplementDataDetailLimits" dbtype="query">
    SELECT  MIN(Total) as MinTotal, MAX(Total) as MaxTotal, SUM(Total) as Total,
            MIN(CountFemale) as MinCountFemale, MAX(CountFemale) as MaxCountFemale, SUM(CountFemale) as TotalCountFemale,
            MIN(CountMale) as MinCountMale, MAX(CountMale) as MaxCountMale, SUM(CountMale) as TotalCountMale
    FROM    getComplementDataDetail
</cfquery>

<cf_tl id="Export to Excel" var="lblExportToExcel">
<cfoutput>
    <h3 style="padding-bottom:10px;">
        <img src="#session.root#/images/Excel.png" style="cursor:pointer;" width="30" height="30" onclick="Prosis.exportToExcel('detailGeoCompRepresentationContent#url.viewId#Detail');" title="#lblExportToExcel#">
        BY REPRESENTATION
    </h3>
</cfoutput>

<table class="table tableDetail table-striped table-bordered table-hover detailGeoCompRepresentationContent<cfoutput>#url.viewId#</cfoutput>Detail" id="detailGeoCompRepresentationContent<cfoutput>#url.viewId#</cfoutput>Detail" style="width:100%;">
    <thead>
        <tr>
            <th><cf_tl id="Status"></th>
            <th><cf_tl id="Female"></th>
            <th><cf_tl id="Male"></th>
            <th><cf_tl id="Total"></th>
        </tr>
    </thead>
    <cfset vTotalF = 0>
    <cfset vTotalM = 0>
    <cfset vTotal = 0>
    <cfoutput query="getComplementDataDetail">
        <tr>
            <td style="color:##30a5ff; cursor:pointer;" onclick="showGeoListingRepresentationDrillDown('#url.viewId#','#Status#')">#Status#</td>
            <td style="text-align:right;" data-order="#CountFemale#">
                <table width="100%">
                    <tr>
                        <td style="font-size:60%;">
                            <cfif getComplementDataDetailLimits.TotalCountFemale neq 0>
                                #numberFormat(CountFemale*100/getComplementDataDetailLimits.TotalCountFemale, ",._")# %
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
                            <cfif getComplementDataDetailLimits.TotalCountMale neq 0>
                                #numberFormat(CountMale*100/getComplementDataDetailLimits.TotalCountMale, ",._")# %
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
                            <cfif getComplementDataDetailLimits.Total neq 0>
                                #numberFormat(Total*100/getComplementDataDetailLimits.Total, ",._")# %
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
            <cfoutput>
                <th><cf_tl id="Total"></th>
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

<cfset ajaxOnLoad("function(){ $('.detailGeoCompRepresentationContent#url.viewId#Detail').DataTable({ 'pageLength':25, 'lengthMenu':[10,25,50,100,200], 'order': [[0, 'asc']] }); }")>

<cfif getComplementDataDetailLimits.Total neq 0>

    <!--- Pie chart --->
    <cfset "doChart_summaryComplementRepresentationMapChart" = "">

    <cfset vSeriesArray = ArrayNew(1)>
    <cfset vSeries = StructNew()>
    <cfset vSeries.query = "#getComplementDataDetail#">
    <cfset vSeries.label = "Status">
    <cfset vSeries.value = "Total">
    <cfset vSeries.color = "green">
    <cfset vSeries.transparency = 0.9>
    <cfset vSeriesArray[1] = vSeries>

    <cf_mobileGraph
        id = "summaryComplementRepresentationMapChart"
        type = "Pie"
        series = "#vSeriesArray#"
        responsive = "yes"
        scaleStep = "5"
        height = "200px"
        legend = "true"
        legendPosition = "right"
        dataPoints = "yes"
        dataPointsPercentage = "yes"
        maxScale = "#getComplementDataDetailLimits.MaxTotal#"
        scaleLabel = "<%= numberAddCommas(value) %>"
        tooltipLabel = "<%if (label){%><%=label%>: <%}%><%= numberAddCommas(value) %>">
    </cf_mobileGraph>

    <cfset ajaxOnLoad("function(){ #doChart_summaryComplementRepresentationMapChart# }")>

</cfif>

