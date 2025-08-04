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
<cftry>

	<!--- fastest result from tools/entityaction/myclearances/ --->

	<cfif url.me eq "true">
		<cf_myClearancesPrepare mode="table" role="0">
	<cfelse>
		<cf_myClearancesPrepare mode="table" role="1">
	</cfif>
		
	<cf_dropTable tblname="#Session.acc#_ActionResultDataset" dbname="AppsQuery">
	
	<cftransaction isolation="READ_UNCOMMITTED">
	
	        <cfset due = dateAdd("d","30",now())>
						
			<cfquery name="ResultListing" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT     OA.ActionId,
				            E.EntityCode, 
				            E.EntityDescription,
							P.ActionLeadTime, 
							P.ActionTakeAction,
							P.NotificationTarget,
							O.EntityGroup,
							O.Mission,
							O.Owner,
							M.Description,
							A.Description as Application,
							A.ListingOrder,
							E.ListingOrder as EntityOrder,
							S.SystemModule,
							(CASE WHEN O.ObjectDue is not NULL 
						      THEN CONVERT(int,getDate()-ObjectDue)
							  ELSE CONVERT(int,getDate()-DateLast) END) as Due
				 INTO 		UserQuery.dbo.#Session.acc#_ActionResultDataset
				 FROM       OrganizationObjectAction OA 
				            INNER JOIN    OrganizationObject O                 ON OA.ObjectId  = O.ObjectId 
							INNER JOIN    userQuery.dbo.#SESSION.acc#Action D  ON OA.ActionId  = D.ActionId 
							INNER JOIN    Ref_Entity E                         ON O.EntityCode = E.EntityCode 
							INNER JOIN    Ref_EntityClass EC                   ON O.EntityCode = EC.EntityCode and O.EntityClass = EC.EntityClass
							INNER JOIN    Ref_EntityActionPublish P            ON OA.ActionPublishNo = P.ActionPublishNo AND OA.ActionCode = P.ActionCode 
							INNER JOIN    Ref_AuthorizationRole S              ON E.Role = S.Role
							INNER JOIN    System.dbo.xl#Client.LanguageId#_Ref_SystemModule M ON M.SystemModule = S.SystemModule
							INNER JOIN    System.dbo.Ref_ApplicationModule AM ON AM.SystemModule = M.SystemModule
							INNER JOIN    System.dbo.Ref_Application A ON A.Code = AM.Code AND Usage = 'System'
				 WHERE      P.EnableMyClearances = 1 
				  AND       O.ObjectStatus       = 0
				  AND       O.Operational        = 1  
				  <cfif url.EntityDue eq "Due">
				  AND       (O.ObjectDue is NULL or O.ObjectDue <= #due#)
				  </cfif>
				  <cfif url.scope eq "portal">
				  AND       E.EnablePortal = 1 AND  EC.EnablePortal = 1
				  </cfif>	  
				  AND       E.ProcessMode       != '9'		
				  <!--- hide concurrent actions that were completed --->
				  AND       OA.ActionStatus     != '2'			 
			</cfquery>
										
	</cftransaction>	

<cfcatch>
		<cf_message message="<span style='color:red;font-size:24px;font-weight:200'>Your request was interrupted.</span> <br><b><span style='color:blue;font-size:24px;font-weight:200'>Please reload your pending for actions view.</font>" return="No">
	<cfabort>

	</cfcatch>

</cftry>

	