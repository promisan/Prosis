
<cfquery name="Param" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Ref_ParameterMission
   	  WHERE Mission = '#URL.Mission#' 	 
</cfquery>

<cfoutput>

<table width="100%" height="100%"><tr><td style="padding-top:3px;padding-left:8px;padding-right:8px">
<table width="100%" height="100%" cellspacing="0" class="formpadding">
    
	<tr>
	<td height="34" valign="top" style="padding-top:3px;padding-left:4px;padding-right:4px">
		
	<table cellspacing="0" cellpadding="0">
	   <tr>
	   
	   
	        <cfset wd = "64">
			<cfset ht = "64">
			
			<cfset itm = 1>
			
			<cf_tl id="Service Object" var="1">
			
			<cf_menutab item       = "#itm#" 
			    iconsrc    = "Logos/Workorder/Service-Object.png" 
    			iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				targetitem = "1"
				class      = "highlight1"
				name       = "#lt_text#"
				source     = "CustomerSearchDomain.cfm?systemfunctionid=#url.systemfunctionid#&dsn=#url.dsn#&mission=#url.mission#">
				
			  <!--- access only for processors --->	
		   		   
		      <cfinvoke component = "Service.Access"  
			   method           = "WorkOrderProcessor" 
			   mission          = "#url.mission#"  
			   returnvariable   = "access">
			  						   
				<cfquery name="Param" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT *
				      FROM   Ref_ParameterMission
				   	  WHERE  Mission = '#URL.Mission#' 	 
				</cfquery>

				<cfquery name="Unit" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT *
				      FROM   Organization
				   	  WHERE  Mission = '#Param.TreeCustomer#' 					
				</cfquery>
			   
			   <cfif access neq "NONE" and access neq "READ" and Unit.recordcount gte "1">
			   
			   	    <cfset itm = itm+1>
					 
					<cf_tl id="Customer" var="1">
									
					<cf_menutab item   = "#itm#" 
			           iconsrc    = "Logos/Workorder/Customer.png" 
					   iconwidth  = "#wd#" 
					   iconheight = "#ht#" 
					   targetitem = "2"
					   name       = "#lt_text#"
					   source     = "CustomerSearchTree.cfm?systemfunctionid=#url.systemfunctionid#&dsn=#url.dsn#&mission=#url.mission#">
			   
			   </cfif>	
			   
			   <!--- access only for processors and requester 
			   
			   removed 
		   		   
		      <cfinvoke component = "Service.Access"  
			   method             = "ServiceRequester" 
			   mission            = "#param.TreeCustomer#"  
			   returnvariable     = "requestaccess">
			   
			   or requestaccess neq "NONE"
			   
			   --->	
			   
			   <cfquery name="check" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT *
				      FROM   Ref_RequestWorkflow				   	  			
				</cfquery>
				
			  <cfif check.recordcount gte "1">	
			   
			  <cfif access eq "EDIT" or access eq "ALL"> 
			   
				  <cfset itm = itm+1> 
				  
				  <cf_tl id="Service Request" var="1">
								
				  <cf_menutab item       = "#itm#" 
					    iconsrc    = "New-Request.png" 
		    			iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "2"
						name       = "#lt_text#"
						source     = "CustomerSearchRequest.cfm?systemfunctionid=#url.systemfunctionid#&dsn=#url.dsn#&mission=#url.mission#&domain={domaininv}">
					
			  </cfif>		
			  
			  </cfif>				
		  
	   </tr>
	</table>	
	
	</td>
	</tr>
		
	<tr><td height="1" class="linedotted"></td></tr>
	
	<tr><td height="2"></td></tr>
		
	<cf_menucontainer item="1" class="regular">
		   <cfinclude template="CustomerSearchDomain.cfm">	
	<cf_menucontainer>
	
	<cf_menucontainer item="2" class="hide">
			

</table>
</td></tr></table>

</cfoutput>

