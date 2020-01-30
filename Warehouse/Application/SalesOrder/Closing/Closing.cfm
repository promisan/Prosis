
<!--- check record if not create record and open it for processing --->

<cfparam name="url.eventid" default="">

<cfquery name="get" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT    *
    FROM      Warehouse	
    WHERE     Warehouse = '#url.warehouse#'			
</cfquery>		

<cfif url.eventid eq "">
	
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
	 
<cfelse>

	<cfset eventid = url.eventid>

</cfif>	 
 
<cfoutput>
 
 	<script language="JavaScript"> 
		 w = "#client.width-100#";
	     h = "#client.height-100#";
		 ptoken.open("#session.root#/Gledger/Application/Event/EventView.cfm?mission=#get.Mission#&id=#eventid#","closing"); 
	</script>
 
</cfoutput>
