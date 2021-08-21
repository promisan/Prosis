<cf_geoListingMapQueryPreparation url="#url#" viewId="#url.viewId#">

<cfset vThisDatasource = evaluate("session.geoListingDataSource_#url.viewId#")>
<cfset vThisCountFemale = evaluate("session.geoListingCountFemale_#url.viewId#")>
<cfset vThisCountMale = evaluate("session.geoListingCountMale_#url.viewId#")>
<cfset vThisCountTotal = evaluate("session.geoListingCountTotal_#url.viewId#")>
<cfset vThisDetailSelect = evaluate("session.geoListingDetailSelect_#url.viewId#")>
<cfset vThisDetailOrder = evaluate("session.geoListingDetailOrder_#url.viewId#")>
<cfset vThisDetailOrderScript = evaluate("session.geoListingDetailOrderScript_#url.viewId#")>
<cfset vThisDetailFieldMap = evaluate("session.geoListingDetailFieldMap_#url.viewId#")>

<cfquery name="getDataDetail" datasource="#vThisDatasource#">		
    SELECT	#preserveSingleQuotes(vThisDetailSelect)#,
			#preserveSingleQuotes(vThisCountFemale)# as CountFemale,
			#preserveSingleQuotes(vThisCountMale)# as CountMale,
			#preserveSingleQuotes(vThisCountTotal)# AS Total
	#preserveSingleQuotes(preparationQueryFilters)#
	GROUP BY 
			#preserveSingleQuotes(vThisDetailSelect)#
	ORDER BY 
			#preserveSingleQuotes(vThisDetailOrder)#
</cfquery>

<cfquery name="getDataSummaryLimits" dbtype="query">
    SELECT  MIN(Total) as MinTotal, MAX(Total) as MaxTotal, SUM(Total) as Total,
            MIN(CountFemale) as MinCountFemale, MAX(CountFemale) as MaxCountFemale, SUM(CountFemale) as TotalCountFemale,
            MIN(CountMale) as MinCountMale, MAX(CountMale) as MaxCountMale, SUM(CountMale) as TotalCountMale
    FROM    getDataDetail
</cfquery>

<cf_tl id="Export to Excel" var="lblExportToExcel">

<cfoutput>
<h3 style="padding-bottom:10px;">
    <img src="#session.root#/images/Excel.png" style="cursor:pointer;" width="30" height="30" onclick="Prosis.exportToExcel('detailGeoContent#url.viewId#Detail');" title="#lblExportToExcel#">
    SUMMARY
</h3>
</cfoutput>

<table class="table tableDetail table-striped table-bordered table-hover detailGeoContent<cfoutput>#url.viewId#</cfoutput>Detail" id="detailGeoContent<cfoutput>#url.viewId#</cfoutput>Detail" style="width:100%;">
    <thead>
        <tr>
            <cfloop from="1" to="#ArrayLen(vThisDetailFieldMap)#" index="i">
                <th><cf_tl id="#vThisDetailFieldMap[i].label#"></th>
            </cfloop>
            <th><cf_tl id="Female"></th>
            <th><cf_tl id="Male"></th>
            <th><cf_tl id="Total"></th>
        </tr>
    </thead>
    <cfset vTotalF = 0>
    <cfset vTotalM = 0>
    <cfset vTotal = 0>
    <cfoutput query="getDataDetail">
        <tr>
            <cfloop from="1" to="#ArrayLen(vThisDetailFieldMap)#" index="i">
                <td>#evaluate("#vThisDetailFieldMap[i].queryField#")#</td>
            </cfloop>
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
                        <td style="text-align:right;">#numberFormat(CountMale, ",")# </td>
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
            <cfoutput>
                <th colspan="#ArrayLen(vThisDetailFieldMap)#"><cf_tl id="Total"></th>
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

<cfset ajaxOnLoad("function(){ $('.detailGeoContent#url.viewId#Detail').DataTable({ 'pageLength':50, 'lengthMenu':[10,25,50,100,200], #preserveSingleQuotes(vThisDetailOrderScript)# }); }")>