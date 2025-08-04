<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cf_geoListingMapQueryPreparation url="#url#" exclude="SelectionDate" viewId="#url.viewId#">

<cfset vThisDatasource = evaluate("session.geoListingDataSource_#url.viewId#")>
<cfset vThisFilterMap = evaluate("session.geoListingFilterMap_#url.viewId#")>

<cfset vSelectedDate = "">
<cfset vGenderFilter = 0>
<cfset vUnitFilter = 0>
<cfset vRegionalGroupFilter = 0>
<cfset vGradeFilter = 0>

<cfloop from="1" to="#arraylen(vThisFilterMap)#" index="i">
    <cfif trim(lcase(vThisFilterMap[i].queryField)) eq "selectiondate">
        <cfset vSelectedDate = evaluate("url.#vThisFilterMap[i].id#")>
    </cfif>

    <cfif trim(lcase(vThisFilterMap[i].queryField)) eq "gender" AND trim(evaluate("url.#vThisFilterMap[i].id#")) neq "">
        <cfset vGenderFilter = 1>
    </cfif>

    <cfif trim(lcase(vThisFilterMap[i].queryField)) eq "MissionParent" AND trim(evaluate("url.#vThisFilterMap[i].id#")) neq "">
        <cfset vUnitFilter = 1>
    </cfif>

    <cfif trim(lcase(vThisFilterMap[i].queryField)) eq "CountryGroup" AND trim(evaluate("url.#vThisFilterMap[i].id#")) neq "">
        <cfset vRegionalGroupFilter = 1>
    </cfif>

    <cfif trim(lcase(vThisFilterMap[i].queryField)) eq "PositionGrade" AND trim(evaluate("url.#vThisFilterMap[i].id#")) neq "">
        <cfset vGradeFilter = 1>
    </cfif>
</cfloop>

<cfquery name="getPeriods" datasource="MartStaffing">
    SELECT TOP 5 *
    FROM	Period
    WHERE	DataMart = 'Geographic'
    <cfif vSelectedDate neq "">
        AND SelectionDate <= '#vSelectedDate#'
    </cfif>
    ORDER BY SelectionDate ASC
</cfquery>

<cfquery name="getPeriodsMax" dbtype="query">
    SELECT  MAX(SelectionDate) as MaxSelectionDate
    FROM    getPeriods
</cfquery>

