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


<cfquery name="get"
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Document
	WHERE     DocumentNo = '#url.documentNo#'	
</cfquery>

<cfquery name="for"
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Applicant.dbo.Functionorganization
	<cfif get.Functionid neq "">
	WHERE     FunctionId = '#get.Functionid#'	
	<cfelse>
	WHERE 1=0
	</cfif>
</cfquery>

<cfquery name="pos"
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    P.*
	FROM      DocumentPost DP INNER JOIN Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
	WHERE     DocumentNo = '#url.documentNo#'		
</cfquery>

<cfquery name="flow"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT      P.ActionDescription, P.ActionCompleted, 
	            OOA.OfficerDate, OOA.OfficerUserId, OOA.OfficerLastName, OOA.OfficerFirstName, OOA.ActionStatus
    FROM        OrganizationObjectAction AS OOA INNER JOIN
                OrganizationObject AS OO ON OOA.ObjectId = OO.ObjectId INNER JOIN
                Ref_EntityActionPublish AS P ON OOA.ActionPublishNo = P.ActionPublishNo AND OOA.ActionCode = P.ActionCode
    WHERE       OO.EntityCode IN ('VacDocument', 'xVacCandidate') 
	AND         OO.ObjectKeyValue1 = '#url.documentno#' 
	AND         OOA.OfficerDate IS NOT NULL 
	AND         OOA.ActionStatus <> '0' AND (OO.Operational = 1)
	AND         OOA.OfficerLastName <> 'Agent'
   ORDER BY OOA.ActionFlowOrder 
</cfquery>
  
<cfquery name="can"
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      DocumentCandidate
	WHERE     DocumentNo = '#url.documentNo#'	
	AND       Status IN ('2s','3')
</cfquery>

<cfoutput>

<table width="98%" align="center" class="navigation_table">
<tr><td style="height:5px"></td></tr>
<tr class="labelmedium">
<cfif get.statusDate neq "">
	<td align="center" style="font-size:20px;height:40px;background-color:800040;color:white;padding-left:4px" colspan="2">#url.DocumentNo# #get.Mission#</td>
	<cfif get.Status eq "9">
		<cfset cl = "red">
	<cfelse>
	    <cfset cl = "green">
	</cfif>
	<td colspan="2" align="center" style="background-color:#cl#;color:white">
	#dateformat(get.StatusDate,client.dateformatshow)#<br>#get.StatusOfficerLastName#
	
</td>
<cfelse>
<td style="font-size:20px;height:40px;background-color:800040;color:white" align="center" colspan="4">#url.DocumentNo# #get.Mission#</td>
</cfif>
</tr>

<tr style="height:30px;font-size:17px" class="labelmedium"><td colspan="3">
<a href="javascript:showdocument('#DocumentNo#')">#get.PostGrade# #get.FunctionalTitle# </a></td>
<td align="right" colspan="1">#for.ReferenceNo#</td>
</tr>
<cfloop query="pos">
<tr style="height:20px" class="line labelmedium2"><td colspan="4" style="font-weight:bold">#pos.SourcePostNumber#</td></tr>
</cfloop>
<cfloop query="flow">
<tr style="height:18px" class="labelit fixlengthlist navigation_row">
     <td>#dateformat(OfficerDate,client.dateformatshow)# #timeformat(OfficerDate,"hh:mm")#</td>
	 <td><cfif ActionCompleted eq "">#ActionDescription#<cfelse>#ActionCompleted#</cfif></td>
	 <td><cfif actionStatus eq "2" or actionStatus eq "2y"><cf_tl id="C"><cfelse><cf_tl id="D"></cfif></td>
	 <td>#OfficerLastName#</td>	 
</tr>
</cfloop>
<cfloop query="can">
<tr style="height:20px" class="line labelmedium"><td style="font-weight:bold" colspan="4">#can.FirstName# #can.LastName#</td></tr>
	
	<cfquery name="flow"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT      P.ActionDescription, P.ActionCompleted, 
		            OOA.OfficerDate, OOA.OfficerUserId, OOA.OfficerLastName, OOA.OfficerFirstName, OOA.ActionStatus
	    FROM        OrganizationObjectAction AS OOA INNER JOIN
	                OrganizationObject AS OO ON OOA.ObjectId = OO.ObjectId INNER JOIN
	                Ref_EntityActionPublish AS P ON OOA.ActionPublishNo = P.ActionPublishNo AND OOA.ActionCode = P.ActionCode
	    WHERE       OO.EntityCode IN ('VacCandidate') 
		AND         OO.ObjectKeyValue1 = '#url.documentno#' 
		-- and OO.ObjectKeyValue2 = '#PersonNo#'
		AND         OOA.OfficerDate IS NOT NULL 
		AND         OOA.ActionStatus <> '0' AND OO.Operational = 1
		AND         OOA.OfficerLastName <> 'Agent'
	   ORDER BY OOA.ActionFlowOrder 
	</cfquery>
	
	<cfloop query="flow">
	<tr style="height:18px" class="labelit fixlengthlist navigation_row">
	     <td>#dateformat(OfficerDate,client.dateformatshow)# #timeformat(OfficerDate,"hh:mm")#</td>
		 <td><cfif ActionCompleted eq "">#ActionDescription#<cfelse>#ActionCompleted#</cfif></td>
		 <td><cfif actionStatus eq "2" or actionStatus eq "2y"><cf_tl id="C"><cfelse><cf_tl id="D"></cfif></td>
		 <td>#OfficerLastName#</td>
		 
	</tr>
	</cfloop>

</cfloop>

</table>

</cfoutput>

<cfset ajaxOnload("doHighlight")>
