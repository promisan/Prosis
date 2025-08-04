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

<cfoutput>

<table width="99%" border="0" align="center">		  		
						
	<cfinvoke component="Service.Presentation.Presentation"
    method="highlight" class="highlight3"
    returnvariable="stylescroll"/>
	
		<cfset ht = "54">
		<cfset wd = "54">
		
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
															
			<cfif operational eq "1">			
							
				<cfset itm = itm+1>											
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Staffing/Workschedule.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 	
							padding    = "1"					
							name       = "#vWorkforce#"
							source     = "../../../Application/Workschedule/WorkScheduleListing.cfm?mission=#url.mission#&mandate=#url.mandate#">		
						
			</cfif>		
			
			<!---
						
			<cfset itm = itm+1>		
			<cf_tl id="Events and Actions"	var="vPersonalLog">
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/Staffing/Action.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 	
						padding    = "1"					
						name       = "#vPersonalLog#">				
						
			--->			
			
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
							name       = "#vDocuments#"
							source = "MandateDocument.cfm?mission=#url.mission#&mandate=#url.mandate#">
									
			</cfif>
			
			<!---
			
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
			
			--->
			
		</tr>
</table>
			
</cfoutput>			