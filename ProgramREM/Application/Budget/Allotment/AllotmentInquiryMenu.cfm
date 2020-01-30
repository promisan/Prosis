
<cfoutput>

<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">								
					
			<cf_menuScript>
			<cf_ListingScript>
			
			<cfif not isValid("GUID",url.systemfunctionid)>
			  <cfset url.systemfunctionid = "">			
			</cfif>
												
			<cfset ht = "54">
			<cfset wd = "54">
	
				<tr>		
					
					<cfset itm = 1>								
					<cf_tl id="Requirements and Costing" var="vRequirements">
					<cf_menutab item       = "#itm#" 
				        iconsrc    = "Logos/Program/Requirement.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						class      = "highlight1"
						name       = "#vRequirements#"
						source     = "">	
						
						<cfset itm = itm + 1>							
					<cf_tl id="Requirement Listing" var="vListing">
					<cf_menutab item       = "#itm#" 
				        iconsrc    = "Logos/Program/RequirementList.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "2"
						name       = "#vListing#"
						source     = "AllotmentRequirementListing.cfm?portal=1&programcode=#url.programCode#&period=#url.period#&systemfunctionid=#url.systemfunctionid#">		
						
								
						<cfinvoke component="Service.Access"
					Method="organization"
					ProgramCode="#URL.ProgramCode#"
					Period="#URL.Period#"					
					Role="ContributionOfficer','ProgramAuditor"
					ReturnVariable="ListingAccess">	
																
					<cfif (ListingAccess eq "READ" or ListingAccess eq "EDIT"  or ListingAccess eq "ALL") and Parameter.enableDonor eq "1">	 
									
						<cfset itm = itm + 1>							
						<cf_tl id="Allocated Contributions" var="vContributions">
						<cf_menutab item       = "#itm#" 
					        iconsrc    = "Logos/Program/Donor.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vContributions#"
							source     = "AllotmentContributionListing.cfm?portal=1&programcode=#url.programCode#&period=#url.period#&systemfunctionid=#url.systemfunctionid#">		
											
					</cfif>							
					
						
					<cfif Program.ProgramClass eq "Project">
					
						<cfset itm = itm + 1>	
						<cf_tl id="Metrics and dates" var="vMetrics">
						<cf_menutab item       = "#itm#" 
					        iconsrc    = "Logos/Program/Dates.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vMetrics#"
							source     = "../../Program/Events/EventsEntry.cfm?portal=1&programcode=#url.programCode#&period=#url.period#">		
						
					<cfelseif Program.ServiceClass neq "">
					
						<cfset itm = itm + 1>	
					    <cf_tl id="Status of Services" var="vStatus">
						<cf_menutab item       = "#itm#" 
					        iconsrc    = "Logos/WorkOrder/Agreement.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vStatus#"
							source     = "../../Program/Services/ServiceListing.cfm?portal=1&programcode=#url.programCode#&period=#url.period#">		
									
					</cfif>	
					
						<cfset itm = itm + 1>
						<cf_tl id="Financial Execution" var="vExecution">
						<cf_menutab item       = "#itm#" 
					        iconsrc    = "Logos/Program/Classification.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vExecution#"
							source     = "../Listing/ExpenditureListing.cfm?systemfunctionid=#url.systemfunctionid#&script=0&header=0&mission=#url.mission#&programcode=#url.programCode#&period=#url.period#">									
				
										
					<cfquery name="Earmark" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT  *
						FROM    Ref_ParameterMissionCategory
						WHERE   Mission       = '#Program.Mission#'
						AND     BudgetEarmark = 1 	
					</cfquery>	
					
					<cfif earmark.recordcount eq "1">
					
						<cfset itm = itm + 1>
						<cf_tl id="Earmark Costs" var="vEarmark">
						<cf_menutab item       = "#itm#" 
					        iconsrc    = "Logos/Program/Benefit.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vEarmark#"
							source     = "../Earmark/CostAllocation.cfm?programcode=#url.programCode#&period=#url.period#&editionid=#edition.editionid#">					
							
					</cfif>	
					
					<cfinclude template="../../Program/Category/CategoryScript.cfm">
					
					<cfquery name="Check" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						  SELECT *
						  FROM   Ref_ProgramCategory
						  WHERE  AreaCode > ''
						  AND    Code IN (SELECT Category 
						                  FROM   Ref_ParameterMissionCategory 
										  WHERE  Mission = '#Program.Mission#'
										  AND    BudgetEarmark = 0)
						  AND    (ProgramClass is NULL or ProgramClass = '#Program.ProgramClass#')				  
						 
					</cfquery>
					
					<cfif Check.recordcount gte "1">
					
						<cfset itm = itm + 1>
						<cf_tl id="Classification" var="vClassification">
						<cf_menutab item       = "#itm#" 
					        iconsrc    = "Logos/Program/Classification.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vClassification#"
							source     = "../../Program/Category/CategoryEntry.cfm?script=0&header=0&programcode=#url.programCode#&period=#url.period#">									
							
					</cfif>												
															
					<cfif Program.ProgramClass eq "Project" and Parameter.enableGANTT eq "1">
					
						<cfset itm = itm + 1>
										
						<cfinclude template="../../Activity/Progress/ActivityViewScript.cfm">
						
						<cf_tl id="Workplan/GANTT" var="vGantt">
						
						<cf_menutab item   = "#itm#" 
				        iconsrc    = "Logos/Program/GANTT.png" 
						iconwidth  = "#wd#" iconheight = "#ht#" 
						name       = "#vGantt#"
						targetitem = "2"
						source     = "../../Activity/Progress/ActivityViewContent.cfm?mission=#url.mission#&programcode=#url.programCode#&period=#url.period#">					
										
					<cfelseif Parameter.EnableAUDIT eq "1">
					
						<cfset itm = itm + 1>
						
					    <cf_tl id="Indicator/KPI" var="vKpi">
						
						<cf_menutab item   = "#itm#" 
				        iconsrc    = "Logos/Program/Indicator.png" 
						iconwidth  = "#wd#"	iconheight = "#ht#" 
						name       = "#vKpi#"
						targetitem = "2"
						source     = "alert:To be provided upon request">												
					
					</cfif>		
					
					<!--- hidden 30/6/2012 
					
					<cfset itm = itm + 1>
					
					<cf_menutab item       = "#itm#" 
				        iconsrc    = "Logos/Staffing/Document.png" 
						iconwidth  = "#wd#" iconheight = "#ht#" 
						name       = "Supporting Documents"
						targetitem = "2"
						source     = "AllotmentInquiryDocument.cfm?mission=#url.mission#&programcode=#url.programCode#&period=#url.period#&editionid=#edition.editionid#">					
						
					--->	
																				
				</tr>
</table>
			
</cfoutput>			