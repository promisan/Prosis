<!--
    Copyright © 2025 Promisan B.V.

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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
</head>

<cfset vColorlist = "##5DB7E8,##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">

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
	  SELECT N.Name, count(R.PersonNo) as Total
	  FROM RosterSearchResult R, Applicant A, System.dbo.Ref_Nation N
	  WHERE R.PersonNo = A.PersonNo
	  AND R.SearchId = #URL.ID1#
	  AND N.Code = A.Nationality
	  AND N.Continent = '#URL.ID2#'
	  GROUP BY N.Name
</cfquery>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	
	<tr><td align="center" class="labellarge" style="color:#808080;"><cf_tl id="By Country"></td></tr>
	<tr><td align="center">
		
		<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">

		<cfchart style = "#chartStyleFile#" 
		 format="png" 
		 chartheight="500" 
		 show3d="yes"
		 chartwidth="500">
		
			<cfchartseries 
			type="pie" 
			query="Graph" 
			itemcolumn="Name" 
			valuecolumn="Total" 			
			seriescolor="##FFFFCC" 
			paintstyle="raise" 
			markerstyle="circle"
			colorlist="#vColorlist#">
			
			</cfchartseries>
		
		</cfchart>
	</td>
	</tr>

</table>



</html>
