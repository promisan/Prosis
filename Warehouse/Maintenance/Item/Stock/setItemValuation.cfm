
<cfset session.status = 0>
<cf_tl id="Calculating standard reevaluation" var="1">
<cfset session.StatusStr = lt_text>

<cftransaction>
	
	<cfif url.revaluation eq "false">
		
		<cfinvoke component = "Service.Process.Materials.Stock"  
		   method           = "RedoIssuanceTransaction" 
		   Mode             = "Standard" <!---  and now also handles 0 initial stock values --->
		   filtermission    = "#url.mission#"   
		   filteritemno     = "#url.id#"
		   finalStatus		= "0.3"
		   revaluation      = "0">	 

		<cf_tl id="Calculating forced completed" var="1">
		<cfset session.StatusStr = lt_text> 
			      					
		<cfinvoke component = "Service.Process.Materials.Stock"  
		   method           = "RedoIssuanceTransaction" 
		   Mode             = "Force" <!--- removes small differences --->
		   filtermission    = "#url.mission#"   
		   filteritemno     = "#url.id#"
		   initialStatus  	= "0.6"
		   revaluation      = "0">	
		
			
	<cfelse>
		
		  <cfinvoke component = "Service.Process.Materials.Stock"  
		   method           = "RedoIssuanceTransaction" 
		   Mode             = "Standard"
		   filtermission    = "#url.mission#"   
		   filteritemno     = "#url.id#"
		   revaluation      = "1">	 
	   
	</cfif>		
   
</cftransaction>   

<cfset session.status = 1>
<cf_tl id="Reevaluation completed" var="1">
<cfset session.StatusStr = lt_text> 						

<cfinclude template="ItemStock.cfm">   
   
   	