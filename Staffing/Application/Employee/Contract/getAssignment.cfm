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
<cfset dateValue = "">
<CF_DateConvert Value="#url.dateeffective#">
<cfset DTS = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#url.dateexpiration#">
<cfset DTE = dateValue>

<cfquery name="Assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     P.PersonNo, 
	           P.IndexNo, 
			   P.LastName, 
			   P.FirstName, 
			   PA.DateEffective, 
			   PA.DateExpiration, 
			   PA.AssignmentClass, 
			   PA.Incumbency, 
			   PA.AssignmentClass, 
               PA.OfficerLastName, 
			   PA.OfficerFirstName, 
			   PA.OfficerUserId, 
			   PA.Created
	FROM       PersonAssignment AS PA INNER JOIN
           	   Person AS P ON PA.PersonNo = P.PersonNo
	WHERE      PA.PositionNo = '#url.positionno#' 
	AND        PA.AssignmentStatus IN ('0', '1')
	AND        PA.DateExpiration >= #DTS# 
	AND        PA.DateEffective <= #DTE#
	ORDER BY PA.DateExpiration DESC
</cfquery>

<cfif Assignment.recordcount gte "1">

<table width="100%" class="navigation_table">

	<tr class="labelmedium line">
		<td><cf_tl id="IndexNo"></td>		
		<td><cf_tl id="LastName"></td>
		<td><cf_tl id="FirstName"></td>
		<td><cf_tl id="Start"></td>
		<td><cf_tl id="End"></td>
		<td><cf_tl id="Class"></td>
		<td><cf_tl id="Inc"></td>	
	</tr>

	<cfoutput query="Assignment">
	<tr class="labelmedium navigation_row line" style="height:20px">
		<td><a href="javascript:EditPerson('#PersonNo#')"><font color="0080C0">#Indexno#</a></td>
		<td>#LastName#</td>
		<td>#FirstName#</td>
		<td>#dateformat(DateEffective,client.dateformatshow)#</td>
		<td>#dateformat(DateExpiration,client.dateformatshow)#</td>
		<td>#AssignmentClass#</td>
		<td>#Incumbency#</td>
	</tr>
	</cfoutput>
	
</table>

</cfif>

<cfset ajaxonload("doHighlight")>