<cfquery name="getComplementDataDetail" datasource="#vThisDatasource#">		
    SELECT  Status 
            <cfoutput query="getPeriods">
                , (
                    SELECT  COUNT(*)
                    FROM    Gender Gx
                            INNER JOIN NOVA.dbo.Ref_Nation AS Rx
                                ON Gx.NationalityCode = Rx.ISOCODE2
                    WHERE   Gx.Mission = geoData.Mission
                    AND     geoData.Status = (
                                                SELECT   TOP 1 Ix.Status
                                                FROM     NOVA.dbo.Ref_NationIndicator Ix
                                                WHERE    Ix.Code = Rx.Code 
                                                AND      Ix.StatusClass = 'Represent' 
                                                AND      Ix.DateEffective <= '#vSelectedDate#'
                                                ORDER BY Ix.DateEffective DESC
                                            )
                    AND     Gx.SelectionDate = '#SelectionDate#'
                    AND     Gx.Incumbency = 100
                    AND     Gx.TransactionType = '0'
                    AND     (LEFT(Gx.PositionGrade,1) IN ('P','D') OR Gx.PositionGrade IN ('ASG','USG'))
                    AND     Gx.PositionNature = 'Geographical'
                    <cfif vGenderFilter eq 1>
                        AND     Gx.Gender = geoData.Gender
                    </cfif>
                    <cfif vUnitFilter eq 1>
                        AND     Gx.MissionParent = geoData.MissionParent
                    </cfif>
                    <cfif vRegionalGroupFilter eq 1>
                        AND     Rx.CountryGroup = geoData.CountryGroup
                    </cfif>
                    <cfif vGradeFilter eq 1>
                        AND     Gx.PositionGrade = geoData.PositionGrade
                    </cfif>
                ) AS f_#dateFormat(SelectionDate, 'yyyymmdd')#
            </cfoutput>

            <cfif getPeriodsMax.MaxSelectionDate neq vSelectedDate>
                , (
                    SELECT  COUNT(*)
                    FROM    Gender Gx
                            INNER JOIN NOVA.dbo.Ref_Nation AS Rx
                                ON Gx.NationalityCode = Rx.ISOCODE2
                    WHERE   Gx.Mission = geoData.Mission
                    AND     geoData.Status = (
                                                SELECT   TOP 1 Ix.Status
                                                FROM     NOVA.dbo.Ref_NationIndicator Ix
                                                WHERE    Ix.Code = Rx.Code 
                                                AND      Ix.StatusClass = 'Represent' 
                                                AND      Ix.DateEffective <= '#vSelectedDate#'
                                                ORDER BY Ix.DateEffective DESC
                                            )
                    AND     Gx.SelectionDate = '#vSelectedDate#'
                    AND     Gx.Incumbency = 100
                    AND     Gx.TransactionType = '0'
                    AND     (LEFT(Gx.PositionGrade,1) IN ('P','D') OR Gx.PositionGrade IN ('ASG','USG'))
                    AND     Gx.PositionNature = 'Geographical'
                    <cfif vGenderFilter eq 1>
                        AND     Gx.Gender = geoData.Gender
                    </cfif>
                    <cfif vUnitFilter eq 1>
                        AND     Gx.MissionParent = geoData.MissionParent
                    </cfif>
                    <cfif vRegionalGroupFilter eq 1>
                        AND     Rx.CountryGroup = geoData.CountryGroup
                    </cfif>
                    <cfif vGradeFilter eq 1>
                        AND     Gx.PositionGrade = geoData.PositionGrade
                    </cfif>
                ) AS f_#dateFormat(vSelectedDate, 'yyyymmdd')#
            </cfif>

	#preserveSingleQuotes(preparationQueryFilters)#

    AND     Status != ''
    AND     Status IS NOT NULL

    <cfif vSelectedDate neq "">
        AND SelectionDate <= '#vSelectedDate#'
    </cfif>

	GROUP BY 
            Mission
            , Status
            <cfif vGenderFilter eq 1>
                , Gender
            </cfif>
            <cfif vUnitFilter eq 1>
                , MissionParent
            </cfif>
            <cfif vRegionalGroupFilter eq 1>
                , CountryGroup
            </cfif>
            <cfif vGradeFilter eq 1>
                , PositionGrade
            </cfif>
	ORDER BY Mission, Status
</cfquery>

