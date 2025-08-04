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

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Workflow Status Inquiry Component">
		
	<cffunction name="wfPending"
             access="remote"
             returntype="string"
             displayname="Workflow Pending">
		
			<cfargument name="EntityCode"   type="string" required="true">
		    <cfargument name="ObjectkeyValue1" type="string" required="false" default="">
			<cfargument name="ObjectkeyValue2" type="string" required="false" default="">
			<cfargument name="ObjectkeyValue3" type="string" required="false" default="">
			<cfargument name="ObjectkeyValue4" type="string" required="false" default="">
		
			<!--- Check if object has a pending workflow
			Result will be answer Yes or No
			--->	
			
			<cfset status = "NO">

			<cfquery name="doc" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT * FROM Ref_Entity
				 WHERE EntityCode = '#EntityCode#' 
			</cfquery>
						
			<cfif doc.recordcount eq "1">
			
				<cfquery name="Check" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT ObjectId 
					 FROM OrganizationObject
					 WHERE 1=1 
					 <cfif ObjectkeyValue1 neq "">
					 AND ObjectKeyValue1 = '#ObjectKeyValue1#'
					 </cfif>
					 <cfif ObjectkeyValue2 neq "">
					 AND ObjectKeyValue2 = '#ObjectKeyValue2#'
					 </cfif>
					 <cfif ObjectkeyValue3 neq "">
					 AND ObjectKeyValue3 = '#ObjectKeyValue3#'
					 </cfif>
					 <cfif ObjectkeyValue4 neq "">
					 AND ObjectKeyValue4 = '#ObjectKeyValue4#'
					 </cfif> 
					 AND Operational = 1
				</cfquery>
				
				<!--- there isa pending workflow object --->
		
				<cfif check.recordcount gte "1">
					
						<cfquery name="Pending"
							datasource="AppsOrganization"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT   TOP 1 ActionStatus
							FROM     OrganizationObjectAction
							WHERE    ObjectId = '#Check.ObjectId#'
							ORDER BY ActionFlowOrder DESC
						</cfquery>
						
						<!--- last step of the workflow exisits and is pending 0, 1--->	
											
						<cfif pending.actionStatus lte "1" and pending.recordcount gte "1">
																			
							<cfset status = "YES">
						
						</cfif>
						
				</cfif>	
			
			</cfif>

			<cfreturn Status>
	
	</cffunction>
	
	<cffunction name="wfAuthorization"
         access="remote"
         returntype="struct"
         displayname="Check if a user has access to process the active step in the flow">
		
			<cfargument name="UserAccount" type="string" default="#session.acc#" required="yes">
		    <cfargument name="ObjectId"     type="string" required="true" default="">
			<cfargument name="ActionCode"   type="string" required="true" default="">
			
			<cfquery name="Pending"
				datasource="AppsOrganization"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT    OA.ActionId, 
				          OA.ObjectId, 
						  OO.Mission,
						  OO.OrgUnit, 
						  OO.ActionPublishNo, 
						  OA.ActionCode, 
						  OA.ActionConcurrent, 
						  OO.EntityGroup
				FROM      OrganizationObjectAction OA INNER JOIN OrganizationObject OO ON OA.Objectid = OO.Objectid
				WHERE     OO.ObjectId = '#ObjectId#'
				AND       OA.ActionStatus = '0'
				ORDER BY  ActionFlowOrder DESC
			</cfquery>
			
			<cfif ActionCode neq "">
			
				<cfif Pending.ActionCode neq "" and ActionCode eq Pending.ActionCode>
				
					<cfset result.ActionId = Pending.ActionId>
					<cfset result.status = "1">
					
				<cfelse>
				
					<cfset result.status = "9">	
						
				</cfif>	
				
			<cfelseif Pending.ActionId neq "">
			
				<cfset result.ActionId = Pending.ActionId>
				<cfset result.status = "1">
				
			<cfelse>
			
				<cfset result.status = "9">		
			
			</cfif>
			
			<cfif result.status eq "1">
			
				 <cfinvoke component = "Service.Access"  	
					method         =   "AccessEntity" 
					objectid       =   "#ObjectId#"
					actioncode     =   "#Pending.ActionCode#" 
					mission        =   "#Pending.mission#"
					orgunit        =   "#Pending.OrgUnit#" 
					entitygroup    =   "#Pending.EntityGroup#" 
					returnvariable =   "entityaccess">	
					
					<cfif EntityAccess eq "NONE">					
						<cfset result.status = "9">						
					</cfif>
			
				<!--- we now check if the user has indeed access to this step --->
						
			</cfif>
			
			<cfreturn result>	
			
</cffunction>					
	
</cfcomponent>	