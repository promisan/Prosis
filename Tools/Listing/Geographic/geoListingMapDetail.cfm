<cf_geoListingMapQueryPreparation url="#url#">

<cfquery name="getDataGrade" datasource="srcInspira">		
    SELECT	S.Grade,
			S.GradeSort,
			COUNT(CASE WHEN S.Gender = 'Female' THEN 1 END) as CountFemale,
			COUNT(CASE WHEN S.Gender = 'Male' THEN 1 END) as CountMale,
			COUNT(*) AS Total
	#preserveSingleQuotes(preparationQueryFilters)#
	GROUP BY 
			S.Grade,
			S.GradeSort
	ORDER BY 
			S.GradeSort ASC
</cfquery>

<cfquery name="getNation" datasource="AppsSystem">		
    SELECT	N.*,
            ISNULL(N.Name, '[Undef]') as NationalityName
	FROM    Ref_Nation N
    WHERE   N.ISOCode2 = '#url.country#'
</cfquery>

<cfoutput>
    <h3 style="padding-bottom:10px;">
        #ucase(getNation.NationalityName)# 
        <a style="font-size:50%; padding-left:10px;" href="javascript:showGeoListingSummary('#url.viewId#');">[<cf_tl id="Back to summary">]</a>
    </h3>
</cfoutput>

<table class="table tableDetail table-striped table-bordered table-hover detailGeoContent<cfoutput>#url.viewId#</cfoutput>Detail" style="width:100%;">
    <thead>
        <tr>
            <th><cf_tl id="Sort"></th>
            <th><cf_tl id="Grade"></th>
            <th><cf_tl id="Female"></th>
            <th><cf_tl id="Male"></th>
            <th><cf_tl id="Total"></th>
        </tr>
    </thead>
    <cfset vTotalF = 0>
    <cfset vTotalM = 0>
    <cfset vTotal = 0>
    <cfoutput query="getDataGrade">
        <tr>
            <td>#GradeSort#</td>
            <td>#Grade#</td>
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
            <th colspan="2" style="text-align:right;"><cf_tl id="Total"></th>
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

<cfset ajaxOnLoad("function(){ $('.detailGeoContent#url.viewId#Detail').DataTable({ 'pageLength':50, 'lengthMenu':[10,25,50,100,200], 'order': [[1, 'asc']], 'columnDefs':[{'orderData':[0], 'targets':[1]},{'targets':[0],'visible':false,'searchable':false}] }); }")>