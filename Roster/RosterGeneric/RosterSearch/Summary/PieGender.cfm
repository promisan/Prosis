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
<cfquery name="SearchAction" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   RosterSearch
  WHERE  SearchId = '#URL.ID1#'
</cfquery>

<cfquery name="Gender" 
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

<tr><td>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td align="center" class="labellarge" style="color:#808080;"><cf_tl id="By Gender"></td></tr>

<tr>
<td align="center">

<cfoutput>

<cfif Gender.recordcount gt 0>
	
	<!--- url="../ResultListing.cfm?mode=#url.mode#&ID=GEN&ID1=#URL.ID1#&ID2=$ITEMLABEL$&ID3=NONE" --->
	
	<cf_uichart name="gender" format="png"
          chartheight="300"
          chartwidth="360"
          pieslicestyle="sliced">

		<cf_uichartseries
            type="pie"
            query="#Gender#"
            itemcolumn="Gender"
            valuecolumn="Total"
            seriescolor="FFFFCC"
            paintstyle="raise"
            markerstyle="circle"
            colorlist="#vColorlist#">
		</cf_uichartseries>
				 
	</cf_uichart>
	
</cfif>


</cfoutput>

</td>

</tr>

</table>

</tr>

</table>

</html>
