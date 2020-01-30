<cfparam name="URL.Ajax"     default="No">
<cfif URL.Ajax eq "No">
	<cf_textareascript>
</cfif>		

<cfajaximport tags="cfform">
<cfoutput>

<!--- Important 

There are three mode
	1. Standard all roster selection
	2. Edition, which has been published, actionstatus = 3 or has FunctionOrganization
	3. Edition, which is being published, actionstatus = 0
--->

<table width="97%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">	
    
	<tr><td height="60">
		
	<table width="100%" height="100%" style="min-width:960px;" align="center" cellspacing="0" cellpadding="0">		  		
						
			<cfset ht = "48">
			<cfset wd = "48">
			<cfset itm = "0">
			
			 <!--- ---------------------------- --->				
			 <!--- -----underlying positions--- --->
		     <!--- ---------------------------- --->				 
			 		
			 <cfquery name="get" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  *
					FROM    Ref_SubmissionEdition
					WHERE   SubmissionEdition = '#URL.Edition#'
			 </cfquery>
								
			 <cfquery name="getPositions" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  *
					FROM    Ref_SubmissionEditionPosition
					WHERE   SubmissionEdition = '#URL.Edition#'
			 </cfquery>
					
			<tr>		
			
				  <!--- we always show the matrx first if we have buckets or the mode=all or if we do not have underlying
				  positions to be pusblushed for this edition --->
				  
				  <cfif (getBuckets.recordcount gte "1" 
				      or url.edition eq "all" 					  
					  or getPositions.recordcount eq "0") and get.ActionStatus neq "0">
					  
					  <td valign="top" style="padding-right:6px;padding-top:5px;border-right:0px solid gray">
					  
							<table>
														
							<tr><td style="padding-left:4px;padding-top:5px">
							
							<cf_space spaces="112">
						
							<cfquery name="Class" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  DISTINCT E.ExerciseClass, 
								        R.Description
								FROM    Ref_SubmissionEdition E INNER JOIN Ref_ExerciseClass R ON E.ExerciseClass = R.ExcerciseClass
								WHERE   E.Owner = '#url.owner#'
							</cfquery>		
												
							<select name="exerciseclass" id="exerciseclass" style="width:90%;height:46px;font-size:30px" class="regularxl" onChange="reloadroster()">
								 
								<option value="">--<cf_tl id="Any">--</option>
								<cfloop query="Class">
									<option value="#ExerciseClass#" <cfif url.exerciseclass eq exerciseclass>selected</cfif>>#Description#</option>
								</cfloop>
								
							</select>	
							
							</td></tr>
							</table>	
					  
					  </td>
					  
			
					  <!--- ---------------------------- --->	
					  <!--- ---------- buckets---------- --->	
					  <!--- ---------------------------- --->					
					  
					  <cfset itm = itm+1>
					  						
					  <cf_menutab item       = "#itm#" 					            
						        iconsrc    = "Logos/Staffing/matrix.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "1"
								class      = "highlight1"
								name       = "Matrix"
								source     = "">	
									
					  <cfset itm = itm+1>							
						
					  <cf_menutab item       = "#itm#" 					            
					            iconsrc    = "Logos/Staffing/Search.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 	
								targetitem = "2"							
								name       = "Find Track"
								source     = "">						
				
				  </cfif>
				  
				   <!--- we show the postions first if we have no buckets or the mode<>all and indeed have positions --->
				  
				  <cfif url.edition neq "all">					 
					
					  <cfif getPositions.recordcount gte "1">
					  
							<cfset itm = itm+1>		
							
							<cfif itm eq "1">
							    <cfset cl = "highlight">
							<cfelse>
								<cfset cl = "regular">
							</cfif>
																				
						    <cf_menutab item       = "#itm#" 
							            iconsrc    = "Logos/Staffing/Position-Inquiry.png" 
										iconwidth  = "#wd#" 
										targetitem = "3"
										iconheight = "#ht#" 	
										class     =  "#cl#"							
										name       = "Positions"
										source     = "#session.root#/Roster/Maintenance/RosterEdition/Position/PositionListing.cfm?submissionedition=#URL.edition#">	
							
							<cfset itm = itm+1>		
							
						    <cf_menutab item       = "#itm#" 
							            iconsrc    = "Logos/Workflow.png"
										iconwidth  = "#wd#" 
										targetitem = "4"
										iconheight = "#ht#" 	
										class     =  "#cl#"							
										name       = "Edition Workflow"
										source     = "#session.root#/Roster/Maintenance/RosterEdition/Workflow/Workflow.cfm?submissionedition=#URL.edition#">	
							
							<!--- <cfset itm = itm+1>												
										
						     <cf_menutab item       = "#itm#" 
							            iconsrc    = "Logos/Staffing/Memo.png" 
										iconwidth  = "#wd#" 
										targetitem = "5"
										iconheight = "#ht#" 	
										class     =  "regular"							
										name       = "Publish Materials"
										iframe     = "languagebox"
										source     = "iframe:#session.root#/Roster/Maintenance/RosterEdition/Materials/PublishText.cfm?submissionedition=#URL.edition#">	
								--->
										
							  <!--- underlying published issuances by mail --->
					  									  
							  <cfquery name="getClass" 
								datasource="AppsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT  *
									FROM    Ref_ExerciseClass
									WHERE   ExcerciseClass = '#Edition.ExerciseClass#'
							  </cfquery>
							  
							  <cfif getClass.TreePublish neq "">			
							
								
								<cfif Edition.ActionStatus neq "3">
								
									<cfset itm = itm+1>		
											
							   		 <cf_menutab item  = "#itm#" 
							            iconsrc    = "Logos/Staffing/Publish.png" 
										iconwidth  = "#wd#" 
										targetitem = "4"
										iconheight = "#ht#" 	
										class      =  "regular"							
										name       = "Publish To"
										source     = "#session.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientView.cfm?submissionedition=#URL.edition#">	
										
								</cfif>		
								
								<cfif Edition.ActionStatus gt "1">
								
									<cfset itm = itm+1>		
																 								 										
									<cf_menutab item   = "#itm#" 
							            iconsrc        = "Mail.png" 
										iconwidth      = "#wd#" 
										targetitem     = "4"
										iconheight     = "#ht#" 								
										name           = "Published To"
										source         = "#session.root#/Roster/Maintenance/RosterEdition/Recipient/PublishListing.cfm?submissionedition=#URL.edition#">
													 
								 </cfif> 
								 
							 </cfif>				
																
					  </cfif>					 		 
				  
				  </cfif>					  
				  
				  <cfif getBuckets.recordcount gte "1" 
				      or url.edition eq "all" 
					  or getPositions.recordcount eq "0">
										  
					  	<cfset itm = itm+1>		
																 								 										
						<cf_menutab item   = "#itm#" 
				            iconsrc        = "Logos/Roster/Candidates.png" 
							iconwidth      = "#wd#" 
							targetitem     = "4"
							iconheight     = "#ht#" 								
							name           = "Roster Candidates"
							source         = "#session.root#/Roster/Maintenance/RosterEdition/Candidate/CandidateListing.cfm?systemfunctionid=#url.systemfunctionid#&owner=#url.owner#&exerciseclass=#url.exerciseclass#&submissionedition=#URL.edition#">
					  
				  </cfif>
				  
				  <cfif getBuckets.recordcount eq "0" 
				      and url.edition neq "all" 
					  and getPositions.recordcount neq "0">
			
					  <!--- ---------------------------- --->	
					  <!--- ---------- buckets---------- --->	
					  <!--- ---------------------------- --->					
					  
					  <cfset itm = itm+1>
					  						
					  <cf_menutab item       = "#itm#" 					            
						        iconsrc    = "Logos/Staffing/matrix.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "1"
								class      = "regular"
								name       = "Candidacy by Grade Matrix"
								source     = "">	
									
					  <cfset itm = itm+1>							
						
					  <cf_menutab item       = "#itm#" 					            
					            iconsrc    = "Logos/Staffing/Search.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 	
								targetitem = "2"							
								name       = "Find Bucket/JO"
								source     = "">	
					
				
				  </cfif>				
												
				  <!--- ------------------------------- --->									
				  <!--- we can considere this also 
				  		for the special roster edition- --->
				  <!--- ------------------------------- --->		
				  	
				  <cfif URL.Edition eq "All">
					
						<cfset itm = itm+1>		
								
						<cf_menutab item       = "#itm#" 					            
						            iconsrc    = "Logos/Staffing/Analysis.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 		
									targetitem = "7"						
									name       = "Roster Status Inquiry"
									source     = "javascript:loadset()">	
									
				 </cfif>																					
																	 		
				</tr>
		</table>		
			
		</td></tr>	
		
		
</table>
			
</cfoutput>			