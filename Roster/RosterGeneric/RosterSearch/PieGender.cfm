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
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
</head>

<cfquery name="SearchAction" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM RosterSearch
  WHERE SearchId = '#URL.ID1#'
</cfquery>

<cfquery name="Graph" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  SELECT A.Gender, count(R.PersonNo) as Total
  FROM RosterSearchResult R, Applicant A
  WHERE R.PersonNo = A.PersonNo
  AND R.SearchId = '#URL.ID1#'
  GROUP BY A.Gender

</cfquery>


<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td height="22" align="center" class="top2N"><b>Distribution by Gender</b></td></tr>
<tr><td align="center" class="regular"></td></tr>
<tr><td align="center">

<cfif Graph.recordcount gt 0>

<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart 
	style = "#chartStyleFile#" 
	format="png" 
	chartheight="200" 
	chartwidth="600" 
	pieslicestyle="sliced">
		<cfchartseries 
			type="pie" 
			query="Graph" 
			itemcolumn="Gender" 
			valuecolumn="Total" 
			serieslabel="Gender" 
			seriescolor="##FFFFCC" 
			paintstyle="raise" 
			markerstyle="circle" 
			colorlist="##5DB7E8,##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
		</cfchartseries>
</cfchart>
</cfif>
</td>
</tr>

<tr><td height="10"></td></tr>

</table>



</html>
