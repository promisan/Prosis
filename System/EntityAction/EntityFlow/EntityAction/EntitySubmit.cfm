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
<cfparam name="Form.EnableCreate"      default="0">
<cfparam name="Form.EnableEMail"       default="0">
<cfparam name="Form.EnableEMailLogon"  default="0">
<cfparam name="Form.EnableStatus"      default="0">
<cfparam name="Form.EnableProgram"     default="0">
<cfparam name="Form.EnableFirstStep"   default="0">
<cfparam name="Form.EnableReopen"      default="0">
<cfparam name="Form.EnablePortal"      default="0">
<cfparam name="Form.EnableActionOwner" default="0">
<cfparam name="Form.EnableTopMenu"     default="0">
<cfparam name="Form.EnableRefresh"     default="0">
<cfparam name="Form.TemplateCREATE"    default="">
<cfparam name="Form.TemplateSEARCH"    default="">
<cfparam name="Form.TemplateListing"   default="">
<cfparam name="Form.EnableClassSelect" default="0">
<cfparam name="Form.EnableSelfProcess" default="0">
<cfparam name="Form.EnableGroupSelect" default="0">
<cfparam name="Form.EnableIntegrityCheck" default="1">
<cfparam name="Form.EnablePerformance" default="0">
<cfparam name="Form.DocumentPathName"  default="">

<cfquery name="Update" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_Entity
SET   EntityDescription    = '#Form.EntityDescription#',
      EntityTableName      = '#Form.EntityTableName#',
	  EntityKeyfield1      = '#Form.EntityKeyField1#',
	  EntityKeyfield2      = '#Form.EntityKeyField2#',
	  EntityKeyfield3      = '#Form.EntityKeyField3#',
	  EntityKeyfield4      = '#Form.EntityKeyField4#',
	  EnableSelfProcess    = '#Form.EnableSelfProcess#',
	  <!---
	  EnableActionOwner    = '#Form.EnableActionOwner#',	
	  OwnerAccessLevel     = '#Form.OwnerAccesslevel#',	
	  --->
	  ProcessMode          = '#Form.ProcessMode#',
	  
	  <cfif FORM.enableCreate eq "1">
      TemplateCREATE       = '#Form.TemplateCREATE#',
	  TemplateSEARCH       = '#Form.TemplateSEARCH#',
	  TemplateLISTING      = '#Form.TemplateLISTING#',
	  </cfif>
	  EnableRefresh        = '#Form.EnableRefresh#',
	  EnableTopMenu        = '#Form.EnableTopMenu#',
	  EnableCreate         = '#Form.EnableCreate#', 
	  EnableEMail          = '#Form.EnableEMail#',
	  EnableFirstStep      = '#Form.EnableFirstStep#',
	  EnableReOpen         = '#Form.EnableReOpen#',
	  EnableClassSelect    = '#Form.EnableClassSelect#',
	  EnableGroupSelect    = '#Form.EnableGroupSelect#',
	  MailFrom             = '#Form.MailFrom#', 
	  MailFromAddress      = '#Form.MailFromAddress#',
	  MailRecipient        = '#Form.MailRecipient#',
	  DocumentPathName     = '#Form.DocumentPathName#',
	  EnableEMailLogon     = '#Form.EnableEMailLogon#',	
	  ShowHistory          = '#Form.ShowHistory#',
	  EnableProgram        = '#Form.EnableProgram#',
	  EnablePortal         = '#Form.EnablePortal#',
	  EnableStatus         = '#Form.EnableStatus#',
	  DefaultFormat        = '#Form.DefaultFormat#',
	  EnableIntegrityCheck = '#Form.EnableIntegrityCheck#',
	  EnablePerformance    = '#Form.EnablePerformance#',
      Operational          = '#Form.Operational#'
WHERE EntityCode           = '#Form.EntityCode#'
</cfquery>

<cfquery name="getClass" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * FROM Ref_EntityClass
WHERE EntityCode = '#Form.EntityCode#'
AND Operational = 1
</cfquery>

