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
  FROM RosterSearch
  WHERE SearchId = '#URL.ID1#'
</cfquery>

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#RosterAge">	

<cfset dte  = #DateAdd("yyyy", "-20", now())#>

<cfquery name="Class" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT '0 - 20 ' as Age, count(R.PersonNo) as Total, 1 as ListingOrder
     INTO  userQuery.dbo.tmp#SESSION.acc#RosterAge
     FROM  RosterSearchResult R, Applicant A
     WHERE R.PersonNo = A.PersonNo
     AND   R.SearchId = '#URL.ID1#'
     AND   A.DOB > #dte# 
</cfquery>

<cfset dts  = #DateAdd("yyyy", "-20", now())#>
<cfset dte  = #DateAdd("yyyy", "-30", now())#>

<cfquery name="Class" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  INSERT INTO userQuery.dbo.tmp#SESSION.acc#RosterAge	 
  (Age, Total, ListingOrder)
  SELECT '20 - 29' as Age, count(R.PersonNo) as Total, 2 as ListingOrder
  FROM RosterSearchResult R, Applicant A
  WHERE R.PersonNo = A.PersonNo
  AND R.SearchId = '#URL.ID1#'
  AND A.DOB > #dte# and A.DOB <= #dts#
</cfquery>

<cfset dts  = #DateAdd("yyyy", "-30", now())#>
<cfset dte  = #DateAdd("yyyy", "-40", now())#>

<cfquery name="Class" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  INSERT INTO userQuery.dbo.tmp#SESSION.acc#RosterAge	 
  (Age, Total, ListingOrder)
  SELECT '30 - 39' as Age, count(R.PersonNo) as Total, 3 as ListingOrder
  FROM RosterSearchResult R, Applicant A
  WHERE R.PersonNo = A.PersonNo
  AND R.SearchId = '#URL.ID1#'
  AND A.DOB > #dte# and A.DOB <= #dts#
</cfquery>

<cfset dts  = #DateAdd("yyyy", "-40", now())#>
<cfset dte  = #DateAdd("yyyy", "-50", now())#>

<cfquery name="Class" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  	INSERT INTO userQuery.dbo.tmp#SESSION.acc#RosterAge	 
	  (Age, Total, ListingOrder)
	  SELECT '40 - 49' as Age, count(R.PersonNo) as Total, 4 as ListingOrder
	  FROM RosterSearchResult R, Applicant A
	  WHERE R.PersonNo = A.PersonNo
	  AND R.SearchId = '#URL.ID1#'
	  AND A.DOB > #dte# and A.DOB <= #dts#
</cfquery>

<cfset dts  = #DateAdd("yyyy", "-50", now())#>
<cfset dte  = #DateAdd("yyyy", "-60", now())#>

<cfquery name="Class" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	  INSERT INTO userQuery.dbo.tmp#SESSION.acc#RosterAge	 
	  (Age, Total, ListingOrder)
	  SELECT '50 - 59' as Age, count(R.PersonNo) as Total, 5 as ListingOrder
	  FROM RosterSearchResult R, Applicant A
	  WHERE R.PersonNo = A.PersonNo
	  AND R.SearchId = '#URL.ID1#'
	  AND A.DOB > #dte# and A.DOB <= #dts#
</cfquery>

<cfset dts  = #DateAdd("yyyy", "-60", now())#>

<cfquery name="Class" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	  INSERT INTO userQuery.dbo.tmp#SESSION.acc#RosterAge	 
	  (Age, Total, ListingOrder)
	  SELECT '60+' as Age, count(R.PersonNo) as Total, 6 as ListingOrder
	  FROM RosterSearchResult R, Applicant A
	  WHERE R.PersonNo = A.PersonNo
	  AND R.SearchId = '#URL.ID1#'
	  AND A.DOB <= #dts#
</cfquery>

<cfquery name="Age" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT * FROM userQuery.dbo.tmp#SESSION.acc#RosterAge	 
	 ORDER BY ListingOrder ASC
</cfquery>

<cfquery name="Max" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT MAX(Total) as Total
  	 FROM   userQuery.dbo.tmp#SESSION.acc#RosterAge	 
</cfquery>

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#RosterAge">

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td align="center" class="labellarge" style="color:#808080;"><cf_tl id="By Age"></td></tr>
<tr>
<td align="center">

<cfif Age.recordcount gt 0>

<cf_uichart name="age" format="png" 
	chartheight="300" 
	chartwidth="260" 
	scalefrom="0" 
	fontsize="12"
	scaleto="#Max.Total+1#" 
	pieslicestyle="sliced" >
	
		<cf_uichartseries 
			type="bar" 
			query="#Age#" 
			itemcolumn="Age" 
			valuecolumn="Total" 
			seriescolor="5DB7E8" 
			paintstyle="raise" 
			markerstyle="circle"
			colorlist="#vColorlist#">
		</cf_uichartseries>
		
</cf_uichart>
</cfif>

</td>
</tr>

</table>

