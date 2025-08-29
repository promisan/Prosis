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
<cfparam name="insert" default="Yes">

<cfif insert eq "">
	<cfset insert = "yes">
</cfif>

<cfquery name="Last" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT TOP 1 ActionFlowOrder
	 FROM       OrganizationObjectAction  
	 WHERE      ObjectId        = '#ObjectId#'
	 AND        ActionPublishNo = '#pub#' 
	 ORDER BY   ActionFlowOrder DESC
</cfquery>

<!--- check if the last action has the same parent as the new action --->

<cfif insert eq "Yes">
	
	   <cfset cct = 0>
	   <cfloop index="ac" list="#preservesingleQuotes(Act)#" delimiters=",">
	         
	    <cfset cct = cct + 1>
	
		<cf_assignId>
		
		<!--- check orgunit --->
		
		<cfif orgunit neq "">
		
			 <cfquery name="Check" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     Organization
				 WHERE    OrgUnit = '#orgunit#' 			
			</cfquery>
		
			<cfset unit = "#check.orgunit#">
		
		<cfelse>
		
			<cfset unit = "">		
		
		</cfif>
		
		<cfquery name="InsertStep" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 INSERT INTO OrganizationObjectAction
			          (<cfif Unit neq "">OrgUnit,</cfif>
					   ObjectId,
					   ActionId,
					   ActionPublishNo,
					   ActionCode, 
					   ActionFlowOrder, 
					   <cfif cct gte "2">
					   ActionConcurrent,
					   </cfif>
					   ActionTakeAction,
					   TriggerActionType,
					   TriggerActionId,
					   TriggerDate,
					   CreatedUserId)
			 SELECT    <cfif Unit neq "">'#Unit#',</cfif> 
			           '#objectid#', 
					   '#rowguid#',
					   R.ActionPublishNo,
					   R.ActionCode, 
					   #Last.ActionFlowOrder#+1, 
					   <cfif cct gte "2">
					   1,
					   </cfif>
					   R.ActionTakeAction,						   		  
					   <cfif TriggerType neq "">
					      '#triggertype#',
						  '#trigger#',
						  getDate(),
					   <cfelse>
					      NULL,
						  NULL, 
						  NULL,
					   </cfif>
					   '#SESSION.acc#'
			 FROM      Ref_EntityActionPublish R 
			 WHERE     R.ActionPublishNo = '#pub#' 
			 AND       R.ActionCode IN (#preservesinglequotes(ac)#)  
			 			 
		</cfquery>
		
		<cfquery name="Current" 
			 	datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT *
				 FROM      Ref_EntityActionPublish
				 WHERE     ActionPublishNo = '#pub#' 
				 AND       ActionCode      IN (#preserveSingleQuotes(ac)#) 
			</cfquery>
		
	   </cfloop>
		
	   <cfset actionId = rowguid>		
	   
<cfelse>

	<!--- added by hanno 24/3/2016 --->

		<cfquery name="Current" 
		 	datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT *
				 FROM      Ref_EntityActionPublish
				 WHERE     ActionPublishNo = '#pub#' 
				 AND       ActionCode      IN (#preserveSingleQuotes(ac)#) 
		</cfquery>		  
					
</cfif>		
	
<cfif Current.ActionType eq "Action">

	<cfquery name="Check" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   ActionCode
		 FROM     Ref_EntityActionPublish R
		 WHERE    R.ActionPublishNo = '#pub#' 
		 AND	  R.ActionParent IN (#preservesingleQuotes(Act)#)		 	
		 ORDER BY ActionOrder 
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Check" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   ActionCode
			 FROM     Ref_EntityActionPublish R
			 WHERE    R.ActionPublishNo = '#pub#' 
			 AND      R.ActionParent IN (SELECT ActionCode 
			                             FROM   Ref_EntityActionPublish 
										 WHERE  ActionPublishNo = '#pub#' 
										 AND    ActionParent = '#current.ActionParent#')			
			 ORDER BY ActionOrder 
		</cfquery>
	
	</cfif>
					
	<cfset act = "">				
	<cfif Check.Recordcount gte "1">
	    <cfloop query="Check">
		    <cfif act eq ""> 
			   <cfset act = "'#ActionCode#'">
			<cfelse>
			   <cfset act = "#act#,'#ActionCode#'">
			</cfif>   
		</cfloop>
		<cfinclude template="ObjectStepAdd.cfm">
	</cfif>
		
<cfelse>
   
    <cfset insert = "no">
					
</cfif>	