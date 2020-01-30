
<cfoutput>

<table width="99%" style="min-width: 1200px;" border="0" align="center" cellspacing="0" cellpadding="0">		  		
						
	<cfinvoke component="Service.Presentation.Presentation"
    method="highlight" class="highlight3"
    returnvariable="stylescroll"/>
	
		<cfset ht = "48">
		<cfset wd = "48">
		
		<cf_tl id="Advanced" var="1">
		<cfset tInquiry = "#Lt_text#">		
		
		<tr>
		
			<cfset itm = 1>
		
			<cf_tl id="Grade / Unit Matrix" var="vUnitAndGrade">
		
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/Staffing/Matrix.png" 
						iconwidth  = "#wd#" 
						padding    = "3"
						class      = "highlight1"						
						iconheight = "#ht#" 
						name       = "#vUnitAndGrade#">					
				
			
			<cfset itm = itm+1>				
			
			<cf_tl id="Quick Search" var="vSearch">
			
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/Staffing/search.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						padding    = "1"						
						name       = "#vSearch#">	
								
			  <cfif maintain neq "NONE">	
			  	
			  <cfset itm = itm+1>	
			  <cf_tl id="Staff Inquiry" var="vAdvancedInquiry">
					  
			  <cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Staffing/Staff-Inquiry.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#"		
				padding    = "1"																
				name       = "#vAdvancedInquiry#"
				source     = "javascript:tree('#URL.Mission#','#url.mandate#','#url.tree#','#dt#')">	
			
			</cfif>					
			
			<cfset itm = itm+1>
			<cf_tl id="Vacancies" var="vVacancy">
			
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/Staffing/Staffing.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 		
						padding    = "1"				
						name       = "#vVacancy#"
						source     = "javascript:detail('vacancy','#URL.Mission#','#dt#')">		
			
			<cf_verifyOperational module="WorkOrder" Warning="No" Mission="#url.mission#">
			
			<cf_tl id="Workschedule" var="vWorkforce">
			
			<cfset itm = itm+1>		
																
			<cfif operational eq "1">				
							
														
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Staffing/Workschedule.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 	
							padding    = "1"					
							name       = "#vWorkforce#"
							source     = "../../../Application/Workschedule/WorkScheduleListing.cfm?mission=#url.mission#&mandate=#url.mandate#">		
						
			</cfif>		
						
			<cfset itm = itm+1>		
			<cf_tl id="Events and Actions"	var="vPersonalLog">
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/Staffing/Action.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 	
						padding    = "1"					
						name       = "#vPersonalLog#">				
			
			<cfif maintain neq "NONE">
						
				<cfset itm = itm+1>			
				<cf_tl id="Issued Contracts" var="vIssued">
				
				<cf_menutab item       = "#itm#" 
			            	iconsrc    = "Logos/Staffing/Contract.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 	
							padding    = "1"					
							name       = "#vIssued#">
							
			</cfif>								
			
			<cfif maintain neq "NONE">	
			
				<cfset itm = itm+1>			
				<cf_tl id="Documents" var="vDocuments">
			
				<cf_menutab item       = "#itm#" 
			            	iconsrc    = "Logos/Staffing/Document.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 	
							padding    = "1"					
							name       = "#vDocuments#">
									
			</cfif>
			
			<cfif maintain neq "NONE">
			
			<cfset itm = itm+1>						
			<cf_tl id="Position Inquiry" var="vExpiredPositions">
			
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/Staffing/Position-Inquiry.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 	
						padding    = "1"					
						name       = "#vExpiredPositions#"
						source     = "javascript:window.open('MandateExpiration.cfm?dte=#dte#&mission=#url.mission#&mandate=#url.mandate#','expirationbox')">										   				  		   									
						
			</cfif>
			
		</tr>
</table>
			
</cfoutput>			