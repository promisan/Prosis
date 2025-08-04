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

<cfajaximport>

<cf_screentop height="100%" html="No" scroll="Yes" jquery="Yes">

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td height="30"></td></tr>
	<tr><td height="22" style="padding-left:15px;font-size:25px" class="labellarge">
		<cf_tl id="Supply and Equipment Request Clearance">	
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td height="1" class="linedotted"></td></tr>
	<tr><td height="5"></td></tr>
</table>

<cfparam name="URL.ID" default="">
<cfset CLIENT.Review = "#URL.ID#">
<cfparam name="URL.Sorting" default="">

<cfset act = 0>
  
	<!--- Identify pending records --->
	<cfset IDStatus   = "i">
	<cfset StatusNext = "1">
	
	<cfparam name="URL.Sorting" default="RequestDate">
	<cfset action = "Unit chief requisition clearance">
	<cfset role   = "ReqClear">
	
	<cfif URL.Sorting eq "">
	    <cfset URL.Sorting = "RequestDate">
		<cfset ord = "ORDER BY RequestDate">
	<cfelseif URL.Sorting is "HierarchyCode">
		<cfset ord = "ORDER BY Org.#URL.Sorting#">    		
	<cfelse>
		<cfset ord = "ORDER BY #URL.Sorting#">
	</cfif>
	
	<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
	</cfquery>
	
	<cfquery name="SearchResult" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT   DISTINCT L.*, 
			     L.UoM as UnitOfMeasure, 
				 U.UoMDescription,
				 A.ItemPrecision, 
				 A.ItemDescription, 
				 A.Category, A.CategoryItem ,
				 Org.Mission, 
				 Org.OrgUnitName, 
				 Org.HierarchyCode as OrgUnitHierarchy,
				 (SELECT WarehouseName FROM Materials.dbo.Warehouse WHERE Warehouse = L.ShipToWarehouse) as ShipToWarehouseName
				 
		FROM     Materials.dbo.Request L, 
				 Materials.dbo.Item A,
				 Materials.dbo.ItemUoM U,
				 Organization Org
				  
		WHERE    L.ItemNo      = A.ItemNo		
		AND      L.Status      = '#IDStatus#' 		
		AND      L.OrgUnit     = Org.OrgUnit 
		AND      L.Mission     = '#URL.Mission#'  
		AND      A.ItemNo      = U.ItemNo
		<!--- this is only meant for requests that are pickticket / warehouse resupply --->
		AND      L.RequestType IN ('Pickticket','Warehouse')
		AND      L.UoM         = U.UoM
		
		<cfif getAdministrator(url.mission) eq "0">
				
		AND    (
					L.OrgUnit IN (
					
		                             SELECT  OA.OrgUnit 
		                             FROM    OrganizationAuthorization OA
									 WHERE   OA.OrgUnit          = L.OrgUnit										
									 AND     OA.Role             = 'ReqClear'
									 AND     OA.AccessLevel IN ('0','1','2')
									 AND     OA.UserAccount      = '#session.acc#'
									 
									 )	
					OR
					
					L.Mission IN (
					
									 SELECT  Mission 
		                             FROM    OrganizationAuthorization OA
									 WHERE   OA.Mission          = L.Mission 	
									 AND     OA.Role             = 'ReqClear'
									 AND     OA.OrgUnit IS NULL
									 AND     OA.AccessLevel IN ('0','1','2')
									 AND     OA.UserAccount      = '#session.acc#'
									 
									 )	
					
					)				 				
		
		</cfif>
			
			
	</cfquery>
	
   <cfset role = "reqclear">								
      <cfinclude template="ClearanceListing.cfm">
   
   <cfif Searchresult.recordcount gte "1">
       <cfset act = 1>
   </cfif>
   
   <!--- retrieving records warehouse clearer --->
   
   <!--- Identify pending records --->
   <cfset IDStatus = "1">
   <cfset StatusNext = "2">
	
   <cfparam name="URL.Sorting" default="RequestDate">
   <cfset action = "Warehouse requisition clearance">
   <cfset role = "WhsClear">
	
	<cfif URL.Sorting eq "">
	    <cfset URL.Sorting = "RequestDate">
		<cfset ord = "ORDER BY RequestDate">
	<cfelseif URL.Sorting is "HierarchyCode">
		<cfset ord = "ORDER BY Org.#URL.Sorting#">    		
	<cfelse>
		<cfset ord = "ORDER BY #URL.Sorting#">
	</cfif>
							
	<cfquery name="SearchResult" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT L.*, 
		       L.UoM as UnitOfMeasure, 
			   A.ItemPrecision, 
			   U.UoMDescription,
			   A.ItemDescription, 
			   A.Category, A.CategoryItem ,
			   Org.Mission, 
			   Org.OrgUnitName, 
			   Org.HierarchyCode,
			    (SELECT WarehouseName FROM Materials.dbo.Warehouse WHERE Warehouse = L.ShipToWarehouse) as ShipToWarehouseName
		FROM   Materials.dbo.Request L, 
			   Materials.dbo.Item A,
			   Materials.dbo.ItemUoM U,
			   Materials.dbo.Warehouse W,
			   Organization Org 
		WHERE  L.ItemNo           = A.ItemNo
		AND    L.Status           = '#IDStatus#'
		AND    L.Warehouse        = W.Warehouse 
		AND    A.ItemNo           = U.ItemNo
		AND    L.UoM              = U.UoM
		AND    L.OrgUnit          = Org.OrgUnit
		AND    Org.Mission        = '#URL.Mission#' 
		<!--- this is only meant for requests that are pickticket / warehouse resupply --->
		AND    L.RequestType IN ('Pickticket','Warehouse')
		
		<cfif getAdministrator(url.mission) eq "0">
		
		AND    (
					W.MissionOrgUnitId IN (
		                             SELECT  O2.MissionOrgUnitId 
		                             FROM    OrganizationAuthorization OA, Organization O2
									 WHERE   OA.OrgUnit          = O2.OrgUnit
									 AND     O2.MissionOrgUnitId = W.MissionOrgUnitId 	
									 AND     OA.Role             = 'WhsClear'
									 AND     OA.AccessLevel IN ('0','1','2')
									 AND     OA.UserAccount = '#session.acc#'
									 )	
					OR
					
					W.Mission IN (
					
									 SELECT  Mission 
		                             FROM    OrganizationAuthorization OA
									 WHERE   OA.Mission          = W.Mission 	
									 AND     OA.Role             = 'WhsClear'
									 AND     OA.OrgUnit IS NULL
									 AND     OA.AccessLevel IN ('0','1','2')
									 AND     OA.UserAccount = '#session.acc#'
									 )	
					
					)				 		
		</cfif>
		
		#ord#, A.Category, A.CategoryItem 
				
   </cfquery> 
		
   <cfset role = "whsclear">					
   <cfinclude template="ClearanceListing.cfm">		
   <cfif Searchresult.recordcount gte "1">
	    <cfset act = 1>
   </cfif>
	   
	<!--- Identify pending records --->

	<cfset IDStatus   = "1">
	<cfset StatusNext = "2">
	<cfparam name="URL.Sorting" default="Req.RequestDate">
	<cfset action = "Confirm the receipt of warehouse items">
	<cfset role = "ReqReceipt">
	
	<cfif URL.Sorting eq "">
	    <cfset URL.Sorting = "RequestDate">
		<cfset ord = "ORDER BY RequestDate">
	<cfelse>
		<cfset ord = "ORDER BY #URL.Sorting#">
	</cfif>
				
<cfif act eq "0">

	<table width="100%">
	   <tr><td style="height:40px" align="center" class="labelmedium">There are no records pending for your clearance </td></tr>
	</table>

</cfif>

