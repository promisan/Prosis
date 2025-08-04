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

<cfparam name="Attributes.Mode" default="table">
<cfparam name="Attributes.Role" default="1">

<cfif Attributes.mode eq "variable">
   <cfset FileNo = round(Rand()*100)>
<cfelse>
   <cfset FileNo = round(Rand()*10)>   
</cfif>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#First_#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Current_#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Base_#FileNo#">	

<cfparam name="Attributes.Entity" default="">

<cfquery name="Delegate" 
 datasource="AppsSystem"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT    *
 FROM      UserNames
 WHERE     AccountDelegate = '#SESSION.acc#' 
</cfquery>

<cfif Delegate.AccountDelegate neq "">
  <cfset usr = "'#SESSION.acc#','#Delegate.Account#'">
<cfelse>
  <cfset usr = "'#SESSION.acc#'"> 
</cfif>

<cftransaction isolation="READ_UNCOMMITTED">

<!--- get relevant entity codes to be shown--->

<cfquery name="getEntity" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT EntityCode
    FROM   System.dbo.UserEntitySetting
    WHERE  Account = '#session.acc#'
	AND    EnableMyClearances = 1
</cfquery>	

<cfset entitycode = quotedValueList(getEntity.EntityCode)>
	
<cfquery name="Due" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT    ObjectId, 
           MIN(ActionFlowOrder) AS ActionFlowOrder
 INTO      userQuery.dbo.#SESSION.acc#First_#FileNo#
 FROM      OrganizationObjectAction OA
 WHERE     ObjectId IN (SELECT ObjectId 
                        FROM   OrganizationObject 
						WHERE  ObjectId = OA.ObjectId
						AND    Mission IN (SELECT Mission FROM Ref_Mission WHERE Operational = 1)
						<cfif EntityCode neq "">
						AND    EntityCode IN (#preserveSingleQuotes(entitycode)#) 
						</cfif>
						AND    ObjectStatus = '0'
						AND    (EntityStatus != '9' or EntityStatus is NULL)
						AND    Operational = 1
						<!--- ----------------------- --->
						<!--- filter by object entity --->
						<!--- ----------------------- --->
						<cfif attributes.entity neq "">
						AND    EntityCode = '#attributes.entity#'
						</cfif>
						)
 AND       ActionStatus = '0'  					
 GROUP BY  ObjectId 
</cfquery>

<!---
<cfoutput>a.#cfquery.executiontime#</cfoutput>
--->

<cfquery name="DueAction" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   OA.ActionId,  
	          O.ObjectId, 
			  O.EntityGroup, 
			  OA.ActionCode, 
			  O.Mission, 
			  O.OrgUnit, 
			  O.ObjectKeyValue1
	 INTO     userQuery.dbo.#SESSION.acc#Current_#FileNo#
	 FROM     OrganizationObjectAction OA INNER JOIN
	          userQuery.dbo.#SESSION.acc#First_#FileNo# F ON OA.ObjectId = F.ObjectId 
		      AND OA.ActionFlowOrder = F.ActionFlowOrder 
			  INNER JOIN OrganizationObject O ON OA.ObjectId = O.ObjectId  
	 WHERE    O.Operational  = 1	
	 AND      O.ObjectStatus = 0 	
 </cfquery>

 <!---
 <cfoutput>b1.#cfquery.executiontime#</cfoutput>
 --->
 
<cfquery name="Index" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		CREATE CLUSTERED INDEX [PsitionInd] 
		    ON userQuery.dbo.#SESSION.acc#Current_#FileNo#([ObjectId],[ActionCode]) ON [PRIMARY]
</cfquery>		
 
 <!---
 <cfoutput>b2.#cfquery.executiontime#</cfoutput>
 --->
  
<cfquery name="BaseAccess" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   DISTINCT 
		          Mission,
				  OrgUnit,
				  ClassParameter,
				  GroupParameter
		 INTO     userQuery.dbo.#SESSION.acc#Base_#FileNo# 
		 FROM     OrganizationAuthorization 
		 <cfif SESSION.isAdministrator eq "No">
		 WHERE    UserAccount IN (#preserveSingleQuotes(usr)#)	
		 </cfif>
</cfquery>
 
</cftransaction>
  
 <!---
  <cfoutput>c.#cfquery.executiontime#</cfoutput>
 --->

<!--- actions unit --->

<cfif attributes.mode eq "Table">
    <!--- if this fails the table is gone and will throw an error --->
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Action">	
</cfif>

<cftransaction isolation="READ_UNCOMMITTED">

	<cfsavecontent variable="lastaction">
		(SELECT   TOP 1 OfficerDate 
		 FROM     OrganizationObjectAction
		 WHERE    ObjectId = OA.ObjectId
		 AND      ActionStatus IN ('2','2Y','2N') 
		 ORDER BY OfficerDate DESC) AS DateLast		
	</cfsavecontent>			 
				 
	<cfif SESSION.isAdministrator eq "Yes">
				
		<cfif attributes.role eq "1">		
		
			<cfquery name="Action" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 					
				SELECT  DISTINCT OA.ObjectId, 
				        OA.ActionId, 				
						#preservesinglequotes(lastaction)#	
						
				<cfif attributes.mode eq "Table">
				INTO    userQuery.dbo.#SESSION.acc#Action				
				</cfif>		
				FROM    userQuery.dbo.#SESSION.acc#Current_#FileNo# OA
					
				UNION
					
				 <!--- actions document specific fly --->
				
				SELECT  DISTINCT OA.ObjectId, 
				        OA.ActionId, 
						#preservesinglequotes(lastaction)#	
				FROM    OrganizationObjectActionAccess AA INNER JOIN
			            userQuery.dbo.#SESSION.acc#Current_#FileNo# OA ON AA.ObjectId = OA.ObjectId and AA.ActionCode = OA.ActionCode
				WHERE   AA.AccessLevel >= '0'  	  
				 								
			</cfquery>				
			
									
		<cfelse>				
		
			<cfquery name="Action" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 			 					
				SELECT  DISTINCT OA.ObjectId, 
				        OA.ActionId, 				
						#preservesinglequotes(lastaction)#	
						
				<cfif attributes.mode eq "Table">
				INTO    userQuery.dbo.#SESSION.acc#Action
				</cfif>						
				FROM    OrganizationObjectActionAccess AA INNER JOIN
			            userQuery.dbo.#SESSION.acc#Current_#FileNo# OA ON AA.ObjectId = OA.ObjectId and AA.ActionCode = OA.ActionCode
				WHERE   AA.AccessLevel >= '0'  					
											
			</cfquery>	
					
		</cfif>	
							
		<!---
		<cfoutput>e.#cfquery.executiontime#</cfoutput>
		--->
	
	<cfelse>
	
		
		<cfif attributes.role eq "1">
		
				
			<cfquery name="Action" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			    <!--- actions unit --->
				
				SELECT DISTINCT OA.ObjectId, 
				        OA.ActionId, 
						#preservesinglequotes(lastaction)#	
				
				<cfif attributes.mode eq "Table">
				INTO    userQuery.dbo.#SESSION.acc#Action
				</cfif>
				
				FROM    userQuery.dbo.#SESSION.acc#Current_#FileNo# OA, 
				       	userQuery.dbo.#SESSION.acc#Base_#FileNo# A			
				WHERE   OA.OrgUnit     = A.OrgUnit 
				AND     OA.ActionCode  = A.ClassParameter
				AND     OA.EntityGroup = A.GroupParameter
				
					
				UNION
				
				<!--- actions mission level access --->
				
				SELECT  DISTINCT OA.ObjectId, 
				        OA.ActionId, 
						#preservesinglequotes(lastaction)#	
				FROM    userQuery.dbo.#SESSION.acc#Current_#FileNo# OA, 
				       	userQuery.dbo.#SESSION.acc#Base_#FileNo# A			
				WHERE   A.Mission      = OA.Mission 
				AND     OA.ActionCode  = A.ClassParameter
				AND     OA.EntityGroup = A.GroupParameter	
				<!--- validate only if the orgunit is defined for the object --->
				AND     (OA.OrgUnit is NULL or (OA.OrgUnit is NOT NULL AND (A.OrgUnit IS NULL or A.OrgUnit = 0)))
					
				UNION
				
				<!--- actions global level --->
				
				SELECT  DISTINCT OA.ObjectId, 
				        OA.ActionId, 
						#preservesinglequotes(lastaction)#	
				FROM    userQuery.dbo.#SESSION.acc#Current_#FileNo# OA, 	       
						userQuery.dbo.#SESSION.acc#Base_#FileNo# A			
				WHERE   OA.ActionCode  = A.ClassParameter			
				AND     OA.EntityGroup = A.GroupParameter		
				AND     A.OrgUnit is NULL
				AND     A.Mission is NULL  
				
				UNION
					
				 <!--- actions document specific fly --->
				
				SELECT  DISTINCT OA.ObjectId, 
				        OA.ActionId, 
						#preservesinglequotes(lastaction)#	
				FROM    OrganizationObjectActionAccess AA INNER JOIN
			            userQuery.dbo.#SESSION.acc#Current_#FileNo# OA ON AA.ObjectId = OA.ObjectId and AA.ActionCode = OA.ActionCode
				WHERE   AA.AccessLevel >= '0'  	  	
				AND     AA.UserAccount IN (#preserveSingleQuotes(usr)#)
								 					
			</cfquery>	
			
			
			
			<cfquery name="ResultListing" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT     *
				 FROM       userQuery.dbo.#SESSION.acc#Current_#FileNo#  			 
			</cfquery>					
					
		<cfelse>
								
			<cfquery name="Action" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			    <!--- actions unit --->
				
				SELECT DISTINCT OA.ObjectId, 
				        OA.ActionId, 
						#preservesinglequotes(lastaction)#	
				
				<cfif attributes.mode eq "Table">				
				INTO    userQuery.dbo.#SESSION.acc#Action
				</cfif>				
				
				FROM    OrganizationObjectActionAccess AA INNER JOIN
							            userQuery.dbo.#SESSION.acc#Current_#FileNo# OA ON AA.ObjectId = OA.ObjectId and AA.ActionCode = OA.ActionCode
				WHERE   AA.AccessLevel >= '0'  	  	
				AND     AA.UserAccount IN (#preserveSingleQuotes(usr)#) 
				
				UNION
								
				<!--- mail alerts sent to this person --->
				
				SELECT  DISTINCT OA.ObjectId, 
				        OA.ActionId, 
						#preservesinglequotes(lastaction)#	
				FROM    OrganizationObjectMail AA INNER JOIN
			            userQuery.dbo.#SESSION.acc#Current_#FileNo# OA ON AA.ObjectId = OA.ObjectId and AA.ActionCode = OA.ActionCode 	
				WHERE   AA.Account IN (#preserveSingleQuotes(usr)#)
				  	 
								 					
			</cfquery>	
					
		</cfif>	
		
	</cfif>
	
</cftransaction>

<cfif attributes.mode eq "Table">
	
	<cfquery name="Index" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			CREATE UNIQUE CLUSTERED INDEX [ActionId] 
			    ON userQuery.dbo.#SESSION.acc#Action([ActionId]) ON [PRIMARY]
	</cfquery>		
			
<cfelse>

	<cfif attributes.entity neq "">	
		<cfif Action.ActionId neq "">
		<CFSET Caller.actions = quotedValueList(Action.ActionId)>				
		<cfelse>		
		<CFSET Caller.actions = "'00000000-0000-0000-0000-000000000000'">		
		</cfif>
	</cfif>	
	
</cfif>	

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#First_#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Current_#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Base_#FileNo#">	

