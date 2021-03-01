
<!--- determine the owner access --->

<cfparam name="url.idmenu" default="">

<input type="hidden" name="conditionvalue" id="conditionvalue">

<cfquery name="Status" 
	  datasource="AppsOrganization">
      SELECT *
	  FROM   Ref_EntityStatus
	  WHERE  EntityCode = 'SysChange'	 
</cfquery>	
		
<cfif Status.recordcount eq "0">

	<cfquery name="Status" 
	  datasource="AppsOrganization">
      INSERT INTO Ref_EntityStatus
	  (EntityCode,EntityStatus,StatusDescription)
	  VALUES
	  ('SysChange','0','Pending')	 
	</cfquery>	
	
	<cfquery name="Status" 
	  datasource="AppsOrganization">
      INSERT INTO Ref_EntityStatus
	  (EntityCode,EntityStatus,StatusDescription)
	  VALUES
	  ('SysChange','1','Testing')	 
	</cfquery>	
	
	<cfquery name="Status" 
	  datasource="AppsOrganization">
      INSERT INTO Ref_EntityStatus
	  (EntityCode,EntityStatus,StatusDescription)
	  VALUES
	  ('SysChange','2','Completed')	 
	</cfquery>	
	
	<cfquery name="Status" 
	  datasource="AppsOrganization">
      INSERT INTO Ref_EntityStatus
	  (EntityCode,EntityStatus,StatusDescription)
	  VALUES
	  ('SysChange','9','Cancelled')	 
	</cfquery>	

</cfif>

<table width="99%" height="100%" align="center">
	
	<cfset page = "">
	<cfset add = "0">
	<cfset menu = "0">
	
	<cfif url.idmenu neq "">
	<tr><td height="30">	
		<cfinclude template="../Access/HeaderMaintain.cfm">
		</td>
	</tr>		
	</cfif>
   
	<tr><td height="100%" valign="top" style="padding:4px">
	
	    <cfdiv id="detail" style="height:100%;">
		
			<cfif url.systemfunctionid eq "">
														
				<cfquery name="Menu" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT TOP 1 *
					FROM   #CLIENT.LanPrefix#Ref_ModuleControl
					WHERE  SystemModule   = 'SelfService'
					AND    FunctionClass  = '#url.id#'
					AND    MenuClass      = 'Process'
					AND    Operational = 1
					
					<cfif client.browser eq "Explorer">
					AND    (BrowserSupport = '1' OR BrowserSupport = '2')
					<cfelseif client.browser eq "Firefox" or client.browser eq "Chrome" or client.browser eq "Safari">
					AND    BrowserSupport = '2'
					<cfelse>
					AND    BrowserSupport = '0'
						<cfset BrowserSupport = "0">
					</cfif>	
					ORDER BY MenuOrder
				</cfquery>
					 
				<cfoutput>
				 		 		 		
				    <iframe src="#SESSION.root#/System/Modification/ModificationViewListing.cfm?systemfunctionid=#menu.systemfunctionid#&#menu.functioncondition#&mission=#url.mission#&webapp=#url.webapp#&scope=portal" 
					   width="100%" 
					   height="100%" 
					   marginwidth="4" marginheight="4" scrolling="no" frameborder="0">
					 </iframe>
					 			 
				</cfoutput>			
			
			<cfelse>
					 		 
			 <cfoutput>
			 		 		 		
			    <iframe src="#SESSION.root#/System/Modification/ModificationViewListing.cfm?systemfunctionid=#url.systemfunctionid#&observationclass=#url.observationclass#&mission=#url.mission#&webapp=#url.webapp#&scope=portal" 
				   width="100%" 
				   height="100%" 
				   marginwidth="4" marginheight="4" scrolling="no" frameborder="0">
				 </iframe>
				 			 
			 </cfoutput>			
			
		 	</cfif>	 
		  
		</cfdiv>   
		
		</td>
	</tr>	
	
	<tr><td height="4"></td></tr>
	
</table>

<cf_screenbottom html="No">
