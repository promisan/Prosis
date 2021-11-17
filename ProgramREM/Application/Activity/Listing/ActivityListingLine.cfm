
<cfparam name="url.option" default="1">

<cfoutput>

	<!--- ---- --->
	<!--- TASK --->		
	<!--- ---- --->		
	
	<cfif Status eq "Pending" and ActivityDateStart gt now()>
	   <cfset actcolor  = "NotStarted"> <!--- normal --->
	<cfelseif Status eq "Pending" and ActivityDateStart lte now() and ActivityDateEnd gt now()>
	   <cfset actcolor  = "OnSchedule"> <!--- due --->  
	<cfelseif Status eq "Pending" and ActivityDateEnd lte now()>
	   <cfset actcolor  = "Overdue"> <!--- overdue --->
	<cfelseif Status eq "">  
	   <cfset actcolor  = "Completed"> <!--- green --->
	<cfelse>
	   <cfset actcolor = "White">   
	</cfif> 
	<cfset st = Status>		
				
    <cfset act = act+1>
	
	<cfset ds = ActivityDateStart>

	<cfif url.output eq "1" or Status eq "Pending">
		<cfset de = ActivityDateEnd>
	<cfelse>
		<cfset de = ActivityDate>
	</cfif>
		
	<tr name="cl#clrow#" id="cl#clrow#" class="navigation_row labelmedium line fixlengthlist">
		
	<cfif url.outputshow eq "0" and url.option neq "2">
	
		<td align="center" style="height:24px;cursor:pointer;min-width:20px" onClick="javascript:showprogress('#activityId#')">
				
		<cfset cl = "hide">
				
		<img src="#SESSION.root#/Images/ArrowRight.gif"
		     alt="Progress"
		     id="max#activityId#"
		     border="0"
			 align="absmiddle"
		     class="regular">
		 
		<img src="#SESSION.root#/Images/ArrowDown.gif"
		     alt="Collapse"
		     id="min#activityId#"
		     border="0"
			 align="absmiddle"
		     class="hide">		
		 								 
		</td>
		
	<cfelse>
	
		<td style="width:10px"></td>
		
			<cfset cl = "regular">
	
	</cfif>
	
	<td style="cursor: pointer;padding-right:5px" onClick="javascript:showprogress('#activityId#')">	
		#currentrow#	
	</td>	
	
	<cfif ActivityDescription neq ""and len(activitydescription) gt "4">
		<cfset vDescription = ActivityDescription>
	<cfelse>
		<cf_tl id="Undefined" var="1">
		<cfset vDescription = "<font color='red'>(#lt_text#)</font>">
	</cfif>
		
	<cfif (EditAccess eq "Edit" or EditAccess eq "ALL") and (ActivityPeriod eq url.Period)>	
	    
		<td style="padding-left:10px" onclick="javascript:edit('#activityid#')">	
						  
		  <font color="0080C0">		  
		  <cf_UITooltip
			id         = "#activityId#"
			ContentUrl = "Listing/ActivityPopup.cfm?activityid=#activityid#"
			CallOut    = "false"
			Position   = "right"  
			Width      = "400"
			Height     = "200"
			Duration   = "300">#vDescription#</cf_UITooltip>		  
		  </font>
		</td>
		
	<cfelse>
		<td>
						
		<cf_UITooltip
			id         = "#activityId#"
			ContentUrl = "Listing/ActivityPopup.cfm?activityid=#activityid#"
			CallOut    = "false"
			Position   = "right"  
			Width      = "400"
			Height     = "200"
			Duration   = "300">#vDescription#</cf_UITooltip>
			
		</td>
	</cfif>
		
	<td align="center">
			
		<cfquery name="Locations" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   L.Description as LocationName	        
			FROM     ProgramActivityLocation P ,Payroll.dbo.Ref_PayrollLocation L
			WHERE    ProgramCode    = '#ProgramCode#'
			AND      ActivityPeriod = '#ActivityPeriod#'
			AND      ActivityID     = '#ActivityID#'  		
			AND      P.LocationCode = L.LocationCode
		</cfquery>
	
		<table>
		<cfloop query="Locations">	
			<tr class="labelmedium"><td>#LocationName#</td></tr>	
		</cfloop>
		</table>
			
	</td>
							
	<td align="center" style="width:100px">#DateFormat(ActivityDateStart, CLIENT.DateFormatShow)#</td>
	<td align="center" style="width:100px">
	<cfif url.output eq "1" or Status eq "Pending">
		<!--- the real planned date ---->
		#DateFormat(ActivityDateEnd, CLIENT.DateFormatShow)#
	<cfelse>
		#DateFormat(ActivityDate, CLIENT.DateFormatShow)#
	</cfif>	
	</td>
	
	<td align="center" style="width:60px">
	
	<cftry>
	
		<cfif url.output eq "1" or Status eq "Pending">
			<cfset vduration = ActivityDateEnd - ActivityDateStart  + 1>		
			<cf_space align="center" spaces="14" label="#vduration#d">
		<cfelse>
			<cf_space align="center" spaces="14" label="#ActivityDays#d">
		</cfif>
	
		<cfcatch></cfcatch>
	
	</cftry>
	
	</td>
			
	</tr>
		
	<cfif url.option eq "1">
				
		<tr name="cl#clrow#" id="cl#clrow#">
		
		    <td></td>
			<td></td>
			<td colspan="#cols-1#" style="padding-left:15px;padding-right:5px;">
									
			<cfdiv id="cost#activityid#">
			
			<cfset url.activityid = activityid>	   
			<cfset url.period     = url.period>
			
			<cfquery name="getCosting" dbtype="query">
					SELECT    *
					FROM      Costing
					WHERE     ActivityId   = #url.activityid# 
					ORDER BY  EditionId,HierarchyCode
			</cfquery>
									
			<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">
			
					<!--- now we check if the project itself is closed or not 
					so possibly we lock the requirement in the below cfc --->
					
					<cfinvoke component="Service.Process.Program.ProgramAllotment"  <!--- get access levels based on top Program--->
						Method         = "RequirementStatus"
						ProgramCode    = "#getCosting.ProgramCode#"
						Period         = "#URL.Period#"	
						EditionId      = "#getCosting.editionId#" 
						ReturnVariable = "RequirementLock">			
						
			<cfelse>
			
				<!--- WE LOCK THE REQUIREMENT --->
				<cfset RequirementLock = "1">			
						
			</cfif>				
				
			<!--- for rippled access only, can be tuned --->
			
			<cfinvoke component="Service.Access"  
					Method         = "budget"
					ProgramCode    = "#getCosting.ProgramCode#"
					Period         = "#URL.Period#"	
					EditionId      = "#getCosting.editionId#"  
					Role           = "'BudgetManager'"
					ReturnVariable = "BudgetManagerAccess">	
			  		  
			  <table width="100%" class="navigation_table">
			  
			    <cfset tot = 0>
				
			  	<cfloop query="getCosting">
				 
					 <cfset tot = tot + RequestAmountBase>
					 
				     <tr class="line labelmedium2 navigation_row">
					 
					    <td style="padding-top:2px;width:20px">
											
							<cfif Allotment eq "0" or Allotment eq "">
																													
								<cfif RequestType eq "ripple">
								
									<!--- only budget manager has access to rippled stuff --->																				
									<cfif requirementLock eq "0" and (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL")>																				
										<cf_img icon="edit" navigation="Yes" onclick="alldetinsert('resource','#editionid#','#objectcode#','#requirementid#','resource')">								
									</cfif>
								
								<cfelse>
							
									<cfif requirementLock eq "0">																					
										<cf_img icon="edit" navigation="Yes" onclick="alldetinsert('resource','#editionid#','#objectcode#','#requirementid#','resource')">													
									</cfif>
								
								</cfif>
																								
							</cfif>					
						
						</td>
					 	<td style="width:60px;padding-left:4px">#Fund#</td>
						<td style="width:20%">#Description#</td>
						<td style="width:100px">#Dateformat(RequestDue,client.dateformatshow)#</td>
						<td>#ItemMaster# #RequestDescription#</td>
						<td align="right" style="width:120px;padding-right:4px">#numberformat(RequestAmountBase,",.__")#</td>
						
					 </tr>
				 
				</cfloop> 
				
				<cfif tot neq "0">
					
					<tr><td colspan="5"></td>
						<td bgcolor="CAFBD7" align="right" class="labelit" style="width:120px;padding-right:4px">#numberformat(tot,",__.__")#</td>
					</tr>
					
				</cfif>
			  </table>	 		  
			   
		    </cfdiv>
			   
			 </td>
			 <td></td>
		
		</tr>
	
	</cfif>
	
	<cfif url.option neq "2">
		
		<tr name="cl#clrow#" id="cl#clrow#" style="border-top:1px solid silver">
		
		    <td colspan="2"></td>
			
			<td colspan="#cols#">		
			
				<table border="0" width="100%">
					<tr id="row#activityid#" class="#cl#">
					<td id="box#activityid#">
								
					   <cfset url.fileNo = fileNo>							 
					   <cfset url.activityid = activityid>
					   <cfset url.mode = "read">
					      
					   <cfinclude template="ActivityListingOutput.cfm">
					   		
					</td>
					</tr>
				</table>	
				   
			</td>
			<td></td>
		 </tr>	 	
	 
	 </cfif>
	
</cfoutput>		