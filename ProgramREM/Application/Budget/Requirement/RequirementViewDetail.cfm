
<table width="100%" class="navigation_table formpadding">

	<tr class="labelmedium line">
	  <td width="2%"></td>	  
	  <td></td>
	  <td style="min-width:100%"></td>
	  <td style="min-width:100px" align="center"></td>
	  <cfif vIncludePSCColumns>
	  <td style="min-width:100px" align="center"></td>		
	  </cfif>
	  <td style="min-width:100px" align="center"></td>	
	  <cfif vIncludePSCColumns>
	  <td style="min-width:100px" align="center"></td>	
	  </cfif>
	  <td style="min-width:100px" align="center"></td>	
	  <td style="min-width:100px" align="center"></td>	
	  <td style="min-width:100px" align="center"></td>		
	  <td style="min-width:100px" align="center"></td>		
	  <td style="min-width:100px" align="center"></td>		
	  	   
	</tr>
	
	<cfset ToDateDue = 0>
	<cfset TotalDue  = 0>
	
	<cfset row = 0>
		
	<cfoutput query="listing" group="OrgUnitName">
	
		<cfset ToDateDueSub = 0>
		<cfset TotalDueSub = 0>
	
		<tr class="clsRequirementRow line navigation_row fixrow">
		    <td colspan="10" class="ccontent labellarge" width="20" style="height:40px;padding-left:5px">#OrgUnitName# <font size="2">#OrgUnitNameShort#</td>
		</tr>	
	
		<cfoutput>
	
		<!--- define the correct value for vetted requirments + support for the portion which is
		to be relase based on the time, maybe this is in the tables onwards as we havet he percentage
		field though --->			
		
		<cfif supportpercentage eq "">
		    <cfset DueTotal  = AmountVettedToAllotTotal>
			<cfset DueTodate = AmountVettedToAllotToDate>
		<cfelse>
		    <!--- 8/24/2017 this is not correct as you could 
			           have OE's not enabled for PSC and then this amount is wrong --->
		    <cfset DueTotal  = AmountVettedToAllotTotal  * (1+(SupportPercentage/100))>
			<cfset DueTodate = AmountVettedToAllotToDate * (1+(SupportPercentage/100))>
		</cfif>
					
		<cfset overdue = DueToDate - AllotedToDate>
		
		<cfif url.modeselect eq "overdue" and overdue gte 10>
			<cfset show = "1">
		<cfelseif url.modeselect eq "overdue">
			<cfset show = "0"> 
		<cfelse>
			<cfset show = "1">	
		</cfif>
		
		<cfif show eq "1">
		
			<cfset row = row+1>
		
			<tr class="clsRequirementRow line labelmedium navigation_row">
			
			    <td style="display:none" class="ccontent">#OrgUnitName# #OrgUnitNameshort#</td>
			    <td width="40" style="padding-left:2px">
					<table><tr>
					<td style="padding-top:1px">
						<cf_img icon="open" navigation="Yes" onClick="AllotmentInquiry('#ProgramCode#','','#URL.Period#','Inquiry','#get.Version#','#url.systemfunctionid#')">
					</td>
					<td align="center" style="padding-top:2px;padding-left:4px;padding-right:20px">	
					
						<cfquery name="Allotment" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">							   		
							SELECT    *
							FROM   	  ProgramAllotment
							WHERE     ProgramCode = '#ProgramCode#'
							AND       Period      = '#url.period#'
							AND       EditionId   = '#url.edition#'		
						</cfquery>		
																														
						<cfif Allotment.status eq "1">					   											
							<cf_img icon="edit" navigation="Yes" onClick="allotdrill('#ProgramCode#','#url.period#','#url.Edition#')">						
						</cfif>
					   						   
					</td>							
					</tr>
					</table>
				</td>
					
				<td style="padding-left:4px" class="ccontent">#Reference#</td>
				<td width="40%" class="ccontent" style="padding-left:2px;min-width:168">
				<cfif len(ProgramName) gte "50">#left(ProgramName,50)#..<cfelse>#ProgramName#</cfif>			
				</td>	
				<td align="right" style="#st#">#numberformat(AmountRequested,",._")#</td> 	
				<cfif vIncludePSCColumns>
				<td align="right" style="#st#;font-size:11px">#numberformat(AmountRequestedTotal,",._")#</td> 	
				</cfif>
				<td align="right" bgcolor="e1e1e1" style="#st#">
					<cfif Amountrequested neq AmountVetted>
					<font color="FF0000">#numberformat(AmountVetted,",._")#</font>
					<cfelse>
					<font color="808080">#numberformat(AmountVetted,",._")#</font>
					</cfif>
				</td> 	
				<cfif vIncludePSCColumns>
				<td bgcolor="d4d4d4" align="right" style="#st#;font-size:11px">
					#numberformat(DueTotal,",._")#
				</td> 	
				</cfif>									
				<td align="right" style="#st#" bgcolor="yellow">
				
					<table style="width:100%">
					<tr>
					<td align="center" style="min-width:20px;padding-left:1px;padding-right:1px">							
						  <cf_img icon="add" navigation="Yes" onClick=" maintainRelease('#url.edition#','#url.period#','program','#ProgramCode#')">														  								
					</td>
					<td style="width:100%" class="labelit" align="right">#numberformat(DueTodate,",._")#</td>
					</tr>
					</table>
				
				</td>
				<td align="right" bgcolor="FBFCDA" style="#st#">#numberformat(AllotedToDate,",._")#</td>
				<td align="right" bgcolor="FBFCDA" style="#st#">#numberformat(AmountAmended,",._")#</td>
				
				<cfif AllotedToDate neq AllotedToDate2>
					<td align="right" bgcolor="FBFCDA" style="#st#">#numberformat(AllotedToDate2,",._")#</td>			
				<cfelse>
					<td align="right" bgcolor="ffffaf" style="#st#"><font color="808080">same</font></td>						
				</cfif>				
				
				<cfif abs(Overdue) lt 3> 
					<td align="right" style="padding-right:4px;border-left:1px solid silver;border-right:1px solid silver">--</td>
				<cfelseif Overdue gte "3">					
					<td align="right" bgcolor="red" style="#st#;border-left:1px solid silver;border-right:1px solid silver;padding-right:1px" class="regular" onmouseover="if (this.className=='regular') {this.className='highlight'}"
					 onmouseout="if (this.className=='highlight') {this.className='regular'}" onclick="javascript:allotdrill('#programcode#','#period#','#editionid#')">				
					<font color="white">
					#numberformat(overdue,",._")#
					</font>
					</td>
				<cfelse>
					<td align="right" bgcolor="green" style="padding-right:4px;border-left:1px solid silver">
					<font color="white">
					#numberformat(overdue*-1,",._")#
					</font>		
					</td>
				</cfif>				
				
			</tr>
		
		</cfif>
		
		<cfset todatedueSub = ToDateDueSub + dueTodate>		
		<cfset todatedue    = ToDateDue    + dueTodate>		
		<cfset totaldueSub  = TotalDueSub  + dueTotal>		
		<cfset totaldue     = totaldue     + dueTotal>		
		
		</cfoutput>
		
		<cfif url.modeselect eq "">
					
		<cfquery name="Total" dbtype="query">
			SELECT Sum(AmountRequested)          as AmountRequested,
				   Sum(AmountRequestedTotal)     as AmountRequestedTotal,	
			       Sum(AmountVetted)             as AmountVetted,
				   Sum(AmountVettedToAllotTotal) as AmountVettedToAllotTotal,	
				   Sum(AmountAmended)            as AmountAmended,	      
				   Sum(AllotedToDate)            as AllotedToDate,
				   Sum(AllotedToDate2)           as AllotedToDate2
			FROM   Listing
			WHERE  HierarchyCode = '#hierarchyCode#'
		</cfquery>
				
						
			<cfloop query="Total">
			
			<tr class="labelmedium navigation_row clsRequirementRow">
				<td style="display:none" class="ccontent">#Listing.OrgUnitName# #Listing.OrgUnitNameshort#</td>	
			    <td width="2%" style="padding-left:2px"></td>
				<td width="8%" style="padding-left:2px"></td>
				<td  style="min-width:100%"></td>
				<td align="right" style="#st#">#numberformat(AmountRequested,",._")#</td> 	
				<cfif vIncludePSCColumns>
				<td align="right" style="#st#;font-size:11px">#numberformat(AmountRequestedTotal,",._")#</td> 
				</cfif>
				<td align="right" bgcolor="e1e1e1" style="#st#">#numberformat(AmountVetted,",._")#</td> 	
				<cfif vIncludePSCColumns>
				<td align="right" bgcolor="silver" style="#st#;font-size:11px">#numberformat(TotalDueSub,",._")#</td> 		
				</cfif>
				<td align="right" bgcolor="gray" style="#st#"><font color="FFFFFF">#numberformat(TodateDueSub,",._")#</td>
									
				<td align="right" bgcolor="FBFCDA" style="#st#">#numberformat(AllotedToDate,",._")#</td>
				<td align="right" bgcolor="FBFCDA" style="#st#">#numberformat(AmountAmended,",._")#</td>
				<td align="right" bgcolor="ffffaf" style="#st#">#numberformat(AllotedToDate2,",._")#</td>						
				
					<cfset overdue = TodateDueSub - AllotedToDate>
					
					<cfif abs(Overdue) lt 3> 
					<td align="right" style="#st#;padding-right:4px;border-left:1px solid silver;border-right:1px solid silver">--</td>
					<cfelseif overdue gte "3">
						<td align="right" bgcolor="red"  			   
						   style="#st#;padding-right:4px;border-left:1px dotted silver">
											
							<font color="white">
							#numberformat(overdue,",._")#
							</font>
						
						</td>
					<cfelse>
						<td align="right" bgcolor="green" style="#st#;padding-right:4px;border-left:1px dotted silver">
						<font color="white">
						#numberformat(overdue*-1,",._")#
						</font>							
						</td>
					</cfif>	
				
				</td>
			</tr>	
						
			</cfloop>			
					
		</cfif>
					
	</cfoutput>
			
</table>
