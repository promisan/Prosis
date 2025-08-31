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
<cfset selected      = "">	
<cfset mode          = "edit">	
<cfset alias         = "appsSelection">
<cfset table         = "Ref_Experience">
<cfset pk            = "ExperienceFieldId">
<cfset desc          = "Description">	
<cfset order         = "">
<cfset filterstring  = "AND ExperienceClass IN (SELECT ExperienceClass FROM Ref_ExperienceClass WHERE Parent = '@@')">
 
<cfparam name="URL.FunctionNo"      default="#URL.ID#">
<cfparam name="URL.GradeDeployment" default="#URL.ID1#">

<cfquery name="Function"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   FunctionTitle F, FunctionTitleGrade G
	WHERE  F.FunctionNo = G.FunctionNo
	AND    G.GradeDeployment = '#URL.GradeDeployment#'
	AND    F.FunctionNo = '#URL.FunctionNo#'
</cfquery>

<cfquery name="Check"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   FunctionRequirement
	WHERE  GradeDeployment = '#URL.GradeDeployment#'
	AND    FunctionNo      = '#URL.FunctionNo#'
</cfquery>

<cfquery name="Profile"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   FunctionTitleGrade
	WHERE  GradeDeployment = '#URL.GradeDeployment#'
	AND    FunctionNo = '#URL.FunctionNo#'
</cfquery>

<cfif Profile.recordcount eq "0">
	
	<cfoutput>
	
	<table width="99%"
	       border="0"
		   cellspacing="0"
	       cellpadding="0"
	       align="center"	      
		   id="structured"
	       class="formpadding">
		   <tr><td height="40" align="center">
		   		<font color="FF0000">Job Profile for the grade #URL.GradeDeployment# has not been defined.</td></tr>
		   </table>
		   
	</cfoutput>

<cfabort>

</cfif>

<cfif Check.recordcount eq "0" and Profile.recordcount eq "1">
	
	<cf_assignid>
	
	<cfquery name="Check"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO FunctionRequirement
			(RequirementId,
			 FunctionNo, 
			 GradeDeployment, 
			 RequirementClass, 
			 ActionStatus, 
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
		VALUES ('#rowguid#',
				'#URL.FunctionNo#',
				'#URL.GradeDeployment#',
				'Minimum',
				'1',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
	</cfquery>
	
	<cfquery name="Check"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     FunctionRequirement
		WHERE    GradeDeployment = '#URL.GradeDeployment#'
		AND      FunctionNo      = '#URL.FunctionNo#'
		ORDER BY RequirementClass
	</cfquery>

</cfif>

<cfoutput>
	<input id="requirementid"   type="hidden" value="#check.requirementid#">
	<input id="requirementline" type="hidden" value="">
	<input id="parent"          type="hidden" value="">
	<input id="box"             type="hidden" value="">
</cfoutput>

<cfquery name="Areas"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *,Parent as ParentCode
	FROM     Ref_ExperienceParent
	WHERE    Parent NOT IN ('Skills','Miscellaneous','History','Application')
	ORDER BY Area, SearchOrder
</cfquery>

<table width="99%" 
       align="center"    
	   id="structured">
	   
<cfloop query="Check">

    <!---
	<tr><td colspan="3" style="height:40px;font-size:27px" class="labellarge"><cfoutput>#RequirementClass# <cf_tl id="requirements"></cfoutput></td></tr>
	--->
	
	<cfset id  = RequirementId>
	<cfset row = CurrentRow>
	
	<cfoutput query="Areas" group="Area">
	
		<tr class="line"><td style="height:34px;padding-left:10px;font-size:22px" colspan="3" class="labelmedium">#area#</td></tr>
		
		<tr><td height="5"></td></tr>		
				
		<cfoutput>
			<tr class="linedotted labelmedium2">
			
				<cfif Area eq "skills">
					<cfset vLink = "editTopic('#id#','','#parent#','','b#parent#_#currentRow#');">
				<cfelse>
					<cfset vLink = "editField('#id#','','#parent#','','b#parent#_#currentRow#');">
				</cfif>
			
				<cfif Access eq "EDIT" or Access eq "ALL"> 
				<td width="10" height="18" align="right" style="cursor: pointer;padding-right:4px">
	   		    	<cf_img icon="add" onclick="#vLink#">				
				</td>
				<cfelse>
				<td bgcolor="ffffdf"></td>
				</cfif>				
				
			    <td width="95%" style="height:15px;padding-left:15px" class="labelmedium">					
								
				<cfif Access eq "EDIT" or Access eq "ALL"> 
				<a href="javascript:#vLink#"><font color="0080C0">#Description#</font></a>
				<cfelse>
				#Description#
				</cfif>				
				</td>
					
			</tr>	
				
			<tr bgcolor="fafafa">
				<td style="padding-left:50px" colspan="2" id="b#parent#_#currentRow#">
				   <cfset box = "b#parent#_#currentRow#">
				   <cfset url.requirementId   = "#id#">
				   <cfinclude template="FunctionRequirementLine.cfm">					
				</td>
		   	</tr>
			
	   </cfoutput>
	   
	</cfoutput>	
	
</cfloop>
</table>

