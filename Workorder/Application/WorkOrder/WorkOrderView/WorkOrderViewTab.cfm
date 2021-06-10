

<cfquery name="Workorder" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Workorder
		WHERE WorkorderId = '#URL.workorderid#'	
</cfquery>	

<cfquery name="ServiceItem" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  ServiceItem
		WHERE Code = '#WorkOrder.ServiceItem#'	
</cfquery>	

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM  OrganizationObject
		WHERE ObjectKeyValue4 = '#URL.workorderid#'	
</cfquery>

<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="0">
	   
		<!--- determine overall access --->
	
	<!--- 
	<cfinvoke component = "Service.Access"  
		    method           = "WorkorderManager" 
			mission          = "#Workorder.Mission#" 	   
		    returnvariable   = "accessLevel">	
			---->
			
	<cfset accesslevel = "all">		
			
	<!--- ------------------------------------------------------------------------------ --->
	<!--- check if access to the tabs is granted based on the fly access settings in wf- --->
	<!--- ------------------------------------------------------------------------------ --->
					
	<cfif accesslevel eq "NONE">
		
		<cfset accessgranted = "">
												
		<cfif Object.ObjectId neq "">
								
			<cfinvoke component = "Service.Access"  
		    method           = "AccessEntityFly" 	   
			ObjectId         = "#Object.Objectid#"
		    returnvariable   = "accessgranted">	
					
			<!--- return NULL, 0 (collaborator), 1 (processor) --->
				
		</cfif>
				
	<cfelse>
			
			<cfset accessgranted = "2">
			
	</cfif>									
	
	<cfif accessgranted eq "">
	
		You do no longer have access to this document
	
	<cfelse>
	
			<!--- --------- --->
			<!--- --menu--- --->
			<!--- --------- --->
	
			<cfset menu = "0">
							
			<!--- ------------------------ --->
			<!--- show only to a processor --->
			<!--- ------------------------ --->
			
			<cfset wd = "64">
			<cfset ht = "64">
			
			<cfif accessgranted gte "1">
			
				<cf_tl id="Summary" var="vSummary">
			
				<cf_menutab item       = "1" 
				            iconsrc    = "Summary.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							name       = "#vSummary#"
							source     = "../Header/WorkorderHeader.cfm?systemfunctionid=#url.systemfunctionid#&init=0&workorderid=#URL.workorderId#&mission=#url.Mission#">
			
							
			</cfif>					
			
			<cfquery name="myTabs" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT   *
				    FROM     ServiceItemTab
					WHERE    Code = '#Workorder.ServiceItem#'	
					AND      TabName != 'Control'
					AND      Mission = '#Workorder.mission#'
					AND      Operational = 1
					ORDER BY TabOrder
			</cfquery>				
			
			<cfset menu = 1>			 
			<cfloop query="mytabs">
			
			
						
				<!--- ----------------------------------------------------------- --->
				<!--- define if the tab will be shown based on the value 0, 1, 2- --->
				<!--- ----------------------------------------------------------- --->
				
				<cfif accessgranted gte accesslevelread and accessgranted neq "">		
					
					<cfset menu = menu+1>
					
					<cf_menutab item       = "#menu#" 
					            iconsrc    = "#TabIcon#" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "2"
								name       = "#TabName#"
								source     = "#TabTemplate#?systemfunctionid=#url.systemfunctionid#&tabno=2&WorkorderId=#URL.WorkorderId#&mission=#url.Mission#">
									
				</cfif>					
				 
			</cfloop>	
			
			<cfset menu = menu+1>	
			
			<cf_tl id="Contact Information" var="vContact">
			
			<cf_menutab item       = "#menu#" 
		            iconsrc    = "Contact.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					name       = "#vContact#"
					source     = "../Header/WorkorderAddress.cfm?init=0&workorderid=#URL.workorderId#&mission=#url.Mission#">
						
					
						
	</cfif>

</table>
	