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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
</head>

<cfquery name="SearchAction" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RosterSearch
    WHERE  SearchId = '#URL.ID1#'
</cfquery>

<cfquery name="Graph" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	  SELECT N.Continent, count(R.PersonNo) as Total
	  FROM   RosterSearchResult R, Applicant A, System.dbo.Ref_Nation N
	  WHERE  R.PersonNo = A.PersonNo
	  AND    R.SearchId = #URL.ID1#
	  AND    N.Code = A.Nationality
	  GROUP BY N.Continent    
</cfquery>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">


<tr><td align="center" class="labellarge" style="color:#808080;"><cf_tl id="By Continent"></td></tr>
<tr>

<td align="center">

<cf_uichart name="Continent" format="png" 
	 chartheight="300" 
	 chartwidth="600">
	
	<cf_uichartseries type="pie" 
	  query="#Graph#" 
	  itemcolumn="Continent" 
	  valuecolumn="Total" 
	  seriescolor="##FFFFCC" 
	  paintstyle="raise" 
	  markerstyle="circle"
	  colorlist="#vColorlist#">
	</cf_uichartseries>

</cf_uichart>
</td>

</tr>

</table>

</tr>

</table>

</html>
