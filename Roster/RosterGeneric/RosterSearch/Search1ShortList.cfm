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

<cfparam name="url.mode"        default="vacancy">
<cfparam name="url.wParam"      default="">
<cfparam name="url.wActionId"   default="">

<cfajaximport tags="cfform,cfdiv">
<cf_menuscript>

<cfif url.wActionId neq "">

	<!--- is called from the workflow --->

	<cfquery name="param" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     R.ActionDialogParameter, O.ObjectId, O.ObjectKeyValue1, O.ObjectKeyValue2
		FROM       OrganizationObjectAction OA 
		           INNER JOIN  Ref_EntityActionPublish R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode 
				   INNER JOIN  OrganizationObject O ON O.ObjectId = OA.ObjectId
		WHERE      OA.ActionId = '#url.wActionId#'
	</cfquery>
	
	<cfset url.wParam = param.ActionDialogParameter>
	<cfset url.docNo  = param.ObjectKeyValue1>
	
	<cfquery name="Doc" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Document D
		WHERE  D.DocumentNo = #URL.DocNo# 
	</cfquery>
	
	<cfset url.functionNo = doc.FunctionNo>
	
</cfif>

<cfparam name="url.wParam"      default="">
<cfparam name="url.functionno"  default="">
	
<cfif url.mode eq "vacancy">
	
	<!--- check if matching OccGroup and grade in Vactrack rosters --->
	
	<cfquery name="Doc" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Document D
		WHERE  D.DocumentNo = #URL.DocNo# 
	</cfquery>
	
	<cfset owner = "">
	
	<cfif doc.owner eq "">
	
		<cfquery name="Owner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_ParameterOwner D
			WHERE D.Owner IN (SELECT MissionOwner 
			                  FROM   Organization.dbo.Ref_Mission 
							  WHERE  Mission = '#Doc.Mission#')
		</cfquery>
	
		<cfset own = owner.owner>
	
	<cfelse>
	
		<cfquery name="Owner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterOwner D
			WHERE  D.Owner = '#doc.owner#'
		</cfquery>
	
	    <cfset own = owner.owner>
	
	</cfif>
	
	<cfif own eq "">
	
	  <cf_message message="Roster has not been configured for this track" return="close()">
	  <cfabort>
	
	</cfif>
		
	<!---
	<cfif ShortList.recordcount eq "0">  this would load a different screen for this bucket only to a full view does not work, better to merge
	bucket search with the full view in one container
	--->
			
	
	<cfset url.owner  = Own>
	<cfset url.mode   = "Vacancy">	
								
	<cfinclude template="InitView.cfm">
	
<cfelseif url.mode eq "ssa">	

	<!--- this is triggered from the procurement portion --->

	<cfquery name="Job" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Job 
		WHERE JobNo = '#URL.JobNo#' 
	</cfquery>
	
	<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_Mission 
		WHERE Mission = '#Job.Mission#' 
	</cfquery>
		
		<cfset url.owner  = Mission.MissionOwner>
		<cfset url.mode   = "ssa">	
		<cfset url.docno  = url.jobno>
						
		<cfinclude template="InitView.cfm">

</cfif>