<cfquery name="getComplementDataDetailLimits" dbtype="query">
    SELECT  '' as Limits
            <cfoutput query="getPeriods">
                , SUM(f_#dateFormat(SelectionDate, 'yyyymmdd')#) AS Total_#dateFormat(SelectionDate, 'yyyymmdd')#
                , MAX(f_#dateFormat(SelectionDate, 'yyyymmdd')#) AS Max_#dateFormat(SelectionDate, 'yyyymmdd')#
                , MIN(f_#dateFormat(SelectionDate, 'yyyymmdd')#) AS Min_#dateFormat(SelectionDate, 'yyyymmdd')#
            </cfoutput>
            <cfif getPeriodsMax.MaxSelectionDate neq vSelectedDate>
                , SUM(f_#dateFormat(vSelectedDate, 'yyyymmdd')#) AS Total_#dateFormat(vSelectedDate, 'yyyymmdd')#
                , MAX(f_#dateFormat(vSelectedDate, 'yyyymmdd')#) AS Max_#dateFormat(vSelectedDate, 'yyyymmdd')#
                , MIN(f_#dateFormat(vSelectedDate, 'yyyymmdd')#) AS Min_#dateFormat(vSelectedDate, 'yyyymmdd')#
            </cfif>
    FROM    getComplementDataDetail
</cfquery>

<cf_tl id="Export to Excel" var="lblExportToExcel">
<cfoutput>
    <h3 style="padding-bottom:10px;">
        <img src="#session.root#/images/Excel.png" style="cursor:pointer;" width="30" height="30" onclick="Prosis.exportToExcel('detailGeoCompLongitudinalByStatusContent#url.viewId#Detail');" title="#lblExportToExcel#">
        LONGITUDINAL BY REPRESENTATION
    </h3>
</cfoutput>

<table class="table tableDetail table-striped table-bordered table-hover detailGeoCompLongitudinalByStatusContent<cfoutput>#url.viewId#</cfoutput>Detail" id="detailGeoCompLongitudinalByStatusContent<cfoutput>#url.viewId#</cfoutput>Detail" style="width:100%;">
    <thead>
        <tr>
            <th><cf_tl id="Status"></th>
            <cfoutput query="getPeriods">
                <th style="text-align:right;">#dateFormat(SelectionDate, 'mmm-yyyy')#</th>
            </cfoutput>
            <cfif getPeriodsMax.MaxSelectionDate neq vSelectedDate>
                <cfoutput>
                    <th style="text-align:right;">#dateFormat(vSelectedDate, 'mmm-yyyy')#</th>
                </cfoutput>
            </cfif>
        </tr>
    </thead>
    <cfset vTotal = 0>
    <cfoutput query="getComplementDataDetail">
        <tr>
            <td>#Status#</td>
            <cfloop query="getPeriods">
                <td style="text-align:right;" data-order="#evaluate("getComplementDataDetail.f_#dateFormat(SelectionDate, 'yyyymmdd')#")#">
                    <table width="100%">
                        <tr>
                            <td style="font-size:60%;">
                                <cfif evaluate("getComplementDataDetailLimits.Total_#dateFormat(SelectionDate, 'yyyymmdd')#") neq 0>
                                    #numberFormat(evaluate("getComplementDataDetail.f_#dateFormat(SelectionDate, 'yyyymmdd')#")*100/evaluate("getComplementDataDetailLimits.Total_#dateFormat(SelectionDate, 'yyyymmdd')#"), ",._")# %
                                </cfif>
                            </td>
                            <td style="text-align:right;">
                                #numberFormat(evaluate("getComplementDataDetail.f_#dateFormat(SelectionDate, 'yyyymmdd')#"), ",")#
                            </td>
                        </tr>
                    </table>
                </td>
            </cfloop>
            <cfif getPeriodsMax.MaxSelectionDate neq vSelectedDate>
                <td style="text-align:right;" data-order="#evaluate("getComplementDataDetail.f_#dateFormat(vSelectedDate, 'yyyymmdd')#")#">
                    <table width="100%">
                        <tr>
                            <td style="font-size:60%;">
                                <cfif evaluate("getComplementDataDetailLimits.Total_#dateFormat(vSelectedDate, 'yyyymmdd')#") neq 0>
                                    #numberFormat(evaluate("getComplementDataDetail.f_#dateFormat(vSelectedDate, 'yyyymmdd')#")*100/evaluate("getComplementDataDetailLimits.Total_#dateFormat(vSelectedDate, 'yyyymmdd')#"), ",._")# %
                                </cfif>
                            </td>
                            <td style="text-align:right;">
                                #numberFormat(evaluate("getComplementDataDetail.f_#dateFormat(vSelectedDate, 'yyyymmdd')#"), ",")#
                            </td>
                        </tr>
                    </table>
                </td>

            </cfif>
        </tr>
        <cfset vTotal = vTotal + 0>
    </cfoutput>
    <tfoot>
        <tr>
            <th style="text-align:right;"><cf_tl id="Total"></th>
            <cfoutput query="getPeriods">
                <th style="text-align:right;">
                    #numberFormat(evaluate("getComplementDataDetailLimits.Total_#dateFormat(SelectionDate, 'yyyymmdd')#"), ",")#
                </th>
            </cfoutput>
            <cfif getPeriodsMax.MaxSelectionDate neq vSelectedDate>
                <th style="text-align:right;">
                    <cfoutput>
                        #numberFormat(evaluate("getComplementDataDetailLimits.Total_#dateFormat(vSelectedDate, 'yyyymmdd')#"), ",")#
                    </cfoutput>
                </th>
            </cfif>
        </tr>
    </tfoot>
</table>

<cfset ajaxOnLoad("function(){ $('.detailGeoCompLongitudinalByStatusContent#url.viewId#Detail').DataTable({ 'pageLength':25, 'lengthMenu':[10,25,50,100,200], 'order': [[0, 'asc']] }); }")>

<!--- Line chart --->
<cfset "doChart_summaryComplementLongitudinalByStatusMapChart" = "">

<cfset vSeriesCount = 1>
<cfset vSeriesArray = ArrayNew(1)>

<cfquery name="getComplementDataDetailDistinctStatus" dbtype="query">
    SELECT  DISTINCT Status
    FROM    getComplementDataDetail
</cfquery>

<cfset vSeriesColors = []>
<cfset vSeriesColors = ['##00a8ff','##c23616','##44bd32','##fbc531','##8c7ae6','##ff9ff3','##1dd1a1','##ee5253', '##ff5252', '##474787', '##ffda79']>

<cfoutput query="getComplementDataDetailDistinctStatus">

    <cfquery name="getComplementDataDetailGraph" dbtype="query">
        <cfset vCountPeriods = 0>
        <cfloop query="getPeriods">
            <cfif vCountPeriods neq 0>UNION ALL</cfif>
            SELECT  '#SelectionDate#' as SelectionDateRaw,
                    '#dateFormat(SelectionDate, 'mmm-yyyy')#' as SelectionDate,
                    (
                        f_#dateFormat(SelectionDate, 'yyyymmdd')# 
                        /
                        <cfif evaluate("getComplementDataDetailLimits.Total_#dateFormat(SelectionDate, 'yyyymmdd')#") eq 0>
                            1
                        <cfelse>
                            #evaluate("getComplementDataDetailLimits.Total_#dateFormat(SelectionDate, 'yyyymmdd')#")#
                        </cfif>
                    ) * 100 AS Total
            FROM    getComplementDataDetail
            WHERE   Status = '#getComplementDataDetailDistinctStatus.Status#'
            <cfset vCountPeriods = vCountPeriods + 1>
        </cfloop>
        <cfif getPeriodsMax.MaxSelectionDate neq vSelectedDate>
            UNION ALL
            SELECT  '#vSelectedDate#' as SelectionDateRaw,
                    '#dateFormat(vSelectedDate, 'mmm-yyyy')#' as SelectionDate,
                    (
                        f_#dateFormat(vSelectedDate, 'yyyymmdd')# 
                        /
                        <cfif evaluate("getComplementDataDetailLimits.Total_#dateFormat(vSelectedDate, 'yyyymmdd')#") eq 0>
                            1
                        <cfelse>
                            #evaluate("getComplementDataDetailLimits.Total_#dateFormat(vSelectedDate, 'yyyymmdd')#")#
                        </cfif>
                    ) * 100 AS Total
            FROM    getComplementDataDetail
            WHERE   Status = '#getComplementDataDetailDistinctStatus.Status#'
        </cfif>
    </cfquery>

    <cfquery name="getComplementDataDetailGraphOrdered" dbtype="query">
        SELECT  *
        FROM    getComplementDataDetailGraph
        ORDER BY SelectionDateRaw ASC
    </cfquery>

    <cfset vSeries = StructNew()>
    <cfset vSeries.query = "#getComplementDataDetailGraphOrdered#">
    <cfset vSeries.name = "#Status#">
    <cfset vSeries.label = "SelectionDate">
    <cfset vSeries.value = "Total">
  
    <cfset vSeries.color = "#vSeriesColors[vSeriesCount]#">
    <cfset vSeries.transparency = 0.9>
    <cfset vSeriesArray[vSeriesCount] = vSeries>
    <cfset vSeriesCount = vSeriesCount + 1>
</cfoutput>

<cf_mobileGraph
    id = "summaryComplementLongitudinalByStatusMapChart"
    type = "Line"
    series = "#vSeriesArray#"
    responsive = "yes"
    scaleStep = "1"
    height = "200px"
    legend = "true"
    legendPosition = "bottom"
    labelAppend = "%"
    dataPoints = "yes"
    scaleLabel = "<%= numberAddCommas(value) %>"
    tooltipLabel = "<%if (label){%><%=label%>: <%}%><%= numberAddCommas(value) %>">
</cf_mobileGraph>

<cfset ajaxOnLoad("function(){ #doChart_summaryComplementLongitudinalByStatusMapChart# }")>

<cfoutput>
    <style>
        .detailGeoCompLongitudinalByStatusContent#url.viewId#Detail thead tr th {
            font-size:12px;
        }
    </style>
</cfoutput>

