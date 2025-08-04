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


<cfquery name="SearchAction" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM PersonSearch
  WHERE SearchId = '#URL.ID1#'
</cfquery>

<cfquery name="Graph" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  SELECT A.Gender, count(R.PersonNo) as Total
  FROM PersonSearchResult R, Person A
  WHERE R.PersonNo = A.PersonNo
  AND R.SearchId = #URL.ID1#
  GROUP BY A.Gender
    
</cfquery>

<cfif Graph.recordCount neq "0">

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td align="center"><b><cf_tl id="Distribution by Gender"></b></td></tr>
<tr><td align="center"></td></tr>
<tr><td align="center">

<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="html"
           chartheight="340"
           chartwidth="800"
           showygridlines="no"
           seriesplacement="default"          
           sortxaxis="yes"
           show3d="no"
           tipstyle="mouseOver"
           tipbgcolor="000000"
           pieslicestyle="sliced">

<cfchartseries
             type="pie"
             query="Graph"
             itemcolumn="Gender"
             valuecolumn="Total"
             serieslabel="Gender"
             seriescolor="00FFFC"
             paintstyle="raise"
			 colorlist="##66AC6A,##999A9A"
             markerstyle="circle"></cfchartseries>

</cfchart>
</td>
</tr>

<tr><td height="10"></td></tr>

</table>

</cfif>
