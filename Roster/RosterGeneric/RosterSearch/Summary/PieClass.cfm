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
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM RosterSearch
  WHERE SearchId = '#URL.ID1#'
</cfquery>

<cfquery name="Class" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  SELECT Ref.Description, count(R.PersonNo) as Total
  FROM RosterSearchResult R, Applicant A, Ref_ApplicantClass Ref
  WHERE R.PersonNo = A.PersonNo
  AND Ref.ApplicantClassId = A.ApplicantClass
  AND R.SearchId = '#URL.ID1#'
  GROUP BY Ref.Description
</cfquery>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td align="center" class="labellarge" style="color:#808080;"><cf_tl id="By Class"></td></tr>

<tr>

<td align="center">

<cfif Class.recordcount gt 0>

<cf_uichart name="class"	
	format="png" 
	chartheight="300" 
	chartwidth="490" 
	pieslicestyle="sliced">

		<cf_uichartseries 
			type="pie" 
			query="#Class#" 
			itemcolumn="Description" 
			valuecolumn="Total" 
			seriescolor="FFFFCC" 
			paintstyle="raise" 
			markerstyle="circle" 
			colorlist="#vColorlist#">
		</cf_uichartseries>
		
</cf_uichart>
</cfif>

</td>
</tr>

</table>

</tr>

</table>

</html>
