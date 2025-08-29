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
<cfparam name="url.eventid"  default="">
<cfparam name="eventid"  default="#url.eventid#">
<cfparam name="url.date" default="">

<cfquery name="get" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT    *
    FROM      Warehouse	
    WHERE     Warehouse = '#url.warehouse#'			
</cfquery>		

<cfif url.date neq "">

    <cfset dateValue = "">
	<CF_DateConvert Value="#url.date#">
	<cfset DTS = dateValue>

	<cfquery name="close"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
		SELECT    *
		FROM      Accounting.dbo.Event
		WHERE     OrgUnit IN
                             (SELECT  O.OrgUnit
                              FROM    Warehouse W, Organization.dbo.Organization O
                              WHERE   W.MissionorgUnitid = O.MissionOrgUnitId
							  AND     W.Warehouse = '#url.warehouse#') 
		AND       ActionCode = 'Closing' 
	    AND       EventDate  = #DTS#
	
	</cfquery>
	
	<cfif close.recordcount gte "1">	
		 <cfset eventid = close.eventid>	 
	</cfif>
	
</cfif>	

<cfif eventid eq "">
	
	<cf_assignid>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.date#">
	<cfset DTS = dateValue>
	
	<cfquery name="Param" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
	        FROM      Ref_ParameterMission		
	        WHERE     Mission = '#get.mission#'		
	</cfquery>		
		
	<cfquery name="Period" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    TOP 1 *
	        FROM      Ref_MissionPeriod
	        WHERE     Mission = '#get.mission#'		
			ORDER BY  DefaultPeriod DESC  			  
	</cfquery>		
	
	<cfif Period.AccountPeriod eq "">
	
		<script>
			alert("Account period has not been configured")
		</script>
		
		<cfabort>
	
	<cfelse>
	
		<cfquery name="getOrg" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    O.Mission, 
				          O.MandateNo, 
						  O.ParentOrgUnit, 
						  O.OrgUnit 
		        FROM      Organization.dbo.Organization O
		        WHERE     O.MissionOrgUnitId = '#get.MissionorgUnitid#'		
				AND       O.DateEffective <= #DTS#
				ORDER BY  O.DateEffective
		</cfquery>		
		
		<!--- add provision to stop if nothing is found --->
		
		<cfif Param.AdministrationLevel eq "tree">
		
			<cfset parent = "0">
			
		<cfelse>
			
			<cfquery name="getParent" 
				   datasource="AppsOrganization" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					SELECT    *
			        FROM      Organization O
			        WHERE     O.Mission     = '#getOrg.Mission#'
					AND       O.MandateNo   = '#getOrg.MandateNo#'
					AND       O.OrgUnitCode = '#getOrg.ParentOrgUnit#'		
			</cfquery>		
			
			<cfset parent = getParent.OrgUnit>
			
		</cfif>
	
		<cfquery name="Insert" 
		   datasource="AppsLedger" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   INSERT INTO Event
				 (EventId, 
				  Mission, 
				  AccountPeriod, 
				  OrgUnitOwner, 
				  OrgUnit, 
				  ActionCode, 
				  ActionStatus, 
				  EventDate, 
				  EventDescription, 
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName)
			   VALUES (
			   '#rowguid#',
			   '#get.mission#',
			   '#Period.AccountPeriod#',
			   '#Parent#',
			   '#getOrg.OrgUnit#',
			   'Closing',
			   '0',
			   #DTS#,
			   'Closing',
			   '#session.acc#',
			   '#session.last#',
			   '#session.first#')	    
		 </cfquery>
	 
	 	<cfset eventid = rowguid>
		
	</cfif>	
	 
</cfif>	 
 
<cfoutput>
 
 	<script language="JavaScript"> 
		 w = "#client.width-100#";
	     h = "#client.height-100#";
		 ptoken.open("#session.root#/Gledger/Application/Event/EventView.cfm?mission=#get.Mission#&id=#eventid#","closing"); 
	</script>
 
</cfoutput>
