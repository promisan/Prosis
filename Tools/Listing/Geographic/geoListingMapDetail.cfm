<cfparam name="url.region"    default="">

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
    SELECT  
            <cfif trim(url.region) neq "">
                CountryGroup,
                <cfloop from="1" to="#ArrayLen(vThisDetailFieldMap)#" index="i">
                    #vThisDetailFieldMap[i].queryField#
                    <cfif i lt ArrayLen(vThisDetailFieldMap)>
                    ,
                    </cfif>
                </cfloop>
            <cfelse>
                #preserveSingleQuotes(vThisDetailSelect)#
            </cfif>
            ,
			#preserveSingleQuotes(vThisCountFemale)# as CountFemale,
			#preserveSingleQuotes(vThisCountMale)# as CountMale,
			#preserveSingleQuotes(vThisCountTotal)# AS Total

	#preserveSingleQuotes(preparationQueryFilters)#

	GROUP BY 
            <cfif trim(url.region) neq "">
                CountryGroup,
                <cfloop from="1" to="#ArrayLen(vThisDetailFieldMap)#" index="i">
                    #vThisDetailFieldMap[i].queryField#
                    <cfif i lt ArrayLen(vThisDetailFieldMap)>
                    ,
                    </cfif>
                </cfloop>
            <cfelse>
                #preserveSingleQuotes(vThisDetailSelect)#
            </cfif>

	ORDER BY 
            <cfif trim(url.region) neq "">
                CountryGroup,
                <cfloop from="1" to="#ArrayLen(vThisDetailFieldMap)#" index="i">
                    #vThisDetailFieldMap[i].queryField#
                    <cfif i lt ArrayLen(vThisDetailFieldMap)>
                    ,
                    </cfif>
                </cfloop>
            <cfelse>
                #preserveSingleQuotes(vThisDetailOrder)#
            </cfif>
			
</cfquery>

<cfquery name="getNation" datasource="AppsSystem">		
    SELECT	N.*,
            ISNULL(N.Name, '[Undef]') as NationalityName
	FROM    Ref_Nation N
    WHERE   N.ISOCode2 = '#url.country#'
</cfquery>

<cfoutput>
    <cfset vMainSummaryFunction = evaluate("session.geoListingMainTableScriptFunction_#url.viewId#")>
    <h3 style="padding-bottom:10px;">
        <cfif trim(url.country) neq "">
            #ucase(getNation.NationalityName)# 
        </cfif>
        <cfif trim(url.region) neq "">
            #ucase(url.region)# 
        </cfif>
        <a style="font-size:50%; padding-left:10px;" href="javascript:#vMainSummaryFunction#('#url.viewId#');">[<cf_tl id="Back to summary">]</a>
    </h3>
</cfoutput>

<table class="table tableDetail table-striped table-bordered table-hover detailGeoContent<cfoutput>#url.viewId#</cfoutput>Detail" style="width:100%;">
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
                <th colspan="#ArrayLen(vThisDetailFieldMap)#" style="text-align:right;"><cf_tl id="Total"></th>
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


<cfif trim(url.region) neq "" AND trim(url.country) eq "">

    <cfquery name="getDataRegionDetail" datasource="#vThisDatasource#">		
        SELECT  Country,
                NationalityName,
                #preserveSingleQuotes(vThisCountFemale)# as CountFemale,
                #preserveSingleQuotes(vThisCountMale)# as CountMale,
                #preserveSingleQuotes(vThisCountTotal)# AS Total

        #preserveSingleQuotes(preparationQueryFilters)#

        GROUP BY 
                Country, 
                NationalityName
        ORDER BY 
                NationalityName
                
    </cfquery>

    <h3 style="padding-bottom:10px; padding-top:20px;">
        <cf_tl id="Region Country Detail" var="lblCountryDetail">
        <cfoutput>
            #UCASE(lblCountryDetail)#
            <a style="font-size:50%; padding-left:10px;" href="javascript:#vMainSummaryFunction#('#url.viewId#');">[<cf_tl id="Back to summary">]</a>
        </cfoutput>
    </h3>

    <table class="table tableDetail table-striped table-bordered table-hover detailGeoRegionContent<cfoutput>#url.viewId#</cfoutput>Detail" style="width:100%;">
        <thead>
            <tr>
                <th><cf_tl id="Country"></th>
                <th><cf_tl id="Female"></th>
                <th><cf_tl id="Male"></th>
                <th><cf_tl id="Total"></th>
            </tr>
        </thead>
        <cfset vTotalF = 0>
        <cfset vTotalM = 0>
        <cfset vTotal = 0>
        <cfoutput query="getDataRegionDetail">
            <tr>
                <td>#NationalityName#</td>
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
                    <th style="text-align:right;"><cf_tl id="Total"></th>
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

    <cfset ajaxOnLoad("function(){ $('.detailGeoRegionContent#url.viewId#Detail').DataTable({ 'pageLength':50, 'lengthMenu':[10,25,50,100,200], 'order': [[0, 'asc']] }); }")>

</cfif>