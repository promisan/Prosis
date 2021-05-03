<cf_geoListingMapQueryPreparation url="#url#" viewId="#url.viewId#">

<cfquery name="getDataDetail" datasource="#session.geoListingDataSource#">		
    SELECT	#preserveSingleQuotes(session.geoListingDetailSelect)#,
			#preserveSingleQuotes(session.geoListingCountFemale)# as CountFemale,
			#preserveSingleQuotes(session.geoListingCountMale)# as CountMale,
			#preserveSingleQuotes(session.geoListingCountTotal)# AS Total
	#preserveSingleQuotes(preparationQueryFilters)#
	GROUP BY 
			#preserveSingleQuotes(session.geoListingDetailSelect)#
	ORDER BY 
			#preserveSingleQuotes(session.geoListingDetailOrder)#
</cfquery>

<table class="table tableDetail table-striped table-bordered table-hover detailGeoContent<cfoutput>#url.viewId#</cfoutput>Detail" style="width:100%;">
    <thead>
        <tr>
            <cfloop from="1" to="#ArrayLen(session.geoListingDetailFieldMap)#" index="i">
                <th><cf_tl id="#session.geoListingDetailFieldMap[i].label#"></th>
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
            <cfloop from="1" to="#ArrayLen(session.geoListingDetailFieldMap)#" index="i">
                <td>#evaluate("#session.geoListingDetailFieldMap[i].queryField#")#</td>
            </cfloop>
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
            <cfoutput>
                <th colspan="#ArrayLen(session.geoListingDetailFieldMap)#" style="text-align:right;"><cf_tl id="Total"></th>
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

<cfset ajaxOnLoad("function(){ $('.detailGeoContent#url.viewId#Detail').DataTable({ 'pageLength':50, 'lengthMenu':[10,25,50,100,200], #preserveSingleQuotes(session.geoListingDetailOrderScript)# }); }")>