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

<!--- generate a chort --->

<cfquery name="Resource" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    R.Code, 
	          R.Description, 
			  R.Listingorder, 
			  SUM(PA.Amount * (PAE.Percentage / 100)) AS Amount
	FROM      ProgramAllotmentDetail PA INNER JOIN
              ProgramAllotmentEarmark PAE ON PA.ProgramCode = PAE.ProgramCode AND PA.Period = PAE.Period AND PA.EditionId = PAE.EditionId INNER JOIN
              Ref_ProgramCategory R ON PAE.ProgramCategory = R.Code LEFT OUTER JOIN
              Ref_Object O ON PA.ObjectCode = O.Code AND PAE.Resource = O.Resource
	WHERE     PA.ProgramCode = '#url.programCode#' 
	  AND     PA.Period      = '#url.period#' 
	  AND     PA.EditionId   = '#url.editionid#' 
	  AND     PAE.Percentage > 0
	  AND     PA.Status IN ('0', '1')
	  AND     R.AreaCode = '#URL.area#'
	GROUP BY  R.Code, 
	          R.Description, 
			  R.Listingorder
	HAVING    SUM(PA.Amount * (PAE.Percentage / 100)) > 0
	ORDER BY  R.Listingorder	
</cfquery>	

<cfif Resource.recordcount gte "1">

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td>
	
	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png"
           chartheight="379"
           chartwidth="690"
           scalefrom="0"
           gridlines="6"
           showxgridlines="yes"
           seriesplacement="default"
           font="Verdana"
           fontsize="12"          
           labelformat="number"
           show3d="yes"
           tipstyle="mouseOver"
           tipbgcolor="F4F4F4"
           showmarkers="yes"
           markersize="30"
           pieslicestyle="sliced"
           backgroundcolor="ffffff">
				 
		<cfchartseries
             type="pie"
             query="Resource"
             itemcolumn="Description"
             valuecolumn="Amount"
             seriescolor="0000CC"
             datalabelstyle="pattern"			 
             paintstyle="light"
             markerstyle="mcross"
             colorlist="##CCCC66,##3399FF,##66CC66,##999999,##FFFF99,##9966FF,##FF7777,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA"></cfchartseries>
					 
	</cfchart>

		</td></tr>
</table>

</cfif>