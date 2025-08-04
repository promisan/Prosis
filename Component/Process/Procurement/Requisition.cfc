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

<!---  Name: /Component/Process/Procurement/Requisition.cfc
       Description: Requisition procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "RequisitionRoutine">
	
	<cffunction name="getQueryScope"
             access="public"
             returntype="any"
             displayname="Program">
		
		<cfargument name="Role"               type="string" required="true"  default="">	
		<cfargument name="AccessLevel"        type="string" required="true"  default="'0','1','2'">	 
		<!--- added 20/12/2014 to support a scope from fnder and implementer --->
		<cfargument name="Mode"               type="string" required="true"  default="OrgUnit">  <!--- OrgUnit, OrgUnitImplement, Noth --->	
		<cfargument name="Connector"          type="string" required="true"  default="L.RequisitionNo">		
		
		<!--- pending provision for inquiry role --->
						
		<cfquery name="getRole" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_AuthorizationRole
				WHERE  Role = '#role#' 
		</cfquery>
		
		<cfoutput>

		<cfsavecontent variable="queryScope">
		
		     <!---  --------------------- --->
			 <!--- ----access rights----- --->
			 <!---  --------------------- --->
				
		     #connector# IN 
		   
		   		(
				
				 SELECT RequisitionNo
		         FROM   RequisitionLine RL INNER JOIN ItemMaster RM ON RL.ItemMaster = RM.Code
				 WHERE  
				 			   						 					
				   <!--- 15/4/2012 check for access based on the item entry class which is used for filtering
				   please note that access is propograted implicitly for any unit in this mode --->
				
				   <!--- to be remove as this is included in the below query
				   <cfif Role.Parameter eq "EntryClass">
								
					AND   RL.ItemMaster IN 
									  ( SELECT I.Code 
				                        FROM   ItemMaster I
										WHERE  I.Code = L.ItemMaster
									    AND    I.EntryClass IN (
										                      SELECT DISTINCT ClassParameter 
				   						  					  FROM   Organization.dbo.OrganizationAuthorization
														      WHERE  UserAccount = '#SESSION.acc#'
															  AND    AccessLevel IN (#preserveSingleQuotes(AccessLevel)#) 
														      AND    Role = '#role#'
														       ) 
									  )						
				   </cfif>
				   
				   --->				
																			
					(
					
					<cfif mode eq "OrgUnit" or mode eq "both">
					
							<cfif getRole.OrgUnitLevel eq "All">
							
							 <!--- unit granted --->
							
							 RL.OrgUnit IN 
						            (SELECT OrgUnit 
									 FROM   Organization.dbo.OrganizationAuthorization 
									 WHERE  Role        = '#Role#' 	
									 <cfif getRole.Parameter eq "EntryClass">
									 AND    ClassParameter = RM.EntryClass
									 </cfif>							 
									 AND    AccessLevel IN (#preserveSingleQuotes(AccessLevel)#) 
									 AND    UserAccount = '#SESSION.acc#')
									 
							<cfelse>
							
							 <!--- parent granted --->
							
							 RL.OrgUnit IN 
						            (SELECT  O.OrgUnit
									 FROM    Organization.dbo.Organization O INNER JOIN
						                     Organization.dbo.Organization Par ON 
											  	Par.OrgUnitCode = O.HierarchyRootUnit
												AND O.Mission   = Par.Mission 
												AND O.MandateNo = Par.MandateNo INNER JOIN
						                      Organization.dbo.OrganizationAuthorization OA ON Par.OrgUnit = OA.OrgUnit
									 WHERE  OA.Role        = '#Role#' 
									 <cfif getRole.Parameter eq "EntryClass">
									 AND    OA.ClassParameter = RM.EntryClass
									 </cfif>		
									 AND    OA.AccessLevel IN (#preserveSingleQuotes(AccessLevel)#) 
									 AND    OA.UserAccount = '#SESSION.acc#')		
							
							</cfif>		
							
							 OR
							
					 </cfif>						  	
					 
					 <cfif mode eq "OrgUnitImplement" or mode eq "both">
					
							<cfif getRole.OrgUnitLevel eq "All">
							
							 <!--- unit granted --->
							
							 RL.OrgUnitImplement IN 
						            (SELECT OrgUnit 
									 FROM   Organization.dbo.OrganizationAuthorization 
									 WHERE  Role        = '#Role#' 	
									 <cfif getRole.Parameter eq "EntryClass">
									 AND    ClassParameter = RM.EntryClass
									 </cfif>							 
									 AND    AccessLevel IN (#preserveSingleQuotes(AccessLevel)#) 
									 AND    UserAccount = '#SESSION.acc#')
									 
							<cfelse>
							
							 <!--- parent granted --->
							
							 RL.OrgUnitImplement IN 
						            (SELECT  O.OrgUnit
									 FROM    Organization.dbo.Organization O INNER JOIN
						                     Organization.dbo.Organization Par ON 
											  	Par.OrgUnitCode = O.HierarchyRootUnit
												AND O.Mission   = Par.Mission 
												AND O.MandateNo = Par.MandateNo INNER JOIN
						                      Organization.dbo.OrganizationAuthorization OA ON Par.OrgUnit = OA.OrgUnit
									 WHERE  OA.Role        = '#Role#' 
									 <cfif getRole.Parameter eq "EntryClass">
									 AND    OA.ClassParameter = RM.EntryClass
									 </cfif>		
									 AND    OA.AccessLevel IN (#preserveSingleQuotes(AccessLevel)#) 
									 AND    OA.UserAccount = '#SESSION.acc#')		
							
							</cfif>		
							
							 OR
							
					 </cfif>		
					 					 
					  RL.Mission IN 
							 (SELECT Mission
							 FROM    Organization.dbo.OrganizationAuthorization 
							 WHERE   Role        = '#Role#'
							 AND     AccessLevel IN (#preserveSingleQuotes(AccessLevel)#) 
							  <cfif getRole.Parameter eq "EntryClass">
							 AND     ClassParameter = RM.EntryClass
							 </cfif>	
							 AND     UserAccount = '#SESSION.acc#'
							 AND     OrgUnit is NULL)
							 
						OR	 
																		 
					   RL.RequisitionNo IN (SELECT RequisitionNo 
					                        FROM   RequisitionLineAuthorization 
											WHERE  RequisitionNo = RL.RequisitionNo 
											AND    Role = '#role#'
											AND    UserAccount = '#SESSION.acc#'
											)		 
						 
					)
									
		)
		
		<!---  --------------------- --->
		<!---  -end of access right- --->
		<!---  --------------------- --->
			
		</cfsavecontent>
		
		</cfoutput>
		   
		<cfreturn queryScope>		
		 
   </cffunction>		
		
		
	<cffunction name="getRequisitionList"
             access="public"
             returntype="any"
             displayname="Program">
		
		<cfargument name="Role"             type="string" required="true"  default="">	
		<cfargument name="AccessLevel"      type="string" required="true"  default="'0','1','2'">	 
		<cfargument name="Table"            type="string" required="false" default="#SESSION.acc#Requisition">
		
		<CF_DropTable dbName="AppsQuery" tblName="#table#">

		
		<cfset vScope = getQueryScope(Role,AccessLevel,"L.RequisitionNo")>
		
		<cfquery name="getRequisitions" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				INTO   UserQuery.dbo.#table#				
			    FROM   RequisitionLine L
				WHERE  #preserveSingleQuotes(vScope)# 
		</cfquery>		
	
		
	</cffunction>
	
	
</cfcomponent>	 