<cfloop query="getClass">

	<cfset cid = replaceNoCase(entityClass," ","","ALL")>
	<cfset cid = replaceNoCase(cid,"/","","ALL")>

	<cfparam name="Form.f#cid#EnableActionOwner" default="0">
	<cfparam name="Form.f#cid#OwnerAccessLevel" default="0">
	
	<cfset val = evaluate("Form.f#cid#EnableActionOwner")>
	<cfset lvl = evaluate("Form.f#cid#OwnerAccessLevel")>
	
		
	<cfquery name="setClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_EntityClass
		SET    EnableActionOwner = '#val#', 
		       OwnerAccessLevel = '#lvl#'
		WHERE  EntityCode        = '#Form.EntityCode#'
		AND    EntityClass       = '#cid#'
	</cfquery>

</cfloop> 

<cfif form.EnablePerformance eq "1">

		 <cfquery name="Init" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			UPDATE  OrganizationObjectAction
			SET     ActionTakeAction = R.ActionTakeAction
			FROM    OrganizationObject O INNER JOIN
			        OrganizationObjectAction OA ON O.ObjectId = OA.ObjectId INNER JOIN
			        Ref_EntityActionPublish R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode AND 
		            OA.ActionTakeAction <> R.ActionTakeAction
			WHERE   O.EntityCode = '#Form.EntityCode#'
			AND     OA.ActionTakeAction = '0'
		</cfquery>	
		
</cfif>

<cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_Entity
		WHERE  EntityCode= '#Form.EntityCode#'
</cfquery>	

<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_AuthorizationRole
		WHERE  Role = '#Entity.Role#'
</cfquery>	
	
<!--- currently limited to procurement only --->	
	
<cfquery name="MissionList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Mission
		WHERE  Operational = 1
		AND    Mission IN (SELECT Mission 
		                   FROM   Ref_MissionModule
						   WHERE  SystemModule = '#Role.SystemModule#'
						   <!--- AND    SystemModule IN ('Procurement','Staffing') --->
						  ) 
		<cfif session.isAdministrator eq "No" and SESSION.isLocalAdministrator neq "No">
				
				AND Mission IN (#preservesingleQuotes(SESSION.isLocalAdministrator)#)
				
				</cfif>								  
		ORDER BY MissionType				  	
						  
</cfquery>

<cfloop query="MissionList">

	<cfparam name="Form.WorkflowEnabled_#currentrow#" default="0">
    <cfparam name="Form.WorkflowEnforce_#currentrow#" default="0">
		
	<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityMission
			WHERE  EntityCode = '#Entity.EntityCode#'
			AND    Mission    = '#Mission#'	
								
	</cfquery>
		 
	<cfset wf = evaluate("Form.WorkflowEnabled_#currentrow#")>	 
	<cfset fc = evaluate("Form.WorkflowEnforce_#currentrow#")>
		 
	<cfif Check.recordcount eq "0">	
								
		<cfquery name="Insert" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				INSERT INTO Ref_EntityMission
				(EntityCode,Mission,WorkflowEnabled,WorkFlowEnforce,OfficerUserid,OfficerLastName,OfficerFirstName)
				VALUES
				('#Entity.EntityCode#','#mission#','#wf#','#fc#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
			 </cfquery>
	
	<cfelse>
	
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			UPDATE Ref_EntityMission
			SET    WorkflowEnabled = '#wf#',
			       WorkflowEnforce = '#fc#',
			       Created = getDate()
			WHERE  EntityCode = '#Entity.EntityCode#'
			AND    Mission = '#Mission#' 
		 </cfquery>
		 		 
		 <!---
		 <cfoutput>
		 #mission# #wf# #Entity.EntityCode#<br>
		 </cfoutput>
		 --->
	
	</cfif>	 
	
</cfloop>	

<cfoutput>
<table><tr class="labelmedium"><td>[Updated: #timeformat(now(),"HH:MM:SS")#]</td></tr></table>

<script>
    if (document.getElementById('wf#Entity.EntityCode#')) {
      ptoken.navigate('#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityStatus.cfm?mission=#form.mission#&entitycode=#Entity.EntityCode#','wf#Entity.EntityCode#')
	} 
</script>

</cfoutput>