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
<!--- 
	OrphanedAssignmentsListing.CFM

	Get orphaned assignments according to the following rules:
	1. Assignments in current period on positions that have no match in the succeeding period.
	2. Assignments in current period on positions that have a match in the succeeding period but
	where the IMIS numbers (in SourcePostNumber) do not match.

	View orphaned assignments.
	
	Modification History:
	27Jun05 - created by MM
--->
<HTML><HEAD><TITLE>Orphaned Assignments</TITLE></HEAD>

<cfset CLIENT.DataSource = "AppsEmployee">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<cf_PreventCache>

<script language = "JavaScript">
function reloadForm(page) {
    window.location="OrphanedAssignmentsListing.cfm?Page=" + page;
}
</script>

<cfparam name="URL.ID" default="">
<cfparam name="URL.ID1" default="">
<cfparam name="URL.Page" default="1">

<cfquery name="Get" datasource="AppsOrganization"  
 username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT * FROM Ref_Mandate
WHERE Mission = '#URL.ID#'
AND	  MandateNo = '#URL.ID1#'
</cfquery>

<cfquery name="GetRecs" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT  po.PostType, p.LastName, p.FirstName, pa.DateArrival, pa.DateDeparture, 
		po.SourcePostNumber AS currentSourcePostNumber, 
        po1.SourcePostNumber AS futureSourcePostNumber
FROM    PersonAssignment pa INNER JOIN
		Person p ON pa.PersonNo = p.PersonNo INNER JOIN
		Position po ON pa.PositionNo = po.PositionNo INNER JOIN
		[Position] po1 ON po.PositionNo = po1.SourcePositionNo AND po.SourcePostNumber <> po1.SourcePostNumber
WHERE	po.Mission = '#Get.Mission#'
AND 	po.MandateNo = '#Get.MandateParent#'
AND 	po.PostType IN ('International','Local') 
AND 	(pa.DateEffective IS NULL OR pa.DateEffective <= '#Get.DateExpiration#')
AND     pa.AssignmentNo = (SELECT Max(pa1.AssignmentNo) 
							FROM PersonAssignment pa1
							WHERE pa1.PersonNo = pa.PersonNo)	
UNION
SELECT  po.PostType, p.LastName, p.FirstName, pa.DateArrival, pa.DateDeparture, 
		po.SourcePostNumber AS currentSourcePostNumber, 
        po1.SourcePostNumber AS futureSourcePostNumber
FROM    PersonAssignment pa INNER JOIN
        Person p ON pa.PersonNo = p.PersonNo INNER JOIN
	    [Position] po ON pa.PositionNo = po.PositionNo LEFT OUTER JOIN
		Position po1 ON po.PositionNo = po1.SourcePositionNo
WHERE   po.Mission = '#Get.Mission#'
AND 	po.MandateNo = '#Get.MandateParent#'
AND 	po.PostType IN ('International','Local') 
AND 	(pa.DateEffective IS NULL OR pa.DateEffective <= '#Get.DateExpiration#')
AND		po1.SourcePositionNo IS NULL
AND     pa.AssignmentNo = (SELECT Max(pa1.AssignmentNo) 
							FROM PersonAssignment pa1
							WHERE pa1.PersonNo = pa.PersonNo)
</cfquery>

<cfquery name="SearchResult" dbtype="query">
	SELECT DISTINCT * FROM GetRecs
	ORDER BY PostType, LastName, FirstName
</cfquery>
<!--- Query returning search results --->
<body class="main" onload="window.focus()">

<form name="OrphanedAssignmentsListing" id="OrphanedAssignmentsListing">

<!--- Column headers --->
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<tr>
	<td class="regularG" colspan="3">
		<cfoutput>Mission - MandateNo: #Get.Mission# - #Get.MandateNo#</cfoutput>
	</td>

	<cfinclude template="../../../Tools/PageCount.cfm">
	
	<td colspan="4" align="right">
	<select name="page" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(this.value)">
			 <cfloop index="Item" from="1" to="#pages#" step="1">
    			<cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>#Item# of #pages#</option></cfoutput>
		     </cfloop>	 
	</select>&nbsp;&nbsp;
	</td>
</tr>

<tr bgcolor="#8EA4BB">
    <td class="topN">&nbsp;</td>
    <td class="topN"><cf_tl id="Last Name"></td>
	<td class="topN"><cf_tl id="First Name"></td>
	<td class="topN"><cf_tl id="Arrival"></td>			
	<td class="topN"><cf_tl id="Departure"></td>
	<td class="topN"><cf_tl id="IMIS Post"></td>
	<td class="topN"><cf_tl id="New IMIS Post"></td>		
</tr>

<!--- Record detail row --->
<cfoutput query="SearchResult" group="PostType" startrow=#first# maxrows=#No#>
<tr><td colspan="7" height="15">&nbsp;</td></tr>
<tr bgcolor="f6f6f6">
	<td colspan="7"><font face="Tahoma" size="2"><b>&nbsp;#PostType#</b></font></td>
</tr>

<cfoutput>
<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	<td class="regular">#CurrentRow#.</td>	
	<td class="regular">#SearchResult.LastName#</td>
	<td class="regular">#SearchResult.FirstName#</td>
	<td class="regular">#DateFormat(DateArrival, "#CLIENT.DateFormatShow#")#</td>		
	<td class="regular">#DateFormat(DateDeparture, "#CLIENT.DateFormatShow#")#</td>		
	<td class="regular">#SearchResult.currentSourcePostNumber#</td>
	<td class="regular">#SearchResult.futureSourcePostNumber#</td>
</tr>
</cfoutput>

</cfoutput>
</table>

<hr><p align="center"><font face="Tahoma" size="1"><cfoutput>#SESSION.welcome#</cfoutput></font></p>

</form>

</BODY></HTML>