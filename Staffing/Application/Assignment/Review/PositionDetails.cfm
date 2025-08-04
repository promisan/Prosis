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
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT P.*, O.OrgunitName
	FROM   Position P, Organization.dbo.Organization O
	WHERE  P.OrgunitOperational = O.OrgUnit
	AND    Positionno = '#url.id1#'
</cfquery>

<cfquery name="getEmployee"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT     PA.DateEffective, 
              PA.DateExpiration,			  			  
			  P.LastName, 
			  P.FirstName, 
			  P.Gender, 
			  P.Nationality,
			  (SELECT Name FROM System.dbo.Ref_Nation WHERE Code = P.Nationality) as NationalityName
   FROM       PersonAssignment AS PA INNER JOIN
              Person AS P ON PA.PersonNo = P.PersonNo
	WHERE     PA.PositionNo = '#url.id1#' 
	AND       PA.DateEffective <= GETDATE() 
	AND       PA.DateExpiration >= GETDATE() 
	AND       PA.AssignmentStatus IN ('0', '1')
</cfquery>

<cfoutput>

<table width="98%" cellspacing="0" cellpadding="0" border="0" align="center">

<tr><td height="4"></td></tr>
<tr><td class="labelit" width="100">Unit:</td>
	<td class="labelmedium" width="80%">#get.OrgUnitName#</td>
</tr>
<tr><td colspan="2" class="linedotted"></td></tr>
<tr><td class="labelit">Postnumber:</td>
	<td class="labelmedium"><a href="javascript:EditPosition('#get.mission#','#get.Mandateno#','#get.Positionno#')">
	<font color="0080C0">#get.SourcePostNumber#</font></a></td>
</tr>
<tr><td colspan="2" class="linedotted"></td></tr>
<tr><td class="labelit">Title:</td>
	<td class="labelmedium">#get.FunctionDescription#</td>
</tr>
<tr><td colspan="2" class="linedotted"></td></tr>
<tr><td class="labelit">Grade:</td>
	<td class="labelmedium">#get.PostGrade#</td>
</tr>
<tr><td colspan="2" class="linedotted"></td></tr>
<tr><td class="labelit">Employee:</td>
	<td class="labelmedium">#getEmployee.FirstName# #getEmployee.LastName#</td>
</tr>
<tr><td colspan="2" class="linedotted"></td></tr>
<tr><td class="labelit">Nationality:</td>
	<td class="labelmedium">#getEmployee.NationalityName#</td>
</tr>
<tr><td colspan="2" class="linedotted"></td></tr>
<tr><td valign="top" style="padding-top:3px" class="labelit">Expiration:</td>
	<td class="labelmedium"><b>#dateformat(getEmployee.DateExpiration,client.dateformatshow)#</b></td>
</tr>

<tr><td colspan="2" class="linedotted"></td></tr>
	   
<cf_wfactive entityCode="PositionReview" ObjectKeyValue1="#url.id1#">

<!--- enter competencies --->
<tr><td colspan="2" style="padding-left:10px">
	<cfinclude template="PositionCompetence.cfm">
	</td>
</tr>

<tr><td colspan="2" class="linedotted"></tr>

	<input type="hidden" 
		   name="workflowlink_#url.id1#" 
		   id="workflowlink_#url.id1#" 		   
		   value="PositionWorkflow.cfm">		

<cfif wfstatus eq "closed" and url.caller neq "edition">

	<!--- we ensure any workflow are deactivated so we can raise a new flow --->
	
	<cfquery name="setClose"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE OrganizationObject
		SET    Operational = 0
		WHERE  ObjectkeyValue1 = '#url.id1#'
	</cfquery>

	<tr>
	<td colspan="2" class="labelmedium" id="#url.id1#" align="center" style="height:70">
		<a href="javascript:ColdFusion.navigate('PositionWorkflow.cfm?box=#url.box#&ajaxid=#url.id1#','#url.id1#')"><font color="0080C0">
		Please click <u>here</u> to initiate a Post review process for extension or recruitment</a>
		</font>	
	</td>
	</tr>

<cfelse>		   
	
	<tr><td colspan="2" id="#url.id1#">	
					   
		 <input type="hidden" 
          id="workflowlink_#url.id1#" 
          value="PositionWorkflow.cfm"> 
 
	     <cfdiv id="#url.id1#"  bind="url:PositionWorkflow.cfm?ajaxid=#url.id1#&init=1"/>
		   
		</td>
	</tr>
		
</cfif>

</table>

</cfoutput>