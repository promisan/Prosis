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
<cfparam name="url.mode" default="regular">

<cfif url.mode eq "revert">

	 <cfquery name="getCurrent" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
         SELECT    ActionOrder
		 FROM      Ref_EntityActionPublish
		 WHERE     ActionCode      = '#ActionCode#'
		 AND       ActionPublishNo = '#ActionPublishNo#' 
	 </cfquery>	 

     <cfquery name="getPrior" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   TOP 1 * 
			 FROM     Ref_EntityActionPublish
			 WHERE    ActionPublishNo = '#ActionPublishNo#' 
			 AND      ActionOrder < '#getCurrent.actionOrder#' 		
			 ORDER By ActionOrder DESC				 
	   </cfquery> 			
	   
	   <cfif getprior.recordcount eq "1">
	    <cfset actioncode = getprior.actioncode>
	   </cfif> 

</cfif>

<!--- only processor will see this option --->

<cfparam name="entityaccess" default="edit">

<cfif entityaccess eq "EDIT">
	
	<cfquery name="Object" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT *
	   FROM   OrganizationObject O, Ref_Entity R		
	   WHERE  ObjectId       = '#url.ObjectId#' 
	   AND    O.EntityCode   = R.EntityCode
	   AND    O.Operational  = 1
	</cfquery>

	<table width="100%">
		   	   	   	   
		   <!--- element 1b of 3 GRANT FLY ACCESS --->   
		  			   
		   <cfquery name="GrantAccess" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			     SELECT    *
				 FROM      Ref_EntityActionPublish
				 WHERE     ActionAccess    = '#ActionCode#'
				 AND       ActionPublishNo = '#ActionPublishNo#' 
				 AND       ActionCode      != '#ActionCode#'
				 ORDER BY ActionOrder
		   </cfquery> 			  			 				  		  			  
		   							   
		   <cfif GrantAccess.recordcount gte "1">
		   
		   		<tr class="labelmedium line"><td style="padding-left:10px;height:35px;font-size:20px" colspan"2"><cf_tl id="Identify processors for workflow steps"></td></tr>
		   	   
		   	   <cfquery name="GrantBatch" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				     SELECT    *
					 FROM      Ref_EntityActionPublish
					 WHERE     ActionCode      = '#ActionCode#'
					 AND       ActionPublishNo = '#ActionPublishNo#' 
					 ORDER BY ActionOrder
			   </cfquery> 	
		   
		   	   <cfset unit = "#OrgUnit#">
			   	   
		   	   <cfif GrantBatch.ActionAccessPointer eq "0">		
			   					   
			        <cfloop query="GrantAccess">	
					
						<tr>
						<td colspan="2" id="stepflyaccess">
																																	
						    <cf_securediv id="actor#currentRow#" 
							bind="url:#SESSION.root#/tools/EntityAction/ActionListingActor.cfm?label=#ActionCode#Delegated&accesslevel=1&box=actor#currentrow#&Mode=Insert&ObjectId=#Object.ObjectId#&OrgUnit=#Unit#&Role=#Object.Role#&ActionPublishNo=#ActionPublishNo#&ActionCode=#ActionCode#&Group=#ActionAccessUserGroup#&Assist=#ActionAccessUGCollaborate#">
													
					    </td>
						</tr>						
										
					</cfloop>
				
				<cfelse>	
							
						<tr>
						<td colspan="2" id="stepflyaccess">					
																										
						    <cf_securediv id="actor0" 
							bind="url:#SESSION.root#/tools/EntityAction/ActionListingActor.cfm?box=actor0&Mode=BatchInsert&ObjectId=#Object.ObjectId#&OrgUnit=#Unit#&Role=#Object.Role#&ActionPublishNo=#ActionPublishNo#&ActionCode=#ActionCode#&Group=#GrantAccess.ActionAccessUserGroup#&Assist=#GrantAccess.ActionAccessUGCollaborate#">
													
					    </td>
						</tr>				
				
				</cfif>
				
		   	   
		   </cfif> 	
	   		   		   
	</table>
	
</cfif>	